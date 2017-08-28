trigger RegistrationToVisitRollup on Volunteer_Registration__c (after delete, after insert, after undelete, 
after update) {

	set<ID> VisitIDs = new Set<ID>();
	
	if(Trigger.isInsert || Trigger.isUnDelete) {
		for(Volunteer_Registration__c reg : System.Trigger.new){
				if(reg.Status__c == 'Completed') {
					VisitIDs.add(reg.Volunteer_Visit__c);}
			}
		
		// query for all visits
		Volunteer_Visit__c[] visits = new List<Volunteer_Visit__c>();
		visits = [select Id, (select Num_of_Hours__c, Con_Email__c from Volunteers__r where Status__c = 'Completed') from Volunteer_Visit__c where ID in :VisitIDs ];
	
		Map<Id, Volunteer_Registration__c[]> visitreg = new Map<Id, Volunteer_Registration__c[]>();
		
		for (Volunteer_Visit__c eachVisit: visits){
			visitreg.put(eachVisit.Id, eachVisit.Volunteers__r);
			 }
				
		Volunteer_Visit__c[] updatedVisits = new List<Volunteer_Visit__c>();
		Volunteer_Registration__c[] volregs = new List<Volunteer_Registration__c>();
		
			for (Volunteer_Visit__c v : visits ){
					volregs=visitreg.get(v.Id);
					Double SumOfHours = 0;
											
					if(volregs.size()>0) {
						for(Volunteer_Registration__c r : volregs) {
								SumOfHours += r.Num_of_Hours__c;
								}
						v.Actual_hours__c = SumOfHours;
						v.Actual_volunteers__c = volregs.size();
										
						updatedVisits.add(v);
					}			
			}
		
		if (updatedVisits.size()>0) {update updatedVisits;}
	}	

	if( Trigger.isUpdate ) {
		
		for (integer i = 0; i<Trigger.new.size(); i++) {
				//if (Trigger.old[i].Status__c == 'Completed' || Trigger.new[i].Status__c == 'Completed')					
				// if status has been changed to Completed
				// if number of hours have changed
				// if volunteer visit has changed
				if ((Trigger.old[i].Status__c <> 'Completed' && Trigger.new[i].Status__c == 'Completed')
				|| (Trigger.old[i].Status__c == 'Completed' && Trigger.new[i].Status__c <> 'Completed')
				|| (Trigger.old[i].Num_of_Hours__c <> Trigger.new[i].Num_of_Hours__c) 
				|| (Trigger.old[i].Volunteer_Visit__c <> Trigger.new[i].Volunteer_Visit__c)) 
					{VisitIDs.add(Trigger.new[i].Volunteer_Visit__c);}
									
		}
		
		// query for all visits
		Volunteer_Visit__c[] visits = new List<Volunteer_Visit__c>();
		visits = [select Id, (select Num_of_Hours__c, Con_Email__c from Volunteers__r where Status__c = 'Completed') from Volunteer_Visit__c where ID in :VisitIDs ];
	
		Map<Id, Volunteer_Registration__c[]> visitreg = new Map<Id, Volunteer_Registration__c[]>();
		
		for (Volunteer_Visit__c eachVisit: visits){
			visitreg.put(eachVisit.Id, eachVisit.Volunteers__r);
			 }
				
		Volunteer_Visit__c[] updatedVisits = new List<Volunteer_Visit__c>();
		Volunteer_Registration__c[] volregs = new List<Volunteer_Registration__c>();
		
			for (Volunteer_Visit__c v : visits ){
					volregs=visitreg.get(v.Id);
					Double SumOfHours = 0;
											
					if(volregs.size()>0) {
						for(Volunteer_Registration__c r : volregs) {
								SumOfHours += r.Num_of_Hours__c;
								}
						v.Actual_hours__c = SumOfHours;
						v.Actual_volunteers__c = volregs.size();
					}
					else
					{
						v.Actual_hours__c = NULL;
						v.Actual_volunteers__c = NULL;
					}					
						updatedVisits.add(v);
					
			}
		
		if (updatedVisits.size()>0) {update updatedVisits;}
	}	
	
	
	if(Trigger.isDelete) {
		for(Volunteer_Registration__c reg : System.Trigger.old){
				if(reg.Status__c == 'Completed')
					{VisitIDs.add(reg.Volunteer_Visit__c);}
			}
		
		// query for all visits
		Volunteer_Visit__c[] visits = new List<Volunteer_Visit__c>();
		visits = [select Id, (select Num_of_Hours__c, Con_Email__c from Volunteers__r where Status__c = 'Completed') from Volunteer_Visit__c where ID in :VisitIDs ];
	
		Map<Id, Volunteer_Registration__c[]> visitreg = new Map<Id, Volunteer_Registration__c[]>();
		
		for (Volunteer_Visit__c eachVisit: visits){
			visitreg.put(eachVisit.Id, eachVisit.Volunteers__r);
			 }
				
		Volunteer_Visit__c[] updatedVisits = new List<Volunteer_Visit__c>();
		Volunteer_Registration__c[] volregs = new List<Volunteer_Registration__c>();
		
			for (Volunteer_Visit__c v : visits ){
					volregs=visitreg.get(v.Id);
					Double SumOfHours = 0;
											
					if(volregs.size()>0) {
						for(Volunteer_Registration__c r : volregs) {
								SumOfHours += r.Num_of_Hours__c;
								}
						v.Actual_hours__c = SumOfHours;
						v.Actual_volunteers__c = volregs.size();
					}
					else
					{
						v.Actual_hours__c = NULL;
						v.Actual_volunteers__c = NULL;
					}					
						updatedVisits.add(v);
					
			}
		
		if (updatedVisits.size()>0) {update updatedVisits;}
	}	



}