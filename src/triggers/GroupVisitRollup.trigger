trigger GroupVisitRollup on Volunteer_Visit__c (after delete, after insert, after undelete, 
after update) {

	set<ID> GrpIDs = new Set<ID>();
	
	if(Trigger.isInsert || Trigger.isUnDelete) {
		for(Volunteer_Visit__c visit : System.Trigger.new){
				if((visit.Status__c == 'Completed' || visit.Status__c == 'Completed - Send Thanks') && visit.Org_Group__c <> NULL && (visit.Volunteer_Type__c == 'Family' || visit.Volunteer_Type__c == 'Group')) {
					GrpIDs.add(visit.Org_Group__c);}
			}
		
		if(GrpIDs.size()>0){RollupToGroup.DoImpact(GrpIDs);}
	}	

	if( Trigger.isUpdate ) {
		
		for (integer i = 0; i<Trigger.new.size(); i++) {
				//Handles the case of Volunteer_Visit__c.Volunteer__Type__c being changed
				if(Trigger.old[i].Volunteer_Type__c <> Trigger.new[i].Volunteer_Type__c && ((Trigger.new[i].Volunteer_Type__c == 'Group' || Trigger.new[i].Volunteer_Type__c == 'Family' ) || (Trigger.old[i].Volunteer_Type__c == 'Group' || Trigger.old[i].Volunteer_Type__c == 'Family' )  ))
					{if(Trigger.new[i].Org_Group__c <>NULL){GrpIDs.add(Trigger.new[i].Org_Group__c);}}
				
				//Handles the case of Status being changed to/from Completed
				if((Trigger.old[i].Status__c == 'Completed' || Trigger.new[i].Status__c == 'Completed - Send Thanks'|| Trigger.old[i].Status__c == 'Completed' || Trigger.old[i].Status__c == 'Completed - Send Thanks') && (Trigger.new[i].Volunteer_Type__c == 'Group' ||Trigger.new[i].Volunteer_Type__c == 'Family' ))
					{if(Trigger.old[i].Org_Group__c <>NULL){GrpIDs.add(Trigger.old[i].Org_Group__c);}}
					
				//Handles the case of Volunteer_Visit__c.Org_Group__c being changed
				//if(Trigger.old[i].Org_Group__c <> Trigger.new[i].Org_Group__c && (Trigger.new[i].Volunteer_Type__c == 'Group' ||Trigger.new[i].Volunteer_Type__c == 'Family' ) && (Trigger.new[i].Status__c == 'Completed' && Trigger.old[i].Status__c == 'Completed') )
				if(Trigger.old[i].Org_Group__c <> Trigger.new[i].Org_Group__c && (Trigger.new[i].Volunteer_Type__c == 'Group' ||Trigger.new[i].Volunteer_Type__c == 'Family' ) && (Trigger.new[i].Status__c == 'Completed' || Trigger.old[i].Status__c == 'Completed' || Trigger.new[i].Status__c == 'Completed - Send Thanks' || Trigger.old[i].Status__c == 'Completed - Send Thanks') )
					{
						if(Trigger.new[i].Org_Group__c <>NULL) {GrpIDs.add(Trigger.new[i].Org_Group__c);}
						if(Trigger.old[i].Org_Group__c <>NULL) {GrpIDs.add(Trigger.old[i].Org_Group__c);}
					}	
			}
		
		if(GrpIDs.size()>0){RollupToGroup.DoImpact(GrpIDs);}
	}	
	
	
	
	if(Trigger.isDelete) {
		for(Volunteer_Visit__c visit : System.Trigger.old){
				if((visit.Status__c == 'Completed' || visit.Status__c == 'Completed - Send Thanks')&& (visit.Volunteer_Type__c == 'Family' || visit.Volunteer_Type__c == 'Group' ))
					{if(visit.Org_Group__c <>NULL){GrpIDs.add(visit.Org_Group__c);}}
			}
		
		if(GrpIDs.size()>0){RollupToGroup.DoImpact(GrpIDs);}
	}	

}