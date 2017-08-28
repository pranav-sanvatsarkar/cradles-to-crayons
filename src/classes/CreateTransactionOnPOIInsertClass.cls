public class CreateTransactionOnPOIInsertClass
{
    public static void CreateInventoryTransaction(List<Partner_Order_Item__c> lstPartnerOrderItem)
    {
        Inventory_Transaction_Setting__c InventorySetting = Inventory_Transaction_Setting__c.getInstance();
        List<Inventory_Transaction__c> lstNewInventoryTransaction = new List<Inventory_Transaction__c>();
        map<id,id> mapPOItemToInventory = new map<id,id>();

        try
        {
            if(InventorySetting.Inventory_Stage_Name__c != null && InventorySetting.Inventory_Location_Name__c != null)
            {
                System.debug('Custom field is not null.. InventorySetting  :: '+InventorySetting );
    
                //get recently created production order having inventory stage as Mentioned in custom settings
                list<Production_Order__c> lstProductionOrderPhil = [SELECT Name, CreatedDate  FROM Production_Order__c WHERE Inventory_Stage__r.Name =: InventorySetting.Inventory_Stage_Name__c AND Inventory_Stage__r.Site__c = 'Philadelphia' ORDER BY CreatedDate DESC LIMIT 1];
                
                //get recently created production order having inventory stage as Mentioned in custom settings
                list<Production_Order__c> lstProductionOrderBstn = [SELECT Name, CreatedDate  FROM Production_Order__c WHERE Inventory_Stage__r.Name =: InventorySetting.Inventory_Stage_Name__c AND Inventory_Stage__r.Site__c = 'Boston' ORDER BY CreatedDate DESC LIMIT 1];
                
                //get recently created Inventory Stage Having its Name as Mentioned in custom settings and site is Philadelphia
                list<Inventory_Stage__c> lstInventoryStagePhil = [SELECT Id, Name FROM Inventory_Stage__c WHERE Name =: InventorySetting.Inventory_Stage_Name__c AND Site__c='Philadelphia' ORDER BY CreatedDate DESC LIMIT 1];
                  
                //get recently created Inventory Stage Having its Name as Mentioned in custom settings and site is Boston
                list<Inventory_Stage__c> lstInventoryStageBstn = [SELECT Id, Name FROM Inventory_Stage__c WHERE Name =: InventorySetting.Inventory_Stage_Name__c AND Site__c='Boston' ORDER BY CreatedDate DESC LIMIT 1];
                
                System.debug(InventorySetting.Inventory_Stage_Name__c);
                System.debug(InventorySetting.Inventory_Location_Name__c);
                
                System.debug('after list assignment');
                     
                //Check if any Production order, Inventory Location and Inventory Stage record is present or no  
                //if(lstProductionOrder != null && lstProductionOrder.size() > 0)
                {
                    //get recently created Inventory Location Having its Name as Mentioned in custom settings and site is Philadelphia
                    list<Inventory_Location__c> lstInventoryLocationforPhil = [SELECT Id, Name FROM Inventory_Location__c WHERE Name =: InventorySetting.Inventory_Location_Name__c AND Site__c='Philadelphia' ORDER BY CreatedDate DESC LIMIT 1];

                    //get recently created Inventory Location Having its Name as Mentioned in custom settings and site is Boston
                    list<Inventory_Location__c> lstInventoryLocationforBstn = [SELECT Id, Name FROM Inventory_Location__c WHERE Name =: InventorySetting.Inventory_Location_Name__c AND Site__c='Boston' ORDER BY CreatedDate DESC LIMIT 1];
                
                    lstPartnerOrderItem = new list<Partner_Order_Item__c>([SELECT id,Name,Qty_Fulfilled__c,Item__c,Partner_Order__r.IsBulkOrder__c,Partner_Order__r.status__c,Partner_Order__r.Site__c FROM Partner_Order_Item__c WHERE id IN : Trigger.new]);

                    for(Inventory_Transaction__c InvTransaction : [SELECT id, Order_Item__c FROM Inventory_Transaction__c WHERE Order_Item__c IN : Trigger.New])
                    {
                        if(!mapPOItemToInventory.containsKey(InvTransaction.Order_Item__c))
                        {
                            mapPOItemToInventory.put(InvTransaction.Order_Item__c,InvTransaction.Id);
                        }
                    }

                    for(Partner_Order_Item__c OrderItem : lstPartnerOrderItem)
                    {
                        if((OrderItem.Partner_Order__r.IsBulkOrder__c == false && OrderItem.Partner_Order__r.status__c == 'Fulfilled' && OrderItem.Qty_Fulfilled__c > 0) || (Trigger.isUpdate && mapPOItemToInventory != null && mapPOItemToInventory.size() > 0 && mapPOItemToInventory.containsKey(OrderItem.Id) && OrderItem.Partner_Order__r.IsBulkOrder__c == false && OrderItem.Partner_Order__r.status__c == 'Fulfilled'))
                        {
                            Inventory_Transaction__c NewInventoryTransaction = new Inventory_Transaction__c(); //
                            NewInventoryTransaction.Type__c = 'Out';
                            NewInventoryTransaction.Unit__c = 'Piece';
                            
                            if(OrderItem.Partner_Order__r.Site__c == 'Boston')
                            {
                                //Check if any Production order record for Boston is present or no
                                if(lstProductionOrderBstn != null && lstProductionOrderBstn.size() > 0)
                                    NewInventoryTransaction.Production_Order__c = lstProductionOrderBstn[0].Id;
                                else
                                    Trigger.newMap.get(OrderItem.id).addError('No Production Order found for Boston Site');

                                //Check if any Inventory Stage record for Boston is present or no
                                if(lstInventoryStageBstn != null && lstInventoryStageBstn.size() > 0)
                                    NewInventoryTransaction.Inventory_Stage__c = lstInventoryStageBstn[0].Id;
                                else
                                    Trigger.newMap.get(OrderItem.id).addError('No Inventory Stage found for Boston Site');

                                //Check if any Inventory Location record for Boston is present or no
                                if(lstInventoryLocationforBstn != null && lstInventoryLocationforBstn.size() > 0)
                                    NewInventoryTransaction.Inventory_Location__c = lstInventoryLocationforBstn[0].Id;
                                else
                                    Trigger.newMap.get(OrderItem.id).addError('No Inventory location found for Boston Site');
                            }
                            else if(OrderItem.Partner_Order__r.Site__c == 'Philadelphia')
                            {
                                //Check if any Production order record for Philadelphia is present or no
                                if(lstProductionOrderPhil != null && lstProductionOrderPhil.size() > 0)
                                    NewInventoryTransaction.Production_Order__c = lstProductionOrderPhil[0].Id;
                                else
                                    Trigger.newMap.get(OrderItem.id).addError('No Production Order found for Philadelphia Site');

                                //Check if any Inventory Stage record for Philadelphia is present or no
                                if(lstInventoryStagePhil != null && lstInventoryStagePhil.size() > 0)
                                    NewInventoryTransaction.Inventory_Stage__c = lstInventoryStagePhil[0].Id;
                                else
                                    Trigger.newMap.get(OrderItem.id).addError('No Inventory Stage found for Philadelphia Site');
    
                                //Check if any Inventory Location record for Philadelphia is present or no
                                if(lstInventoryLocationforPhil != null && lstInventoryLocationforPhil.size() > 0)
                                    NewInventoryTransaction.Inventory_Location__c = lstInventoryLocationforPhil[0].Id;
                                else
                                     Trigger.newMap.get(OrderItem.id).addError('No location found for Philadelphia Site');                             
                            }

                            System.debug(NewInventoryTransaction.Inventory_Location__c);
                            if(Trigger.isUpdate)
                            {
                                if(mapPOItemToInventory != null && mapPOItemToInventory.size() > 0)
                                {
                                    if(mapPOItemToInventory.containsKey(OrderItem.Id))
                                    {
                                        NewInventoryTransaction.Id = mapPOItemToInventory.get(OrderItem.Id);
                                    }
                                }
                            }

                            NewInventoryTransaction.Quantity__c = OrderItem.Qty_Fulfilled__c;
                            NewInventoryTransaction.Item__c = OrderItem.Item__c;
                            NewInventoryTransaction.Order_Item__c = OrderItem.Id;
                            lstNewInventoryTransaction.add(NewInventoryTransaction);
                        }
                    }
                   
                    if(lstNewInventoryTransaction != null && lstNewInventoryTransaction.size() > 0)
                    {
                        try
                        {
                            upsert lstNewInventoryTransaction;
                            system.debug(lstNewInventoryTransaction );
                        }
                        catch(DmlException e)
                        {
                            Trigger.new[0].addError(e.getDmlMessage(0));
                        }
                    }
                }
                /* else
                {
                    Trigger.new[0].addError('Please Update custom settings with proper values for Stage Name and Location Name');
                } */
            }
            else
            {
                System.debug('Custom field is null');
                Trigger.new[0].addError('Please Update custom settings');
            }
        }
        catch(Exception e)
        {
            System.debug('UNEXPECTED_ERROR '+e.getMessage());
        }
    }
}