@isTest public class PartnerOrderControllerTest{ 

@isTest static void ManagePartnerOrder()
{ 
    PartnerOrderTestHelper ManagerOrderHelper = new PartnerOrderTestHelper();  
    System.runAs(ManagerOrderHelper.userDetails){ 
        Portal_Configuration__c poconfig  =   ManagerOrderHelper.getportalconfiguration(); 
        ManagerOrderHelper.getPartnerOrders();
        ManageOrderController ManagerOrder = new ManageOrderController();
        Partner_Order__c  partnerDelete = [SELECT Id, Name from Partner_Order__c LIMIT 1];    
        ManagerOrder.getRecords(); 
        ManagerOrder.cancel();
        ManagerOrder.getPartnerOrders();
        ManagerOrder.last(); 
        ManagerOrder.first();
        ManagerOrder.Next(); 
        ManagerOrder.first();
        ManagerOrder.last();            
        ManagerOrder.previous();   
        ManagerOrder.first();
        ManagerOrder.Next();
        ManagerOrder.previous();  
        ManagerOrder.getViews(); 
        ManagerOrder.Redirect();
        ManagerOrder.PartnerOrderDeleteId = partnerDelete.Id;   
        ManagerOrder.DeleteOrder();    
        
    }
}  
  
@isTest static void BulkPartnerOrder()
{ 
		
    PartnerOrderTestHelper BulkOrderHelper = new PartnerOrderTestHelper(); 
    System.runAs(BulkOrderHelper.userDetails){
        Portal_Configuration__c poconfig  =   BulkOrderHelper.getportalconfiguration();                
        BulkOrderHelper.getItems();   
        BulkOrderHelper.getBulkItems();
        PartnerBulkOrder  PartnerBulkOrderTest = new PartnerBulkOrder(); 
        Item__c Item  = [ SELECT Id,Name,Bulk_Type__c,Available_As_Kid_Pack_Item__c,Available_As_Bulk_Item__c  from Item__c  where Bulk_Type__c =:'Backpacks' limit 1];
        PartnerBulkOrderTest.setPartnerMessages(); 
        PartnerBulkOrderTest.PartnerWrapper[0].ItemBulkType.Bulk_Type__c = Item.Bulk_Type__c;
        PartnerBulkOrderTest.PartnerWrapper[0].SelectedItemId = Item.Id;
        PartnerBulkOrderTest.SelectedIndex = 0;
        PartnerBulkOrderTest.AddRows(); 
        PartnerBulkOrderTest.FillList();                
        PartnerBulkOrderTest.submit(); 
        PartnerBulkOrderTest.cancel(); 
        PartnerBulkOrderTest.Redirect(); 
        //Clone Order
        ApexPages.currentPage().getParameters().put('cloneId',PartnerBulkOrderTest.partnerOrder.id);
        PartnerBulkOrder  PartnerBulkOrderTestclone = new PartnerBulkOrder(); 
        PartnerBulkOrderTestclone.submitNew();
        
    }
}  
  
   
   @isTest static void PartnerOrder()
    {   
    	
        PartnerOrderTestHelper PartnerOrderHelper = new PartnerOrderTestHelper();  
        System.runAs(PartnerOrderHelper.userDetails){ 
            PartnerOrderHelper.getItems();  
            Portal_Configuration__c portalconfiguration = PartnerOrderHelper.getportalconfiguration();
            Partner_Order__c partnerOrderNew = new Partner_Order__c(); 
            PartnerOrderStep1Controller PartnerOrderTest = new PartnerOrderStep1Controller(); 
            PartnerOrderTest.partnerOrder.Child_First_Name__c = 'prakash';
            PartnerOrderTest.partnerOrder.Child_Last_Name__c = 'Nawale';    
            PartnerOrderTest.partnerOrder.Child_Gender__c = 'Boy'; 
            PartnerOrderTest.partnerOrder.Child_Age__c = '10 years';
            PartnerOrderTest.partnerOrder.Caregiver_s_First_name__c = 'Bose';
            PartnerOrderTest.partnerOrder.Caregiver_s_Last_name__c = 'Bose';
            PartnerOrderTest.partnerOrder.Location__c = 'India';
            PartnerOrderTest.setPartnerMessages();
        
            PartnerOrderTest.saveNextStep1();
            Item__c itemBirthdayGift = new Item__c();
            itemBirthdayGift.Available_As_Kid_Pack_Item__c = 'Active'; 
            itemBirthdayGift.Available_As_Bulk_Item__c = null; 
            itemBirthdayGift.Name = ' Birthday Gift';
           
            itemBirthdayGift.Site__c = 'Boston';  
            insert itemBirthdayGift;
            
            PartnerOrderTest.objBoosterSeat.IsSelectedItem = True;
            Item__c itemBoosterSeat = new Item__c(); 
            itemBoosterSeat.Available_As_Kid_Pack_Item__c = 'Active';
            itemBoosterSeat.Available_As_Bulk_Item__c = null; 
            itemBoosterSeat.Name = 'Booster Seat - Table (6-12 mos)';
            itemBoosterSeat.Category__c = 'Baby Gear'; 
            itemBoosterSeat.BabyGearType__c = 'Booster Seat - Table (6-12 mos.)';
            itemBoosterSeat.Ages__c = '10 years';
            itemBoosterSeat.Gender__c = 'Boy';
            itemBoosterSeat.Site__c = 'Boston';
            insert itemBoosterSeat;
           
            PartnerOrderTest.objSupersoucer.IsSelectedItem = True;
            Item__c itemSupersoucer = new Item__c(); 
            itemSupersoucer.Available_As_Kid_Pack_Item__c = 'Active';
            itemSupersoucer.Available_As_Bulk_Item__c = null; 
            itemSupersoucer.Name = 'Super Saucer';
            itemSupersoucer.Category__c = 'Baby Gear'; 
            itemSupersoucer.BabyGearType__c = 'Super Saucer';
            itemSupersoucer.Ages__c = '10 years';
            itemSupersoucer.Gender__c = 'Boy';
            itemSupersoucer.Site__c = 'Boston';
            insert itemSupersoucer;
            
            
            
            PartnerOrderTest.objPacknPlay.IsSelectedItem = True;
            Item__c itemobjPacknPlay = new Item__c(); 
            itemobjPacknPlay.Available_As_Kid_Pack_Item__c = 'Active';
            itemobjPacknPlay.Available_As_Bulk_Item__c = null; 
            itemobjPacknPlay.Name = 'Pack n Play (portable)';
            itemobjPacknPlay.Category__c = 'Baby Gear'; 
            itemobjPacknPlay.BabyGearType__c = 'Pack n Play (portable)';
            itemobjPacknPlay.Ages__c = '10 years';
            itemobjPacknPlay.Gender__c = 'Boy';
            itemobjPacknPlay.Site__c = 'Boston';
            insert itemobjPacknPlay;
           
           
            PartnerOrderTest.objBouncy.IsSelectedItem = True;
            Item__c itemobjBouncy = new Item__c(); 
            itemobjBouncy.Available_As_Kid_Pack_Item__c = 'Active';
            itemobjBouncy.Available_As_Bulk_Item__c = null; 
            itemobjBouncy.Name = 'Bouncy Seat (Infant)';
            itemobjBouncy.Category__c = 'Baby Gear'; 
            itemobjBouncy.BabyGearType__c = 'Bouncy Seat (Infant)';
            itemobjBouncy.Ages__c = '10 years';
            itemobjBouncy.Gender__c = 'Boy';
            itemobjBouncy.Site__c = 'Boston';
            insert itemobjBouncy;
          
            
            PartnerOrderTest.objHighChair.IsSelectedItem = True;
            Item__c itemobjHighChair = new Item__c(); 
            itemobjHighChair.Available_As_Kid_Pack_Item__c = 'Active';
            itemobjHighChair.Available_As_Bulk_Item__c = null; 
            itemobjHighChair.Name = 'High Chair (6 mos. - 2yrs)';
            itemobjHighChair.Category__c = 'Baby Gear'; 
            itemobjHighChair.BabyGearType__c = 'High Chair (6 mos. - 2yrs)';
            itemobjHighChair.Ages__c = '10 years';
            itemobjHighChair.Gender__c = 'Boy';
            itemobjHighChair.Site__c = 'Boston';
            insert itemobjHighChair;
          
            PartnerOrderTest.objBassinet.IsSelectedItem = True;
            Item__c itemobjBassinet = new Item__c(); 
            itemobjBassinet.Available_As_Kid_Pack_Item__c = 'Active';
            itemobjBassinet.Available_As_Bulk_Item__c = null;
            itemobjBassinet.Name = 'Bassinet (Infant)';
            itemobjBassinet.Category__c = 'Baby Gear'; 
            itemobjBassinet.BabyGearType__c = 'Bassinet (Infant)';
            itemobjBassinet.Ages__c = '10 years';
            itemobjBassinet.Gender__c = 'Boy';
            itemobjBassinet.Site__c = 'Boston';
            insert itemobjBassinet;
          
            PartnerOrderTest.objBassinet.SelectedItemId =[SELECT ID,NAME FROM Item__c  WHERE category__c =: 'Baby Gear' AND BabyGearType__c =: 'Bassinet (Infant)' LIMIT 1].ID;
            PartnerOrderTest.objHighChair.SelectedItemId =[SELECT ID,NAME FROM Item__c  WHERE category__c =: 'Baby Gear' AND BabyGearType__c =: 'High Chair (6 mos. - 2yrs)' LIMIT 1].ID;
            PartnerOrderTest.objBouncy.SelectedItemId =[SELECT ID,NAME FROM Item__c  WHERE category__c =: 'Baby Gear' AND BabyGearType__c =: 'Bouncy Seat (Infant)' LIMIT 1].ID;
            PartnerOrderTest.objPacknPlay.SelectedItemId =[SELECT ID,NAME FROM Item__c  WHERE category__c =: 'Baby Gear' AND BabyGearType__c =: 'Pack n Play (portable)' LIMIT 1].ID;
            PartnerOrderTest.objBoosterSeat.SelectedItemId =[SELECT ID,NAME FROM Item__c  WHERE category__c =: 'Baby Gear' AND BabyGearType__c =: 'Booster Seat - Table (6-12 mos.)' LIMIT 1].ID;
            PartnerOrderTest.objSupersoucer.SelectedItemId =[SELECT ID,NAME FROM Item__c  WHERE category__c =: 'Baby Gear' AND BabyGearType__c =: 'Super Saucer' LIMIT 1].ID; 
            PartnerOrderTest.IsAddItem[0] = True;
            PartnerOrderTest.IsAddItem[1] = True;
            PartnerOrderTest.IsAddItem[2] = True;
            PartnerOrderTest.IsAddItem[3] = True;
            PartnerOrderTest.IsAddItem[4] = True;
            PartnerOrderTest.IsAddItem[5] = True;
            PartnerOrderTest.IsAddItem[6] = True;
            PartnerOrderTest.IsAddItem[8] = True;
            PartnerOrderTest.IsAddItem[9] = True;
            PartnerOrderTest.IsAddItem[10] = True;
            PartnerOrderTest.IsAddItem[11] = True;
            PartnerOrderTest.IsAddItem[12] = True; 
            PartnerOrderTest.IsAddItem[13] = True;
            PartnerOrderTest.IsAddItem[14] = True;
            PartnerOrderTest.clothingItemId = PartnerOrderHelper.lstItems[0].id;  
            PartnerOrderTest.footWearItemId = PartnerOrderHelper.lstItems[1].id;  
            PartnerOrderTest.SeasonalFootWearItemId = PartnerOrderHelper.lstItems[2].id;  
            PartnerOrderTest.outerwearItemId = PartnerOrderHelper.lstItems[3].id;  
            PartnerOrderTest.booksItemId = PartnerOrderHelper.lstItems[4].id;  
            PartnerOrderTest.artsCraftsItemId = PartnerOrderHelper.lstItems[5].id;  
            PartnerOrderTest.toysItemId = PartnerOrderHelper.lstItems[6].id; 
            PartnerOrderTest.birthdayItem = itemBirthdayGift; 
          
            PartnerOrderTest.TempItemId = PartnerOrderHelper.lstItems[14].id;
            PartnerOrderTest.bedItemId = PartnerOrderHelper.lstItems[9].id; 
            PartnerOrderTest.largeToysItemId = PartnerOrderHelper.lstItems[11].id;
            PartnerOrderTest.seatsSwingsItemId = PartnerOrderHelper.lstItems[12].id;
            PartnerOrderTest.carSearItemId = PartnerOrderHelper.lstItems[10].id; 
            PartnerOrderTest.StrollerItemId = PartnerOrderHelper.lstItems[13].id; 
            PartnerOrderTest.saveNextStep2();          
            PartnerOrderTest.AddNurseryRow();
            PartnerOrderTest.WrapperNurseryItems[0].SelectedItemId = PartnerOrderHelper.lstItems[8].id;
            PartnerOrderTest.WrapperNurseryItems[0].IsSelectedItem = True;
            
            PartnerOrderTest.saveNextStep3();
            PartnerOrderTest.submit(); 
            
            PartnerOrderStep1Controller PartnerOrderTest2 = new PartnerOrderStep1Controller(); 
            PartnerOrderTest2.partnerOrder.Child_First_Name__c = 'prakash';
            PartnerOrderTest2.partnerOrder.Child_Last_Name__c = 'Nawale';    
            PartnerOrderTest2.partnerOrder.Child_Gender__c = 'Boy'; 
            PartnerOrderTest2.partnerOrder.Child_Age__c = '10 years';
            PartnerOrderTest2.partnerOrder.Caregiver_s_First_name__c = 'Damien';
            PartnerOrderTest2.partnerOrder.Caregiver_s_Last_name__c = 'Damien';
            PartnerOrderTest2.partnerOrder.Location__c = 'India';
            PartnerOrderTest2.setPartnerMessages();
            PartnerOrderTest2.saveNextStep1(); 
            
            PartnerOrderTest2.IsAddItem[0] = True;
            PartnerOrderTest2.IsAddItem[1] = True;
            PartnerOrderTest2.IsAddItem[2] = True;
            PartnerOrderTest2.IsAddItem[3] = True;
            PartnerOrderTest2.IsAddItem[4] = True;
            PartnerOrderTest2.IsAddItem[5] = True;
            PartnerOrderTest.IsAddItem[6] = True;
            PartnerOrderTest2.IsAddItem[8] = True;
            PartnerOrderTest2.IsAddItem[9] = True;
            PartnerOrderTest2.IsAddItem[10] = True;
            PartnerOrderTest2.IsAddItem[11] = True;
            PartnerOrderTest2.IsAddItem[12] = True; 
            PartnerOrderTest2.clothingItemId = PartnerOrderTest.lstItems[0].id;  
            PartnerOrderTest2.footWearItemId = PartnerOrderTest.lstItems[1].id;  
            PartnerOrderTest2.SeasonalFootWearItemId = PartnerOrderTest.lstItems[2].id;  
            PartnerOrderTest2.outerwearItemId = PartnerOrderTest.lstItems[3].id;  
            PartnerOrderTest2.booksItemId = PartnerOrderTest.lstItems[4].id;  
            PartnerOrderTest2.artsCraftsItemId = PartnerOrderTest.lstItems[5].id;  
            PartnerOrderTest2.toysItemId = PartnerOrderTest.lstItems[6].id; 
            PartnerOrderTest2.birthdayItem = itemBirthdayGift; 
            PartnerOrderTest2.nurseryItemId = PartnerOrderTest.lstItems[8].id;  
            PartnerOrderTest2.bedItemId = PartnerOrderTest.lstItems[9].id; 
            PartnerOrderTest2.largeToysItemId = PartnerOrderTest.lstItems[11].id;
            PartnerOrderTest2.seatsSwingsItemId = PartnerOrderTest.lstItems[12].id;
            PartnerOrderTest2.carSearItemId = PartnerOrderTest.lstItems[10].id; 
            PartnerOrderTest2.StrollerItemId = PartnerOrderHelper.lstItems[13].id;
            PartnerOrderTest2.TempItemId = PartnerOrderHelper.lstItems[14].id; 
            PartnerOrderTest2.saveNextStep2();
             PartnerOrderTest2.Step2Back(); 
            PartnerOrderTest2.partnerOrder.Child_Gender__c = 'Girl'; 
            PartnerOrderTest2.saveNextStep1();
            PartnerOrderTest2.saveNextStep2();    
            PartnerOrderTest2.Step3Back(); 
            PartnerOrderTest2.saveNextStep2();
            PartnerOrderTest2.saveNextStep3();
            PartnerOrderTest2.reviewStepBack(); 
            PartnerOrderTest2.saveNextStep3();
            PartnerOrderTest2.submit();  
            
            
            ApexPages.currentPage().getParameters().put('cloneId',PartnerOrderTest.partnerOrder.id);
            
            PartnerOrderStep1Controller PartnerOrderTestClone = new PartnerOrderStep1Controller(); 
            PartnerOrderTestClone.setPartnerMessages();
            PartnerOrderTestClone.saveNextStep1();
            PartnerOrderTestClone.getItems(); 
            PartnerOrderTestClone.birthdayItem = itemBirthdayGift;          
            PartnerOrderTestClone.Step2Back(); 
            PartnerOrderTestClone.saveNextStep1();
            PartnerOrderTestClone.saveNextStep2();
            PartnerOrderTestClone.Step3Back(); 
            PartnerOrderTestClone.saveNextStep2();
            PartnerOrderTestClone.saveNextStep3();
            PartnerOrderTestClone.reviewStepBack();
            PartnerOrderTestClone.saveNextStep3();
            PartnerOrderTestClone.submitNew();  
            
            ApexPages.currentPage().getParameters().put('EditId',PartnerOrderTest.partnerOrder.id); 
            PartnerOrderStep1Controller PartnerOrderTestEdit = new PartnerOrderStep1Controller();  
            PartnerOrderTestEdit.setPartnerMessages();
            PartnerOrderTestEdit.saveNextStep1();
            PartnerOrderTestEdit.getItems(); 
            PartnerOrderTestEdit.saveNextStep2();    
            PartnerOrderTestEdit.saveNextStep3();
            PartnerOrderTestEdit.submitNew();
            PartnerOrderTestEdit.Back();
            PartnerOrderTestEdit.cancel();
            PartnerOrderTestEdit.Redirect(); 
        }
    }  
}