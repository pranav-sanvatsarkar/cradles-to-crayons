trigger UpdateItemsOnFulfilledStatus on Partner_Order__c (after update) {

    Triggers__c  TriggerSetting  = Triggers__c.getValues('UpdateItemsOnFulfilledStatus'); // trigger switch
    if( checkRecursive.runOnce() && (TriggerSetting != null && TriggerSetting.Active__c) )
    {
        list<Partner_Order_item__c> lstPartnerOrderItem = new list<Partner_Order_item__c>();
        
        for(Partner_Order__c PartnerOrder: [select id,Status__c,(select name from Partner_Order_Items__r) from partner_order__c where id IN : Trigger.New AND Status__c = 'Fulfilled'])
        {
            if(PartnerOrder.Partner_Order_Items__r != null && PartnerOrder.Partner_Order_Items__r.size() > 0)
            {
                lstPartnerOrderItem.addAll(PartnerOrder.Partner_Order_Items__r);
            }
        }
        
        try
        {
            if(lstPartnerOrderItem != null && lstPartnerOrderItem.size() >0)
            {
                update lstPartnerOrderItem;
            }
        }
        catch(DmlException e)
        {
            Trigger.new[0].addError(e.getDmlMessage(0));
        }
    }
}