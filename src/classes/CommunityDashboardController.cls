global with sharing class CommunityDashboardController {
    public String StrComponentName { get; set; }
    public  User userDetails {get; set;}
   
    public String EnableCustomLinks {get; set;}
    public String EnableOrder {get; set;}
    public String EnableBulkOrder {get; set;}
    public String OrderToDelete { get; set; }
    //ContentType string is used to verify that the file uploaded is an image
    public String ContentType { get; set; }
    public Blob ProfileImg { get; set; }
    
    private final static String STYLE_INLINE = 'inline-block';
    private final static String STYLE_NONE = 'none';
    private final static String NEW_ORDER_STATUS = 'New (not yet submitted)';
    private final static String SUBMITTED_ORDER_STATUS = 'Submitted (order placed)';
    
    public Portal_Configuration__c portalConfiguration {get; set;}
    public ApexPages.StandardSetController setCon {get; set;}
    public List<PartnerOrderWrapper> PartnerOrders {get; set;} //ui bound variable
    private List<PartnerOrderWrapper> lstWrapperPartnerOrders;  //Complete list of partner orders
    public string FilterID {get; set;}
    
    //pagination variables
    public Integer PageNumber {get; set;}
    public Integer TotalPages {get; set;}
    private Integer iRecordIndex;
    private Integer iTotalRecords;
    private Integer iRemainder;
    public String NumOfItem { get; set; } //variable bound to pagesize select list on ui
    public Integer iNumOfItem { get; set; } //represents items / page
    public Boolean isEnableFirst { get; set;} //Controls visibility of pagination links
    public Boolean isEnableLast { get; set;}
    public Boolean isEnablePrevious { get; set;}
    public Boolean isEnableNext { get; set;}
    public String key { get; set;}
    public String searchKey { get; set;}
    public String currentComponent{get;set;}
    public Map<String,String> componentParams{get;set;}
    public List<String> defaultParameters = new List<String>{'viewId','editVisiblity','cloneVisiblity','bulkCloneVisiblity','cloneId','editId'};
    
    public CommunityDashboardController(){
        system.debug('inside CommunityDashboardController');
        PageNumber = 1;
        iRemainder = 0;
        iNumOfItem = 25; //Initial page size
        NumOfItem = '25'; //UI bound variable
        StrComponentName = ApexPages.currentPage().getParameters().get('cmp');
        try{
            userDetails = [SELECT Id,SmallPhotoUrl,FullPhotoUrl, Contact.Account.Order_Level__c , Username, contactID, Site__c , Name, Contact.Id, IsActive,  Email, Contact.Account.Name, Contact.AccountID,  Contact.Name, Contact.FirstName, Contact.LastName, Contact.npe01__PreferredPhone__c, Contact.MobilePhone, Contact.npe01__WorkPhone__c, Contact.HomePhone, Contact.npe01__Primary_Address_Type__c , Contact.npe01__Home_Address__c, Contact.EnableBulkOrder__c, Contact.Can_order_kid_Pack__c FROM User  WHERE Username = : Userinfo.getUserName() LIMIT 1];
            if (userDetails != null)
                setCon  = new ApexPages.StandardSetController(Database.getQueryLocator(
                            [SELECT Id, Name, IsBulkOrder__c, Emergency_Order__c, Child_First_Name__c, Child_Age__c, Status__c, Caregiver_s_First_name__c, Submitted_Date__c,  Contact__r.Name, Contact__r.AccountId, Contact__r.ID , Contact__c, Partner__c,Submited_Date_Search__c
                             FROM Partner_Order__c where Contact__r.AccountId = :userdetails.Contact.AccountId OR Partner__c =: userdetails.Contact.AccountId LIMIT 10000 ]));
            
            portalConfiguration = [SELECT Location__c, Message__c, EnableBulkOrder__c, EnableOrder__c, ProfilePageMessage__c FROM Portal_Configuration__c WHERE Location__c = : userDetails.Site__c limit 1];
        
        }
        catch(Exception ex){
            system.debug('Exception occured: ' + ex.getMessage());
        }
        setCon.setPageSize(20);
        lstWrapperPartnerOrders = new List<PartnerOrderWrapper>();
        setVisibilityFlags();
        initializeViewList();
        populateOrderList();
        getPartnerOrders();
        if(StrComponentName=='userProfile')
            currentComponent = 'CmmntyUsrPrflCmp';
        else
            currentComponent = 'MngOrdrCmp';
    }
    public static PageReference redirectToLogin(){
        if(UserInfo.getUserType() == 'Guest')
            return Network.communitiesLanding();
        else
            return null;
    }
    public void setComponent(){
        /*currentComponent = ApexPages.CurrentPage().getParameters().get('cmpName');
        if(currentComponent==null || currentComponent=='')
            currentComponent = 'MngOrdrCmp';
        Map<String,String> params = new Map<String,String>();
        List<String> lstParams = new List<String>();
        String strParam = ApexPages.CurrentPage().getParameters().get('cmpParams');
        system.debug('cmpParams------'+strParam);
        if(strParam==null)
            strParam='';
        lstParams=strParam.split(',');
        system.debug('lstParams------'+lstParams);
        for(String param:defaultParameters){
            params.put(param,'');
        }
        system.debug('params------'+params);
        for(String param:lstParams){
            if(param!='' && param.split('=').size()>1){
                params.put(param.split('=')[0].trim(),param.split('=')[1].trim());
            }
        }
        system.debug('params2------'+params);
        componentParams = params;
        return null;*/
    }
    
    //This method sets flag to hide menu items in ui(For order types) dependending upon portal configuration for current user
    public void setVisibilityFlags() {
        if (portalConfiguration != null ) {
            //sidebarMessage aka UserMessage = portalConfiguration.Message__c;
            //SiteSpecificMessage = portalConfiguration.ProfilePageMessage__c;
            EnableOrder = (portalConfiguration.EnableOrder__c == True && userdetails.Contact.Can_order_kid_Pack__c == True) ? STYLE_INLINE : STYLE_NONE;
            EnableBulkOrder = (portalConfiguration.EnableBulkOrder__c  && userdetails.Contact.EnableBulkOrder__c == True) ? STYLE_INLINE : STYLE_NONE;
            EnableCustomLinks = (portalConfiguration.EnableOrder__c == False && portalConfiguration.EnableBulkOrder__c == False && userdetails.Contact.EnableBulkOrder__c == False) ? STYLE_NONE : STYLE_INLINE;
        }

    }
    
    //This method initializes view select list(filter)
    public void initializeViewList(){
         for(SelectOption option : getViews()){
            if(option.getLabel().equalsIgnoreCase('My Orders'))
                FilterId = option.getValue();
         }
         if (FilterID == null) 
            FilterID = getViews()[0].getValue();
        
         setCon.setFilterId(FilterID);
    }
    
    //This method returns list views available for user
    public List<SelectOption> getViews() {
        List<Selectoption> lstoptions = setCon.getListViewOptions();
        lstoptions.sort();
        return lstoptions;
    }
    
    //This method populates global List(lstWrapperPartnerOrders) with complete set of records  in result fetched by standardsetController querylocator
    //As well sets visibility of edit,delete,clone links for each partner order as per it's status
    public void populateOrderList(){
        lstWrapperPartnerOrders = new List<PartnerOrderWrapper>();
        if(setCon != null) 
            //First for loop fills list with records only in current page set.
            for(Partner_Order__c pOrder : (List<Partner_Order__c>)setCon.getRecords()){ 
                //If  account associated with contact of user equals (contact associated with partner's contact   or  partner order's accopunt )
                if (userdetails.Contact.AccountID == pOrder.Contact__r.AccountId || userdetails.Contact.AccountID == pOrder.Partner__c) { //MIGHT NO NEED OF THIS if
                    //User  can operate over his orders only
                    if  (userdetails.ContactId == pOrder.Contact__r.ID ) {
                        //If order is new or submitted and not bulk then hide bulk clone link(Add sibling for bulk)
                        if ((pOrder.Status__c == NEW_ORDER_STATUS || pOrder.Status__c == SUBMITTED_ORDER_STATUS) && pOrder.IsBulkOrder__c == false)
                            lstWrapperPartnerOrders.add(new PartnerOrderWrapper(pOrder, STYLE_INLINE, STYLE_INLINE, STYLE_NONE, STYLE_INLINE));
                        //If order is not new or not submitted but is bulk then hide  kid pack clone(Add sibling for non bulk) link and edit link 
                        if ((pOrder.Status__c != NEW_ORDER_STATUS || pOrder.Status__c != SUBMITTED_ORDER_STATUS ) && pOrder.IsBulkOrder__c == true)
                            lstWrapperPartnerOrders.add(new PartnerOrderWrapper(pOrder, STYLE_NONE, STYLE_NONE, STYLE_INLINE, STYLE_INLINE));
                        //If order is not new or not submitted AND NOT bulk hide edit and bulk clone link(add sibling)
                        if ((pOrder.Status__c != NEW_ORDER_STATUS && pOrder.Status__c != SUBMITTED_ORDER_STATUS ) && pOrder.IsBulkOrder__c == false)
                            lstWrapperPartnerOrders.add(new PartnerOrderWrapper(pOrder, STYLE_NONE, STYLE_INLINE, STYLE_NONE, STYLE_NONE));
                    } 
                    else
                        lstWrapperPartnerOrders.add(new PartnerOrderWrapper(pOrder, STYLE_NONE, STYLE_NONE, STYLE_NONE, STYLE_NONE) );
                }
            }   
            //Iterate over remaining pages
            while (setCon.getHasNext() == True && lstWrapperPartnerOrders != null ) { 
                setCon.next(); 
                for (Partner_Order__c pOrder : (List<Partner_Order__c>) setCon.getRecords()) { 
                    if (userdetails.Contact.AccountID == pOrder.Contact__r.AccountId || userdetails.Contact.AccountID == pOrder.Partner__c) {
                        if (userdetails.ContactId == pOrder.Contact__r.ID ) {
                            if ((pOrder.Status__c == NEW_ORDER_STATUS || pOrder.Status__c == SUBMITTED_ORDER_STATUS) && pOrder.IsBulkOrder__c == false)
                                lstWrapperPartnerOrders.add(new PartnerOrderWrapper(pOrder, STYLE_INLINE, STYLE_INLINE, STYLE_NONE, STYLE_INLINE));
                            if ((pOrder.Status__c != NEW_ORDER_STATUS || pOrder.Status__c != SUBMITTED_ORDER_STATUS ) && pOrder.IsBulkOrder__c == true)
                                lstWrapperPartnerOrders.add(new PartnerOrderWrapper(pOrder, STYLE_NONE, STYLE_NONE, STYLE_INLINE, STYLE_INLINE));
                            if ((pOrder.Status__c != NEW_ORDER_STATUS && pOrder.Status__c != SUBMITTED_ORDER_STATUS ) &&    pOrder.IsBulkOrder__c == false)
                                lstWrapperPartnerOrders.add(new PartnerOrderWrapper(pOrder, STYLE_NONE, STYLE_INLINE, STYLE_NONE, STYLE_NONE));
                        } 
                        else
                            lstWrapperPartnerOrders.add(new PartnerOrderWrapper(pOrder, STYLE_NONE, STYLE_NONE, STYLE_NONE, STYLE_NONE) );
                    }
                }
            }
            lstWrapperPartnerOrders.sort();
            iTotalRecords = lstWrapperPartnerOrders.size() ;
            //Calculate total number of pages and set 1 as current page
            TotalPages = (iTotalRecords / iNumOfItem);
            Integer remainder = (math.mod(iTotalRecords , iNumOfItem));
            if (remainder > 0 )
                TotalPages = TotalPages + 1;
                
            PageNumber = TotalPages == 0 ? 0 : 1;
            iRecordIndex = 0;
    }
    //This is ui bound getter for pageblock table
    public void getPartnerOrders() {
        if (NumOfItem != null )
            iNumOfItem = Integer.valueOf(NumOfItem);  //set selected paging size
        PartnerOrders = new List<PartnerOrderWrapper>();
        while (iRecordIndex < iTotalRecords ) {
            PartnerOrders.add(lstWrapperPartnerOrders.get((iRecordIndex)));
            iRecordIndex++;
            if ((PartnerOrders.size() >= iNumOfItem) || ((iRecordIndex) == iTotalRecords ))
                break;
        }
        Paginate();
    }
    //Enables or disables pagination links
    public void Paginate() {
        if (PageNumber != TotalPages && TotalPages > 1 ) {
            isEnableFirst = isEnablePrevious = True;
            isEnableLast = isEnableNext = False;
        }
        if (PageNumber == TotalPages && TotalPages > 1 ) {
            isEnableFirst = isEnablePrevious = False;
            isEnableLast = isEnableNext = True;
        }
        if (PageNumber != TotalPages && TotalPages > 1 && PageNumber != 1 ) {
            isEnableFirst = isEnablePrevious = False;
            isEnableLast = isEnableNext = False;
        }
        if (PageNumber == 1 && TotalPages == 1)
            isEnableFirst = isEnableLast = isEnablePrevious = isEnableNext = True;
       
        if (PageNumber == 1 &&  TotalPages != 1 ) {
            isEnableFirst = isEnablePrevious = True;
            isEnableLast = isEnableNext = False;
        }
         if (PageNumber == 0 && TotalPages == 0)
            isEnableFirst = isEnableLast = isEnablePrevious = isEnableNext = True;
    }
    //Pagination navigation methods
    public PageReference first() {
        iRecordIndex = 0;
        PageNumber = 1;
        getPartnerOrders();
        return null;
    }
    public PageReference last() {
        PageNumber = TotalPages;
        iRemainder = math.mod(iTotalRecords, iNumOfItem);
        if (iRemainder > 0 ) {
            iRecordIndex = (iTotalRecords - iRemainder);
            getPartnerOrders() ;
        }
        return null;
    }
    public PageReference previous() {
        PageNumber--;
        if (iRemainder > 0 ) {
            iRecordIndex = iRecordIndex - (iRemainder + iNumOfItem);
            iRemainder = 0;
            PartnerOrders = new List<PartnerOrderWrapper>();
            for (Integer i = 0; i < iNumOfItem; i++) {
                PartnerOrders.add(lstWrapperPartnerOrders.get((iRecordIndex)));
                iRecordIndex++;
            }
            Paginate();
        } else if ( iRecordIndex >= iNumOfItem * 2) {
            iRecordIndex = (iRecordIndex - iNumOfItem * 2);
            getPartnerOrders() ;
        } else if ( iRecordIndex < iNumOfItem * 2 ) {
            iRecordIndex = 0;
            getPartnerOrders() ;
        }
        return null;
    }
    public PageReference next() {
        iRemainder = 0;
        if(PageNumber != TotalPages)
        {  
        	PageNumber++;
            getPartnerOrders();
        }  
          return null;
    }
    //Data source for page size select list
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('100', 'View 100'));
        options.add(new SelectOption('50', 'View 50'));
        options.add(new SelectOption('25', 'View 25'));
        return options;
    }
    //This method refreshes the table on changing page size.Invoked by ItemsPerPage actionFunction
    public void refreshTable() {
        lstWrapperPartnerOrders = new List<PartnerOrderWrapper>();
        searchKey ='';
        resetSearchOperation();
    }
    
    //This action function gets called on change of page size select list
    public void ItemsPerPage() {
        if (NumOfItem != null)
            iNumOfItem = Integer.valueOf(NumOfItem);
        refreshTable();
    }
    
    public PageReference DeleteOrder() {
        try{
            String deleteOrder = ApexPages.CurrentPage().getParameters().get('firstParam');
            system.debug('OrderToDelete----'+ deleteOrder);
            if(String.isNotBlank(deleteOrder)){
                Database.DeleteResult deleteResult = Database.delete(deleteOrder);
                system.debug('delete result----'+ deleteResult);
            }
        }
        catch(Exception ex){
            System.debug('Exception in order deletion:'+ ex.getMessage());
        }
        PageReference orderPage = new PageReference('/DistributionPartner/CommunityDashboard');
        orderPage.setRedirect(true);
        return orderPage;
    }
    
    public void searchOrder(){
        List<Id> ordersToFilter = new List<Id>();
        List<Partner_Order__c> lstFilteredOrders = new List<Partner_Order__c>();
        String queryStr = 'SELECT Id,Name,Child_First_Name__c,Child_Age__c,Contact__r.Name,Submitted_Date__c,Status__c,IsBulkOrder__c, Emergency_Order__c,Caregiver_s_First_name__c,Contact__r.AccountId, Contact__r.ID , Contact__c, Partner__c FROM Partner_Order__c WHERE ';
        queryStr += 'Child_First_Name__c LIKE \'%' + key + '%\' OR ';
        queryStr += 'Child_Age__c LIKE \'%' + key + '%\' OR ';
        queryStr += 'Contact__r.Name LIKE \'%' + key + '%\' OR ';
        queryStr += 'Name LIKE \'%' + key + '%\' OR ';
        queryStr += 'Submited_Date_Search__c LIKE \'%' + key + '%\' OR ';
        queryStr += 'Status__c LIKE \'%' + key + '%\' LIMIT 2000';
        System.debug(queryStr);
        lstFilteredOrders = Database.query(queryStr);
        PageNumber = 1;
        iRemainder = 0;
        setcon = new ApexPages.StandardSetController(lstFilteredOrders);
        setcon.setPageSize(20);
        setcon.first();
        System.debug('lstFilteredOrders' + setcon.getRecords());
        populateOrderList();
        getPartnerOrders();
        /*List<List<sObject>> searchResults = new List<List<sObject>>();
        String queryStr = 'FIND ' + '{"' + key + '*"}' + ' IN ALL FIELDS RETURNING Partner_Order__c (Id,Name,Child_First_Name__c,Child_Age__c,Contact__r.Name,Submitted_Date__c,Status__c,IsBulkOrder__c, Emergency_Order__c,Caregiver_s_First_name__c,Contact__r.AccountId, Contact__r.ID , Contact__c, Partner__c LIMIT 2000)';
        System.debug(queryStr);
        searchResults = Search.query(queryStr);
        if(searchResults != null && searchResults[0] != null &&  searchResults[0].size() > 0){
            for(Partner_Order__c tempOrder :(List<Partner_Order__c>)searchResults[0])
                if(tempOrder != null && (tempOrder.Contact__r.AccountId == userdetails.Contact.AccountId || tempOrder.Partner__c == userdetails.Contact.AccountID))
                    ordersToFilter.add(tempOrder.Id);
            if(ordersToFilter.size() > 0){
                lstFilteredOrders = [SELECT Id, Name, IsBulkOrder__c, Emergency_Order__c, Child_First_Name__c, Child_Age__c, Status__c, Caregiver_s_First_name__c, Submitted_Date__c,  Contact__r.Name, Contact__r.AccountId, Contact__r.ID , Contact__c, Partner__c
                                        FROM Partner_Order__c where Id IN :ordersToFilter  LIMIT 2000];
                PageNumber = 1;
                iRemainder = 0;
                setcon = new ApexPages.StandardSetController(lstFilteredOrders);
                setcon.setPageSize(20);
                setcon.first();
                System.debug('lstFilteredOrders' + setcon.getRecords());
                populateOrderList();
                getPartnerOrders();
            }
        }*/
        
    }
    public void resetSearchOperation(){
        setCon  = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, IsBulkOrder__c, Emergency_Order__c, Child_First_Name__c, Child_Age__c, Status__c, Caregiver_s_First_name__c, Submitted_Date__c,  Contact__r.Name, Contact__r.AccountId, Contact__r.ID , Contact__c, Partner__c
                                            FROM Partner_Order__c where Contact__r.AccountId = :userdetails.Contact.AccountId OR Partner__c = :userdetails.Contact.AccountId LIMIT 10000 ]));
        PageNumber = 1;
        iRemainder = 0;
        setcon.first();
        if(FilterID == null) 
            FilterID = getViews()[0].getValue();
        setCon.setFilterId(FilterID);
        populateOrderList();
        getPartnerOrders();
    }
    
    //Partner order wrapped in order to control the visibility of edit,clone and delete for each partner order displayed in grid
    public class PartnerOrderWrapper implements Comparable {
        public Partner_Order__c PartnerOrder { get; set;}
        public string VisibilityEdit { get; set;}
        public string VisibilityClone { get; set;}
        public String VisibilityBulkClone { get; set;}
        public String  VisibilityDelete { get; set;}
        public  PartnerOrderWrapper(Partner_Order__c partnerOrder, String visibilityEdit, String visibilityClone, String visibilityBulkClone, String visibilityDelete) {
            this.PartnerOrder = partnerOrder;
            this.VisibilityEdit = visibilityEdit;
            this.VisibilityClone = visibilityClone;
            this.VisibilityBulkClone = visibilityBulkClone;
            this.VisibilityDelete = visibilityDelete;
        }
        public Integer compareTo(Object compareTo) {
            PartnerOrderWrapper compareToOrder = (PartnerOrderWrapper)compareTo;
            Integer returnValue = 0;
            if (partnerOrder.Name < compareToOrder.partnerOrder.Name)
                returnValue = 1;
            else if (partnerOrder.Name > compareToOrder.partnerOrder.Name)
                returnValue = -1;
            return returnValue;
        }
    }
    
     public Document document {
        get {
            if (document == null)
                document = new Document();
            return document;
        }
        set;
    }

    //method allowing the Community user to change their profile image
    public PageReference upload() {
        Blob b;

        if(contenttype=='image/jpeg' || contenttype=='image/png' || contenttype=='image/gif' || contenttype=='image/jpg' ){
            try {
                // ImageId = '06990000001HnuB';
                b = ProfileImg;
                //ConnectApi.ChatterUsers newPhoto = new ConnectApi.ChatterUsers();
            } catch (DMLException e) {
                system.debug('Error uploading file');
                //return null;
            } finally {
                ProfileImg = null; // clears the viewstate
            }

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Profile image updated successfully.'));
            System.debug('#####' + ConnectApi.Communities.getCommunities());
            String communityId = null;
            String userId = UserInfo.getUserId();
            //ID fileId = ImageId;

            // Set photo
            ConnectApi.Photo photo = ConnectApi.UserProfiles.setPhoto(communityId, userId, new ConnectApi.BinaryInput(b, 'image/jpg', 'userImage.jpg'));
        
            userDetails = [SELECT Id,SmallPhotoUrl,FullPhotoUrl, Contact.Account.Order_Level__c , Username, contactID, Site__c , Name, Contact.Id, IsActive,  Email, Contact.Account.Name, Contact.AccountID,  Contact.Name, Contact.FirstName, Contact.LastName, Contact.npe01__PreferredPhone__c, Contact.MobilePhone, Contact.npe01__WorkPhone__c, Contact.HomePhone, Contact.npe01__Primary_Address_Type__c , Contact.npe01__Home_Address__c, Contact.EnableBulkOrder__c, Contact.Can_order_kid_Pack__c FROM User  WHERE Username = : Userinfo.getUserName() LIMIT 1];
            //userPhoto = [SELECT Id,SmallPhotoUrl,FullPhotoUrl from User WHERE Username = : Userinfo.getUserName() LIMIT 1];
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Invalid image type, please use a valid image.'));
        }
        return null;
    }
}