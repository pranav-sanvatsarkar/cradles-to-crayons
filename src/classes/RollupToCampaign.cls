public with sharing class RollupToCampaign {
	//@Future(callout=true)
	public static void DoRollup(Set<ID> campIDs) {
		Campaign[] updateCampaigns = new Campaign[]{};
        
        Map<ID, Campaign> campaigns = new Map<ID, Campaign>([SELECT Id FROM Campaign WHERE Id in: campIDs ]);
            
        //-------------------------------------------------------------------------------<T01>
        //Using map to avoid another loop.  Various other mechanisms can be also used
         Map<ID, ID> mpChkCamps = new Map<ID, ID>();
        //-------------------------------------------------------------------------------</T01>        
            
        //Loop over the aggregate result set
            for (AggregateResult ar : [select SUM(Books__c)sumBooks, SUM(Toys__c)sumToys, SUM(Clothes__c)sumClothes, SUM(Shoes__c)sumShoes, 
            SUM(Socks__c)sumSocks, SUM(Underwear__c)sumUnderwear, SUM(Coats__c)sumCoats, SUM(Arts_Crafts_School_Supplies__c)sumArts, 
            SUM(Baby_Items__c)sumBabyitems, SUM(Hats_Gloves_Mittens_and_Scarves__c)sumHats, SUM(PJ_s__c)sumPj, 
            SUM(Baby_Equipment__c)sumBabyEquip, SUM(Mixed__c)sumMixed,
            Drive_Campaign__c From Drive_Result__c Where Drive_Campaign__c in: campIDs group by Drive_Campaign__c ]) {    
                  
                  Campaign thisCampaign = new Campaign(Id=String.valueOf(ar.get('Drive_Campaign__c')));
                  thisCampaign.Books_Rollup__c = Integer.valueOf(ar.get('sumBooks')); 
                  thisCampaign.Toys_Rollup__c = Integer.valueOf(ar.get('sumToys')); 
                  thisCampaign.Clothes_Rollup__c = Integer.valueOf(ar.get('sumClothes')); 
                  thisCampaign.Shoes_Rollup__c = Integer.valueOf(ar.get('sumShoes')); 
                  thisCampaign.Socks_Rollup__c = Integer.valueOf(ar.get('sumSocks')); 
                  thisCampaign.Underwear_Rollup__c = Integer.valueOf(ar.get('sumUnderwear')); 
                  thisCampaign.Coats_Rollup__c = Integer.valueOf(ar.get('sumCoats')); 
                  thisCampaign.Arts_Crafts_Rollup__c = Integer.valueOf(ar.get('sumArts')); 
                  thisCampaign.Baby_Items_Rollup__c = Integer.valueOf(ar.get('sumBabyitems')); 
                  thisCampaign.Hats_Gloves_Mittens_Scarves_Rollup__c = Integer.valueOf(ar.get('sumHats')); 
                  thisCampaign.PJ_s_Rollup__c = Integer.valueOf(ar.get('sumPj')); 
                  thisCampaign.Baby_Equipment_Rollup__c = Integer.valueOf(ar.get('sumBabyEquip')); 
                  thisCampaign.Mixed_Rollup__c = Integer.valueOf(ar.get('sumMixed')); 
                  
                  //The Campaigns that need to be checked
                  mpChkCamps.put(thisCampaign.Id, thisCampaign.id);
                              
                  //Add this new campaign to the list of campaign objects
                  updateCampaigns.add(thisCampaign);
            }
            
            //-------------------------------------------------------------------------------<T01>
            //Loop to check if all the IDs were updated without any issues
            for(ID tempID :campIDs) {

                  //If the Contact Id is not in the Map then it does not exist
                  if(mpChkCamps.get(tempID) == null) {
                  
                        //Create a temporary campaign with the total as 0
                        Campaign thisCampaign = new Campaign(Id=tempID);
                        thisCampaign.Books_Rollup__c = NULL;
                        thisCampaign.Toys_Rollup__c = NULL;
                  		thisCampaign.Clothes_Rollup__c = NULL;
                 		thisCampaign.Shoes_Rollup__c = NULL;
               		   	thisCampaign.Socks_Rollup__c = NULL;
               		   	thisCampaign.Underwear_Rollup__c = NULL;
                 		thisCampaign.Coats_Rollup__c = NULL; 
                  		thisCampaign.Arts_Crafts_Rollup__c = NULL;
                  		thisCampaign.Baby_Items_Rollup__c = NULL;
                  		thisCampaign.Hats_Gloves_Mittens_Scarves_Rollup__c = NULL;
                  		thisCampaign.PJ_s_Rollup__c = NULL;
                  		thisCampaign.Baby_Equipment_Rollup__c = NULL; 
                        
                        //Add this new contact to the list of campaign objects
                        updateCampaigns.add(thisCampaign);                
                  
                  }

            }
            //-------------------------------------------------------------------------------</T01>

            //Update the account object.
            if(updateCampaigns.size()>0) {
                  update updateCampaigns;
            }     
	}
}