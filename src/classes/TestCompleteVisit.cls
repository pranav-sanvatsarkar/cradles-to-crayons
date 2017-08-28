/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestCompleteVisit {

    static testMethod void myUnitTest() {
       	Contact c1 = new Contact();
        c1.Firstname ='test';
        c1.Lastname = 'test';
        insert c1;
        
        Contact c2 = new Contact();
        c2.Firstname ='test';
        c2.Lastname = 'test';
        insert c2;
        
        Date dToday = System.Today();
 		Datetime dt = datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
        
        Volunteer_Visit__c v = new Volunteer_Visit__c();
        v.Name = 'New';
        v.Main_Contact__c = c1.Id;
        v.Status__c = 'Inquiry';
        v.Scheduled_Start_Date_Time__c = dt;
        v.Volunteer_Type__c = 'Individual';
        v.Actual_Date_Time__c =dt;
        v.Volunteer_Visit_Duration__c = 120;
        insert v;
        
        Volunteer_Registration__c r1 = new Volunteer_Registration__c();
        r1.Contact__c = c1.Id;
        r1.Role__c = 'Volunteer';
        r1.Status__c = 'Pre-Registred';
        r1.Num_of_Hours__c =2;
        r1.Volunteer_Visit__c =v.Id;
        insert r1;
        
        CompleteVisit.DoCompleteVisit(v.Id);
    	
    	Volunteer_Registration__c[] registrations = [SELECT Id from Volunteer_Registration__c where Volunteer_Visit__c = :v.Id AND Status__c = 'Completed'];
	    //System.assertEquals(1, registrations.size() );
    }
}