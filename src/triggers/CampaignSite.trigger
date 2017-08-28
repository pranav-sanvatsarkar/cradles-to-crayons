trigger CampaignSite on Campaign (before insert, before update) {
    Map<Id, String> ownerIdSite = new Map<Id, String>();
    set<ID> ownerIDs = new Set<ID>();
    set<ID> CampaignIDs = new Set<ID>();
    
    Campaign[] camps = new List<Campaign>(); 
        
    if(Trigger.isInsert) {
        for (Campaign c : System.Trigger.new) {
                ownerIDs.add(c.OwnerId);
                CampaignIDs.add(c.Id);
                camps.add(c);
            }
            
        User[] myusers = [select Id, Site__c from User where ID in :ownerIDs ];
    
        for (User u: myusers) {
            ownerIdSite.put(u.Id,u.Site__c);
            }
    
        for (Campaign ca : camps ){
            if(ca.ownerId <> '00580000003Dc4a' && ownerIdSite.get(ca.OwnerID) != 'Multiple') {ca.Site__c = ownerIdSite.get(ca.OwnerID);} 
            }
    }
    if(Trigger.IsUpdate) {
         for (integer i = 0; i<Trigger.new.size(); i++) {
                if ((Trigger.new[i].OwnerId != Trigger.old[i].OwnerId) || (Trigger.new[i].Site__c != Trigger.old[i].Site__c)){
                    ownerIDs.add(Trigger.new[i].OwnerId);
                    CampaignIDs.add(Trigger.new[i].Id);
                    camps.add(Trigger.new[i]); 
                }
             }  
            
        User[] myusers = [select Id, Site__c from User where ID in :ownerIDs ];
    
        for (User u: myusers) {
            ownerIdSite.put(u.Id,u.Site__c);
            }
    
        for (Campaign ca : camps ){
            if(ca.ownerId <> '00580000003Dc4a' && ownerIdSite.get(ca.OwnerID) != 'Multiple') {ca.Site__c = ownerIdSite.get(ca.OwnerID);} 
            }
    }   
}