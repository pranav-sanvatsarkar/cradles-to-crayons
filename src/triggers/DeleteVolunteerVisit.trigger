trigger DeleteVolunteerVisit on Volunteer_Visit__c (before delete) {
	set<ID> VisitIDs = new Set<ID>();
	if(Trigger.isDelete) {
		// create a list of visit Id
		for(Volunteer_Visit__c vv : System.Trigger.old)
	 	{
			VisitIDs.add(vv.Id);
		}
		// get all corresponding registrations
		Volunteer_Registration__c[] regs = new List<Volunteer_Registration__c>();
		regs = [select Id from Volunteer_Registration__c where Volunteer_Visit__c in :VisitIDs ];
		// delete all corresponding registrations
		delete regs;
	}


}