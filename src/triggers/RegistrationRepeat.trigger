trigger RegistrationRepeat on Volunteer_Registration__c (before insert, before update) {
	 
	set<ID> ContIDs = new Set<ID>();
	Volunteer_Registration__c[] registrations = new List<Volunteer_Registration__c>(); 
	Map<Id, Integer> VisitIDRepeat = new Map<Id, Integer>();
	
	if(Trigger.IsInsert || Trigger.IsUpdate){
		
		for (Volunteer_Registration__c v : Trigger.new) {
			if (v.Status__c == 'Completed'){
					contIDs.add(v.Contact__c);
					registrations.add(v);
			}
		}
		Contact[] conts = new List<Contact>();
        conts = [select Id, of_Volunteer_Visit__c ,of_Group_Volunteer_Visit__c from Contact where ID in :contIDs];
        for (Contact c: conts) {
        	if(c.of_Volunteer_Visit__c >0 || c.of_Group_Volunteer_Visit__c>0)
            	{VisitIDRepeat.put(c.Id,1);}
            //else
            	//{VisitIDRepeat.put(c.Id,'1');}
           }
		
		
		
		for (Volunteer_Registration__c vr : registrations ){
            if(VisitIDRepeat.get(vr.Contact__c) <> NULL) {
            	vr.Repeat__c = VisitIDRepeat.get(vr.Contact__c);
            	}
            }
		
	}

}