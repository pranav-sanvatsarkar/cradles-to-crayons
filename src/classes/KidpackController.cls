public  class KidpackController {
	public User userDetails {get; set;}
    public Portal_Configuration__c portalConfiguration {get; set;}
    public Partner_Order__c partnerOrder {get; set;}
    public Partner_Order_Item__c partnerOrderItem {get; set;}
    private Partner_Order__c clonedOrder;
    public Item__c birthdayItem { get; set;}
    //Lists
    public List<Partner_Order_Item__c> lstOldOrderItems {get; set;}
    private List<Partner_Order_Item__c> lstFinalStandardItems;		  		//Standard Items to be inserted.	
    private List<Partner_Order_Item__c> lstFinalBabyGearItems;  	  		//Baby gear Items to be inserted.
    public List<Item__c> lstItems;   								  		//Global list of items of corresponding site.
    public List<StandardItemWrapper> lstStandardItems {get; set;}	  		//List of standard items UI Bound variable.
    public List<NurseryItemWrapper> lstNurseryItemWrapper {get; set;} 		//List of Nursery items wrapper UI Bound variable.
    public List<BabyGearItemWrapper> lstBabyGearItems {get; set;} 			//List of baby gear items wrapper ui bound List.
    public List<SelectOption> lstNurseryItems {get; set;}			  		//Holds the nursery items bound to dropdownlist.		
    List<SelectOption> footWearItemsMatchingAgeGender = new List<SelectOption>();
    List<SelectOption> seasonalItemsMatchingAgeGender = new List<SelectOption>();  //Few items depend upon age of the child.
  	private List<PartnerOrderItemWrapper> lstPartnerOrderStandardItems;			//Temp Lists
  	private List<PartnerOrderItemWrapper> lstPartnerOrderBabyGearItems;
    //Flags
    private Boolean IsFirstComplete{get; set;}
    private Boolean IsBackUser{get; set;}
    public Boolean IsBirthdayItem {get; set;}
    public Boolean IsOrderInserted {get; set;}
    private Boolean isBabyGearItemDelete = true;
    private Boolean isStandardItemDelete = true;
    private Boolean isStep4Back;
    private Boolean isStep5Back;
    private Boolean isStep6Back;
    private Boolean isStep4Saved;
    //Strings
    private String strChildAge;
    private String strChildGender;
    private String strEditOrderId;
    private String strCloneOrderId;
    //Sets
    private set <Id> setStandardItems; 									//These sets hold Id's of order items for backtracking purpose.
    private set <Id> setBabyGearItems;
    //Maps
    private Map<Id,Item__c> mapItems{ get; set;}  									//Map of items by Id
    private Map<String,List<SelectOption>> mapItemsByCategory { get; set; }   		//Map of  items by its category
    private Map<String,BabyGearItemWrapper> mapBabyGearItemsByCategory{ get; set; }
    private Map<String,StandardItemWrapper> mapStandardItemsByCategory { get; set; }  //Will serve ui bound List w.r.t. wrapper for standard items
    public KidpackController()
    {
    	isStep4Saved = false;
    	setStandardItems = new Set<Id>();
    	setBabyGearItems = new Set<Id>();
    	mapItemsByCategory = new Map<String,List<SelectOption>>();
    	mapStandardItemsByCategory = new Map<String,StandardItemWrapper>();
    	mapBabyGearItemsByCategory = new Map<String,BabyGearItemWrapper>();
    	mapItems = new Map<Id,Item__c>();
    	
        strEditOrderId = System.currentPagereference().getParameters().get('editId'); 
        strCloneOrderId = System.currentPagereference().getParameters().get('cloneId'); 
        //Initialize nursery items
        lstNurseryItemWrapper = new List<NurseryItemWrapper>{ new NurseryItemWrapper(),new NurseryItemWrapper(),new NurseryItemWrapper()};
        lstBabyGearItems = new List<BabyGearItemWrapper>();
        //Initialize flags
        IsOrderInserted = false;
        isStep4Back = false;
        isStep5Back = false;
        isStep6Back = false;
        isBabyGearItemDelete = true;
        isStandardItemDelete = true;
        Id tempOrderId;
        try
         {
	        if(String.isNotBlank(strEditOrderId))
            {
	            partnerOrder = [SELECT Id, name, Caregiver_s_First_name__c, Caregiver_s_Last_name__c, Child_s_Story__c, Child_Age__c, Child_Birthdate__c, Child_First_Name__c, Child_Gender__c, Child_Home_Zip_Code__c, Child_Last_Name__c, Contact__c, Emergency_Order__c, Emergency_Other__c, Emergency_Type__c, Fulfilled_Date__c, Num_Fulfilled_Item__c, Num_Ordered_Item__c, Num_Out_of_Stock_Item__c, Partner__c, Partner_Order_Batch__c, Picked_Up_Date__c, Who_will_pick_up_phone__c, Printed_Date__c, Emergency_Reason__c, Shelf_Location__c, Status__c, Submitted_Date__c, Who_will_pick_up__c, Partner_Email__c, Location__c, Site__c
	            						FROM Partner_Order__c WHERE id = :strEditOrderId LIMIT 1];
                System.debug('strEditOrderId ::' + strEditOrderId);
                System.debug('partnerOrder ::' + partnerOrder);
	            strChildAge = partnerOrder.Child_Age__c;
	            strChildGender = partnerOrder.Child_Gender__c;
	            lstOldOrderItems = [SELECT Id, Comment__c, Item__c, Partner_Order__c, Qty_Fulfilled__c, Qty_Ordered__c FROM Partner_Order_Item__c WHERE Partner_Order__c = : partnerOrder.Id];
		   } 
            else if(String.isNotBlank(strCloneOrderId))
            {
                clonedOrder = new Partner_Order__c();
                partnerOrder = [SELECT  Id, name, Caregiver_s_First_name__c, Caregiver_s_Last_name__c, Contact__c,  Picked_Up_Date__c, Who_will_pick_up_phone__c,  Who_will_pick_up__c, Partner_Email__c, Location__c, Child_Last_Name__c, Child_Home_Zip_Code__c
                                FROM Partner_Order__c WHERE id = :strCloneOrderId LIMIT 1];
                lstOldOrderItems = new List<Partner_Order_Item__c>(); //Changed by client requirement //[SELECT Id, Comment__c, Item__c, Partner_Order__c, Qty_Fulfilled__c, Qty_Ordered__c FROM Partner_Order_Item__c WHERE Partner_Order__c = : partnerOrder.Id];
            } 
	        else if(partnerOrder == null)
	        	partnerOrder = new Partner_Order__c();
	        	
	        userdetails = [SELECT ID, name, Phone, Site__c, ContactId, username, Contact.AccountId, Contact.Account.Order_Level__c, Contact.Phone, Contact.EnableBulkOrder__c, Contact.Email
	            						FROM User WHERE username = : UserInfo.getUserName() LIMIT 1];

	        portalConfiguration = [SELECT Location__c, Message__c, EnableBulkOrder__c, EnableOrder__c FROM Portal_Configuration__c WHERE Location__c = : userdetails.Site__c LIMIT 1];
	        List<Item__c> bItem = [SELECT Id, Name, Category__c, Container_Type__c, Site__c
					            FROM Item__c WHERE Category__c = : 'Birthday Gift' AND Available_As_Kid_Pack_Item__c = : 'Active' AND Available_As_Bulk_Item__c = :null AND Site__c = :userdetails.Site__c AND Ages__c = :null AND Container_Type__c = :null AND Gender__c = :null AND Season__c = :null AND Shopping_Location__c = :null AND Size__c = :null AND SKU__c = : null AND Type_Sub_Category__c = : null AND BabyGearType__c = :null];
		     if(bItem != null && bItem.size() > 0) 
		     	birthdayItem =  bItem[0]; 
        }
        catch(Exception ex)
        {
	    	System.debug('PartnerOrder ::' + ex.getMessage());
	    }
        if(userdetails != null )
        {
        	if(String.isBlank(partnerOrder.Contact__c))
            	partnerOrder.Contact__c = userdetails.ContactId;
            if(String.isBlank(partnerOrder.Who_will_pick_up_phone__c))
				partnerOrder.Who_will_pick_up_phone__c = userdetails.Contact.Phone;
            if(String.isBlank(partnerOrder.Who_will_pick_up__c))
				partnerOrder.Who_will_pick_up__c = userdetails.name;
            if(String.isBlank(partnerOrder.Partner_Email__c))
				partnerOrder.Partner_Email__c = userdetails.Contact.Email;
            //if(String.isBlank(partnerOrder.Site__c))
			partnerOrder.Site__c = userdetails.Site__c;
        }
        getItems();
        /*String strurl = ApexPages.currentPage().getUrl();
        system.debug('strurl-->'+strurl);
        String currentPage = strurl.split('apex/')[1];
        currentPage = currentPage.substring(0,currentPage.indexOf('?')==-1?currentPage.length()-1:currentPage.indexOf('?'));
        if(currentPage=='KidpackStepFour'){
            system.debug('kidpackstep4 executed');
            getStep4Data();
        }
        if(currentPage=='KidpackStepFive'){
            system.debug('kidpackstep4 executed');
            getStep5Data();
        }
        if(currentPage=='KidpackStepSix'){
            system.debug('kidpackstep4 executed');
            getStep6Data();
        }*/
        
    }
    public static PageReference redirectToLogin(){
        if(UserInfo.getUserType() == 'Guest')
            return Network.communitiesLanding();
        else
            return null;
    }
    public void Initialize(){ 
    	mapItemsByCategory  = new Map<String,List<SelectOption>>();
    	mapStandardItemsByCategory = new Map<String,StandardItemWrapper>();
    	//Initialize map with standard items
    	mapItemsByCategory.put('Clothing',new List<Selectoption>()); 
    	mapItemsByCategory.put('Everyday Footwear',new List<Selectoption>());
    	mapItemsByCategory.put('Seasonal Footwear',new List<Selectoption>());
    	mapItemsByCategory.put('Outerwear',new List<Selectoption>());
    	mapItemsByCategory.put('Outerwear Accessories',new List<Selectoption>());
    	mapItemsByCategory.put('Books',new List<Selectoption>());
    	mapItemsByCategory.put('Arts & Crafts',new List<Selectoption>());
    	mapItemsByCategory.put('Toys',new List<Selectoption>());
    	//Initialize map with baby gear type items
    	//mapItemsByCategory.put('Bed',new List<Selectoption>());
    	mapItemsByCategory.put('Car Seat',new List<Selectoption>());
    	mapItemsByCategory.put('Stroller',new List<Selectoption>());
    	mapItemsByCategory.put('Temporary Available Items',new List<Selectoption>());
    	
    	for(string key : mapItemsByCategory.keySet()) //Initialize map
    		mapItemsByCategory.get(key).add(new Selectoption('--None--','--None--'));
    	
    	lstNurseryItems = new List<SelectOption>();
    	lstNurseryItems.add(new Selectoption('--None--','--None--'));
    	seasonalItemsMatchingAgeGender.clear();
    	seasonalItemsMatchingAgeGender.clear();
    }
    public void getItems()
    {
    	Initialize();
    	try
        {  										//Fetch items corresponding to site
            lstItems = new List<Item__c>([SELECT Id, Name, Ages__c, Category__c, Container_Type__c, Gender__c, Season__c, Shopping_Location__c, Size__c, SKU__c, Type_Sub_Category__c, BabyGearType__c, Site__c, Available_As_Kid_Pack_Item__c, Available_As_Bulk_Item__c
            									FROM Item__c WHERE Site__c = : userdetails.Site__c ORDER BY Size_Reporting_Order__c LIMIT 10000]);
        
       if(lstItems.size() > 0)
       {
        	Set<String> setAges;
        	for(Item__c item : lstItems)
            {
        		if (!mapItems.containsKey(item.Id)) 
        			mapItems.put(item.Id, item);
        		if(item.Available_As_Kid_Pack_Item__c == 'Active')
                {          //If item is available as kidpack
        			//Fill out standard items first
        			if(item.Category__c == 'Clothing' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) 
        				mapItemsByCategory.get('Clothing').add(new SelectOption(item.Id, item.Name));
					if(item.Category__c == 'Everyday Footwear')
                    {
	                    if(item.Ages__c != null)
                        {
	                        setAges = new Set<String>();
	                        setAges.addAll(item.Ages__c.split(';'));
	                        if (setAges.contains(partnerOrder.Child_Age__c) && (item.Gender__c == null || item.Gender__c == partnerOrder.Child_Gender__c))     //If item has no gender specified
	                            footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
	                    }
	                    if(item.Ages__c == null && item.Gender__c != null && partnerOrder.Child_Gender__c != null) 
	                        if(item.Gender__c.contains(partnerOrder.Child_Gender__c)) 
	                        	footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
	                    
	                    if(item.Ages__c == null && item.Gender__c == null) 
	                        footWearItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
                	}
	                if(item.Category__c == 'Seasonal Footwear')
                    {
	                    if ((item.Ages__c != null && item.Gender__c != null))
                        {
	                        setAges = new Set <String> ();
	                        setAges.addAll(item.Ages__c.split(';'));
	                        if ((setAges.contains(partnerOrder.Child_Age__c) && (item.Gender__c == partnerOrder.Child_Gender__c)|| item.Gender__c == null)) 
	                            seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
	                    }
	                    if((item.Ages__c == null && item.Gender__c != null && partnerOrder.Child_Gender__c != null)) 
	                        if (item.Gender__c.contains(partnerOrder.Child_Gender__c)) 
	                        	seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
	                    
	                    if(item.Ages__c == null && item.Gender__c == null) 
	                        seasonalItemsMatchingAgeGender.add(new SelectOption(item.Id, item.Name));
	                }
	                if(item.Category__c == 'Outerwear' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) 
	                	mapItemsByCategory.get('Outerwear').add(new SelectOption(item.Id, item.Name));
	
	                if(item.Category__c == 'Outerwear Accessories' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) 
	                	mapItemsByCategory.get('Outerwear Accessories').add(new SelectOption(item.Id, item.Name));
	                if(item.Category__c == 'Books') 
	                	mapItemsByCategory.get('Books').add(new SelectOption(item.Id, item.Name));
	                if(item.Category__c == 'Arts & Crafts' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) 
	                	mapItemsByCategory.get('Arts & Crafts').add(new SelectOption(item.Id, item.Name));
	                if(item.Category__c == 'Toys' && (item.Gender__c == partnerOrder.Child_Gender__c || item.Gender__c == null)) 
	                	mapItemsByCategory.get('Toys').add(new SelectOption(item.Id, item.Name));
	                //Fill out nursery item list
	                if(item.Category__c == 'Nursery') lstNurseryItems.add(new SelectOption(item.Id, item.Name));
	                
	                //Fill out baby gear items
	                if(item.Category__c == 'Baby Gear')
                    {
	                	if(item.BabyGearType__c == 'Super Saucer'){
	                		BabyGearItemWrapper babyGearItem = new BabyGearItemWrapper('Super Saucer',false,item.Id,null,null);
	                		mapBabyGearItemsByCategory.put('Super Saucer',babyGearItem);
	                	}
	                	if(item.BabyGearType__c == 'Booster Seat - Table (6-12 mos.)'){
                    		BabyGearItemWrapper babyGearItem = new BabyGearItemWrapper('Booster Seat - Table (6-12 mos.)',false,item.Id,null,null);
	                		mapBabyGearItemsByCategory.put('Booster Seat - Table (6-12 mos.)',babyGearItem);
                		}
		                if(item.BabyGearType__c == 'Pack n Play (portable)'){
		                    BabyGearItemWrapper babyGearItem = new BabyGearItemWrapper('Pack n Play (portable)',false,item.Id,null,null);
	                		mapBabyGearItemsByCategory.put('Pack n Play (portable)',babyGearItem);
		                }
		                if(item.BabyGearType__c == 'Bouncy Seat (Infant)'){
		                    BabyGearItemWrapper babyGearItem = new BabyGearItemWrapper('Bouncy Seat (Infant)',false,item.Id,null,null);
	                		mapBabyGearItemsByCategory.put('Bouncy Seat (Infant)',babyGearItem);
		                }
		                if(item.BabyGearType__c == 'High Chair (6 mos. - 2yrs)'){
		                    BabyGearItemWrapper babyGearItem = new BabyGearItemWrapper('High Chair (6 mos. - 2yrs)',false,item.Id,null,null);
	                		mapBabyGearItemsByCategory.put('High Chair (6 mos. - 2yrs)',babyGearItem);
		                }
		                if(item.BabyGearType__c == 'Bassinet (Infant)'){
		                    BabyGearItemWrapper babyGearItem = new BabyGearItemWrapper('Bassinet (Infant)',false,item.Id,null,null);
	                		mapBabyGearItemsByCategory.put('Bassinet (Infant)',babyGearItem);
		                }
		                if(item.BabyGearType__c == 'Indoor Swing'){
		                    BabyGearItemWrapper babyGearItem = new BabyGearItemWrapper('Indoor Swing',false,item.Id,null,null);
	                		mapBabyGearItemsByCategory.put('Indoor Swing',babyGearItem);
		                }
		                if(item.BabyGearType__c == 'Safety Gate'){
		                    BabyGearItemWrapper babyGearItem = new BabyGearItemWrapper('Safety Gate',false,item.Id,null,null);
	                		mapBabyGearItemsByCategory.put('Safety Gate',babyGearItem);
		                }
		                if(item.BabyGearType__c == 'Bed Rails'){
		                    BabyGearItemWrapper babyGearItem = new BabyGearItemWrapper('Bed Rails',false,item.Id,null,null);
	                		mapBabyGearItemsByCategory.put('Bed Rails',babyGearItem);
		                }
		               /*if(item.BabyGearType__c == 'Bed') mapItemsByCategory.get('Bed').add(new SelectOption(item.Id, item.Name));*/
		                
		                if(item.BabyGearType__c == 'Car Seat') mapItemsByCategory.get('Car Seat').add(new SelectOption(item.Id, item.Name));
		                
		                if(item.BabyGearType__c == 'Stroller') mapItemsByCategory.get('Stroller').add(new SelectOption(item.Id, item.Name));
		                
		                if(item.BabyGearType__c == 'Temporary Available Items') mapItemsByCategory.get('Temporary Available Items').add(new SelectOption(item.Id, item.Name));
	                }
        			  
        		}
        	}//For loop ends
        	if(seasonalItemsMatchingAgeGender.size() > 0)
        		mapItemsByCategory.get('Seasonal Footwear').addAll(seasonalItemsMatchingAgeGender);
        	if(footWearItemsMatchingAgeGender.size() > 0)
        		mapItemsByCategory.get('Everyday Footwear').addAll(footWearItemsMatchingAgeGender); 
        	footWearItemsMatchingAgeGender.clear();
        	seasonalItemsMatchingAgeGender.clear();
        	//Bind standard items as well baby gear items to UI 
        	for(String categoryKey : mapItemsByCategory.keySet())
            {
        		if(!categoryKey.Equals('Car Seat') && !categoryKey.Equals('Stroller') && !categoryKey.Equals('Temporary Available Items'))
                {
	        		StandardItemWrapper standardItem = new StandardItemWrapper(categoryKey,mapItemsByCategory.get(categoryKey));
	        		mapStandardItemsByCategory.put(categoryKey,standardItem);
        		}
        		else
                {
        			BabyGearItemWrapper babyGearItem = new BabyGearItemWrapper(categoryKey,false,null,mapItemsByCategory.get(categoryKey),null);
	                mapBabyGearItemsByCategory.put(categoryKey,babyGearItem);
        		}
        	}
        }
        if(String.isNotBlank(strEditOrderId) ){ 	//If order is being edited 
    		if(lstOldOrderItems.size() > 0){
                system.debug('inside lstOldOrderItems');
           		lstNurseryItemWrapper = new List<NurseryItemWrapper>();
                for(Partner_Order_Item__c partnerOrderItem : lstOldOrderItems){  			//Iterate over existing order items to populate UI.
                        Item__c selectedItem = mapItems.get(partnerOrderItem.Item__c);  	//Fetch corresponding Item of partner order item.
                        if(selectedItem != null){
                            if(selectedItem.Category__c == 'Clothing' && (selectedItem.Gender__c == partnerOrder.Child_Gender__c || String.isBlank(selectedItem.Gender__c))) {
                                mapStandardItemsByCategory.get('Clothing').SelectedItemId = selectedItem.id;
                                mapStandardItemsByCategory.get('Clothing').IsSelected = true;
                                mapStandardItemsByCategory.get('Clothing').Comment = partnerOrderItem.Comment__c;
                                setStandardItems.add(partnerOrderItem.Id);
                            }
                            if(selectedItem.Ages__c != null){ 
                                if(selectedItem.Category__c == 'Everyday Footwear' && selectedItem.Ages__c.contains(partnerOrder.Child_Age__c) && (selectedItem.Gender__c == partnerOrder.Child_Gender__c || String.isBlank(selectedItem.Gender__c))) {
	                                mapStandardItemsByCategory.get('Everyday Footwear').SelectedItemId = selectedItem.id;
	                                mapStandardItemsByCategory.get('Everyday Footwear').IsSelected = true;
	                                mapStandardItemsByCategory.get('Everyday Footwear').Comment = partnerOrderItem.Comment__c;
	                                setStandardItems.add(partnerOrderItem.Id);
                                } 
                            }
                           	
                            if(selectedItem.Category__c == 'Seasonal Footwear' && (selectedItem.Gender__c == partnerOrder.Child_Gender__c || String.isBlank(selectedItem.Gender__c))){
                                
                                mapStandardItemsByCategory.get('Seasonal Footwear').SelectedItemId = selectedItem.id;
                                mapStandardItemsByCategory.get('Seasonal Footwear').IsSelected = true;
                                mapStandardItemsByCategory.get('Seasonal Footwear').Comment = partnerOrderItem.Comment__c;
                                setStandardItems.add(partnerOrderItem.Id);
                            }

                            if(selectedItem.Category__c == 'Outerwear'  && (selectedItem.Gender__c == partnerOrder.Child_Gender__c || String.isBlank(selectedItem.Gender__c))){
                                mapStandardItemsByCategory.get('Outerwear').SelectedItemId = selectedItem.id;
                                mapStandardItemsByCategory.get('Outerwear').IsSelected = true;
                                mapStandardItemsByCategory.get('Outerwear').Comment = partnerOrderItem.Comment__c;
                                setStandardItems.add(partnerOrderItem.Id);
                            }
                            if(selectedItem.Category__c == 'Outerwear Accessories' && (selectedItem.Gender__c == partnerOrder.Child_Gender__c || String.isBlank(selectedItem.Gender__c))){
                                mapStandardItemsByCategory.get('Outerwear Accessories').SelectedItemId = selectedItem.id;
                                mapStandardItemsByCategory.get('Outerwear Accessories').IsSelected = true;
                                mapStandardItemsByCategory.get('Outerwear Accessories').Comment = partnerOrderItem.Comment__c;
                                setStandardItems.add(partnerOrderItem.Id);
                            }
                            if(selectedItem.Category__c == 'Books'){
                                mapStandardItemsByCategory.get('Books').SelectedItemId = selectedItem.id;
                                mapStandardItemsByCategory.get('Books').IsSelected = true;
                                mapStandardItemsByCategory.get('Books').Comment = partnerOrderItem.Comment__c;
                                setStandardItems.add(partnerOrderItem.Id);
                            }
                            if(selectedItem.Category__c == 'Arts & Crafts' && (selectedItem.Gender__c == partnerOrder.Child_Gender__c || String.isBlank(selectedItem.Gender__c))){
                               mapStandardItemsByCategory.get('Arts & Crafts').SelectedItemId = selectedItem.id;
                               mapStandardItemsByCategory.get('Arts & Crafts').IsSelected = true;
                               mapStandardItemsByCategory.get('Arts & Crafts').Comment = partnerOrderItem.Comment__c;
                               setStandardItems.add(partnerOrderItem.Id);
                            }
                            if(selectedItem.Category__c == 'Toys' && (selectedItem.Gender__c == partnerOrder.Child_Gender__c || String.isBlank(selectedItem.Gender__c))){
                                mapStandardItemsByCategory.get('Toys').SelectedItemId = selectedItem.id;
                                mapStandardItemsByCategory.get('Toys').IsSelected = true;
                                mapStandardItemsByCategory.get('Toys').Comment = partnerOrderItem.Comment__c;
                                setStandardItems.add(partnerOrderItem.Id);
                            }
							if(selectedItem.Category__c == 'Nursery'){
                                NurseryItemWrapper nurseryItem = new NurseryItemWrapper(true,partnerOrderItem.Comment__c,selectedItem.Id,partnerOrderItem.Id);
                                lstNurseryItemWrapper.add(nurseryItem);  //UI bound list populates every time
                                setBabyGearItems.add(partnerOrderItem.Id);
                            }
                            if(birthdayItem != null) 
                            	if(birthdayItem.Id == selectedItem.Id){
	                                IsBirthdayItem = true;
	                                setStandardItems.add(partnerOrderItem.id);
                            	}
                            if(selectedItem.Category__c == 'Baby Gear'){
			                	if(selectedItem.BabyGearType__c == 'Super Saucer'){
			                		setBabyGearItems.add(partnerOrderItem.id);
			                		mapBabyGearItemsByCategory.get('Super Saucer').isSelected = true;
			                		mapBabyGearItemsByCategory.get('Super Saucer').SelectedItemId = selectedItem.Id;
			                	}
			                	if(selectedItem.BabyGearType__c == 'Booster Seat - Table (6-12 mos.)'){
			                		setBabyGearItems.add(partnerOrderItem.id);
			                		mapBabyGearItemsByCategory.get('Booster Seat - Table (6-12 mos.)').isSelected = true;
			                		mapBabyGearItemsByCategory.get('Booster Seat - Table (6-12 mos.)').SelectedItemId = selectedItem.Id;
		                		}
				                if(selectedItem.BabyGearType__c == 'Pack n Play (portable)'){
				                    setBabyGearItems.add(partnerOrderItem.id);
			                	    mapBabyGearItemsByCategory.get('Pack n Play (portable)').isSelected = true;
			                	    mapBabyGearItemsByCategory.get('Pack n Play (portable)').SelectedItemId = selectedItem.Id;
				                }
				                if(selectedItem.BabyGearType__c == 'Bouncy Seat (Infant)'){
									setBabyGearItems.add(partnerOrderItem.id);
			                		mapBabyGearItemsByCategory.get('Bouncy Seat (Infant)').isSelected = true;
			                		mapBabyGearItemsByCategory.get('Bouncy Seat (Infant)').SelectedItemId = selectedItem.Id;
				                }
				                if(selectedItem.BabyGearType__c == 'High Chair (6 mos. - 2yrs)'){
				                    setBabyGearItems.add(partnerOrderItem.id);
			                		mapBabyGearItemsByCategory.get('High Chair (6 mos. - 2yrs)').isSelected = true;
			                		mapBabyGearItemsByCategory.get('High Chair (6 mos. - 2yrs)').SelectedItemId = selectedItem.Id;
				                }
				                if(selectedItem.BabyGearType__c == 'Bassinet (Infant)'){
				                    setBabyGearItems.add(partnerOrderItem.id);
			                		mapBabyGearItemsByCategory.get('Bassinet (Infant)').isSelected = true;
			                		mapBabyGearItemsByCategory.get('Bassinet (Infant)').SelectedItemId = selectedItem.Id;
				                }
				                if(selectedItem.BabyGearType__c == 'Indoor Swing'){
				                    setBabyGearItems.add(partnerOrderItem.id);
			                		mapBabyGearItemsByCategory.get('Indoor Swing').isSelected = true;
			                		mapBabyGearItemsByCategory.get('Indoor Swing').SelectedItemId = selectedItem.Id;
				                }
				                if(selectedItem.BabyGearType__c == 'Safety Gate'){
				                    setBabyGearItems.add(partnerOrderItem.id);
			                		mapBabyGearItemsByCategory.get('Safety Gate').isSelected = true;
			                		mapBabyGearItemsByCategory.get('Safety Gate').SelectedItemId = selectedItem.Id;
				                }
				                if(selectedItem.BabyGearType__c == 'Bed Rails'){
				                   setBabyGearItems.add(partnerOrderItem.id);
			                	   mapBabyGearItemsByCategory.get('Bed Rails').isSelected = true;
			                	   mapBabyGearItemsByCategory.get('Bed Rails').SelectedItemId = selectedItem.Id;
				                }
				                /*if(selectedItem.BabyGearType__c == 'Bed'){        
				                	setBabyGearItems.add(partnerOrderItem.id);
			                	    mapBabyGearItemsByCategory.get('Bed').isSelected = true;
			                	    mapBabyGearItemsByCategory.get('Bed').SelectedItemId = selectedItem.Id;
				                }*/
				                if(selectedItem.BabyGearType__c == 'Car Seat'){
				                	setBabyGearItems.add(partnerOrderItem.id);
			                	    mapBabyGearItemsByCategory.get('Car Seat').isSelected = true;
			                	    mapBabyGearItemsByCategory.get('Car Seat').SelectedItemId = selectedItem.Id;
				                }
				                if(selectedItem.BabyGearType__c == 'Stroller'){
				                	setBabyGearItems.add(partnerOrderItem.id);
			                	    mapBabyGearItemsByCategory.get('Stroller').isSelected = true;
			                	    mapBabyGearItemsByCategory.get('Stroller').SelectedItemId = selectedItem.Id;
				                }
				                if(selectedItem.BabyGearType__c == 'Temporary Available Items'){
				                	setBabyGearItems.add(partnerOrderItem.id);
			                	    mapBabyGearItemsByCategory.get('Temporary Available Items').isSelected = true;
			                	    mapBabyGearItemsByCategory.get('Temporary Available Items').SelectedItemId = selectedItem.Id;
				                }
	                		}
                        }
                    }//For loop ends
                    lstOldOrderItems.clear();
            	}
    		}//Edit / clone if ends
            system.debug('map value' +mapStandardItemsByCategory.values());
        	lstStandardItems = new List<StandardItemWrapper>(mapStandardItemsByCategory.values()); 	//UI bound List for standard items
        	lstBabyGearItems =  new List<BabyGearItemWrapper>(mapBabyGearItemsByCategory.values());	//UI bound List for baby gear items
        if(lstNurseryItemWrapper.size()==0){
            lstNurseryItemWrapper = new List<NurseryItemWrapper>{ new NurseryItemWrapper(),new NurseryItemWrapper(),new NurseryItemWrapper()};
        }
        } 
        catch(Exception Ex)
        {
            System.debug('PartnerOrderController :: GetItems  ::' + Ex);
            System.debug('Line Number :: '+ Ex.getLineNumber());
        }  
   	 }
     public PageReference SaveStepOne()
     {
         try{
             
            
            if(!IsOrderInserted)
            {
                if(String.isBlank(strEditOrderId) && String.isBlank(strCloneOrderId))
                {	//New order
                    partnerOrder.Status__c = 'New (not yet submitted)';
                    partnerOrder.Submitted_Date__c = Datetime.now();
                    partnerOrder.Partner__c = userdetails.Contact.AccountId;
                    partnerOrder.Contact__c = userdetails.Contactid;
                    partnerOrder.Site__c = userdetails.Site__c;
                    Database.insert(partnerOrder); 
                }
                else if(String.isNotblank(strEditOrderId))
                {							//Order being edited
                    Database.update(partnerOrder);
                    system.debug('strcage->'+strChildAge+' pcage->'+partnerOrder.Child_Age__c+' strgender->'+strChildGender+' pgender->'+partnerOrder.Child_Gender__c);
                    if(strChildAge != partnerOrder.Child_Age__c || strChildGender != partnerOrder.Child_Gender__c) 
                        deleteStandardItems();
                }
                else if(String.isNotBlank(strCloneOrderId))
                {						//Order being cloned
                    //Partner_Order__c currentOrder = [Select IsBulkOrder__c,Emergency_Order__c,Emergency_Other__c,Emergency_Type__c,Emergency_Reason__c,(Select Is_Baby_Gear__c,Item__c,Item_Category__c,Item_Site__c,Order_Item_Gender__c,Partner__c,Partner_Order__c from Partner_Order_Items__r) from Partner_Order__c where Id=:partnerOrder.Id];
                    clonedOrder.Child_First_Name__c = partnerOrder.Child_First_Name__c;
                    clonedOrder.Child_Last_Name__c = partnerOrder.Child_Last_Name__c;
                    clonedOrder.Child_Gender__c = partnerOrder.Child_Gender__c;
                    clonedOrder.Child_Age__c = partnerOrder.Child_Age__c;
                    clonedOrder.Child_Home_Zip_Code__c = partnerOrder.Child_Home_Zip_Code__c;
                    clonedOrder.Child_s_Story__c = partnerOrder.Child_s_Story__c;
                    clonedOrder.Submitted_Date__c = Datetime.now();
                    clonedOrder.Partner__c = userdetails.Contact.AccountId;
                    clonedOrder.Contact__c = userdetails.ContactId;
                    clonedOrder.Status__c = 'New (not yet submitted)';
                    
                    /*clonedOrder.IsBulkOrder__c = currentOrder.IsBulkOrder__c;
                    clonedOrder.Emergency_Order__c = currentOrder.Emergency_Order__c;
                    clonedOrder.Emergency_Other__c = currentOrder.Emergency_Other__c;
                    clonedOrder.Emergency_Type__c = currentOrder.Emergency_Type__c;
                    clonedOrder.Emergency_Reason__c = currentOrder.Emergency_Reason__c;*/
                    
                    Database.insert(clonedOrder);
                    /*List<Partner_Order_Item__c> lstItems = new List<Partner_Order_Item__c>();
                    for(Partner_Order_Item__c item:currentOrder.Partner_Order_Items__r){
                        item.Partner_Order__c = clonedOrder.Id;
                        item.Id = null;
                        item.Qty_Fulfilled__c = 0;
                        lstItems.add(item);
                    }*/
                    partnerOrder = clonedOrder;
                  //  Database.insert(lstItems);
                }
                IsOrderInserted = true; 
            }
            else
            { 																		//Update order
                Database.update(partnerOrder); 
                if(String.isBlank(strCloneOrderId)) 
                {
                    if(strChildAge != partnerOrder.Child_Age__c || strChildGender != partnerOrder.Child_Gender__c) 
                    {
                        deleteStandardItems();
                        strChildAge = partnerOrder.Child_Age__c;
                        strChildGender = partnerOrder.Child_Gender__c;
                    }
                }
            }
            system.debug('redirect to edit');
            return new PageReference('/apex/KidpackStepTwo?editId='+partnerOrder.Id).setRedirect(true);
         }catch(Exception ex){
             //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
             return null;
         }
     }
     
    @TestVisible private void deleteStandardItems()
    {
	    List <Partner_Order_Item__c> lstItemDelete = new List <Partner_Order_Item__c>();
	    List <Partner_Order_Item__c> lstOldPartnerOrderStandardItems;
	    try 
        {
	        lstOldPartnerOrderStandardItems = [SELECT Id, Comment__c, Item__c, Partner_Order__c, Qty_Fulfilled__c, Qty_Ordered__c FROM Partner_Order_Item__c WHERE Partner_Order__c = : partnerOrder.Id];
	    } 
	    catch(Exception deleteStandardItemException) 
        {
	        System.debug('PartnerOrderController :: deleteStandardItems :: Exception ::' + deleteStandardItemException);
	    }
	    if(lstOldPartnerOrderStandardItems.size() > 0) 
	   		for(Partner_Order_Item__c PartnerItem: lstOldPartnerOrderStandardItems)
            {
		        if(PartnerItem != null)
                {
		            try
                    {
		                Id itemId = PartnerItem.Item__c;
		                Item__c selectedItem = [SELECT Id, Name, Ages__c, Category__c, Container_Type__c, Gender__c, Season__c, Shopping_Location__c, Size__c, SKU__c, Type_Sub_Category__c, BabyGearType__c, Site__c
		                FROM Item__c WHERE id = : itemId LIMIT 1];
		                if (selectedItem != null) 
                        {
		                    if(selectedItem.Category__c == 'Clothing' && selectedItem.Gender__c != partnerOrder.Child_Gender__c) lstItemDelete.add(PartnerItem);
		                    if(selectedItem.Category__c == 'Everyday Footwear') lstItemDelete.add(PartnerItem);
		                    if(selectedItem.Category__c == 'Seasonal Footwear') lstItemDelete.add(PartnerItem);
		                    if(selectedItem.Category__c == 'Outerwear' && selectedItem.Gender__c != partnerOrder.Child_Gender__c) lstItemDelete.add(PartnerItem);
		                }
		            } 
		            catch(Exception deleteStandardSelectedItemException) 
                    {
		                System.debug('PartnerOrderController :: deleteStandardItems ::selectedItem ::Exception ::' + deleteStandardSelectedItemException);
		            }
		        }
	    	}
	    Database.delete(lstItemDelete);
       // FootWearItemId = SeasonalFootWearItemId = null;
     }
     //Adds row to nursery items
     public void AddNurseryRow(){
     	if(lstNurseryItemWrapper == null)
     		lstNurseryItemWrapper = new List<NurseryItemWrapper>();
        lstNurseryItemWrapper.add(new NurseryItemWrapper());
     }
     public PageReference SaveStepTwo(){
         try{
             Contact contactToUpdate = [SELECT id, name, FirstName, npe01__PreferredPhone__c, Phone FROM contact WHERE id = : userdetails.ContactId LIMIT 1];
             system.debug('contactToUpdate-->'+contactToUpdate);
            if(contactToUpdate.npe01__PreferredPhone__c == null || contactToUpdate.Phone != partnerOrder.Who_will_pick_up_phone__c){
                contactToUpdate.Phone = partnerOrder.Who_will_pick_up_phone__c; 
                Database.update(contactToUpdate);
            } 
            if(String.isBlank(strEditOrderId) && String.isBlank(strCloneOrderId))	
                Database.update(partnerOrder);
            else if(String.isNotBlank(strEditOrderId)) 
                Database.update(partnerOrder);
            else if(String.isNotBlank(strCloneOrderId)){						//Order being cloned
                clonedOrder.Caregiver_s_First_name__c = partnerOrder.Caregiver_s_First_name__c;
                clonedOrder.Caregiver_s_Last_name__c = partnerOrder.Caregiver_s_Last_name__c;
                clonedOrder.Who_will_pick_up__c = partnerOrder.Who_will_pick_up__c;
                clonedOrder.Who_will_pick_up_phone__c = partnerOrder.Who_will_pick_up_phone__c;
                clonedOrder.Location__c = partnerOrder.Location__c;
                clonedOrder.Partner_Email__c = partnerOrder.Partner_Email__c;
                //clonedOrder.Child_Birthdate__c = partnerOrder.Child_Birthdate__c;
                Database.update(clonedOrder);
            }
            return new PageReference('/apex/KidpackStepThree?editId='+System.currentPagereference().getParameters().get('editId')).setRedirect(true);
         }catch(Exception ex){
             return null;
         }
     	
     }
     public PageReference SaveStepThree(){
         try{
             if(String.isBlank(strEditOrderId) && String.isBlank(strCloneOrderId))	
                Database.update(partnerOrder);
             else if(String.isNotBlank(strEditOrderId)){
                 if(!partnerOrder.Emergency_Order__c){
                     partnerOrder.Emergency_Type__c = '';
                     partnerOrder.Emergency_Reason__c = '';
                 }
                 Database.update(partnerOrder);
             }
                
            else if(String.isNotBlank(strCloneOrderId))
            {						//Order being cloned
                clonedOrder.Id = strCloneOrderId;
                clonedOrder.Emergency_Order__c = partnerOrder.Emergency_Order__c;
                clonedOrder.Emergency_Type__c = partnerOrder.Emergency_Type__c;
                clonedOrder.Emergency_Reason__c = partnerOrder.Emergency_Reason__c;
                Database.update(clonedOrder);
                try{ 															//Update partner order object with cloned one for further operations
                    partnerOrder = [SELECT Id, name, Caregiver_s_First_name__c, Caregiver_s_Last_name__c, Child_s_Story__c, Child_Age__c, Child_Birthdate__c, Child_First_Name__c, Child_Gender__c, Child_Home_Zip_Code__c, Child_Last_Name__c, Contact__c, Emergency_Order__c, Emergency_Other__c, Emergency_Type__c, Fulfilled_Date__c, Num_Fulfilled_Item__c, Num_Ordered_Item__c, Num_Out_of_Stock_Item__c, Partner__c, Partner_Order_Batch__c, Picked_Up_Date__c, Who_will_pick_up_phone__c, Printed_Date__c, Emergency_Reason__c, Shelf_Location__c, Status__c, Submitted_Date__c, Who_will_pick_up__c, Partner_Email__c, Location__c, Site__c
                                            FROM Partner_Order__c WHERE id = : clonedOrder.Id LIMIT 1];
                } 
                catch (Exception ClonePartnerOrderException){
                    System.debug('PartnerOrderController :: saveStep3 :: clone partnerOrder :: Exception ::' + ClonePartnerOrderException);
                }
            }
            if(isStep4Saved == false)
                getItems(); 			//Fetch Items
            return new PageReference('/apex/KidpackStepFour?editId='+System.currentPagereference().getParameters().get('editId')).setRedirect(true);
         }catch(Exception ex){
             return null;
         }
     }
     //This method saves standard items
     public PageReference SaveStepFour(){
         try{
             //Code to be changed
            if(String.isBlank(strEditOrderId) && String.isBlank(strCloneOrderId))
                Database.update(partnerOrder);
            else if(String.isNotBlank(strEditOrderId)) 
                Database.update(partnerOrder);
            else if(String.isNotBlank(strCloneOrderId)){						//Order being cloned
                clonedOrder.Child_Birthdate__c = partnerOrder.Child_Birthdate__c;
                Database.update(clonedOrder);
            }
             //End of Replaced code
            if(String.isNotBlank(strEditOrderId) && isStandardItemDelete == true) {
                isStandardItemDelete = false;
                List<Partner_Order_Item__c> lstPartnerItemDelete;
                try {
                    lstPartnerItemDelete = [SELECT id, name FROM Partner_Order_Item__c WHERE Partner_Order__c=:partnerOrder.Id AND (Item_Category__c!='Nursery' AND Item_Category__c!='Baby Gear')];
                    system.debug('lstPartnerItemDelete--'+lstPartnerItemDelete);
                } 
                catch(Exception deletePartnerOrderItemException) {
                    System.debug('PartnerOrderController :: saveStep4 ::strEditPartnerOrderId ::Exception ::' + deletePartnerOrderItemException);
                }
                if(lstPartnerItemDelete != null && lstPartnerItemDelete.size() > 0) {
                    Database.delete(lstPartnerItemDelete);
                    setStandardItems.clear();
                }
            }
            lstPartnerOrderStandardItems = new List<PartnerOrderItemWrapper>();
            for(StandardItemWrapper sItem : lstStandardItems){
                if(sItem.isSelected == true && sItem.SelectedItemId != '--None--')
                    lstPartnerOrderStandardItems.add(new PartnerOrderItemWrapper(partnerOrder.Id, sItem.SelectedItemId, sItem.Comment, 0));
            }
            if(IsBirthdayItem == true && birthdayItem != null) //Add birthday Item
                lstPartnerOrderStandardItems.add(new PartnerOrderItemWrapper(partnerOrder.Id, birthdayItem.Id, '', 0));
            lstFinalStandardItems = new List<Partner_Order_Item__c>(); //Prepare List for final insert
            for(PartnerOrderItemWrapper orderItem: lstPartnerOrderStandardItems)
                lstFinalStandardItems.add(orderItem.PartnerOrderItem);
    
            Database.insert(lstFinalStandardItems);
            if(isStep4Back == true) {
                List<Partner_Order_Item__c> lstPartnerItemDelete;
                try{
                    lstPartnerItemDelete = [SELECT id, name FROM Partner_Order_Item__c WHERE id in : setStandardItems];
                } 
                catch(Exception deletePartnerOrderStadardItemException) {
                    System.debug('PartnerOrderController :: saveStep4 ::deletePartnerOrderStadardItem ::Exception ::' + deletePartnerOrderStadardItemException);
                }
                Database.delete(lstPartnerItemDelete);
                setStandardItems.clear();
            }
            isStep4Back = false;
            isStep4Saved = true;
            return new PageReference('/apex/KidpackStepFive?editId='+System.currentPagereference().getParameters().get('editId')).setRedirect(true);
         }catch(Exception ex){
             return null;
         }
     }
     
     //Save Nursery Items
     public PageReference SaveStepFive(){
         try{
             List<Partner_Order_Item__c> lstPartnerItemDelete;
             try {
                 lstPartnerItemDelete = [SELECT Id, Name FROM Partner_Order_Item__c WHERE Partner_Order__c=:partnerOrder.Id AND Item_Category__c='Nursery'];
             } 
             catch (Exception deletePartnerOrderBabyGrearItemsException) {
                 System.debug('PartnerOrderController :: saveStep5 ::deletePartnerOrderBabyGrear ::Exception ::' + deletePartnerOrderBabyGrearItemsException);
             }
             Database.delete(lstPartnerItemDelete);
             
             
             lstPartnerOrderBabyGearItems = new List<PartnerOrderItemWrapper>();
            for(NurseryItemWrapper objNursery: lstNurseryItemWrapper) {
                if (objNursery != null && objNursery.SelectedItemId != null && objNursery.SelectedItemId != '--None--') 
                    lstPartnerOrderBabyGearItems.add(new PartnerOrderItemWrapper(partnerOrder.Id, objNursery.SelectedItemId,'', 0));
            }
            lstFinalBabyGearItems = new List<Partner_Order_Item__c>();
            for (PartnerOrderItemWrapper orderItemWrapper: lstPartnerOrderBabyGearItems)
                lstFinalbabyGearItems.add(orderItemWrapper.PartnerOrderItem);
           
            Database.insert(lstFinalbabyGearItems);
            setBabyGearItems.clear();
            return new PageReference('/apex/KidpackStepSix?editId='+System.currentPagereference().getParameters().get('editId')).setRedirect(true);
         }catch(Exception ex){
             return null;
         }
     }
     
     //Saves Baby Gear Items
     public PageReference SaveStepSix(){
         try{
             if(String.isNotBlank(strEditOrderId) && isBabyGearItemDelete == true) {
                isBabyGearItemDelete = true;
                List<Partner_Order_Item__c> lstPartnerItemDelete;
                
                 lstPartnerItemDelete = [SELECT id, name FROM Partner_Order_Item__c WHERE Partner_Order__c=:partnerOrder.Id AND Item_Category__c='Baby Gear'];
             
                if(lstPartnerItemDelete != null && lstPartnerItemDelete.size() > 0) {
                    Database.delete(lstPartnerItemDelete);
                    setBabyGearItems.clear();
                }
            }
            lstPartnerOrderBabyGearItems = new List<PartnerOrderItemWrapper>();
            for(BabyGearItemWrapper bItem : lstBabyGearItems){
                if(bItem.isSelected == true && bItem.SelectedItemId != null && bItem.SelectedItemId != '--None--'  ){
                        lstPartnerOrderBabyGearItems.add(new PartnerOrderItemWrapper(partnerOrder.Id, bItem.SelectedItemId, '', 0));
                }
            }
            lstFinalBabyGearItems = new List<Partner_Order_Item__c>();
            for(PartnerOrderItemWrapper orderItemwrapper : lstPartnerOrderBabyGearItems)
                lstFinalBabyGearItems.add(orderItemwrapper.PartnerOrderItem);
                
            Database.insert(lstFinalBabyGearItems);
            system.debug('saved');
            if(isStep6Back == true) {
                List<Partner_Order_Item__c> lstPartnerItemDelete;
                try {
                    lstPartnerItemDelete = [SELECT Id, name FROM Partner_Order_Item__c WHERE id in : setBabyGearItems];
                } 
                catch(Exception deletePartnerOrderBabyGrearItemsException) {
                    System.debug('PartnerOrderController :: saveStep6 ::deletePartnerOrderBabyGear ::Exception ::' + deletePartnerOrderBabyGrearItemsException);
                }
                Database.delete(lstPartnerItemDelete);
            }
            isStep6Back = false;
            setBabyGearItems.clear();
            return new PageReference('/apex/OrderReview?viewId='+System.currentPagereference().getParameters().get('editId')+'&cloneVisiblity=none&bulkCloneVisiblity=none&editVisiblity=none&submitVisiblity=inline-block').setRedirect(true);
         }catch(Exception ex){
             return null;
         }
     }
     //Back to dashboard
     public PageReference Step1Back(){
      	return new PageReference('/apex/CommunityDashBoard').setRedirect(true);
     }
     public PageReference Step2Back(){
      	return new PageReference('/apex/KidpackStepOne?editId='+System.currentPagereference().getParameters().get('editId')).setRedirect(true);
     }
     public PageReference Step3Back(){
      	return new PageReference('/apex/KidpackStepTwo?editId='+System.currentPagereference().getParameters().get('editId')).setRedirect(true);
     }
     public PageReference Step4Back(){
     	//strChildAge = partnerOrder.Child_Age__c;
        //strChildGender = partnerOrder.Child_Gender__c;
        isStep4Back = true;
      	return new PageReference('/apex/KidpackStepThree?editId='+System.currentPagereference().getParameters().get('editId')).setRedirect(true);
     }
     //Backward navigation from step 6 (Baby gear items) to step (Nursery item)
     public PageReference Step6Back(){
        /*isStep5Back = true;          //Step 5 traversed again
        setBabyGearItems = new Set<Id>();
        for(NurseryItemWrapper objNursery: lstNurseryItemWrapper)
        	if(objNursery != null && objNursery.SelectedItemId != null && objNursery.SelectedItemId != '--None--') 
        		setBabyGearItems.add(objNursery.PartnerOrderItemId);*/
        return new PageReference('/apex/KidpackStepFive?editId='+System.currentPagereference().getParameters().get('editId')).setRedirect(true);
     }
     //Backward navigation from step 5 (nursery items) to step 4(standatd items)
     public PageReference Step5Back(){
        /*isStep4Back = true;          //Step 4 traversed again
        setStandardItems = new Set<Id>();
        for(Partner_Order_Item__c pItem : lstFinalStandardItems)
        	setStandardItems.add(pItem.Id);*/
        return new PageReference('/apex/KidpackStepFour?editId='+System.currentPagereference().getParameters().get('editId')).setRedirect(true);
     }
     //Backward navigation from review step
     public PageReference reviewStepBack() {
        setBabyGearItems = new Set<Id>();
        isStep6Back = true;
        for(Partner_Order_Item__c pItem: lstFinalbabyGearItems)
        	setBabyGearItems.add(pItem.Id);
        return new PageReference('/apex/KidpackStepSix?editId='+System.currentPagereference().getParameters().get('editId')).setRedirect(true);
     }
    
    //This function is final submission after review page
    public PageReference submit() {
        if (portalConfiguration.EnableOrder__c) {
            partnerOrder.Status__c = 'Submitted (order placed)';
            partnerOrder.Submitted_Date__c = Datetime.now();
            Database.update(partnerOrder);
        }
        return new PageReference('/apex/ManageOrder').setRedirect(true);
    }
     
    //Wrapper Classes
    //This class wraps baby gear as well as standard items. Generic Wrapper yields final order item(junction) list that is to  be inserted in database
    class PartnerOrderItemWrapper{
        public Partner_Order_Item__c PartnerOrderItem { get; set; }
        public PartnerOrderItemWrapper(String strPartnerOrderId, String strItemId, String strItemComment, Integer qtyFullFilled) {
            this.PartnerOrderItem = new Partner_Order_Item__c();
            this.PartnerOrderItem.Partner_Order__c = strPartnerOrderId;
            this.PartnerOrderItem.Item__c = strItemId;
            this.PartnerOrderItem.Comment__c = strItemComment;
            this.PartnerOrderItem.Qty_Ordered__c = 1;
            this.PartnerOrderItem.Qty_Fulfilled__c = qtyFullFilled;
        }
    }
	//Wrapper class for standard items ui bound List
	public class StandardItemWrapper{
		public String Category { get; set;}
		public List<SelectOption> ItemsByCategory { get; set;}
		public String Comment { get; set;}
        public Boolean IsSelected { get; set;}
        public String SelectedItemId{ get; set;}
        public string PartnerOrderItemId { get; set;}
        public StandardItemWrapper(String strCategory,List<SelectOption> itemsByCategory){
        	this.IsSelected = false;
        	this.ItemsByCategory = new List<Selectoption>(itemsByCategory);
        	this.Category = strCategory;
        }
	}
	//Wrapper class yields nursery Items ui bound List
    public class NurseryItemWrapper {
        public String Comment { get; set;}
        public Boolean IsSelected { get; set;}
        public String SelectedItemId{ get; set;}
        public string PartnerOrderItemId{ get; set;}
        public NurseryItemWrapper(){
        	this.IsSelected = false;
        }
        public NurseryItemWrapper(Boolean selected, String comment, String itemId, String pOrderItemId){
        	this.IsSelected = selected;
        	this.Comment = comment;
        	this.SelectedItemId = itemId;
        	this.PartnerOrderItemId = pOrderItemId;
        }
    }
    //Wrapper Class for baby gear items ui bound List
    public class BabyGearItemWrapper {
    	public String Category { get; set;}
        public Boolean IsSelected { get; set;}
        public String SelectedItemId{ get; set;}
        public string PartnerOrderItemId{ get; set;}
        public List<SelectOption> ItemsBySubCategory{get; set;}
        public BabyGearItemWrapper(){
        	this.IsSelected = false;
        }
        public BabyGearItemWrapper(String strCategory,Boolean selected, String itemId, List<SelectOption> itemsByCategory,String pOrderItemId){
        	this.Category = strCategory;
        	this.IsSelected = selected;
        	this.SelectedItemId = itemId;
        	if(itemsByCategory != null)
        		this.ItemsBySubCategory = new List<SelectOption>(itemsByCategory);
        	else
        		this.ItemsBySubCategory = null;
        	this.PartnerOrderItemId = pOrderItemId;
        }
    }
}