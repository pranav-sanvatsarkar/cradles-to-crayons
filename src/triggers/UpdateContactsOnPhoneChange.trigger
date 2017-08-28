trigger UpdateContactsOnPhoneChange on npo02__Household__c (before update) {
/*
	//Create a map with all households affected
	Map<Id, npo02__Household__c> households = new Map<Id, npo02__Household__c>();
	for (npo02__Household__c household  : System.Trigger.new) {
		if (household.npo02__HouseholdPhone__c != System.Trigger.oldMap.get(household.Id).npo02__HouseholdPhone__c) {
					households.put(household.Id, household);
		}
	}
	
	//Collect all Contacts related to these Households
	Contact[] relatedcontacts = new List<Contact>();
	relatedcontacts = [select Id, npo02__Household__c, HomePhone from Contact where npo02__Household__c in : households.keySet()];
	
	//Update all Contacts
	Contact[] updatedcontacts = new List<Contact>();
	for (Contact c : relatedcontacts) {
		npo02__Household__c RelHousehold = households.get(c.npo02__Household__c); 
		c.HomePhone = RelHousehold.npo02__HouseholdPhone__c;
		updatedcontacts.add(c);	
	}
	update updatedcontacts;
*/

}