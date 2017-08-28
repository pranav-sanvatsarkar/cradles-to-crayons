/*
   * Summary:     Create a new inventory transaction on insertion of new Partner Order Item if its partner order is not Bulk Order
   * Author:      Sheetal Patil
   * Created on: 18/12/2014
   * Modified by & on:
*/
 
trigger CreateTransactionOnPOIInsert on Partner_Order_Item__c (after insert, after update) {

    //list<Partner_Order_Item__c> lstPartnerOrderItem = new list<Partner_Order_Item__c>([SELECT id,Name,Qty_Fulfilled__c,Item__c,Partner_Order__r.IsBulkOrder__c,Partner_Order__r.status__c,Partner_Order__r.Site__c FROM Partner_Order_Item__c WHERE id IN : Trigger.new]);
    Triggers__c  TriggerSetting  = Triggers__c.getValues('CreateTransactionOnPOIInsert'); // trigger switch
   // system.debug('TriggerSetting '+TriggerSetting +'  TriggerSetting.Active__c ==>> checkRecursive.runOnce() &&  '+checkRecursive.myMethod() );
    if( checkRecursive.avoidRecurssion() && (TriggerSetting != null && TriggerSetting.Active__c) )
    {
         system.debug('Trigger is fired');
        CreateTransactionOnPOIInsertClass.CreateInventoryTransaction(Trigger.New);
    }
}