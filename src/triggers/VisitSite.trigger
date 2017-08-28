trigger VisitSite on Volunteer_Visit__c (before insert, before update) {
    Map<Id, String> createdIdSite = new Map<Id, String>();
    set<ID> creatorIDs = new Set<ID>();
    set<ID> Volunteer_VisitIDs = new Set<ID>();
    Volunteer_Visit__c[] visits = new List<Volunteer_Visit__c>(); 
        
    if(Trigger.isInsert) {
        for (Volunteer_Visit__c v : System.Trigger.new) {
                System.debug('Created by: ' + UserInfo.getUserId());
                creatorIDs.add(UserInfo.getUserId());
                Volunteer_VisitIDs.add(v.Id);
                visits.add(v);
            }
            
        User[] myusers = [select Id, Site__c from User where ID in :creatorIDs ];
    
        for (User u: myusers) {
            createdIdSite.put(u.Id,u.Site__c);
            }
    
        for (Volunteer_Visit__c vv : visits ){
            if(createdIdSite.get(UserInfo.getUserId()) <> NULL && createdIdSite.get(UserInfo.getUserId()) <> 'Multiple') {
                vv.Site__c = createdIdSite.get(UserInfo.getUserId());
                }
            }
    }
}