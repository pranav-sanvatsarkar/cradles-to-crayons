/**
 * Test Class : TestAutofillAccountId.cls
 * 
 * Modified By : Lister Technologies
 * Modified Date : 14-Dec-2012
 * Modified Purpose : If record_type is "Individual Donation" and npe01__Is_Opp_From_Individual__c is FALSE 
 *				then search for an Account where npe01__One2OneContact__c is Opportunity.ContactId. 
 *				If a record found then replace the accountid on the opportunity with the accountid found. 
 *				Otherwise create a new account replace the accountid on the opportunity with the newly created accountid.
 *
 **/

trigger AutofillAccountId on Opportunity (before insert, before update) {
	
	Set<Id> setOfContactIds = new Set<Id>();
	Map<Id, Contact> mapOfContactIdToContact = new Map<Id, Contact>();
	Map<Id, Id> mapOfContactIdToAccountId = new Map<Id, Id>(); 
	
	//Get the Id of the opportunity record type "Individual Donation"
	Id idOppIndDonRecType = [Select Id, Name From RecordType Where SObjectType = 'Opportunity' And Name = 'Individual Donation' limit 1].Id;
	
	//Get the Id of the opportunity record type "Individual Donation"
	Id idAccOrgRecType = [Select Id, Name From RecordType Where SObjectType = 'Account' And Name = 'Organization' limit 1].Id;

	//Get the list of opportunities which is of record type "Individual Donation" and npe01__Is_Opp_From_Individual__c is FALSE
	for (Opportunity opp : trigger.New){
		if(opp.RecordTypeId == idOppIndDonRecType && opp.npe01__Is_Opp_From_Individual__c=='FALSE' && opp.Contact__c != NULL){
			setOfContactIds.add(opp.Contact__c);
		}
	}
	
	//Map of contact Id and the contact.
	for (Contact con : [Select Id, FirstName, LastName From Contact Where Id in :setOfContactIds]){
		System.debug('Contact Id = ' + con.Id + ', First Name = ' + con.FirstName + ', Last Name = ' + con.LastName);
		mapOfContactIdToContact.put(con.Id, con);
	}
	
	//Map the contactId with respective AccountId
	for (Account acc : [Select Id, Name, npe01__One2OneContact__c From Account Where npe01__One2OneContact__c in :setOfContactIds ]){
		System.debug('Account Id = ' + acc.Id + ', Name = ' + acc.Name);
		mapOfContactIdToAccountId.put(acc.npe01__One2OneContact__c, acc.Id);
	}
	
	//If account not present, create one and map it to the ContactId
	for (Id contactId : new List<Id>(setOfContactIds)){
		Contact con = mapOfContactIdToContact.get(contactId);
		if (!mapOfContactIdToAccountId.containsKey(con.Id)){
			Account acc = new Account();
			acc.RecordTypeId = idAccOrgRecType;
			acc.Name = con.FirstName + ' ' + con.LastName;
			acc.npe01__SYSTEMIsIndividual__c = TRUE;
			acc.npe01__One2OneContact__c = con.Id;
			acc.npe01__SYSTEM_AccountType__c = 'One-to-One Individual'; 
			insert acc;
			
			mapOfContactIdToAccountId.put(con.Id, acc.Id);
		}
	}
	
	//Set the opportunity account id.
	for (Opportunity opp : trigger.New){
		if(opp.RecordTypeId == idOppIndDonRecType && opp.npe01__Is_Opp_From_Individual__c=='FALSE' && opp.Contact__c != NULL){
			opp.AccountId = mapOfContactIdToAccountId.get(opp.Contact__c);
		}else if(opp.AccountId == NULL){
			opp.AccountId = opp.AccountId__c;
		}
	}
	
}