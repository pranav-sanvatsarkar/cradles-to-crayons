public class C2CTestHelper 
{ 
	public static User userDetails {get;set;}
	public static Portal_Configuration__c getPortalConfiguration()
    {
		userDetails = [SELECT ID,name,Phone,Site__c,ContactId,username,Contact.Account.Order_Level__c,Contact.Accountid,Contact.EnableBulkOrder__c,Contact.Name,Contact.Email,Contact.Phone
							FROM USER WHERE username = :UserInfo.getUserName() limit 1];
        System.debug('userDetails:: ' + userDetails);
        Portal_Configuration__c testPortal = new Portal_Configuration__c();
		testPortal.Name= 'Test Portal Configuration';
		testPortal.Message__c = 'Test Messege';
		testPortal.EnableBulkOrder__c = true;
	    testPortal.Location__c = userDetails.Site__c;
		testPortal.EnableOrder__c = true;
		return testPortal;
	}
	public static Database.SaveResult InsertWithAssert(sObject dataObject)
    {
        Database.SaveResult saveResult = Database.insert(dataObject);
        System.assert(saveResult.isSuccess());
        return saveResult;
    }
	public static Partner_Order_Item__c getOrderItem(Id orderId)
    {
		Partner_Order_Item__c testOrderItem = new Partner_Order_Item__c();
		testOrderItem.Partner_Order__c = orderId;
		return testOrderItem;
	}
    public static Item__c getItem()
    {
        Item__c testItem = new Item__c();
		testItem.Site__c = userDetails.Site__c;
        testItem.Available_As_Bulk_Item__c = 'Active';
        testItem.Available_As_Kid_Pack_Item__c = 'Active';
        return testItem;
    }
	public static Partner_Order__c getSpecialityOreder()
    {
		Partner_Order__c testOrder = new Partner_Order__c();
		return testOrder;
	}
	public static Partner_Order__c getKidpackOreder()
    {
		userDetails = [SELECT ID,name,Phone,Site__c,ContactId,username,Contact.Account.Order_Level__c,Contact.Accountid,Contact.EnableBulkOrder__c,Contact.Name,Contact.Email,Contact.Phone
							FROM USER WHERE username = :UserInfo.getUserName() limit 1];
        Partner_Order__c testOrder = new Partner_Order__c();
        testOrder.Partner__c = userdetails.Contact.AccountId;
		return testOrder;
	}

}