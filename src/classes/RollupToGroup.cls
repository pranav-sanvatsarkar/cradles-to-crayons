public with sharing class RollupToGroup {
	
	
	//@Future(callout=true)
	public static void DoVisit(Set<ID> AcctIDs) {
         System.debug('Here');
       
    	Account[] updateAccounts = new Account[]{};
        
        Map<ID, Account> Accounts = new Map<ID, Account>([SELECT ID FROM Account WHERE Id in: AcctIDs ]);
             
        //-------------------------------------------------------------------------------<T01>
        //Using map to avoid another loop.  Various other mechanisms can be also used
         Map<ID, ID> mpChkAccts = new Map<ID, ID>();
        //-------------------------------------------------------------------------------</T01>
        
        //Loop over the aggregate result set
		for (AggregateResult ar : [select Org_Group__c, COUNT(Id)numVisits, MAX(Actual_Date_Time__c)lastDateTime, MIN(Actual_Date_Time__c)firstDateTime, SUM(Actual_hours__c)sumHours From Volunteer_Visit__c Where Org_Group__c in: AcctIDs AND (Volunteer_Type__c = 'Group' OR Volunteer_Type__c = 'Family') AND ( Status__c = 'Completed' OR Status__c = 'Completed - Send Thanks') group by Org_Group__c ]) 
		{	
			Account thisAccount = new Account(Id=String.valueOf(ar.get('Org_Group__c')));
			thisAccount.of_Volunteer_Visit__c = Integer.valueOf(ar.get('numVisits'));
			
			DateTime dT1 = DateTime.valueOf(ar.get('lastDateTime'));
			Date myDate1 = date.newinstance(dT1.year(), dT1.month(), dT1.day());
			thisAccount.Last_Group_Volunteer_Date__c = myDate1;
			
			DateTime dT2 = DateTime.valueOf(ar.get('firstDateTime'));
			Date myDate2 = date.newinstance(dT2.year(), dT2.month(), dT2.day());
			thisAccount.First_Group_Volunteer_Date__c = myDate2;
			
			thisAccount.of_Volunteer_Hours__c = Double.valueOf(ar.get('sumHours'));
			
			//The contacts that need to be checked
            mpChkAccts.put(thisAccount.Id, thisAccount.Id);
			
			//Add this new account to the list of account objects
			updateAccounts.add(thisAccount);
		}
		 //-------------------------------------------------------------------------------<T01>
            //Loop to check if all the IDs were updated without any issues
            for(ID tempID :AcctIDs) {

                  //If the Account Id is not in the Map then it does not exist
                  if(mpChkAccts.get(tempID) == null) {
                  
                        //Create a temporary account with the volunteer visit as 0
                        Account thisAccount = new Account(Id=tempID);
                        thisAccount.of_Volunteer_Visit__c  = NULL;
                        thisAccount.Last_Group_Volunteer_Date__c = NULL;
                        thisAccount.First_Group_Volunteer_Date__c  = NULL;
                        thisAccount.of_Volunteer_Hours__c = NULL;
                        
                        //Add this new contact to the list of contact objects
                        updateAccounts.add(thisAccount);                
                  }
            }

		//Update the account object.
		if(updateAccounts.size()>0) {update updateAccounts;}	
        }
        
    //@Future(callout=true)
	public static void DoImpact(Set<ID> AcctIDs) {
         System.debug('Here');
       
    	Account[] updateAccounts = new Account[]{};
        
        Map<ID, Account> Accounts = new Map<ID, Account>([SELECT ID FROM Account WHERE Id in: AcctIDs ]);
             
        //-------------------------------------------------------------------------------<T01>
        //Using map to avoid another loop.  Various other mechanisms can be also used
         Map<ID, ID> mpChkAccts = new Map<ID, ID>();
        //-------------------------------------------------------------------------------</T01>
        
        //Loop over the aggregate result set
		for (AggregateResult ar : [select Org_Group__c, SUM(Total_Impact__c)sumImpact From Volunteer_Visit__c Where Org_Group__c in: AcctIDs AND (Volunteer_Type__c = 'Group' OR Volunteer_Type__c = 'Family') AND (Status__c = 'Completed' OR Status__c = 'Completed - Send Thanks')group by Org_Group__c ]) 
		{	
			Account thisAccount = new Account(Id=String.valueOf(ar.get('Org_Group__c')));
			thisAccount.Total_Impact_Group__c = Double.valueOf(ar.get('sumImpact'));
			
			//The contacts that need to be checked
            mpChkAccts.put(thisAccount.Id, thisAccount.Id);
			
			//Add this new account to the list of account objects
			updateAccounts.add(thisAccount);
		}
		//-------------------------------------------------------------------------------<T01>
        //Loop to check if all the IDs were updated without any issues
        for(ID tempID :AcctIDs) {

                  //If the Account Id is not in the Map then it does not exist
                  if(mpChkAccts.get(tempID) == null) {
                  
                        //Create a temporary account with the volunteer visit as 0
                        Account thisAccount = new Account(Id=tempID);
                       	thisAccount.Total_Impact_Group__c = NULL;
                        
                        //Add this new contact to the list of contact objects
                        updateAccounts.add(thisAccount);                
                  }
            }
		//Update the account object.
		if(updateAccounts.size()>0) {update updateAccounts;}	
        }
        

}