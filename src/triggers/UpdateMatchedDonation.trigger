trigger UpdateMatchedDonation on Opportunity (after insert, after delete, after undelete) {

    set<ID> oppIDs = new Set<ID>();
    
    RecordType rt = [Select Id, Name from RecordType where Name = 'Organization Donation' limit 1];
    Id DonationRTid = rt.Id;
    
    if(Trigger.isInsert || Trigger.isUnDelete) {
        for(Opportunity o : System.Trigger.new){
                if(o.RecordTypeId == DonationRTid && o.IsWon == TRUE && o.type == 'Matching' && o.Matched_Donation__c <> NULL) 
                		{oppIDs.add(o.Matched_Donation__c);}
        }
        //Update matched donations
        Opportunity[] opps = new List<Opportunity>();
        opps = [select Id, Matching_Received__c from Opportunity where ID in :oppIDs ];
        
        Opportunity[] updatedOpportunities = new List<Opportunity>();
        for(Opportunity opty : opps) {
        	 opty.Matching_Received__c = TRUE;
        	 updatedOpportunities.add(opty);
            }   
        if (updatedOpportunities.size()>0) {update updatedOpportunities;}
	}
	
	if(Trigger.isDelete) {
                for(Opportunity o : System.Trigger.old){
                     if(o.RecordTypeId == DonationRTid && o.IsWon == TRUE && o.type == 'Matching' && o.Matched_Donation__c <> NULL) 
                		{oppIDs.add(o.Matched_Donation__c);}
            }
            //Update matched donations
        	Opportunity[] opps = new List<Opportunity>();
        	opps = [select Id, Matching_Received__c from Opportunity where ID in :oppIDs ];
        
        	Opportunity[] updatedOpportunities = new List<Opportunity>();
        	for(Opportunity opty : opps) {
        		 opty.Matching_Received__c = False;
        	 	updatedOpportunities.add(opty);
            	}   
        	if (updatedOpportunities.size()>0) {update updatedOpportunities;}
		}	
	}