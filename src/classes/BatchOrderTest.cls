@isTest
private class BatchOrderTest {
    
    static testMethod void myUnitTest() {
        Triggers__c  BatchOrderSetting  = Triggers__c.getValues('BatchOrder');
        
        System.runAs ( new User(Id = UserInfo.getUserId()) )
        {

        ////custom setting for batch Order

            if( BatchOrderSetting == null )
            {
                BatchOrderSetting = new Triggers__c( Name = 'BatchOrder');
                insert BatchOrderSetting;
                System.assertNotEquals( BatchOrderSetting.Id, null);
            }
            else
            {
                 if( BatchOrderSetting.Active__c != true )
                 {
                 BatchOrderSetting.Active__c = true;
                 update BatchOrderSetting;
                 }
            }
         }
        
        boolean nullBatch = FALSE;
        Partner_Order__c testOrder = new Partner_Order__c();
        testOrder.Status__c = 'Processing (printed, waiting to be packed)';
        testOrder.Caregiver_s_First_name__c = 'caregivers';
        testOrder.Caregiver_s_Last_name__c = 'caregivers';
        
        insert testOrder;
        update testOrder;
        
        Partner_Order__c testNull = [Select Id, Partner_Order_Batch__c From Partner_Order__c Where Id =: testOrder.Id];
        
        if(testNull.Partner_Order_Batch__c != NULL){
            nullBatch = TRUE;
        }
        
        System.assertEquals(TRUE, nullBatch);
    }
}