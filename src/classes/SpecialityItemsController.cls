public with sharing class SpecialityItemsController {
	 public String OrderLevel {get;set;}
     public User userDetails {get; set;}
     public Portal_Configuration__c  portalConfiguration {get;set;}
     
     public List<Item__c> lstItems{get;set;}   
   	 public Partner_Order__c partnerOrder {get;set;}		//Represents current Order.
     //public String bulkOrderToClone{get; set{if(String.isBlank(value)){value=null;}if(bulkOrderToClone!=value)setterFlag=true;bulkOrderToClone=value;if(setterFlag){renderComponent();setterFlag=false;}}}						//Used at the time of adding sibling.
     public String bulkOrderToClone{get; set;} 
     public List<BulkOrderItem> lstBulkOrderItems {get;set;}  //Represents order Items that are part of current bulk order.
     
     public Integer Index {get;set;}
     public Integer SelectedIndex {get;set;}
     public String rowIndex {get; set;} //Row Numbewr to delete
     public Boolean setterFlag;
     public SpecialityItemsController(){
    	renderComponent();
     }
    public void renderComponent(){
        system.debug('order id----'+bulkOrderToClone);
	 	bulkOrderToClone = ApexPages.CurrentPage().getParameters().get('cloneId');
	 	lstBulkOrderItems = new List<BulkOrderItem>();
	 	partnerOrder = new Partner_Order__c(); 
	 	Index = 0;
	 	try{
			userDetails = [SELECT ID,name,Phone,Site__c,ContactId,username,Contact.Account.Order_Level__c,Contact.Accountid,Contact.EnableBulkOrder__c,Contact.Name,Contact.Email,Contact.Phone
							FROM USER WHERE username = :UserInfo.getUserName() limit 1];
			lstItems = new  List<Item__c>([SELECT Id,Name,Ages__c,Category__c,Container_Type__c,Gender__c,Season__c,Shopping_Location__c,Size__c,SKU__c,Type_Sub_Category__c,BabyGearType__c ,Site__c,Bulk_Type__c,Available_As_Kid_Pack_Item__c,Available_As_Bulk_Item__c 
											FROM Item__c WHERE Site__c= :userDetails.Site__c ORDER BY Size_Reporting_Order__c LIMIT 10000]);
		}
		catch (Exception userDetailsException){
			System.debug('PartnerBulkOrderController :: Constructor :: userDetailsException ::Exception:'+userDetailsException);
		}
		if(String.isNotBlank(bulkOrderToClone))
			CloneOrder();
			
		if(userDetails != null ){
			if(userDetails.Contact.Account.Order_Level__c != null)
				OrderLevel = String.valueOf(userDetails.Contact.Account.Order_Level__c); 
			if(userDetails.Site__c != null)
				portalConfiguration = [SELECT Id, Location__c,Message__c,EnableBulkOrder__c,EnableOrder__c FROM Portal_Configuration__c WHERE Location__c =: userDetails.Site__c LIMIT 1];
			
			//Copy relevant contact fields from user's Contact
			partnerOrder.Who_will_pick_up__c = userDetails.Contact.Name;
	        partnerOrder.Partner_Email__c = userDetails.Contact.Email; 
	        partnerOrder.Who_will_pick_up_phone__c = userDetails.Contact.Phone;
	        partnerOrder.Site__c = userDetails.Site__c;
		}
		List<SelectOption> lstoptions = new List<SelectOption>();
	    lstoptions.add(new SelectOption('--None--','--None--' ));
	    if(bulkOrderToClone == null){
	        lstBulkOrderItems.add(new BulkOrderItem(lstoptions , 2,0));  //item types list,quantity and index
	        lstBulkOrderItems.add(new BulkOrderItem(lstoptions , 2,1));
	        lstBulkOrderItems.add(new BulkOrderItem(lstoptions , 2,2));
	        Index = 2;
	    }

        
    }
    public static PageReference redirectToLogin(){
        if(UserInfo.getUserType() == 'Guest')
            return Network.communitiesLanding();
        else
            return null;
    }
	 public void CloneOrder(){
	 	 partnerOrder = [SELECT Id,Child_s_Story__c,Status__c,Submitted_Date__c,Contact__c,Partner__c,IsBulkOrder__c,Partner_Email__c,Partner_Phone__c,PickUpDay__c,Pick_up_Hours__c,Who_will_pick_up__c,Who_will_pick_up_phone__c,Location__c
                         	FROM Partner_Order__c WHERE Id = :bulkOrderToClone LIMIT 1];
         List<Partner_Order_Item__c> lstOldPartnerItem = new List<Partner_Order_Item__c>([SELECT Id ,Comment__c,Item__c,Partner_Order__c,Qty_Fulfilled__c,Qty_Ordered__c 
                                                     		FROM Partner_Order_Item__c WHERE  Partner_Order__c =: bulkOrderToClone limit 10000]);
		 Integer oldIndex = 0;
		 for(Partner_Order_Item__c oldPartnerItem : lstOldPartnerItem){  //Items specific for order to be cloned.Populate UI bound list
			 for(Item__c item : lstItems){  							//iterate ver items corresponding to site
		     	if(oldPartnerItem != null && oldPartnerItem.Item__c == item.Id){
	                List<Selectoption> lstOptions = new  List<Selectoption>();
	                for(Item__c OptionItems : lstItems){ 
	                	if(item.Bulk_Type__c == OptionItems.Bulk_Type__c)
	                	lstOptions.add(new SelectOption(OptionItems.id, OptionItems.name)); 
	                }
	                BulkOrderItem partnerItem =  new BulkOrderItem(lstOptions,Integer.valueOf(oldPartnerItem.Qty_Ordered__c), Index);
	                partnerItem.ItemBulkType.Bulk_Type__c = item.Bulk_Type__c;
	                partnerItem.SelectedItemId = item.Id;
	                lstBulkOrderItems.add(partnerItem);
	                Index++;
		         }
		    }
		 }
         Index = (lstBulkOrderItems.size() < 1) ? 0 : (lstBulkOrderItems.size() - 1); 
	 }
	 
	 //Adds row to Item list with blank initialization.
	 public void AddItemRows(){
        List<SelectOption> lstoptions = new List<SelectOption>();
	    lstoptions.add(new SelectOption('--None--','--None--' ));
		Index++;
	    lstBulkOrderItems.add(new BulkOrderItem(lstoptions , 2, Index));
	 }
	 
	 //This method deletes the row from list of items.
	 public void DeleteItemRow(){
	 	System.debug(rowIndex);
	 	Integer deleteIndex = Integer.valueOf(rowIndex);
	 	lstBulkOrderItems.remove(deleteIndex);
	 	Index--;
	 }
	 
	 //This method populates item list by selected type.
	 public void PopulateItemsByType(){
		BulkOrderItem selectedItem = lstBulkOrderItems.get(SelectedIndex);
	   	selectedItem.BulkTypeItems = new List<selectOption>(); 
	   	selectedItem.BulkTypeItems.add(new SelectOption('--None--','--None--' ));
		for(Item__c item : lstItems){ 	       									//Fills out item list by selected type
			/*if(item.Available_As_Bulk_Item__c == 'Active'){
				if(selectedItem.ItemBulkType.Bulk_Type__c != null)		 
					if(item.Bulk_Type__c == selectedItem.ItemBulkType.Bulk_Type__c)
						selectedItem.BulkTypeItems.add(new SelectOption(item.id, item.name ));
			}*/
			if(item.Available_As_Bulk_Item__c == 'Active' && item.Available_As_Kid_Pack_Item__c == 'Active'){
				if(selectedItem.ItemBulkType.Bulk_Type__c != null)		 
					if(item.Bulk_Type__c == selectedItem.ItemBulkType.Bulk_Type__c)
						selectedItem.BulkTypeItems.add(new SelectOption(item.id, item.name ));
			}
		} 
	    lstBulkOrderItems[SelectedIndex] = selectedItem;
	 }
	 
	 public void SubmitOrder(){	
             List<Partner_Order_Item__c> lstOrderItems = new List<Partner_Order_Item__c>();
            Partner_Order_Item__c pItem;	
            if(String.isBlank(bulkOrderToClone)){
                partnerOrder.Status__c = 'Submitted (order placed)';
                partnerOrder.Submitted_Date__c = Datetime.now();
                partnerOrder.Contact__c = userDetails.ContactId;
                partnerOrder.Partner__c = userDetails.Contact.AccountId;
                partnerOrder.IsBulkOrder__c = true; 
            
                Database.insert(partnerOrder);
                for(BulkOrderItem obj : lstBulkOrderItems){  
                    if(obj != null && obj.SelectedItemId != null && obj.SelectedItemId != '--None--'){ 
                         pItem = new  Partner_Order_Item__c();
                         pItem.Partner_Order__c = partnerOrder.Id;
                         pItem.Item__c = obj.SelectedItemId;
                         pItem.Qty_Ordered__c =  obj.Quantity;
                         pItem.Qty_Fulfilled__c = 0;  
                         lstOrderItems.add(pItem);
                    }
                } 
            }
            else{	//clone order 
                 Partner_Order__c clonePartnerOrder = partnerOrder.clone(false,true);      
                 clonePartnerOrder.Status__c = 'Submitted (order placed)';
                 clonePartnerOrder.Submitted_Date__c = Datetime.now();
                 clonePartnerOrder.Contact__c = userDetails.ContactId;
                 clonePartnerOrder.Partner__c = userDetails.Contact.AccountId;
                 clonePartnerOrder.IsBulkOrder__c = true;
                 clonePartnerOrder.Site__c = userDetails.Site__c;
                 Database.insert(clonePartnerOrder);
                 for(BulkOrderItem obj : lstBulkOrderItems){  
                     if(obj != null && obj.SelectedItemId != null && obj.SelectedItemId != '--None--'){ 
                          pItem = new  Partner_Order_Item__c();
                          pItem.Partner_Order__c = clonePartnerOrder.Id;
                          pItem.Item__c = obj.SelectedItemId;
                          pItem.Qty_Ordered__c =  obj.Quantity;
                          pItem.Qty_Fulfilled__c = 0;  
                          lstOrderItems.add(pItem);
                     }
                 } 
             }
             if(lstOrderItems.size() > 0 )
                     insert lstOrderItems;
             setterFlag=true;
	 	
	 }    
	 public PageReference submit(){ 
         try{
             SubmitOrder(); 
             return new PageReference('/apex/communityDashboard').setRedirect(False);  
         }catch(Exception ex){
             return null;
         }
		 
	 }
	 
	 public PageReference submitNew(){
         try{
             SubmitOrder();
			return new PageReference('/apex/specialityItems').setRedirect(True);
         }catch(Exception ex){
             return null;
         }
	 }
	
	 public void cancel(){
		//return new PageReference('/apex/communityDashboard').setRedirect(False);
	 } 
	 //This class represents Item available in bulk order
	 public class BulkOrderItem {
        public Item__c ItemBulkType { get; set;}
        public Integer Quantity { get; set;}
        public List<SelectOption> BulkTypeItems { get; set;}
        public Integer Index { get; set;}
        public String SelectedItemId { get; set;}
        
        public BulkOrderItem(List<SelectOption> itemsByType, Integer quantity, Integer index){
        	this.ItemBulkType =  new Item__c();
            this.BulkTypeItems = itemsByType;
			this.Quantity = quantity;
            this.Index = index;
            SelectedItemId = null;
        }
     }
}