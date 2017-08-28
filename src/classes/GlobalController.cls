public class GlobalController 
{
    public Portal_Configuration__c portal { get; set; }
    public GlobalController()
    {
        
    	try
        {
            User user = [ SELECT Id, Site__c FROM User WHERE Id =: Userinfo.getUserId() ];
    		portal = [ SELECT Id, Message__c FROM Portal_Configuration__c WHERE Location__c =: user.Site__c ][0]; 	   
        }
        catch( Exception ex )
        {
        	portal = new Portal_Configuration__c( Message__c ='');	
        }
    }
    public PageReference redirectToDashboard()
    {
	     return Page.CommunityDashboard;
    }
}