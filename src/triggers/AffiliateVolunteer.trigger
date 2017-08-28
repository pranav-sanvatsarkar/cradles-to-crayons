trigger AffiliateVolunteer on Volunteer_Registration__c (after delete, after insert, after undelete, 
after update) {
	set<ID> ConIDs = new Set<ID>();
	Map<Id, Id> ContactOrganization = new Map<Id, Id>();
	
	if(Trigger.isInsert || Trigger.isUnDelete || Trigger.isUpdate) {
		for(Volunteer_Registration__c reg : System.Trigger.new){
				if(reg.Status__c == 'Completed' && (reg.Inquiry_Type__c == 'Group' || reg.Inquiry_Type__c == 'Family') && reg.Org_ID__c <> NULL) {
					ConIDs.add(reg.Contact__c);
					//ContactOrganization.put(reg.Contact__r.Id, reg.Volunteer_Visit__r.Org_Group__r.Id);
					ContactOrganization.put(reg.Con_ID__c, reg.Org_ID__c);
			}
		}
	// get all the contacts and related affiliations
		Contact[] conts = new List<Contact>();
		conts = [select Id, (select npe5__Organization__c from npe5__Affiliations__r where Type__c = 'C2C Volunteer') from Contact where ID in :ConIDs ];

		Map<Id, npe5__Affiliation__c[]> conaff = new Map<Id, npe5__Affiliation__c[]>();
		for (Contact eachCon: conts){
			conaff.put(eachCon.Id, eachCon.npe5__Affiliations__r);
		 } 
		npe5__Affiliation__c[] Affiliationstocreate = new List<npe5__Affiliation__c>();
		npe5__Affiliation__c[] Affs = new List<npe5__Affiliation__c>();
		for (Contact c : conts ){
			Affs = Conaff.get(c.Id);
			
			if (Affs.size()==0) {
		  		npe5__Affiliation__c newa =  new npe5__Affiliation__c(
							npe5__Organization__c=ContactOrganization.get(c.Id),
							npe5__Status__c = 'Current',
							Type__c = 'C2C Volunteer',
							npe5__Contact__c = c.Id);
		  		Affiliationstocreate.add(newa);
				}
			else 
				{ 
				for(npe5__Affiliation__c a : affs) {
					
					if(a.npe5__Organization__c <> ContactOrganization.get(c.Id)) {
						//create a new affiliation
						npe5__Affiliation__c newa =  new npe5__Affiliation__c(
							npe5__Organization__c=ContactOrganization.get(c.Id),
							npe5__Status__c = 'Current',
							Type__c = 'C2C Volunteer',
							npe5__Contact__c = c.Id);
		  				Affiliationstocreate.add(newa);	
					}
				}
			}
		}	
		//insert Affiliationstocreate;
	}

//	if(Trigger.isDelete) {
//			for(Volunteer_Registration__c reg : System.Trigger.old){
			
//			}
//	} 
}