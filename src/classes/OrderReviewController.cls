public  class OrderReviewController {
	public User userDetails { get; set;}
    public String orderId { get;set;} 									 // Id of the order being displayed captured as pagereference parameter.
	public Partner_Order__c partnerOrder { get; set;}					 // Partner order.
	public String partnerOrderStatus { get; set;} 						 //Order status.
	public List<Partner_Order_Item__c> lstPartnerOrderItem {get; set;}  //List of order Items
	public String editVisiblity{get;set;}
	public String cloneVisiblity{get;set;}
	public String bulkCloneVisiblity{get;set;}
    public String submitVisiblity{get;set;}
	public String submitSpanVisiblity{get;set;}
    public OrderReviewController(){
    	renderOrder();
    }
    public void renderOrder(){
        orderId = ApexPages.CurrentPage().getParameters().get('viewId');
        editVisiblity = ApexPages.CurrentPage().getParameters().get('editVisiblity');
        cloneVisiblity = ApexPages.CurrentPage().getParameters().get('cloneVisiblity');
        bulkCloneVisiblity = ApexPages.CurrentPage().getParameters().get('bulkCloneVisiblity');
        submitVisiblity = ApexPages.CurrentPage().getParameters().get('submitVisiblity');
        if(submitVisiblity=='inline-block')
			submitSpanVisiblity = 'block';
		else
			submitSpanVisiblity = 'none';
		userDetails = [SELECT ID, name, Phone, Site__c, ContactId, username, Contact.AccountId, Contact.Account.Order_Level__c, Contact.Phone, Contact.EnableBulkOrder__c, Contact.Email
            				FROM USER WHERE username = : UserInfo.getUserName() LIMIT 1];
    	if(String.isNotBlank(orderId) && userDetails != null){
    		partnerOrder = [SELECT Id, name, Caregiver_s_First_name__c, Caregiver_s_Last_name__c, Child_s_Story__c, Child_Age__c, Child_Birthdate__c, Child_First_Name__c, Child_Gender__c, Child_Home_Zip_Code__c, Child_Last_Name__c, Contact__c, Emergency_Order__c, Emergency_Other__c, Emergency_Type__c, Fulfilled_Date__c, Num_Fulfilled_Item__c, Num_Ordered_Item__c, Num_Out_of_Stock_Item__c, Partner__c, Partner_Order_Batch__c, Picked_Up_Date__c, Who_will_pick_up_phone__c, Printed_Date__c, Emergency_Reason__c, Shelf_Location__c, Status__c, Submitted_Date__c, Who_will_pick_up__c, Partner_Email__c, Location__c, Site__c
                				FROM Partner_Order__c WHERE id = : orderId LIMIT 1];
            lstPartnerOrderItem = [SELECT Id, Item__c,Item__r.Name, comment__c, Partner_Order_Status__c, Qty_Fulfilled__c, Qty_Ordered__c, Partner_Order__c from Partner_Order_Item__c WHERE Partner_Order__c = : orderId];
            partnerOrderStatus = partnerOrder.Status__c;
    	}
        
    }
    public static PageReference redirectToLogin(){
        if(UserInfo.getUserType() == 'Guest')
            return Network.communitiesLanding();
        else
            return null;
    }
    public PageReference submitOrder(){
        try{
            partnerOrder.Status__c = 'Submitted (order placed)';
            partnerOrder.Submitted_Date__c = Datetime.now();
            Database.update(partnerOrder);
            return new PageReference('/apex/CommunityDashboard').setRedirect(true); 
        }catch(Exception ex){
            return null;
        }

    }
    public PageReference submitAndNew(){
        try{
            partnerOrder.Status__c = 'Submitted (order placed)';
            partnerOrder.Submitted_Date__c = Datetime.now();
            Database.update(partnerOrder);
            return new PageReference('/apex/KidpackStepOne').setRedirect(true);
        }catch(Exception ex){
            return null;
        }
    	
    }
}