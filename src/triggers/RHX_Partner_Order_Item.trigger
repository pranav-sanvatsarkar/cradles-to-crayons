trigger RHX_Partner_Order_Item on Partner_Order_Item__c (after delete, after insert, after undelete, 
after update) {

	if (trigger.isAfter) {
    
        Type rollClass = System.Type.forName('rh2', 'ParentUtil');
        if(rollClass != null) {
            rh2.PS_Rollup_Engine pu = (rh2.PS_Rollup_Engine) rollClass.newInstance();
            Database.update(pu.performTriggerRollups(trigger.oldMap, trigger.newMap, null), false);
         }
    }
}