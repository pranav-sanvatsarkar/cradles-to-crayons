@isTest
private class TestCancelVisit {

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
 		Datetime dt = datetime.newInstance(dToday.year(), dToday.month()+1,dToday.day());
        
        Volunteer_Visit__c v = new Volunteer_Visit__c();
        v.Name = 'New';
        v.Main_Contact__c = c1.Id;
        v.Status__c = 'Cancelled';
        v.Scheduled_Start_Date_Time__c = dt;
        v.Volunteer_Type__c = 'Individual';
        //v.Actual_Date_Time__c =dt;
        v.Volunteer_Visit_Duration__c = 120;
        insert v;
        
        Volunteer_Registration__c r1 = new Volunteer_Registration__c();
        r1.Contact__c = c1.Id;
        r1.Role__c = 'Volunteer';
        r1.Status__c = 'Pre-Registred';
        r1.Num_of_Hours__c =2;
        r1.Volunteer_Visit__c =v.Id;
        insert r1;
        
        CancelVisit.DoCancelVisit(v.Id);
    	
    	Volunteer_Registration__c[] registrations = [SELECT Id from Volunteer_Registration__c where Volunteer_Visit__c = :v.Id AND Status__c = 'Cancelled'];
	    //System.assertEquals(1, registrations.size() );
    }
}