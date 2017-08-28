trigger RHX_Volunteer_Registration on Volunteer_Registration__c (after insert, after update, after delete, after undelete){   
        if (trigger.isAfter){            
            Type rollClass = System.Type.forName('rh2', 'ParentUtil');        
            if(rollClass != null) {            
                RH2.PS_Rollup_Engine pu = (RH2.PS_Rollup_Engine) rollClass.newInstance();            
                Database.update(pu.performTriggerRollups(trigger.oldMap, trigger.newMap, null), false);         
            }    
        }
    }