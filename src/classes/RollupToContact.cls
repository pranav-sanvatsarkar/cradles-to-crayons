public with sharing class RollupToContact {

	//@Future(callout=true)
	public static void DoIndVisit(Set<ID> contIDs) {
                
      Contact[] updateContacts = new Contact[]{};
        
        Map<ID, Contact> contacts = new Map<ID, Contact>([SELECT Id FROM Contact WHERE Id in: ContIDs ]);
            
        //-------------------------------------------------------------------------------<T01>
        //Using map to avoid another loop.  Various other mechanisms can be also used
         Map<ID, ID> mpChkConts = new Map<ID, ID>();
        //-------------------------------------------------------------------------------</T01>        
            
        //Loop over the aggregate result set
            for (AggregateResult ar : [select Contact__c, COUNT(Id)numVisits, MAX(Actual_Start_Date_Time__c)lastVisit, MIN(Actual_Start_Date_Time__c)firstVisit, SUM(Num_of_Hours__c)sumHours From Volunteer_Registration__c Where Contact__c in: ContIDs and Status__c = 'Completed' AND Inquiry_Type__c = 'Individual' group by Contact__c ]) {    
                  
                  Contact thisContact = new Contact(Id=String.valueOf(ar.get('Contact__c')));
                  thisContact.of_Volunteer_Visit__c = Integer.valueOf(ar.get('numVisits')); 
                  
                  DateTime dT1 = DateTime.valueOf(ar.get('lastVisit'));
				  Date myDate1 = date.newinstance(dT1.year(), dT1.month(), dT1.day());
				  thisContact.Last_Ind_Volunteer_Date__c = myDate1;
			
				  DateTime dT2 = DateTime.valueOf(ar.get('firstVisit'));
				  Date myDate2 = date.newinstance(dT2.year(), dT2.month(), dT2.day());
				  thisContact.First_Ind_Volunteer_Date__c = myDate2;
			
				  thisContact.of_Volunteer_Hours__c = Double.valueOf(ar.get('sumHours'));
                  
                  //The contacts that need to be checked
                  mpChkConts.put(thisContact.Id, thisContact.id);
                              
                  //Add this new account to the list of account objects
                  updateContacts.add(thisContact);
            }
            
            //-------------------------------------------------------------------------------<T01>
            //Loop to check if all the IDs were updated without any issues
            for(ID tempID :contIDs) {

                  //If the Contact Id is not in the Map then it does not exist
                  if(mpChkConts.get(tempID) == null) {
                  
                        //Create a temporary contact with the volunteer visit as 0
                        Contact thisContact = new Contact(Id=tempID);
                        thisContact.of_Volunteer_Visit__c = NULL;
                        thisContact.Last_Ind_Volunteer_Date__c = NULL;
                        thisContact.First_Ind_Volunteer_Date__c = NULL;
                        thisContact.of_Volunteer_Hours__c = NULL;
                        
                        //Add this new contact to the list of contact objects
                        updateContacts.add(thisContact);                
                  
                  }

            }
            //-------------------------------------------------------------------------------</T01>

            //Update the account object.
            if(updateContacts.size()>0) {
                  update updateContacts;
            }     
      }
	
	//@Future(callout=true)
	public static void DoGroupVisit(Set<ID> contIDs) {
         System.debug('Here');
       
    	Contact[] updateContacts = new Contact[]{};
        
        Map<ID, Contact> contacts = new Map<ID, Contact>([SELECT Id FROM Contact WHERE Id in: ContIDs ]);
        
        //-------------------------------------------------------------------------------<T01>
        //Using map to avoid another loop.  Various other mechanisms can be also used
        Map<ID, ID> mpChkConts = new Map<ID, ID>();
        //-------------------------------------------------------------------------------</T01>        
            
                     
        //Loop over the aggregate result set
		for (AggregateResult ar : [select Contact__c, COUNT(Id)numVisits, MAX(Actual_Start_Date_Time__c)lastVisit, MIN(Actual_Start_Date_Time__c)firstVisit, SUM(Num_of_Hours__c)sumHours From Volunteer_Registration__c Where Contact__c in: ContIDs and Status__c = 'Completed' AND (Inquiry_Type__c = 'Group' OR Inquiry_Type__c = 'Family')group by Contact__c ]) 
		{	
			Contact thisContact = new Contact(Id=String.valueOf(ar.get('Contact__c')));
			thisContact.of_Group_Volunteer_Visit__c = Integer.valueOf(ar.get('numVisits'));
			
			DateTime dT1 = DateTime.valueOf(ar.get('lastVisit'));
			Date myDate1 = date.newinstance(dT1.year(), dT1.month(), dT1.day());
			thisContact.Last_Group_Volunteer_Date__c = myDate1;
			
			
			DateTime dT2 = DateTime.valueOf(ar.get('firstVisit'));
			Date myDate2 = date.newinstance(dT2.year(), dT2.month(), dT2.day());
			thisContact.First_Group_Volunteer_Date__c = myDate2;
			
			
			thisContact.of_Group_Volunteer_Hours__c = Double.valueOf(ar.get('sumHours'));
			
			//The contacts that need to be checked
            mpChkConts.put(thisContact.Id, thisContact.id);
			
			//Add this new account to the list of account objects
			updateContacts.add(thisContact);
		}
		//-------------------------------------------------------------------------------<T01>
            //Loop to check if all the IDs were updated without any issues
            for(ID tempID :contIDs) {

                  //If the Contact Id is not in the Map then it does not exist
                  if(mpChkConts.get(tempID) == null) {
                  
                        //Create a temporary contact with the volunteer visit as 0
                        Contact thisContact = new Contact(Id=tempID);
                        thisContact.of_Group_Volunteer_Visit__c = NULL;
                        thisContact.Last_Group_Volunteer_Date__c = NULL;
                        thisContact.First_Group_Volunteer_Date__c  = NULL;
                        thisContact.of_Group_Volunteer_Hours__c = NULL;
                        
                        //Add this new contact to the list of contact objects
                        updateContacts.add(thisContact);                
                  
                  }

            }
            //-------------------------------------------------------------------------------</T01>

		//Update the account object.
		if(updateContacts.size()>0) {update updateContacts;}	
        }
	
}