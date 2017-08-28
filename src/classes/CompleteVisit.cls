global class CompleteVisit {
// Change Visit Status to Completed
// Change all Status field for all related registration records to Completed

	webService static void DoCompleteVisit(Id visitId) 
    {
        //change Visit Status to Completed      
        Volunteer_Visit__c v = [select Id, Duration_In_Hours__c, Actual_Date_Time__c from Volunteer_Visit__c where Id = :visitId limit 1];                
        Volunteer_Visit__c visittoupdate = new Volunteer_Visit__c(Id = visitId, Status__c='Completed');
        update visittoupdate;
                
        // Change all Status field for all related registration records to Completed
        Volunteer_Registration__c[] registrationstoupdate = new List<Volunteer_Registration__c>();
        Volunteer_Registration__c[] registrations = [select Id, Status__c from Volunteer_Registration__c where Volunteer_Visit__c = :visitId]; 
        if (registrations.size()>0) {
        	for(Volunteer_Registration__c r : registrations){
        		Volunteer_Registration__c reg =  new Volunteer_Registration__c(
						Id = r.Id,
						Status__c = 'Completed',
						Num_of_Hours__c=v.Duration_In_Hours__c,
						Actual_Start_Date_Time__c=v.Actual_Date_Time__c);
				registrationstoupdate.add(reg);	
        	}
     
        	if(registrationstoupdate.size()>0) {update registrationstoupdate;}	
        }         
    }
}