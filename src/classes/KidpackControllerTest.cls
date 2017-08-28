@isTest
public class KidpackControllerTest {
	
    static testMethod void verifyRedirectToLogin() 
    { 
        KidpackController.redirectToLogin();
    }
    
    static testMethod void verifyKidpackController()
    { 
        Account accountObj = new Account(name ='Grazitti');
        insert accountObj; 
        system.assertNotEquals( accountObj.Id, null );
       
        Contact con = new Contact(LastName ='testCon', AccountId = accountObj.Id, Email = 'test@test.com', npe01__PreferredPhone__c = '9921870602');
        insert con;
        system.assertNotEquals( con.Id, null );
        Contact con1 = new Contact(LastName ='testCon1', AccountId = accountObj.Id, Email = 'test1@test.com', npe01__PreferredPhone__c = '9921870602');
        insert con1;
        system.assertNotEquals( con1.Id, null );
        User usr;
        User usr1;
        List<Profile> lstProfiles = [ SELECT Id FROM Profile WHERE Name = 'Cradles Partner Community Login' ];
        if( !lstProfiles.isEmpty() )
        {
            usr = new User();
            usr.alias = 'test123';
            usr.email = 'test123@noemail.com';
            usr.lastname = 'Testing';
            usr.ProfileId = lstProfiles[0].Id;
            usr.emailencodingkey = 'UTF-8';
            usr.languagelocalekey = 'en_US';
            usr.localesidkey = 'en_US';
            usr.country = 'United States';
            usr.ContactId = con.Id;
            usr.timezonesidkey = 'America/Los_Angeles';
            usr.username = 'tester@noemail.com';
            insert usr;
            system.assertNotEquals( usr.Id, null );
           
            // create user to test negative cases 
            usr1 = new User();
            usr1.alias = 'test1234';
            usr1.email = 'test1234@noemail.com';
            usr1.lastname = 'Testing';
            usr1.ProfileId = lstProfiles[0].Id;
            usr1.emailencodingkey = 'UTF-8';
            usr1.languagelocalekey = 'en_US';
            usr1.localesidkey = 'en_US';
            usr1.country = 'United States';
            usr1.ContactId = con1.Id;
            usr1.timezonesidkey = 'America/Los_Angeles';
            usr1.username = 'tester1@noemail.com';
            usr1.Site__c = '';
            insert usr1;
            system.assertNotEquals( usr1.Id, null );
        }
        system.runAs(usr) 
        {
            // statements to be executed by this test user. 
            
            Partner_Order__c partnerOrderObj = new Partner_Order__c();
            partnerOrderObj.Child_Age__c = '2 years';
            partnerOrderObj.Child_Gender__c = 'Boy';
            partnerOrderObj.Status__c = 'Picked Up';
            insert partnerOrderObj;
            system.assertNotEquals(partnerOrderObj.Id, null);
            
            User userdetails = [SELECT ID, name, Phone, Site__c, ContactId, username, Contact.AccountId, Contact.Account.Order_Level__c, Contact.Phone, Contact.EnableBulkOrder__c, Contact.Email
                                FROM User WHERE username = : UserInfo.getUserName() LIMIT 1]; 
            
            Portal_Configuration__c portalConfigObj = new Portal_Configuration__c();
            portalConfigObj.Location__c = userdetails.Site__c;
            portalConfigObj.EnableOrder__c = true;
            portalConfigObj.Message__c = 'message';
            insert portalConfigObj;
            system.assertNotEquals(portalConfigObj.Id, null);
            
            List<Item__c> lstItem = new List<Item__c>();
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 1' , Category__c = 'Everyday Footwear', Available_As_Kid_Pack_Item__c = 'Active', Ages__c = '2 years',  Gender__c = 'Boy'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 2' , Category__c = 'Everyday Footwear', Available_As_Kid_Pack_Item__c = 'Active', Gender__c = 'Boy'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 3' , Category__c = 'Everyday Footwear', Available_As_Kid_Pack_Item__c = 'Active'));
            
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 4' , Category__c = 'Seasonal Footwear', Available_As_Kid_Pack_Item__c = 'Active', Ages__c = '2 years',  Gender__c = 'Boy'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 5' , Category__c = 'Seasonal Footwear', Available_As_Kid_Pack_Item__c = 'Active', Gender__c = 'Boy'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 6' , Category__c = 'Seasonal Footwear', Available_As_Kid_Pack_Item__c = 'Active'));
            
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 8' , Category__c = 'Outerwear', Available_As_Kid_Pack_Item__c = 'Active', Gender__c = 'Boy'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 9' , Category__c = 'Outerwear Accessories', Available_As_Kid_Pack_Item__c = 'Active', Gender__c = 'Boy'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 10' , Category__c = 'Books', Available_As_Kid_Pack_Item__c = 'Active', Gender__c = 'Boy'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 11' , Category__c = 'Arts & Crafts', Available_As_Kid_Pack_Item__c = 'Active', Gender__c = 'Boy'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 12' , Category__c = 'Toys', Available_As_Kid_Pack_Item__c = 'Active', Gender__c = 'Boy'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 30' , Category__c = 'Nursery', Available_As_Kid_Pack_Item__c = 'Active', Gender__c = 'Boy'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 31' , Category__c = 'Clothing', Available_As_Kid_Pack_Item__c = 'Active', Gender__c = 'Boy'));
            lstItem.add( new Item__c(Category__c = 'Birthday Gift', Available_As_Kid_Pack_Item__c = 'Active', Available_As_Bulk_Item__c = null, Site__c = userdetails.Site__c, Ages__c = null, Container_Type__c = null, Gender__c =null, Season__c = null, Shopping_Location__c = null, Size__c =null, SKU__c = null, Type_Sub_Category__c = null, BabyGearType__c = null));
            
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 15' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Super Saucer'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 16' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Booster Seat - Table (6-12 mos.)'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 17' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Pack n Play (portable)'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 18' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Bouncy Seat (Infant)'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 19' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'High Chair (6 mos. - 2yrs)'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 20' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Bassinet (Infant)'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 21' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Indoor Swing'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 22' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Safety Gate'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 24' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Bed Rails'));
          //lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 25' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Bed'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 26' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Car Seat'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 27' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Stroller'));
            lstItem.add( new Item__c(Site__c =  userdetails.Site__c, Name = 'item number 28' , Category__c = 'Baby Gear', Available_As_Kid_Pack_Item__c = 'Active', BabyGearType__c = 'Temporary Available Items'));
            insert lstItem;
            List<Item__c> insertedLstItem = [SELECT Id,Name FROM Item__c];
            system.assertEquals(lstItem.size(), insertedLstItem.size());
            
            List<Partner_Order_Item__c> lstPartnerOrderItem = new List<Partner_Order_Item__c>();
            for(Item__c item : insertedLstItem){
                lstPartnerOrderItem.add(new Partner_Order_Item__c(Partner_Order__c = partnerOrderObj.Id, Item__c = item.Id));
            }
            insert lstPartnerOrderItem;
            List<Partner_Order_Item__c> insertedLstPartnerOrderItem = [SELECT Id,Name FROM Partner_Order_Item__c];
            system.assertEquals(lstPartnerOrderItem.size(), insertedLstPartnerOrderItem.size());
                
            PageReference pageRef = Page.kidpackStepOne;
            Test.setCurrentPage(pageRef); 
            
            ApexPages.currentPage().getParameters().put('cloneId', partnerOrderObj.id); 
            KidpackController kidpackObj = new KidpackController();
            kidpackObj.SaveStepOne();
            kidpackObj.SaveStepTwo();
            
            ApexPages.currentPage().getParameters().put('cloneId','');
            ApexPages.currentPage().getParameters().put('editId', partnerOrderObj.id); 
            KidpackController kidpackObjEdit = new KidpackController();
            kidpackObjEdit.SaveStepOne();
            kidpackObjEdit.SaveStepTwo();
            kidpackObjEdit.SaveStepThree();
            kidpackObjEdit.SaveStepFour();
            kidpackObjEdit.Step4Back();
            kidpackObjEdit.SaveStepFour(); 
            kidpackObjEdit.SaveStepFive();
            kidpackObjEdit.SaveStepSix();
           	kidpackObjEdit.reviewStepBack();
            kidpackObjEdit.SaveStepSix(); 
            kidpackObjEdit.AddNurseryRow();
            kidpackObjEdit.submit(); 
            //kidpackObjEdit.strChildAge = '1 years'; // if strChildAge is public
            //kidpackObjEdit.SaveStepOne();
            
            ApexPages.currentPage().getParameters().put('cloneId','');
            ApexPages.currentPage().getParameters().put('editId', '');  
            KidpackController kidpackObjCloneAndEdit = new KidpackController(); 
            kidpackObjCloneAndEdit.SaveStepOne();
            kidpackObjCloneAndEdit.SaveStepTwo();
            kidpackObjCloneAndEdit.SaveStepThree(); 
            
            ApexPages.currentPage().getParameters().put('cloneId', partnerOrderObj.id);
            KidpackController kidpackObjClone = new KidpackController(); 
            kidpackObjClone.IsOrderInserted = true; 
            kidpackObjClone.SaveStepOne(); 
            kidpackObjClone.SaveStepThree();
            
            kidpackObjClone.Step1Back();
            kidpackObjClone.Step2Back();
            kidpackObjClone.Step3Back(); 
            kidpackObjClone.Step5Back();
            kidpackObjClone.Step6Back();
            
            kidpackObjEdit.deleteStandardItems();
        }
        system.runAs(usr1)
        {
       		User userdetails = [ SELECT ID, name, Phone, Site__c, ContactId, username, Contact.AccountId, Contact.Account.Order_Level__c, Contact.Phone, Contact.EnableBulkOrder__c, Contact.Email
                                FROM User WHERE username = : UserInfo.getUserName() LIMIT 1 ]; 
            Portal_Configuration__c portalConfigObj = new Portal_Configuration__c();
            portalConfigObj.Location__c = userdetails.Site__c;
            portalConfigObj.EnableOrder__c = true;
            portalConfigObj.Message__c = 'message';
            insert portalConfigObj;
            system.assertNotEquals(portalConfigObj.Id, null);
            PageReference pageRef = Page.kidpackStepOne;
            Test.setCurrentPage(pageRef); 
            ApexPages.currentPage().getParameters().put('editId','apxcd223AAA');
            try
            {
            	KidpackController kidpackObjEdit = new KidpackController();
            }
            catch(Exception ex)
            {
                 system.debug('KidPackController Test Method Exception '+ ex.getMessage());
            }
        }    
    }
}