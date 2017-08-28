trigger OwnerLookup on Campaign (before update, before insert) {

    for (campaign o : trigger.New) 
    o.Ownerlookup__c = o.OwnerID;
}