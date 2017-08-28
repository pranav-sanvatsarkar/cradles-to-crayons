trigger RHX_Parnter_Order on Partner_Order__c (after delete, after insert, after undelete, 
after update) {
	Boolean isRecordExist = false;
	Triggers__c RHX_Parnter_OrderSetting = Triggers__c.getInstance('RHX_Parnter_Order');
	if( RHX_Parnter_OrderSetting != null )
	{
		isRecordExist = false;
		if( RHX_Parnter_OrderSetting.Active__c )
			isRecordExist = true;
	}
	else
		isRecordExist = true;
		
	if( isRecordExist ){
	    if (trigger.isAfter) {
	    
	        Type rollClass = System.Type.forName('rh2', 'ParentUtil');
	        if(rollClass != null) {
	            rh2.PS_Rollup_Engine pu = (rh2.PS_Rollup_Engine) rollClass.newInstance();
	            Database.update(pu.performTriggerRollups(trigger.oldMap, trigger.newMap, null), false);
	         }
	    }
	}
}