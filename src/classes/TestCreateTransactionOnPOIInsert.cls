@isTest
private class TestCreateTransactionOnPOIInsert
{
    static testMethod void TestCreateTransaction()
    {
        //Create and insert a hierarchical custom setting  record
        Inventory_Transaction_Setting__c setting = new Inventory_Transaction_Setting__c(setupOwnerId = System.Userinfo.getOrganizationId());
        setting.Inventory_Location_Name__c = 'Production Floor Location';
        setting.Inventory_Stage_Name__c = 'Shopping Stage';
        insert setting;

        Triggers__c settings = new Triggers__c();
        settings.Name = 'CreateTransactionOnPOIInsert';
        settings.Active__c = true;
        insert settings;

        //Create and insert inventory stage records
        Inventory_Stage__c InventoryStagePhil = new Inventory_Stage__c();
        InventoryStagePhil.Name = 'Shopping Stage';
        InventoryStagePhil.Site__c = 'Philadelphia'; 

        insert InventoryStagePhil;

        Inventory_Stage__c InventoryStageBoston = new Inventory_Stage__c();
        InventoryStageBoston.Name = 'Shopping Stage';
        InventoryStageBoston.Site__c = 'Boston'; 

        insert InventoryStageBoston;

        //Create and insert inventory location records
        Inventory_Location__c InventoryLocationPhil = new Inventory_Location__c();
        InventoryLocationPhil.Name = 'Production Floor Location';
        InventoryLocationPhil.Site__c = 'Philadelphia';
        insert InventoryLocationPhil;

        System.assertNotEquals(InventoryLocationPhil.Id,null,'InventoryLocation Phil is null');

        Inventory_Location__c InventoryLocationBoston = new Inventory_Location__c();
        InventoryLocationBoston.Name = 'Production Floor Location';
        InventoryLocationBoston.Site__c = 'Boston';
        insert InventoryLocationBoston;

        System.assertNotEquals(InventoryLocationBoston.Id,null,'InventoryLocation Boston is null');

        //Create and insert Production Order records
        Production_Order__c ProductionOrderPhil = new Production_Order__c();
        ProductionOrderPhil.Inventory_Stage__c = InventoryStagePhil.Id;
        ProductionOrderPhil.Inventory_Location__c = InventoryLocationPhil.Id;
        insert ProductionOrderPhil;
        
        Production_Order__c ProductionOrderBoston = new Production_Order__c();
        ProductionOrderBoston.Inventory_Stage__c = InventoryStageBoston.Id;
        ProductionOrderBoston.Inventory_Location__c = InventoryLocationBoston.Id;
        insert ProductionOrderBoston;

        //Create and insert Partner Order records
        Partner_Order__c PartnerOrderBoston = new Partner_Order__c();
        PartnerOrderBoston.Shelf_Location__c = 'Test';
        PartnerOrderBoston.Fulfilled_Date__c = DateTime.parse('12/12/2016 12:00 AM');
        PartnerOrderBoston.Caregiver_s_First_name__c = 'TestFirstName';
        PartnerOrderBoston.Caregiver_s_Last_name__c = 'TestLastName';
        PartnerOrderBoston.IsBulkOrder__c = false;
        PartnerOrderBoston.status__c = 'Fulfilled';
        PartnerOrderBoston.Site__c = 'Boston'; 
        insert PartnerOrderBoston;

        Partner_Order__c PartnerOrderPhil = new Partner_Order__c();
        PartnerOrderPhil.Shelf_Location__c = 'Test';
        PartnerOrderPhil.Fulfilled_Date__c = DateTime.parse('12/12/2016 12:00 AM');
        PartnerOrderPhil.Caregiver_s_First_name__c = 'TestFirstName';
        PartnerOrderPhil.Caregiver_s_Last_name__c = 'TestLastName';
        PartnerOrderPhil.IsBulkOrder__c = false;
        PartnerOrderPhil.status__c = 'Fulfilled';
        PartnerOrderPhil.Site__c = 'Philadelphia'; 
        insert PartnerOrderPhil;
        
        //Create and insert Item record
        Item__c item1 = new Item__c();
        insert item1;

        List<Partner_Order_Item__c> lstPartnerOrderItem = new List<Partner_Order_Item__c>();
        for(Integer x=0; x<20;x++){
            Partner_Order_Item__c PartnerOrderItem = new Partner_Order_Item__c();
            PartnerOrderItem.Qty_Ordered__c = 4;
            PartnerOrderItem.Item__c = item1.Id;
            PartnerOrderItem.Partner_Order__c = PartnerOrderBoston.Id;
            PartnerOrderItem.Qty_Fulfilled__c = 3;
            lstPartnerOrderItem.add(PartnerOrderItem);
        }

        for(Integer x=0; x<20;x++){
            Partner_Order_Item__c PartnerOrderItem = new Partner_Order_Item__c();
            PartnerOrderItem.Qty_Ordered__c = 5;
            PartnerOrderItem.Item__c = item1.Id;
            PartnerOrderItem.Partner_Order__c = PartnerOrderPhil.Id;
            PartnerOrderItem.Qty_Fulfilled__c = 4;
            lstPartnerOrderItem.add(PartnerOrderItem);
        }

        Test.startTest();
        insert lstPartnerOrderItem;
        Test.stopTest();    
        
        Partner_Order_Item__c PartnerOrderItem1 = new Partner_Order_Item__c();
        PartnerOrderItem1.Id = null;
        PartnerOrderItem1.Qty_Ordered__c = 4;
        PartnerOrderItem1.Item__c = item1.Id;
        PartnerOrderItem1.Partner_Order__c = PartnerOrderPhil.Id;
        PartnerOrderItem1.Qty_Fulfilled__c = 3;
        
        System.assertEquals(PartnerOrderItem1.Id,null,'PartnerOrderItem not null');

        lstPartnerOrderItem[10].Qty_Fulfilled__c = 5;
        update lstPartnerOrderItem[10];

        
        list<Inventory_Transaction__c> InvTransBoston = [select id, Order_Item__c, Quantity__c,Inventory_Location__c,Inventory_Stage__c,Production_Order__c from Inventory_Transaction__c where Order_Item__c =: lstPartnerOrderItem[10].Id limit 1];
        
        //System.assertEquals(InvTransBoston[0].Quantity__c, lstPartnerOrderItem[10].Qty_Fulfilled__c,'Quantity not updated');
        System.assertEquals(InvTransBoston[0].Inventory_Location__c, InventoryLocationBoston.Id,'Location update is not correct for boston');
        System.assertEquals(InvTransBoston[0].Inventory_Stage__c, InventoryStageBoston.Id,'Stage update is not correct for boston');
        System.assertEquals(InvTransBoston[0].Production_Order__c, ProductionOrderBoston.Id,'Production Order update is not correct for boston');
        
        
        list<Inventory_Transaction__c> InvTransPhil = [select id, Order_Item__c, Quantity__c,Inventory_Location__c,Inventory_Stage__c,Production_Order__c from Inventory_Transaction__c where Order_Item__c =: lstPartnerOrderItem[30].Id limit 1];
        
        System.assertEquals(InvTransPhil[0].Inventory_Location__c, InventoryLocationPhil.Id,'Location update is not correct for Philadelphia');
        System.assertEquals(InvTransPhil[0].Inventory_Stage__c, InventoryStagePhil.Id,'Stage update is not correct for Philadelphia');
        System.assertEquals(InvTransPhil[0].Production_Order__c, ProductionOrderPhil.Id,'Production Order update is not correct for Philadelphia');
        

        //update custom setting with invalid location
        //setting.Inventory_Location_Name__c = 'Shopping Production';
        //update setting;

        //Insert PO Item to check code behaviour when no proper custom setting is done

        //insert PartnerOrderItem1;
        
        //PartnerOrderItem1.Id = null;
        //System.assertEquals(PartnerOrderItem1.Id,null,'PartnerOrderItem not null');
        
        //update custom setting with no location provided
        //setting.Inventory_Location_Name__c = null;
        //update setting;

        //insert PartnerOrderItem1;
    }
}