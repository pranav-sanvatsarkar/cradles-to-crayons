@isTest
private class TEST_RHX {

    static testMethod void Drive_Result() {
        
        List<sObject> sourceList = [SELECT ID FROM Drive_Result__c LIMIT 1];

        if(sourceList.size() == 0) {
            sourceList.add(new Drive_Result__c());
        }
	Database.upsert(sourceList);
    }
    
    static testMethod void Partner_Order() {
        
        List<sObject> sourceList = [SELECT ID FROM Partner_Order__c LIMIT 1];

        if(sourceList.size() == 0) {
            sourceList.add(new Partner_Order__c(Caregiver_S_First_Name__c = 'Care', Caregiver_S_Last_Name__c = 'Giver'));
        }
	Database.upsert(sourceList);
    }
    
    static testMethod void Volunteer_Registration() {
    	
    	Contact testContact = new Contact(firstname = 'test', lastname = 'contact');
    	
    	insert testContact;
    	
        Volunteer_Visit__c testVisit = new Volunteer_Visit__c(Main_Contact__c = testContact.Id, Volunteer_Type__c = 'Individual');
        
        insert testVisit;
        
        List<sObject> sourceList = [SELECT ID FROM Volunteer_Registration__c LIMIT 1];

        if(sourceList.size() == 0) {
            sourceList.add(new Volunteer_Registration__c(Volunteer_Visit__c = testVisit.ID, Contact__c = testContact.ID));
        }
	Database.upsert(sourceList);
    }
    
    static testMethod void Receiving_Log() {
    	
        List<sObject> sourceList = [SELECT ID FROM Receiving_Log__c LIMIT 1];

        if(sourceList.size() == 0) {
            sourceList.add(new Receiving_Log__c());
        }
	Database.upsert(sourceList);
    }
    
    static testMethod void PO_Item() {
        
        List<sObject> sourceList = [SELECT ID FROM PO_Item__c LIMIT 1];

        if(sourceList.size() == 0) {
            sourceList.add(new PO_Item__c());
        }
	Database.upsert(sourceList);
    }
    
    static testMethod void Partner_Order_Item() {
    	
    	Partner_Order__c testPartner = new Partner_Order__c(Caregiver_S_First_Name__c = 'Care', Caregiver_S_Last_Name__c = 'Giver');
    	
    	insert testPartner;
        
        List<sObject> sourceList = [SELECT ID FROM Partner_Order_Item__c LIMIT 1];

        if(sourceList.size() == 0) {
            sourceList.add(new Partner_Order_Item__c(Partner_Order__c = testPartner.ID));
        }
	Database.upsert(sourceList);
    }
}