@isTest
public class GlobalControllerTest
{ 
	static testMethod void verifyGlobalController()
    {   
        verifyInternalUser();
        verifyExternalUser();
    }
    Public Static void verifyInternalUser()
    {
    	User standardUser = new User( Alias = 'StdUser', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                                      ProfileId = [ SELECT Id FROM Profile WHERE Name = 'Standard User' ].Id, TimeZoneSidKey='America/Los_Angeles', UserName='stduser@testorg.com', Site__c = 'Boston');
        runAs(standardUser);    
    }    		
    public static void verifyExternalUser()
    {
    	Contact contact = new Contact( LastName='TestCommunityUserContact' );
        insert  contact;
        User communityUser = new User( Alias = 'commUser', Email='Communityuser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                                        ProfileId = [ SELECT Id FROM Profile WHERE Name = 'Customer Community User' ].Id, TimeZoneSidKey='America/Los_Angeles', UserName='Communityuser@testorg.com', ContactId = contact.id, Site__c = 'Boston');
         
        runAs(communityUser);
    }
    public static void runAs(User testUser)
    {
    	system.runAs(testUser)
        {  
        	new GlobalController();
         	Portal_Configuration__c testPortal = C2CTestHelper.getPortalConfiguration();
        	C2CTestHelper.InsertWithAssert(testPortal);
            new GlobalController();
        }    
    }
}