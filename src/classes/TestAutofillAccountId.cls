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
private class TestAutofillAccountId {

    static testMethod void myUnitTest() {
        
        Contact Cont2 = new Contact();
        Cont2.LastName = 'Test';
        Cont2.FirstName = 'Contact 1001';
        Cont2.email='Test1001@gmail.com';
        insert Cont2;
        
        RecordType Rec;
        Rec = [select Id from RecordType where Name = 'Individual Donation'];
        
        Opportunity Opp = new Opportunity();
        Opp.CloseDate = Date.today().addDays(30);
        Opp.RecordTypeId = Rec.Id;
        opp.StageName = 'Target';
        Opp.name = 'Test Opp 1001';
        Opp.Amount = 10000;
        Opp.Contact__c=Cont2.Id;
		insert Opp;
		
        Account acct2 = new Account();
        acct2.Name = 'Organization Test 2';
        acct2.npe01__SYSTEMIsIndividual__c = FALSE;
        insert acct2;

        Contact Cont1 = new Contact();
        Cont1.LastName = 'test1';
        Cont1.FirstName = 'test1';
        Cont1.email='test1@gmail.com';
        insert Cont1;        

        Account acct1 = new Account();
        acct1.Name = 'Organization Test 1';
        acct1.npe01__One2OneContact__c = Cont1.Id;
        acct1.npe01__SYSTEMIsIndividual__c = FALSE;
        insert acct1;
        
		Opp = [Select Id, Contact__c From Opportunity Where Id = :opp.Id].get(0);
        Opp.AccountId=acct2.Id;
        Opp.Contact__c=Cont1.Id;
        update Opp;
        
    }
}