@isTest
private class TestSetVolVisit {

    static testMethod void myUnitTest() {
    	
    	Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
    	
    	insert testContact;
    	    	
    	Volunteer_Visit__c testReg = new Volunteer_Visit__c(Name = 'Test', Main_Contact__c = testContact.ID,
    		Volunteer_Type__c = 'Individual', Status__c = 'Pre-registration sent', Scheduled_Start_Date_Time__c = date.today());
    		
    	insert testReg;
    	    	
    	Receiving_Log__c testLog = new Receiving_Log__c(Contact__c = testContact.ID, Drop_off_Date_Time__c = date.today());
    	
    	insert testLog;
    }
}