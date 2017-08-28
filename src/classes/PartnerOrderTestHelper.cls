public class PartnerOrderTestHelper{
    public ApexPages.StandardSetController scon{get;set;}
   
    public  Contact userContact {get;set;}
    public user userDetails{get;set;}
    public List<Item__c> lstItems {get;set;} 
  
    public List<Partner_Order__c> lstPartnerorders{get;set;}
 	public PartnerOrderTestHelper()
 	{ 
        getContact();
        getUser();
   
    } 
	public  List<SelectOption> getPartnerOderView()
    {
    	return scon.getListViewOptions();
    }
    public Account getAccount()
    {
      	Account accounttest = new  Account();
        accounttest.Name = 'testorg1';
        accounttest.Type = 'School';
        insert accounttest;
        return accounttest;
    }
    public contact getContact()
    {
        userContact = new Contact();
        userContact.FirstName = 'prakash';
        userContact.LastName = 'Nawale';
        userContact.AccountId = getAccount().Id;
        userContact.EnableBulkOrder__c = True;
        insert userContact;
        return userContact;
    }
    public User getUser()
    {	
        userDetails = new User();	 	
        userDetails.ContactId = userContact.ID;
        userDetails.FirstName='prakash';
        userDetails.Email = 'prakash.nawale_test@enzigma.com';
        userDetails.Username = 'prakash.nawale_test@enzigma.com';
        userDetails.LastName = 'Nawale'; 
        List<User> userProfileId = new List<User>([Select Id, ProfileId from User where Profile.Name = 'Cradles Partner Community']); 
        system.debug('***userProfileId'+userProfileId[0].Id);
        userDetails.ProfileId = userProfileId[0].ProfileId;
      //userDetails.ProfileId='00eM0000000QPDE';
        userDetails.EmailEncodingKey='ISO-8859-1'; 
        userDetails.TimeZoneSidKey='America/Los_Angeles';
        userDetails.LocaleSidKey='en_US';
        userDetails.LanguageLocaleKey='en_US';
        userDetails.ReceivesAdminInfoEmails=false; 
        userDetails.Alias='prakash';
        userDetails.Site__c = 'Boston'; 
        insert userDetails;
        return userDetails;
    }
    public Portal_Configuration__c getportalconfiguration()
    {
     	Portal_Configuration__c	portalConfiguration = new Portal_Configuration__c();
        portalConfiguration.EnableBulkOrder__c = True;
        portalConfiguration.EnableOrder__c = True;
        portalConfiguration.Location__c = 'Boston';
        portalConfiguration.Message__c = 'Test';
        insert portalConfiguration;
        return portalConfiguration;
    }
    public void getPartnerOrders()
    { 	 
		  lstPartnerorders = new List<Partner_Order__c> ();
        
        for(Integer i=0;i<30;i++)
        {
            Partner_Order__c porder = new Partner_Order__c();
            porder.Child_First_Name__c ='prakash';
            porder.Child_Age__c = '5 years';
            porder.Contact__c = userContact.id;
            porder.Status__c = 'New(not yet submitted)';
            porder.Caregiver_s_First_name__c = 'Bose';
             porder.Caregiver_s_Last_name__c = 'Bose';
             porder.Location__c = 'India';
        	lstPartnerorders.add(porder); 
        }
        
        for(Integer i=0;i<10;i++)
        {
            Partner_Order__c porder = new Partner_Order__c();
            porder.Child_First_Name__c ='prakash';
            porder.Child_Age__c = '5 years';
            porder.IsBulkOrder__c = True;
            porder.Status__c = 	'Being Fullfilled';
            porder.Contact__c = userContact.id;
            porder.Caregiver_s_First_name__c = 'Bose';
            porder.Caregiver_s_Last_name__c = 'Bose';
            porder.Location__c = 'India';
        	lstPartnerorders.add(porder); 
        }
      for(Integer i=0;i<30;i++)
        {
            Partner_Order__c porder = new Partner_Order__c();
            porder.Child_First_Name__c ='prakash';
            porder.Child_Age__c = '5 years';
            porder.Status__c = 'Submitted (order placed)';
            porder.Contact__c = userContact.id;
            porder.Caregiver_s_First_name__c = 'Bose';
            porder.Caregiver_s_Last_name__c = 'Bose';
            porder.Location__c = 'India';
        	lstPartnerorders.add(porder); 
        }
         for(Integer i=0;i<10;i++)
        {
            Partner_Order__c porder = new Partner_Order__c();
            porder.Child_First_Name__c ='prakash';
            porder.Child_Age__c = '5 years';
           	porder.IsBulkOrder__c = True;
            porder.Status__c = 	'Being Fullfilled';
           	porder.Contact__c = userContact.id;
           	porder.Caregiver_s_First_name__c = 'Bose';
           	porder.Caregiver_s_Last_name__c = 'Bose';
           	porder.Location__c = 'India';
           	lstPartnerorders.add(porder); 
        }
        
        for(Integer i=0;i<20;i++)
        {
            Partner_Order__c porder = new Partner_Order__c();
            porder.Child_First_Name__c ='prakash';
            porder.Child_Age__c = '5 years';
            porder.IsBulkOrder__c = True;
            porder.Status__c = 	'Being Fullfilled';
            porder.Contact__c = userContact.id;
            porder.Caregiver_s_First_name__c = 'Bose';
            porder.Caregiver_s_Last_name__c = 'Bose';
            porder.Location__c = 'India';
        	lstPartnerorders.add(porder); 
        }
        for(Integer i=0;i<10;i++)
        {
            Partner_Order__c porder = new Partner_Order__c();
            porder.Child_First_Name__c ='prakash';
            porder.Child_Age__c = '5 years';
            porder.IsBulkOrder__c = True;
            porder.Status__c = 	'Submitted (order placed)';
            porder.Contact__c = userContact.id;
            porder.Caregiver_s_First_name__c = 'Bose';
            porder.Caregiver_s_Last_name__c = 'Bose';
            porder.Location__c = 'India';
            lstPartnerorders.add(porder); 
        }
        
        
        insert lstPartnerorders;
          
    }
    public void getItems()
    { 	 
    	 lstItems = new List<Item__c>();
       
        //0
        Item__c itemClothing = new Item__c(); 
        itemClothing.Available_As_Kid_Pack_Item__c = 'Active';
        itemClothing.Available_As_Bulk_Item__c = null;
        itemClothing.Name = ' itemClothing';
        itemClothing.Category__c = 'Clothing';
        itemClothing.Ages__c = '10 years';
        itemClothing.Gender__c = 'Boy';
        itemClothing.Site__c = 'Boston';
       	lstItems.add(itemClothing);
       //1
        Item__c itemFootwear = new Item__c(); 
        itemFootwear.Available_As_Kid_Pack_Item__c = 'Active';
        itemFootwear.Available_As_Bulk_Item__c = null;
        itemFootwear.Name = ' itemFootwear1';    
        itemFootwear.Category__c = 'Everyday Footwear';
        itemFootwear.Ages__c = '10 years';
        itemFootwear.Gender__c = 'Boy';
        itemFootwear.Site__c = 'Boston'; 
       	lstItems.add(itemFootwear);
        //2
        Item__c itemWinterBoots = new Item__c();
        itemWinterBoots.Available_As_Kid_Pack_Item__c = 'Active';
		itemWinterBoots.Available_As_Bulk_Item__c = null; 
        itemWinterBoots.Name = ' itemFootwear2';
        itemWinterBoots.Category__c = 'Seasonal Footwear';
        itemWinterBoots.Ages__c = '10 years';
        itemWinterBoots.Gender__c = 'Boy';
        itemWinterBoots.Site__c = 'Boston'; 
       	lstItems.add(itemWinterBoots);
        //3 
        Item__c itemOuterwear = new Item__c(); 
        itemOuterwear.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemOuterwear.Name = ' itemOuterwear';
        itemOuterwear.Category__c = 'Outerwear'; 
        itemOuterwear.Ages__c = '10 years';
        itemOuterwear.Gender__c = 'Boy';
        itemOuterwear.Site__c = 'Boston'; 
       	lstItems.add(itemOuterwear);
        
        //4
        Item__c itemBooks = new Item__c(); 
        itemBooks.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemBooks.Name = ' ItemBooks';
        itemBooks.Category__c = 'Books'; 
        itemBooks.Ages__c = '10 years';
        itemBooks.Gender__c = 'Boy';
        itemBooks.Site__c = 'Boston'; 
       	lstItems.add(itemBooks);
        
        //5
        Item__c itemArtsCrafts = new Item__c(); 
        itemArtsCrafts.Available_As_Kid_Pack_Item__c = 'Active';
        itemArtsCrafts.Available_As_Bulk_Item__c = null; 
        itemArtsCrafts.Name = ' ItemArts & Crafts';
        itemArtsCrafts.Category__c = 'Arts & Crafts'; 
        itemArtsCrafts.Ages__c = '10 years';
        itemArtsCrafts.Gender__c = 'Boy';
        itemArtsCrafts.Site__c = 'Boston'; 
       	lstItems.add(itemArtsCrafts);
        //6
        Item__c itemToys = new Item__c();
        itemToys.Available_As_Kid_Pack_Item__c = 'Active';
        itemToys.Available_As_Bulk_Item__c = null;  
        itemToys.Name = ' ItemToys';
        itemToys.Category__c = 'Toys';
        itemToys.Ages__c = '10 years';
        itemToys.Gender__c = 'Boy';
        itemToys.Site__c = 'Boston'; 
       	lstItems.add(itemToys);
        //7
        Item__c itemBirthdayGift = new Item__c(); 
        itemBirthdayGift.Available_As_Kid_Pack_Item__c = 'Active';
        itemBirthdayGift.Available_As_Bulk_Item__c = null;  
        itemBirthdayGift.Name = ' Birthday Gift';
        itemBirthdayGift.Site__c = 'Boston'; 
       	lstItems.add(itemBirthdayGift);
        
        //8
        Item__c itemNursery = new Item__c();
        itemNursery.Available_As_Kid_Pack_Item__c = 'Active';
        itemNursery.Available_As_Bulk_Item__c = null;  
        itemNursery.Name = ' ItemBaby Gear1';
        itemNursery.Category__c = 'Baby Gear'; 
        itemNursery.BabyGearType__c = 'Nursery';
        itemNursery.Ages__c = '10 years';
        itemNursery.Gender__c = 'Boy';
        itemNursery.Site__c = 'Boston'; 
       	lstItems.add(itemNursery);
        //9
        Item__c itemBed = new Item__c(); 
        itemBed.Available_As_Kid_Pack_Item__c = 'Active';
        itemBed.Available_As_Bulk_Item__c = null;  
        itemBed.Name = ' ItemBaby Gear2';
        itemBed.Category__c = 'Baby Gear'; 
        itemBed.BabyGearType__c = 'Bed';
        itemBed.Ages__c = '10 years';
        itemBed.Gender__c = 'Boy';
        itemBed.Site__c = 'Boston'; 
       	lstItems.add(itemBed);
        //10
        Item__c itemCarSeat = new Item__c(); 
        itemCarSeat.Available_As_Kid_Pack_Item__c = 'Active';
        itemCarSeat.Available_As_Bulk_Item__c = null;
        itemCarSeat.Name = ' ItemBaby Gear3';
        itemCarSeat.Category__c = 'Baby Gear'; 
        itemCarSeat.BabyGearType__c = 'Car Seat';
        itemCarSeat.Ages__c = '10 years';
        itemCarSeat.Gender__c = 'Boy';
        itemCarSeat.Site__c = 'Boston'; 
       	lstItems.add(itemCarSeat);
        
        //11
        Item__c itemLargeToys = new Item__c();
        itemLargeToys.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemLargeToys.Available_As_Bulk_Item__c = null;
        itemLargeToys.Name = ' ItemBaby Gear4';
        itemLargeToys.Category__c = 'Baby Gear'; 
        itemLargeToys.BabyGearType__c = 'Large Toys';
        itemLargeToys.Ages__c = '10 years';
        itemLargeToys.Gender__c = 'Boy';
        itemLargeToys.Site__c = 'Boston'; 
       	lstItems.add(itemLargeToys);
        //12
        Item__c itemSeatsSwings = new Item__c(); 
        itemSeatsSwings.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemSeatsSwings.Available_As_Bulk_Item__c = null;
        itemSeatsSwings.Name = ' ItemBaby Gear5';
        itemSeatsSwings.Category__c = 'Baby Gear'; 
        itemSeatsSwings.BabyGearType__c = 'Seats & Swings';
        itemSeatsSwings.Ages__c = '10 years';
        itemSeatsSwings.Gender__c = 'Boy';
        itemSeatsSwings.Site__c = 'Boston'; 
        lstItems.add(itemSeatsSwings);
        //13
        Item__c itemSeatsSwings2 = new Item__c();
        itemSeatsSwings2.Available_As_Kid_Pack_Item__c = 'Active';
        itemSeatsSwings2.Available_As_Bulk_Item__c = null; 
        itemSeatsSwings2.Name = ' ItemBaby Gear5';
        itemSeatsSwings2.Category__c = 'Baby Gear'; 
        itemSeatsSwings2.BabyGearType__c = 'Seats & Swings';
        itemSeatsSwings2.Ages__c = '10 years';
        itemSeatsSwings2.Gender__c = 'Boy';
        itemSeatsSwings2.Site__c = 'Boston'; 
       	lstItems.add(itemSeatsSwings2);
         
        //14
        Item__c itemTemporaryAvailable = new Item__c(); 
        itemTemporaryAvailable.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemTemporaryAvailable.Available_As_Bulk_Item__c = null; 
        itemTemporaryAvailable.Name = 'Temporary Available Items';
        itemTemporaryAvailable.Category__c = 'Baby Gear'; 
        itemTemporaryAvailable.BabyGearType__c = 'Temporary Available Items';
        itemTemporaryAvailable.Ages__c = '10 years';
        itemTemporaryAvailable.Gender__c = 'Boy';
        itemTemporaryAvailable.Site__c = 'Boston'; 
       	lstItems.add(itemTemporaryAvailable);
       	//15
        Item__c itemStroller = new Item__c(); 
        itemStroller.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemStroller.Name = 'Stroller';
        itemStroller.Category__c = 'Baby Gear'; 
        itemStroller.BabyGearType__c = 'Stroller';
        itemStroller.Ages__c = '10 years';
        itemStroller.Gender__c = 'Boy';
        itemStroller.Site__c = 'Boston'; 
       	lstItems.add(itemStroller);
       	//16
        Item__c itemBoosterSeat = new Item__c();
        itemBoosterSeat.Available_As_Kid_Pack_Item__c = 'Active';         
        itemBoosterSeat.Name = 'Booster Seat - Table (6-12 mos)';
        itemBoosterSeat.Category__c = 'Baby Gear'; 
        itemBoosterSeat.BabyGearType__c = 'Booster Seat - Table (6-12 mos.)';
        itemBoosterSeat.Ages__c = '10 years';
        itemBoosterSeat.Gender__c = 'Boy';
        itemBoosterSeat.Site__c = 'Boston'; 
       	lstItems.add(itemBoosterSeat);
       	 //00
        Item__c itemClothing1 = new Item__c(); 
        itemClothing1.Available_As_Kid_Pack_Item__c = 'Active';
        itemClothing1.Available_As_Bulk_Item__c = 'Active';
        itemClothing1.Name = ' itemClothing';
        itemClothing1.Category__c = 'Clothing';
        itemClothing1.Ages__c = '10 years';
        itemClothing1.Gender__c = 'Boy';
        itemClothing1.Site__c = 'Boston';
       	lstItems.add(itemClothing1);
       //01
        Item__c itemFootwear1 = new Item__c(); 
        itemFootwear1.Available_As_Kid_Pack_Item__c = 'Active';
        itemFootwear1.Available_As_Bulk_Item__c = 'Active';
        itemFootwear1.Name = ' itemFootwear1';
        itemFootwear1.Category__c = 'Everyday Footwear';
        itemFootwear1.Ages__c = '10 years';
        itemFootwear1.Gender__c = 'Boy';
        itemFootwear1.Site__c = 'Boston'; 
       	lstItems.add(itemFootwear1);
        //02
        Item__c itemWinterBoots1 = new Item__c();
        itemWinterBoots1.Available_As_Kid_Pack_Item__c = 'Active';
        itemWinterBoots1.Available_As_Bulk_Item__c = 'Active';
        itemWinterBoots1.Name = ' itemFootwear2';
        itemWinterBoots1.Category__c = 'Seasonal Footwear';
        itemWinterBoots1.Ages__c = '10 years';
        itemWinterBoots1.Gender__c = 'Boy';
        itemWinterBoots1.Site__c = 'Boston'; 
       	lstItems.add(itemWinterBoots1);
        //03 
        Item__c itemOuterwear1 = new Item__c(); 
        itemOuterwear1.Available_As_Kid_Pack_Item__c = 'Active';
        itemOuterwear1.Available_As_Bulk_Item__c = 'Active';
        itemOuterwear1.Name = ' itemOuterwear';
        itemOuterwear1.Category__c = 'Outerwear'; 
        itemOuterwear1.Ages__c = '10 years';
        itemOuterwear1.Gender__c = 'Boy';
        itemOuterwear1.Site__c = 'Boston'; 
       	lstItems.add(itemOuterwear1);
        
        //04
        Item__c itemBooks1 = new Item__c(); 
        itemBooks1.Available_As_Kid_Pack_Item__c = 'Active';
        itemBooks1.Available_As_Bulk_Item__c = 'Active';
        itemBooks1.Name = ' ItemBooks';
        itemBooks1.Category__c = 'Books';
        itemBooks1.Ages__c = '10 years';
        itemBooks1.Gender__c = 'Boy';
        itemBooks1.Site__c = 'Boston'; 
       	lstItems.add(itemBooks1);
        
        //05
        Item__c itemArtsCrafts1 = new Item__c(); 
        itemArtsCrafts1.Available_As_Kid_Pack_Item__c = 'Active';
        itemArtsCrafts1.Available_As_Bulk_Item__c = 'Active';
        itemArtsCrafts1.Name = ' ItemArts & Crafts';
        itemArtsCrafts1.Category__c = 'Arts & Crafts'; 
        itemArtsCrafts1.Ages__c = '10 years';
        itemArtsCrafts1.Gender__c = 'Boy';
        itemArtsCrafts1.Site__c = 'Boston'; 
       	lstItems.add(itemArtsCrafts1);
        //06
        Item__c itemToys1 = new Item__c();
        itemToys1.Available_As_Bulk_Item__c = 'Active';
        itemToys1.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemToys1.Name = ' ItemToys';
        itemToys1.Category__c = 'Toys'; 
        itemToys1.Ages__c = '10 years';
        itemToys1.Gender__c = 'Boy';
        itemToys1.Site__c = 'Boston'; 
       	lstItems.add(itemToys1);
        //07
        Item__c itemBirthdayGift1 = new Item__c();
        itemBirthdayGift1.Available_As_Bulk_Item__c = 'Active';
        itemBirthdayGift1.Available_As_Kid_Pack_Item__c = null;  
        itemBirthdayGift1.Name = ' Birthday Gift';
        itemBirthdayGift1.Site__c = 'Boston'; 
       	lstItems.add(itemBirthdayGift1);
        
        //08
        Item__c itemNursery1 = new Item__c();
        itemNursery1.Available_As_Bulk_Item__c = 'Active';
        itemNursery1.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemNursery1.Name = ' ItemBaby Gear1';
        itemNursery1.Category__c = 'Baby Gear'; 
        itemNursery1.BabyGearType__c = 'Nursery';
        itemNursery1.Ages__c = '10 years';
        itemNursery1.Gender__c = 'Boy';
        itemNursery1.Site__c = 'Boston'; 
       	lstItems.add(itemNursery1);
        //09
        Item__c itemBed1 = new Item__c(); 
        itemBed1.Available_As_Bulk_Item__c = 'Active';
        itemBed1.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemBed1.Name = ' ItemBaby Gear2';
        itemBed1.Category__c = 'Baby Gear'; 
        itemBed1.BabyGearType__c = 'Bed';
        itemBed1.Ages__c = '10 years';
        itemBed1.Gender__c = 'Boy';
        itemBed1.Site__c = 'Boston'; 
       	lstItems.add(itemBed1);
        //010
        Item__c itemCarSeat1 = new Item__c(); 
        itemCarSeat1.Available_As_Bulk_Item__c = 'Active';
        itemCarSeat1.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemCarSeat1.Name = ' ItemBaby Gear3';
        itemCarSeat1.Category__c = 'Baby Gear'; 
        itemCarSeat1.BabyGearType__c = 'Car Seat';
        itemCarSeat1.Ages__c = '10 years';
        itemCarSeat1.Gender__c = 'Boy';
        itemCarSeat1.Site__c = 'Boston'; 
       	lstItems.add(itemCarSeat1);
        
        //011
        Item__c itemLargeToys1 = new Item__c();
        itemLargeToys1.Available_As_Bulk_Item__c = 'Active';
        itemLargeToys1.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemLargeToys1.Category__c = 'Baby Gear'; 
        itemLargeToys1.BabyGearType__c = 'Large Toys';
        itemLargeToys1.Ages__c = '10 years';
        itemLargeToys1.Gender__c = 'Boy';
        itemLargeToys1.Site__c = 'Boston'; 
       	lstItems.add(itemLargeToys1);
        //012
        Item__c itemSeatsSwings1 = new Item__c(); 
        itemSeatsSwings1.Available_As_Bulk_Item__c = 'Active';
        itemSeatsSwings1.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemSeatsSwings1.Name = ' ItemBaby Gear5';
        itemSeatsSwings1.Category__c = 'Baby Gear'; 
        itemSeatsSwings1.BabyGearType__c = 'Seats & Swings';
        itemSeatsSwings1.Ages__c = '10 years';
        itemSeatsSwings1.Gender__c = 'Boy';
        itemSeatsSwings1.Site__c = 'Boston'; 
        lstItems.add(itemSeatsSwings1);
        //013
        Item__c itemSeatsSwings3 = new Item__c();
        itemSeatsSwings3.Available_As_Bulk_Item__c = 'Active';
        itemSeatsSwings3.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemSeatsSwings3.Name = ' ItemBaby Gear5';
        itemSeatsSwings3.Category__c = 'Baby Gear'; 
        itemSeatsSwings3.BabyGearType__c = 'Seats & Swings';
        itemSeatsSwings3.Ages__c = '10 years';
        itemSeatsSwings3.Gender__c = 'Boy';
        itemSeatsSwings3.Site__c = 'Boston'; 
       	lstItems.add(itemSeatsSwings3);
         
        //014
        Item__c itemTemporaryAvailable1 = new Item__c(); 
        itemTemporaryAvailable1.Available_As_Bulk_Item__c = 'Active';
        itemTemporaryAvailable1.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemTemporaryAvailable1.Name = 'Temporary Available Items';
        itemTemporaryAvailable1.Category__c = 'Baby Gear'; 
        itemTemporaryAvailable1.BabyGearType__c = 'Temporary Available Items';
        itemTemporaryAvailable1.Ages__c = '10 years';
        itemTemporaryAvailable1.Gender__c = 'Boy';
        itemTemporaryAvailable1.Site__c = 'Boston'; 
       	lstItems.add(itemTemporaryAvailable1);
       	//015
        Item__c itemStroller1 = new Item__c(); 
        itemStroller1.Available_As_Bulk_Item__c = 'Active';
        itemStroller1.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemStroller1.Name = 'Stroller';
        itemStroller1.Category__c = 'Baby Gear'; 
        itemStroller1.BabyGearType__c = 'Stroller';
        itemStroller1.Ages__c = '10 years';
        itemStroller1.Gender__c = 'Boy';
        itemStroller1.Site__c = 'Boston'; 
       	lstItems.add(itemStroller1);
       	//016
        Item__c itemBoosterSeat1 = new Item__c();
        itemBoosterSeat1.Available_As_Bulk_Item__c = 'Active';
        itemBoosterSeat1.Available_As_Kid_Pack_Item__c = 'Active';  
        itemBoosterSeat1.Name = 'Booster Seat - Table (6-12 mos)';
        itemBoosterSeat1.Category__c = 'Baby Gear'; 
        itemBoosterSeat1.BabyGearType__c = 'Booster Seat - Table (6-12 mos.)';
        itemBoosterSeat1.Ages__c = '10 years';
        itemBoosterSeat1.Gender__c = 'Boy';
        itemBoosterSeat1.Site__c = 'Boston'; 
       	lstItems.add(itemBoosterSeat1);
  		
  	 	
       //dont have age
        Item__c itemFootwear2 = new Item__c(); 
        itemFootwear2.Available_As_Kid_Pack_Item__c = 'Active';
        itemFootwear2.Available_As_Bulk_Item__c = null; 
        itemFootwear2.Name = ' itemFootwear1';    
        itemFootwear2.Category__c = 'Everyday Footwear';   
        itemFootwear2.Ages__c = null;
        itemFootwear2.Gender__c = 'Boy';
        itemFootwear2.Site__c = 'Boston'; 
       	lstItems.add(itemFootwear2);
        //dont have age
        Item__c itemWinterBoots2 = new Item__c();
        itemWinterBoots2.Available_As_Kid_Pack_Item__c = 'Active';
        itemWinterBoots2.Available_As_Bulk_Item__c = null; 
        itemWinterBoots2.Name = ' itemFootwear2';
        itemWinterBoots2.Category__c = 'Seasonal Footwear';  
        itemWinterBoots2.Ages__c = null;
        itemWinterBoots2.Gender__c = 'Boy';
        itemWinterBoots2.Site__c = 'Boston'; 
       	lstItems.add(itemWinterBoots2);
  
       	//dont have gender
        Item__c itemFootwear4 = new Item__c(); 
        itemFootwear4.Available_As_Kid_Pack_Item__c = 'Active';
        itemFootwear4.Available_As_Bulk_Item__c = null; 
        itemFootwear4.Name = ' itemFootwear1';    
        itemFootwear4.Category__c = 'Everyday Footwear';   
        itemFootwear4.Ages__c = '10 years';
        itemFootwear4.Gender__c = null;
        itemFootwear4.Site__c = 'Boston'; 
       	lstItems.add(itemFootwear4);
        //dont have gender
        Item__c itemWinterBoots4 = new Item__c();
        itemWinterBoots4.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemWinterBoots4.Available_As_Bulk_Item__c = null; 
        itemWinterBoots4.Name = ' itemFootwear2';
        itemWinterBoots4.Category__c = 'Seasonal Footwear';    
        itemWinterBoots4.Ages__c = '10 years';
        itemWinterBoots4.Gender__c = null;
        itemWinterBoots4.Site__c = 'Boston'; 
       	lstItems.add(itemWinterBoots4);
      	
       	 //Item for Both KidPack & Bulk(dont have age)
        Item__c itemFootwear5 = new Item__c(); 
        itemFootwear5.Available_As_Kid_Pack_Item__c = 'Active';
        itemFootwear5.Available_As_Bulk_Item__c = 'Active';
        itemFootwear5.Name = ' itemFootwear1';    
        itemFootwear5.Category__c = 'Everyday Footwear';     
        itemFootwear5.Ages__c = null;
        itemFootwear5.Gender__c = 'Boy';
        itemFootwear5.Site__c = 'Boston'; 
       	lstItems.add(itemFootwear5);
       
        //Item for Both KidPack & Bulk(dont have age)
        Item__c itemWinterBoots5 = new Item__c();
        itemWinterBoots5.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemWinterBoots5.Available_As_Bulk_Item__c = 'Active';
        itemWinterBoots5.Name = ' itemFootwear2';
        itemWinterBoots5.Category__c = 'Seasonal Footwear';   
        itemWinterBoots5.Gender__c = 'Boy';
        itemWinterBoots5.Ages__c = null;
        itemWinterBoots5.Site__c = 'Boston'; 
       	lstItems.add(itemWinterBoots5);
       	
       	//Item for Both KidPack & Bulk(dont have age and gender)
        Item__c itemFootwear6 = new Item__c(); 
        itemFootwear6.Available_As_Kid_Pack_Item__c = 'Active';
        itemFootwear6.Available_As_Bulk_Item__c = 'Active';
        itemFootwear6.Name = ' itemFootwear1';    
        itemFootwear6.Category__c = 'Everyday Footwear';
        itemFootwear6.Gender__c = null;
        itemFootwear6.Ages__c = null;
        itemFootwear6.Site__c = 'Boston'; 
       	lstItems.add(itemFootwear6);
        //Item for Both KidPack & Bulk(dont have age and gender)
        Item__c itemWinterBoots6 = new Item__c();
        itemWinterBoots6.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemWinterBoots6.Available_As_Bulk_Item__c = 'Active';
        itemWinterBoots6.Name = ' itemFootwear2';
        itemWinterBoots6.Category__c = 'Seasonal Footwear';
        itemWinterBoots6.Gender__c = null;
        itemWinterBoots6.Ages__c = null;
        itemWinterBoots6.Site__c = 'Boston'; 
       	lstItems.add(itemWinterBoots6);
       
       	//Item for Both KidPack & Bulk(dont have gender)
        Item__c itemFootwear7 = new Item__c(); 
        itemFootwear7.Available_As_Kid_Pack_Item__c = 'Active';
        itemFootwear7.Available_As_Bulk_Item__c = 'Active';
        itemFootwear7.Name = ' itemFootwear1';    
        itemFootwear7.Category__c = 'Everyday Footwear';   
        itemFootwear7.Ages__c = '10 years';
        itemFootwear7.Gender__c = null;
        itemFootwear7.Site__c = 'Boston'; 
       	lstItems.add(itemFootwear7);
        //Item for Both KidPack & Bulk(dont have gender)
        Item__c itemWinterBoots7 = new Item__c();
        itemWinterBoots7.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemWinterBoots7.Available_As_Bulk_Item__c = 'Active';
        itemWinterBoots7.Name = ' itemFootwear2';
        itemWinterBoots7.Category__c = 'Seasonal Footwear';   
        itemWinterBoots7.Ages__c = '10 years';
        itemWinterBoots7.Gender__c = null;
        itemWinterBoots7.Site__c = 'Boston'; 
       	lstItems.add(itemWinterBoots7);

        insert lstItems;
       
    }
 
    public void getBulkItems()
    {	List<Item__c> lstBulkItems = new List<Item__c> ();
     	Item__c itemBulk1 = new Item__c(); 
     	itemBulk1.Available_As_Bulk_Item__c = 'Active';
        itemBulk1.Name = ' ItemBabybulk';
        itemBulk1.Bulk_Type__c = 'Backpacks';
     	itemBulk1.Category__c = 'Baby Gear'; 
        itemBulk1.BabyGearType__c = 'Seats & Swings';
        itemBulk1.Ages__c = '12 years';
        itemBulk1.Gender__c = 'Boy';
        itemBulk1.Site__c = 'Boston'; 
       	lstBulkItems.add(itemBulk1);
        
        Item__c itemBulk2 = new Item__c(); 
        itemBulk2.Available_As_Bulk_Item__c = 'Active';
        itemBulk2.Name = ' ItemClothingbulk';
        itemBulk2.Bulk_Type__c = 'Backpacks';
        itemBulk2.Category__c = 'Clothing'; 
        itemBulk2.Ages__c = '12 years';
        itemBulk2.Gender__c = 'Boy';
        itemBulk2.Site__c = 'Boston'; 
       	lstBulkItems.add(itemBulk2);
       	
       	Item__c itemBulk3 = new Item__c(); 
     	itemBulk3.Available_As_Bulk_Item__c = 'Active';
     	itemBulk3.Available_As_Kid_Pack_Item__c = 'Active'; 
        itemBulk3.Name = ' ItemBabyNursery';
        itemBulk3.Bulk_Type__c = 'Nursery';	
        itemBulk3.Ages__c = '12 years';
        itemBulk3.Gender__c = 'Boy';
        itemBulk3.Site__c = 'Boston'; 
       	lstBulkItems.add(itemBulk3);
       insert lstBulkItems;
     
    }
    
    
     
}