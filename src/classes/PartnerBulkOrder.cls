public class PartnerBulkOrder
{
	public String OrderLevel {get;set;}
    public String UserMessage {get;set;}
    public String EnableCustomLinks {get;set;}
    public String EnableOrder {get;set;}
    public String EnableBulkOrder {get;set;} 
    public USER  userDetails{get;set;}
    public Portal_Configuration__c  portalConfiguration {get;set;}
    public List<Item__c> lstItems{get;set;}   
   	public Partner_Order__c partnerOrder {get;set;}
    private String strCloneBulkPartnerId;
    private final static String strStyleInline = 'inline';
    private final static String strStyleNone = 'none'; 
    public List<PartnerBulkOrderWrapper> PartnerWrapper{get;set;}
    public Integer Index {get;set;}
    public Integer SelectedIndex {get;set;}
public PartnerBulkOrder(){
	System.debug('partnerBulkOrder::constructor');
	strCloneBulkPartnerId = System.currentPagereference().getParameters().get('cloneId'); 
	partnerOrder = new  Partner_Order__c(); 
	try
	{
		userDetails = [SELECT ID,name,Phone,Site__c,ContactId,username,Contact.Account.Order_Level__c,Contact.Accountid,Contact.EnableBulkOrder__c,Contact.Name,Contact.Email,Contact.Phone
						FROM USER WHERE username =: UserInfo.getUserName() limit 1];
		lstItems = new  List<Item__c>([SELECT Id,Name,Ages__c,Category__c,Container_Type__c,Gender__c,Season__c,Shopping_Location__c,Size__c,SKU__c,Type_Sub_Category__c,BabyGearType__c ,Site__c,Bulk_Type__c,Available_As_Kid_Pack_Item__c,Available_As_Bulk_Item__c 
										FROM Item__c WHERE Site__c=:userDetails.Site__c ORDER BY Size_Reporting_Order__c LIMIT 10000]);
	}
	catch (Exception userDetailsException)
	{
		System.debug('PartnerBulkOrderController :: Contructor :: userDetailsException ::Exception ::'+userDetailsException);
	}
	if( userDetails != null )
		if( userDetails.Contact.Account.Order_Level__c != null )
			OrderLevel = String.valueOf(userDetails.Contact.Account.Order_Level__c); 
    
	try
	{
		if( userDetails != null )
			if( userDetails.Site__c != null )
				portalConfiguration = [SELECT Id, Location__c,Message__c,EnableBulkOrder__c,EnableOrder__c 
								FROM Portal_Configuration__c WHERE Location__c =: userDetails.Site__c LIMIT 1];		
	}
	catch(Exception portalConfigurationException)
	{
		System.debug('PartnerBulkOrderController :: Contructor :: portalConfiguration ::Exception ::'+portalConfigurationException);
	}
	setPartnerMessages();
    PartnerWrapper = new  List<PartnerBulkOrderWrapper>();
     Index = 0;
	if( strCloneBulkPartnerId != null )
		ClondeOrder();
      
    if( userDetails != null )
    {
        partnerOrder.Who_will_pick_up__c = userDetails.Contact.Name;
        partnerOrder.Partner_Email__c = userDetails.Contact.Email; 
        partnerOrder.Who_will_pick_up_phone__c = userDetails.Contact.Phone;
        partnerOrder.Site__c = userDetails.Site__c;
    }
  
    List<SelectOption>lstoptions = new List<SelectOption>();
    lstoptions.add(new SelectOption('--None--','--None--' ));
    if( strCloneBulkPartnerId == null )
    {
        PartnerWrapper.add( new PartnerBulkOrderWrapper(lstoptions , 0,0));
        PartnerWrapper.add( new PartnerBulkOrderWrapper(lstoptions , 0,1));
        PartnerWrapper.add( new PartnerBulkOrderWrapper(lstoptions , 0,2));
        Index = 2;
    }
}
    
public void AddRows(){
    List<SelectOption>lstoptions = new List<SelectOption>();
    lstoptions.add(new SelectOption('--None--','--None--' ));
	Index++;
    PartnerWrapper.add( new PartnerBulkOrderWrapper(lstoptions , 1,Index));
}
public void FillList(){
	PartnerBulkOrderWrapper selectedItem = PartnerWrapper.get(SelectedIndex);
   	selectedItem.BulkTypeItems = new List<selectOption>(); 
   	selectedItem.BulkTypeItems.add(new SelectOption('--None--','--None--' ));
	for(Item__c item : lstItems)	
	{ 	
		if( item.Available_As_Bulk_Item__c == 'Active'){
			if( selectedItem.ItemBulkType.Bulk_Type__c != null )		 
				if( item.Bulk_Type__c == selectedItem.ItemBulkType.Bulk_Type__c )
					selectedItem.BulkTypeItems.add( new SelectOption(item.id, item.name ));
		}
		else if( item.Available_As_Bulk_Item__c == 'Active' && item.Available_As_Kid_Pack_Item__c == 'Active' ){
			if( selectedItem.ItemBulkType.Bulk_Type__c != null )		 
				if( item.Bulk_Type__c == selectedItem.ItemBulkType.Bulk_Type__c )
					selectedItem.BulkTypeItems.add( new SelectOption(item.id, item.name ));
		}
				
	} 
     PartnerWrapper[SelectedIndex] = selectedItem;
        
}
public void ClondeOrder(){ 
    
    partnerOrder = [SELECT Id,Child_s_Story__c,Status__c,Submitted_Date__c,Contact__c,Partner__c,IsBulkOrder__c,Partner_Email__c,Partner_Phone__c,PickUpDay__c,Pick_up_Hours__c,Who_will_pick_up__c,Who_will_pick_up_phone__c,Location__c
                                          	FROM Partner_Order__c WHERE Id =: strCloneBulkPartnerId   LIMIT 1];
    List<Partner_Order_Item__c> lstOldPartnerItem = new List<Partner_Order_Item__c>();//[SELECT Id ,Comment__c,Item__c,Partner_Order__c,Qty_Fulfilled__c,Qty_Ordered__c 
                                                     //FROM Partner_Order_Item__c WHERE  Partner_Order__c =: strCloneBulkPartnerId limit 10000];
    Integer oldIndex = 0;
     
    for( Partner_Order_Item__c oldPartnerItem : lstOldPartnerItem )
    {
  		 	 
        for( Item__c item : lstItems )
        { 
        	if( oldPartnerItem != null && oldPartnerItem.Item__c == item.Id )
            {
                List<Selectoption> lstOptions = new  List<Selectoption>();
                for( Item__c OptionItems:lstItems )
                { 
                	if( item.Bulk_Type__c == OptionItems.Bulk_Type__c )
                	lstOptions.add( new SelectOption(OptionItems.id, OptionItems.name )); 
                }
                PartnerBulkOrderWrapper WrapperPartnerItem =  new PartnerBulkOrderWrapper(lstOptions,Integer.valueOf(oldPartnerItem.Qty_Ordered__c ), Index );
                WrapperPartnerItem.ItemBulkType.Bulk_Type__c = item.Bulk_Type__c;
                WrapperPartnerItem.SelectedItemId = item.Id;
                PartnerWrapper.add(WrapperPartnerItem );
                Index++;
            }
        }
            
        
    }
	if( PartnerWrapper.size() < 1 )
        Index = 0;
    else
    	Index = (PartnerWrapper.size() -1);  
}
   
private void SubmitOrder()
{
	if( strCloneBulkPartnerId == null )
  	{
	 	partnerOrder.Status__c = 'Submitted (order placed)';
		partnerOrder.Submitted_Date__c = Datetime.now();
		partnerOrder.Contact__c = userDetails.ContactId;
		partnerOrder.Partner__c = userDetails.Contact.AccountId;
		partnerOrder.IsBulkOrder__c = true; 
	
		Database.insert(partnerOrder);
     	List<Partner_Order_Item__c> lstPartnerOrderItems = new List<Partner_Order_Item__c>();
     	Partner_Order_Item__c pItem;
    	 for(PartnerBulkOrderWrapper obj : PartnerWrapper)
    	 {  
         	if( obj != null && obj.SelectedItemId != null && obj.SelectedItemId != '--None--' )
        	 { 
	             pItem = new  Partner_Order_Item__c();
	             pItem.Partner_Order__c = partnerOrder.Id;
	             pItem.Item__c = obj.SelectedItemId;
	             pItem.Qty_Ordered__c =  obj.Quantity;
	             pItem.Qty_Fulfilled__c = 0;  // Ajinkya
	             lstPartnerOrderItems.add(pItem);
         	}
     	} 
      	if( lstPartnerOrderItems.size()>0 )
   			insert lstPartnerOrderItems; 
    }
    else
     {//clone porder 
     	 Partner_Order__c clonePartnerOrder = new Partner_Order__c();          
         clonePartnerOrder.Status__c = 'Submitted (order placed)';
         clonePartnerOrder.Submitted_Date__c = Datetime.now();
         clonePartnerOrder.Contact__c = userDetails.ContactId;
         clonePartnerOrder.Partner__c = userDetails.Contact.AccountId;
         clonePartnerOrder.IsBulkOrder__c = true;
         clonePartnerOrder.Who_will_pick_up__c = partnerOrder.Who_will_pick_up__c;
         clonePartnerOrder.Who_will_pick_up_phone__c = partnerOrder.Who_will_pick_up_phone__c ;
         clonePartnerOrder.Child_s_Story__c =  partnerOrder.Child_s_Story__c;
         clonePartnerOrder.Pick_up_Hours__c = partnerOrder.Pick_up_Hours__c;
         clonePartnerOrder.PickUpDay__c = partnerOrder.PickUpDay__c;
         clonePartnerOrder.Partner_Email__c = partnerOrder.Partner_Email__c;  
         clonePartnerOrder.Location__c = partnerOrder.Location__c; 
         clonePartnerOrder.Site__c = userDetails.Site__c;
         Database.insert(clonePartnerOrder);
         List<Partner_Order_Item__c> lstPartnerOrderItems = new List<Partner_Order_Item__c>();
         Partner_Order_Item__c pItem;
         for(PartnerBulkOrderWrapper obj:PartnerWrapper)
         {  
             if( obj != null && obj.SelectedItemId != null && obj.SelectedItemId != '--None--' )
             { 
	              pItem = new  Partner_Order_Item__c();
	              pItem.Partner_Order__c = clonePartnerOrder.Id;
	              pItem.Item__c = obj.SelectedItemId;
	              pItem.Qty_Ordered__c =  obj.Quantity;
                  pItem.Qty_Fulfilled__c = 0;  // Ajinkya
	              lstPartnerOrderItems.add(pItem);
             }
         } 
        if( lstPartnerOrderItems.size()>0 )
             insert lstPartnerOrderItems; 
     	}
}    
public PageReference submit(){ 
	SubmitOrder(); 
  	return new PageReference('/apex/manageOrder').setRedirect(False);   
 }
 
public PageReference submitNew(){
    SubmitOrder();
	return new PageReference('/apex/partnerBulkOrder').setRedirect(True);
}

public PageReference cancel(){
	return new PageReference('/apex/manageOrder').setRedirect(False);
} 

public void setPartnerMessages(){
	if(portalConfiguration != null)
	{
		UserMessage = portalConfiguration.Message__c; 
        if(portalConfiguration.EnableOrder__c == True)
        	EnableOrder = strStyleInline;
        else
        	EnableOrder = strStyleNone;
        if(portalConfiguration.EnableBulkOrder__c == True && userDetails.Contact.EnableBulkOrder__c == True)
            EnableBulkOrder = strStyleInline;
       	else
			EnableBulkOrder = strStyleNone;
        if(portalConfiguration.EnableOrder__c == False && portalConfiguration.EnableBulkOrder__c == False && userDetails.Contact.EnableBulkOrder__c == False)
        	EnableCustomLinks = strStyleNone;
		else
			EnableCustomLinks = strStyleInline;	
	}
}

public PageReference Redirect(){
	
	if( UserInfo.getUserType() == 'Guest' )
		return Network.communitiesLanding();  
	else 
		return null;
}
    public class PartnerBulkOrderWrapper
    {
       
        public Item__c ItemBulkType{get;set;}
        public Integer Quantity{get;set;}
        public List<SelectOption> BulkTypeItems{get;set;}
        public Integer Index{get;set;}
        public String SelectedItemId{get;set;}
        public PartnerBulkOrderWrapper(List<SelectOption> BulkItems, Integer Quantity,Integer index)
        {
        	this.ItemBulkType =  new Item__c();
            this.BulkTypeItems = BulkItems;
			this.Quantity = Quantity;
            this.Index = index;
            SelectedItemId = null;
        }
    
    }
}