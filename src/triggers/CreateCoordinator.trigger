trigger CreateCoordinator on Campaign (after insert) {
    set<ID> CampaignIDs = new Set<ID>();
    
    //RecordType rt1 = [Select Id, Name from RecordType where Name = 'Product Collection Campaign' limit 1];   
    
    if(Trigger.isInsert) {
        for(Campaign ca : System.Trigger.new){
                if (ca.Primary_Contact__c <> NULL) {
                        CampaignIDs.add(ca.Id);
                }
            }
        
        if(CampaignIDs.size()<>0){
            Campaign[] campaigns = new List<Campaign>();
            campaigns = [select Id, Primary_Contact__c from Campaign where ID in :CampaignIDs];
            Coordinator__c[] coordinators = new List<Coordinator__c>();
            for (Campaign c : campaigns){
                    if (c.Primary_Contact__c <> NULL) {
                    Coordinator__c coor =  new Coordinator__c(
                        Campaign__c=c.Id,
                        Contact__c = c.Primary_Contact__c);
                        coordinators.add(coor);
                        }
                    }       
            if (coordinators.size()>0) {insert coordinators;}
            
            }
    }
}