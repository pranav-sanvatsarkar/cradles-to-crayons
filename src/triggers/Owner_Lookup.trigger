trigger Owner_Lookup on Account (before update, before insert) {

    for (account o : trigger.New) 
    o.Owner_Lookup__c = o.OwnerID;
}