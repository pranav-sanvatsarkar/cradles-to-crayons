trigger AccountSite on Account (before insert, before update) {
    Map<Id, String> ownerIdSite = new Map<Id, String>();
    set<ID> ownerIDs = new Set<ID>();
    set<ID> accountIDs = new Set<ID>();
    
    Account[] accts = new List<Account>(); 
        
    if(Trigger.isInsert) {
        for (Account a : System.Trigger.new) {
                ownerIDs.add(a.OwnerId);
                accountIDs.add(a.Id);
                accts.add(a);
            }
            
        User[] myusers = [select Id, Site__c from User where ID in :ownerIDs ];
    
        for (User u: myusers) {
            ownerIdSite.put(u.Id,u.Site__c);
            }
    
        for (Account ac : accts ){
            if (ac.OwnerId != '00580000003Dc4a' && ownerIdSite.get(ac.OwnerID) != 'Multiple') {ac.Site__c = ownerIdSite.get(ac.OwnerID);}
            }
    }
    if(Trigger.IsUpdate) {
         for (integer i = 0; i<Trigger.new.size(); i++) {
                if ((Trigger.new[i].OwnerId != Trigger.old[i].OwnerId) || (Trigger.new[i].Site__c != Trigger.old[i].Site__c)){
                    ownerIDs.add(Trigger.new[i].OwnerId);
                    accountIDs.add(Trigger.new[i].Id);
                    accts.add(Trigger.new[i]); 
                }
             }  
            
        User[] myusers = [select Id, Site__c from User where ID in :ownerIDs ];
    
        for (User u: myusers) {
            ownerIdSite.put(u.Id,u.Site__c);
            }
    
        for (Account ac : accts ){
            if(ac.OwnerId != '00580000003Dc4a' && ownerIdSite.get(ac.OwnerID) != 'Multiple') {ac.Site__c = ownerIdSite.get(ac.OwnerID);} 
            }
    }   
}