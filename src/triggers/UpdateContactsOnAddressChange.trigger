trigger UpdateContactsOnAddressChange on npo02__Household__c (after update) {
	/*
	//Create a map with all households affected
	Map<Id, npo02__Household__c> households = new Map<Id, npo02__Household__c>();
	for (npo02__Household__c household  : System.Trigger.new) {
		if (household.npo02__Formula_MailingAddress__c != System.Trigger.oldMap.get(household.Id).npo02__Formula_MailingAddress__c) {
					households.put(household.Id, household);
		}
	}
	
	//Collect all Contacts with a primary address = home related to these Households
	Contact[] relatedcontactsprim = new List<Contact>();
	relatedcontactsprim = [select Id, npo02__Household__c, HomePhone from Contact where npo02__Household__c in : households.keySet() and (npe01__Primary_Address_Type__c = 'Home' or (npe01__Primary_Address_Type__c = NULL and npe01__Secondary_Address_Type__c <> 'Home') )];
	
	
	//Collect all Contacts with a secondary address = home related to these Households
	Contact[] relatedcontactssec = new List<Contact>();
	relatedcontactssec = [select Id, npo02__Household__c, HomePhone from Contact where npo02__Household__c in : households.keySet() and (npe01__Secondary_Address_Type__c = 'Home' or (npe01__Secondary_Address_Type__c = NULL and npe01__Primary_Address_Type__c <> 'Home' and npe01__Primary_Address_Type__c <> NULL))];
	
				
	//Update all Contacts with primary address = Home
	Contact[] updatedcontacts = new List<Contact>();
	for (Contact c : relatedcontactsprim) {
		npo02__Household__c RelHousehold = households.get(c.npo02__Household__c); 
		c.MailingStreet = RelHousehold.npo02__MailingStreet__c;
		c.MailingCity = RelHousehold.npo02__MailingCity__c;
		c.MailingState = RelHousehold.npo02__MailingState__c;
		c.MailingPostalCode = RelHousehold.npo02__MailingPostalCode__c;
		c.MailingCountry = RelHousehold.npo02__MailingCountry__c;
		c.npe01__Primary_Address_Type__c = 'Home';
		updatedcontacts.add(c);	
	}
	//Update all Contacts with secondary address = Home
	
	for (Contact c : relatedcontactssec) {
		npo02__Household__c RelHousehold = households.get(c.npo02__Household__c); 
		c.OtherStreet = RelHousehold.npo02__MailingStreet__c;
		c.OtherCity = RelHousehold.npo02__MailingCity__c;
		c.OtherState = RelHousehold.npo02__MailingState__c;
		c.OtherPostalCode = RelHousehold.npo02__MailingPostalCode__c;
		c.OtherCountry = RelHousehold.npo02__MailingCountry__c;
		c.npe01__Secondary_Address_Type__c = 'Home';
		updatedcontacts.add(c);	
	}
	
	update updatedcontacts;

*/
}