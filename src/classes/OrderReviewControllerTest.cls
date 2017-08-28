@isTest
public class OrderReviewControllerTest { 
	static testMethod void verifyRedirectToLogin(){
        OrderReviewController.redirectToLogin();
    }
    static testMethod void verifyRenderOrder(){
		Partner_Order__c testOrder = C2CTestHelper.getKidpackOreder();
		C2CTestHelper.InsertWithAssert(testOrder);
		System.currentPageReference().getParameters().put('viewId', testOrder.Id);
		System.currentPageReference().getParameters().put('editVisiblity', 'none');
		System.currentPageReference().getParameters().put('cloneVisiblity', 'none');
		System.currentPageReference().getParameters().put('bulkCloneVisiblity','none');
		System.currentPageReference().getParameters().put('submitVisiblity', 'inline-block');
		OrderReviewController orderReview = new OrderReviewController();
		orderReview.submitOrder();
	}
}