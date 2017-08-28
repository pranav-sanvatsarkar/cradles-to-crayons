trigger OpportunitySite on Opportunity (before insert, before update) {
    Map<Id, String> ownerIdSite = new Map<Id, String>();
    set<ID> ownerIDs = new Set<ID>();
    set<ID> OppIDs = new Set<ID>();
    
    Opportunity[] opps = new List<Opportunity>(); 
        
    if(Trigger.isInsert) {
        for (Opportunity o : System.Trigger.new) {
                ownerIDs.add(o.OwnerId);
                OppIDs.add(o.Id);
                opps.add(o);
            }
            
        User[] myusers = [select Id, Site__c from User where ID in :ownerIDs ];
    
        for (User u: myusers) {
            ownerIdSite.put(u.Id,u.Site__c);
            }
    
        for (Opportunity op : opps ){
            if(op.ownerId != '00580000003Dc4a' && ownerIdSite.get(op.OwnerID) != 'Multiple')  {op.Site__c = ownerIdSite.get(op.OwnerID);} 
            }
    }
    if(Trigger.IsUpdate) {
         for (integer i = 0; i<Trigger.new.size(); i++) {
                if ((Trigger.new[i].OwnerId != Trigger.old[i].OwnerId) || (Trigger.new[i].Site__c != Trigger.old[i].Site__c)){
                    ownerIDs.add(Trigger.new[i].OwnerId);
                    OppIDs.add(Trigger.new[i].Id);
                    opps.add(Trigger.new[i]); 
                }
             }  
            
        User[] myusers = [select Id, Site__c from User where ID in :ownerIDs ];
    
        for (User u: myusers) {
            ownerIdSite.put(u.Id,u.Site__c);
            }
    
        for (Opportunity op : opps ){
            if(op.ownerId != '00580000003Dc4a' && ownerIdSite.get(op.OwnerID) != 'Multiple') {op.Site__c = ownerIdSite.get(op.OwnerID);} 
            }
    }   

}