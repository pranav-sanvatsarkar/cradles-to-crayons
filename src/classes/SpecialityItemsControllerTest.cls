@isTest
public class SpecialityItemsControllerTest { 
    static testMethod void verifyRedirectToLogin(){
        SpecialityItemsController.redirectToLogin();
    }
    static testMethod void verifyrenderComponent(){
        Portal_Configuration__c testPortal = C2CTestHelper.getPortalConfiguration();
		C2CTestHelper.InsertWithAssert(testPortal);
        Item__c item1 = C2CTestHelper.getItem();
        C2CTestHelper.InsertWithAssert(item1);
		SpecialityItemsController speciality = new SpecialityItemsController();
		SpecialityItemsController.BulkOrderItem orderitem1 = new SpecialityItemsController.BulkOrderItem(null,10,0);
		orderitem1.SelectedItemId = item1.Id;
        speciality.lstBulkOrderItems.add(orderitem1);
       	speciality.SelectedIndex = 3;
        speciality.PopulateItemsByType();
        speciality.AddItemRows();
        speciality.rowIndex = '0';
        speciality.DeleteItemRow();
		speciality.submitNew();
		Partner_Order__c cloneOrder = [Select Id from Partner_Order__c Limit 1];
		System.currentPageReference().getParameters().put('cloneId', cloneOrder.Id);
		SpecialityItemsController specialityClone = new SpecialityItemsController();
		specialityClone.submit();
	}
    
}