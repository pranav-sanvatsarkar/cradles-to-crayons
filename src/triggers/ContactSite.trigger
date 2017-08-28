trigger ContactSite on Contact (before insert, before update) {
    Map<Id, String> ownerIdSite = new Map<Id, String>();
    set<ID> ownerIDs = new Set<ID>();
    set<ID> contactIDs = new Set<ID>();
    
    Contact[] conts = new List<Contact>(); 
        
    if(Trigger.isInsert) {
        for (Contact c : System.Trigger.new) {
                ownerIDs.add(c.OwnerId);
                contactIDs.add(c.Id);
                conts.add(c);
            }
            
        User[] myusers = [select Id, Site__c from User where ID in :ownerIDs ];
    
        for (User u: myusers) {
            ownerIdSite.put(u.Id,u.Site__c);
            }
    
        for (Contact co : conts ){
            if(co.ownerId <> '00580000003Dc4a' && ownerIdSite.get(co.OwnerID) != 'Multiple') {co.Site__c = ownerIdSite.get(co.OwnerID);} 
            }
    }
    if(Trigger.IsUpdate) {
         for (integer i = 0; i<Trigger.new.size(); i++) {
                if ((Trigger.new[i].OwnerId != Trigger.old[i].OwnerId) || (Trigger.new[i].Site__c != Trigger.old[i].Site__c)){
                    ownerIDs.add(Trigger.new[i].OwnerId);
                    contactIDs.add(Trigger.new[i].Id);
                    conts.add(Trigger.new[i]); 
                }
             }  
            
        User[] myusers = [select Id, Site__c from User where ID in :ownerIDs ];
    
        for (User u: myusers) {
            ownerIdSite.put(u.Id,u.Site__c);
            }
    
        for (Contact co : conts ){
            if(co.ownerId <> '00580000003Dc4a' && ownerIdSite.get(co.OwnerID) != 'Multiple') {co.Site__c = ownerIdSite.get(co.OwnerID);} 
            }
    }

}