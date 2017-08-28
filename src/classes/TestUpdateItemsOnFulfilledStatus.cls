@isTest
private class TestUpdateItemsOnFulfilledStatus
{
    static testMethod void TestUpdateItems()
    {
        Inventory_Transaction_Setting__c setting = new Inventory_Transaction_Setting__c(setupOwnerId = System.Userinfo.getOrganizationId());
        Production_Order__c ProductionOrder = new Production_Order__c();
        Inventory_Location__c InventoryLocation = new Inventory_Location__c();
        Inventory_Stage__c InventoryStage = new Inventory_Stage__c();
        Partner_Order__c PartnerOrder = new Partner_Order__c();
        Item__c item1 = new Item__c();
        Partner_Order_Item__c PartnerOrderItem = new Partner_Order_Item__c();
        List<Partner_Order_Item__c> lstPartnerOrderItem = new List<Partner_Order_Item__c>();
          
        InventoryStage.Name = 'Shopping Stage';
        InventoryLocation.Name = 'Production Floor Location';
        PartnerOrder.Shelf_Location__c = 'Test';
        PartnerOrder.Fulfilled_Date__c = DateTime.parse('12/12/2014 12:00 AM');
        PartnerOrder.Caregiver_s_First_name__c = 'TestFirstName';
        PartnerOrder.Caregiver_s_Last_name__c = 'TestLastName';
        PartnerOrder.Status__c = 'Fulfilled';
        
        PartnerOrderItem.Qty_Ordered__c = 4;
       
        
        insert InventoryStage;
        insert InventoryLocation;

        ProductionOrder.Inventory_Stage__c = InventoryStage.Id;
        ProductionOrder.Inventory_Location__c = InventoryLocation.Id;
        insert ProductionOrder;

        setting.Inventory_Location_Name__c = 'Production Floor Location';
        setting.Inventory_Stage_Name__c = 'Shopping Stage';
        insert setting;

        insert item1;
        insert PartnerOrder;

        PartnerOrderItem.Item__c = item1.Id;
        PartnerOrderItem.Partner_Order__c = PartnerOrder.Id;
        insert PartnerOrderItem;      
    }
}