trigger RegistrationToVisitEmailRollup on Volunteer_Registration__c (after delete, after insert, after undelete, 
after update) {

set<ID> VisitIDs = new Set<ID>();
	
	if(Trigger.isInsert || Trigger.isUnDelete) {
		for(Volunteer_Registration__c reg : System.Trigger.new){
				if(reg.Con_Email__c <> NULL) {
					VisitIDs.add(reg.Volunteer_Visit__c);}
			}
		
		// query for all visits
		Volunteer_Visit__c[] visits = new List<Volunteer_Visit__c>();
		visits = [select Id, (select Num_of_Hours__c, Con_Email__c from Volunteers__r ) from Volunteer_Visit__c where ID in :VisitIDs ];
	
		Map<Id, Volunteer_Registration__c[]> visitreg = new Map<Id, Volunteer_Registration__c[]>();
		
		for (Volunteer_Visit__c eachVisit: visits){
			visitreg.put(eachVisit.Id, eachVisit.Volunteers__r);
			 }
				
		Volunteer_Visit__c[] updatedVisits = new List<Volunteer_Visit__c>();
		Volunteer_Registration__c[] volregs = new List<Volunteer_Registration__c>();
		
		for (Volunteer_Visit__c v : visits ){
					volregs=visitreg.get(v.Id);
					String recipients; 
											
					if(volregs.size()>0) {
						for(Volunteer_Registration__c r : volregs) {
								if(r.Con_Email__c <> NULL) {
									if (recipients == NULL) {recipients = r.Con_Email__c;}
									else {recipients = recipients + ' ; ' + r.Con_Email__c;}
									}
								}
						v.Email_list_of_registered_volunteer__c = recipients;
										
						updatedVisits.add(v);
					}			
		}
		
		if (updatedVisits.size()>0) {update updatedVisits;}
	}	

	if( Trigger.isUpdate ) {
		
		for (integer i = 0; i<Trigger.new.size(); i++) {
							
				//Handles the case of Status being changed to/from Completed
				if(Trigger.old[i].Con_Email__c <> Trigger.new[i].Con_Email__c)
					{VisitIDs.add(Trigger.new[i].Volunteer_Visit__c);}
					
		}
		
		// query for all visits
		Volunteer_Visit__c[] visits = new List<Volunteer_Visit__c>();
		visits = [select Id, (select Num_of_Hours__c, Con_Email__c from Volunteers__r) from Volunteer_Visit__c where ID in :VisitIDs ];
	
		Map<Id, Volunteer_Registration__c[]> visitreg = new Map<Id, Volunteer_Registration__c[]>();
		
		for (Volunteer_Visit__c eachVisit: visits){
			visitreg.put(eachVisit.Id, eachVisit.Volunteers__r);
			 }
				
		Volunteer_Visit__c[] updatedVisits = new List<Volunteer_Visit__c>();
		Volunteer_Registration__c[] volregs = new List<Volunteer_Registration__c>();
		
		for (Volunteer_Visit__c v : visits ){
					volregs=visitreg.get(v.Id);
					String recipients;
											
					if(volregs.size()>0) {
						for(Volunteer_Registration__c r : volregs) {
								if(r.Con_Email__c <> NULL) {
									if (recipients == NULL) {recipients = r.Con_Email__c;}
									else {recipients = recipients + ' ; ' + r.Con_Email__c;}
									}
								}
						v.Email_list_of_registered_volunteer__c = recipients;				
					}
					else
					{
						v.Email_list_of_registered_volunteer__c = NULL;
					}					
					updatedVisits.add(v);
		}
		
		if (updatedVisits.size()>0) {update updatedVisits;}
	}	
	
	
	if(Trigger.isDelete) {
		for(Volunteer_Registration__c reg : System.Trigger.old){
				if(reg.Con_Email__c <> NULL)
					{VisitIDs.add(reg.Volunteer_Visit__c);}
			}
		
		// query for all visits
		Volunteer_Visit__c[] visits = new List<Volunteer_Visit__c>();
		visits = [select Id, (select Num_of_Hours__c, Con_Email__c from Volunteers__r) from Volunteer_Visit__c where ID in :VisitIDs ];
	
		Map<Id, Volunteer_Registration__c[]> visitreg = new Map<Id, Volunteer_Registration__c[]>();
		
		for (Volunteer_Visit__c eachVisit: visits){
			visitreg.put(eachVisit.Id, eachVisit.Volunteers__r);
			 }
				
		Volunteer_Visit__c[] updatedVisits = new List<Volunteer_Visit__c>();
		Volunteer_Registration__c[] volregs = new List<Volunteer_Registration__c>();
		
		for (Volunteer_Visit__c v : visits ){
					volregs=visitreg.get(v.Id);
					String recipients;
											
					if(volregs.size()>0) {
						for(Volunteer_Registration__c r : volregs) {
								if(r.Con_Email__c <> NULL) {
									if (recipients == NULL) {recipients = r.Con_Email__c;}
									else {recipients = recipients + ' ; ' + r.Con_Email__c;}
									}
								}
						v.Email_list_of_registered_volunteer__c = recipients;				
					}
					else
					{
						v.Email_list_of_registered_volunteer__c = NULL;
					}					
					updatedVisits.add(v);
					
		}
		
		if (updatedVisits.size()>0) {update updatedVisits;}
	}	

}