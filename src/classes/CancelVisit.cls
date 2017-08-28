Global class CancelVisit {
// Change Visit Status to Cancelled
// Change all Status field for all related registration records to Cancelled

	webService static void DoCancelVisit(Id visitId) 
    {
        //change Visit Status to Cancelled     
        Volunteer_Visit__c v = [select Id, Status__c, Actual_Date_Time__c, Scheduled_Start_Date_Time__c from Volunteer_Visit__c where Id = :visitId limit 1];                
       //if (v.Status__c == 'Cancelled' && v.Actual_Date_Time__c==null && v.Scheduled_Start_Date_Time__c > System.Today()) {
		if (v.Actual_Date_Time__c==null && v.Scheduled_Start_Date_Time__c > System.Today()) {

        	Volunteer_Visit__c visittoupdate = new Volunteer_Visit__c(Id = visitId, Status__c='Cancelled');
        	update visittoupdate;
        
                
        	// Change all Status field for all related registration records to Cancelled
       		Volunteer_Registration__c[] registrationstoupdate = new List<Volunteer_Registration__c>();
        	Volunteer_Registration__c[] registrations = [select Id, Status__c from Volunteer_Registration__c where Volunteer_Visit__c = :visitId]; 
       		 if (registrations.size()>0) {
        		for(Volunteer_Registration__c r : registrations){
        		
        			Volunteer_Registration__c reg =  new Volunteer_Registration__c(
						Id = r.Id,
						Status__c = 'Cancelled');
						registrationstoupdate.add(reg);
        		}
     
        		
       		 }
       		 if(registrationstoupdate.size()>0) {update registrationstoupdate;}	
        }         
    }
}