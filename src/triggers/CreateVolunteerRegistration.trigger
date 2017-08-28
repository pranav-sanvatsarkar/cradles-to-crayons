trigger CreateVolunteerRegistration on Volunteer_Visit__c (after insert, after update) {
	if(!Validator_cls.hasAlreadyDone()){
		set<ID> volvisitIDs = new Set<ID>();
		set<ID> volvisitDelIDs = new Set<ID>();
		if(Trigger.isInsert) {
			
			for(Volunteer_Visit__c vv : System.Trigger.new){
						if(vv.Do_Not_Autocreate_Registration__c == FALSE && vv.Main_Contact_Volunteer__c == TRUE && (vv.Status__c == 'Scheduled' || vv.Status__c == 'Pre-registration sent' || vv.Status__c == 'Completed'))
						volvisitIDs.add(vv.Id);
			}
			// If the set is not empty
			// create a list of volunteer visit
			// create a list of volunteer registration and add to the corresponding volunteer visit
			if(volvisitIDs.size()<>0){
				Volunteer_Visit__c[] visits = new List<Volunteer_Visit__c>();
				visits = [select Id, Main_Contact__c, Volunteer_Type__c from Volunteer_Visit__c where ID in :volvisitIDs];
				Volunteer_Registration__c[] registrations = new List<Volunteer_Registration__c>();
					for (Volunteer_Visit__c v : visits){
						if(v.Volunteer_Type__c == 'Individual') {
							Volunteer_Registration__c registration =  new Volunteer_Registration__c(
							Volunteer_Visit__c=v.Id,
							Status__c = 'Pre-registered',
							Role__c = 'Volunteer',
							Contact__c = v.Main_Contact__c);
							registrations.add(registration);}
						else {
							Volunteer_Registration__c registration =  new Volunteer_Registration__c(
							Volunteer_Visit__c=v.Id,
							Status__c = 'Pre-registered',
							Role__c = 'Group Leader',
							Contact__c = v.Main_Contact__c);
							registrations.add(registration);}	
		  			}
					insert registrations;	
					Validator_cls.setAlreadyDone();
			}
		}

	if(Trigger.isUpdate) {
		for (integer i = 0; i<Trigger.new.size(); i++) {
        	if(Trigger.new[i].Do_Not_Autocreate_Registration__c == FALSE && (Trigger.old[i].Status__c == 'Inquiry'||Trigger.old[i].Status__c == 'Prospect'||Trigger.old[i].Status__c == 'Contacted') && (Trigger.new[i].Status__c == 'Scheduled' 
                    	|| Trigger.new[i].Status__c == 'Pre-registration sent' || Trigger.new[i].Status__c == 'Completed') && Trigger.new[i].Main_Contact_Volunteer__c == True){
                    	volvisitIDs.add(Trigger.old[i].Id);                   		
           	}
           if(Trigger.new[i].Do_Not_Autocreate_Registration__c == FALSE && (Trigger.old[i].Status__c <> 'Inquiry' || Trigger.old[i].Status__c == 'Prospect'||Trigger.old[i].Status__c == 'Contacted') && Trigger.new[i].Status__c == 'Inquiry' && Trigger.new[i].Main_Contact_Volunteer__c == True){
                    	volvisitDelIDs.add(Trigger.new[i].Id);                   		
           	}	
		}
		if(volvisitIDs.size()<>0){
			Volunteer_Visit__c[] visits = new List<Volunteer_Visit__c>();
			visits = [select Id, Main_Contact__c, Volunteer_Type__c  from Volunteer_Visit__c where ID in :volvisitIDs];
			Volunteer_Registration__c[] registrations = new List<Volunteer_Registration__c>();
			for (Volunteer_Visit__c v : visits){
				if(v.Volunteer_Type__c == 'Individual') {
					Volunteer_Registration__c registration =  new Volunteer_Registration__c(
						Volunteer_Visit__c=v.Id,
						Status__c = 'Pre-registered',
						Role__c = 'Volunteer',
						Contact__c = v.Main_Contact__c);
						registrations.add(registration);}
				else {
						Volunteer_Registration__c registration =  new Volunteer_Registration__c(
						Volunteer_Visit__c=v.Id,
						Status__c = 'Pre-registered',
						Role__c = 'Group Leader',
						Contact__c = v.Main_Contact__c);
						registrations.add(registration);}
		  	}
			insert registrations;
			Validator_cls.setAlreadyDone();	
		}	
		if(volvisitDelIDs.size()<>0){
			Volunteer_Registration__c[] regs = new List<Volunteer_Registration__c>();
			regs = [select Id  from Volunteer_Registration__c where Volunteer_Visit__c in :volvisitDelIDs];
			delete regs;	
		}
	}
	}
}