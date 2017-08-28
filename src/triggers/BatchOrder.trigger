trigger BatchOrder on Partner_Order__c (before insert, before update) {
  	Boolean isRecordExist = false;
	Triggers__c BatchOrderSetting = Triggers__c.getInstance('BatchOrder');
	if(BatchOrderSetting != null )
	{
		isRecordExist = false;
		if(BatchOrderSetting.Active__c)
			isRecordExist = true;
	}
	else
		isRecordExist = true;
  
  if(isRecordExist)
  {
	  if(Trigger.IsInsert||Trigger.isUpdate){
	        List<Partner_Order_Batch__c> batchList = new List<Partner_Order_Batch__c>();
	        List<Partner_Order__c> orderList = new List<Partner_Order__c>();
	        
	            
	         for (Partner_Order__c d : Trigger.new) {
                if (d.Partner_Order_Batch__c == null && d.Status__c == 'Processing (printed, waiting to be packed)' ) {
                    Date datetoday = date.today();
                    Partner_Order_Batch__c[] batches = [Select Id from Partner_Order_Batch__c where Contact__c=:d.Contact__c  AND Batch_Date__c=:datetoday];
                    Partner_Order_Batch__c db;
                    if(batches.size()>0) {
                    	d.Partner_Order_Batch__c  = batches[0].Id;
                    }
                    else {  
                        db = new Partner_Order_Batch__c(Contact__c = d.Contact__c, 
                        	Batch_Date__c=datetoday, Organization__c = d.Partner__c, Site__c = d.Site__c);    
                        batchList.add(db);
                        orderList.add(d);
                    }
	            }
	        }
	        List<String> ids = new List<String>();
	        if (batchList.size() > 0) {
	            Database.SaveResult[] result = Database.Insert(batchList, false);
	            for (Database.SaveResult sr : result){
	                ids.add(sr.Id);
	            }
	        }
	        if (ids.size() > 0) {
	            for (Integer i=0; i<ids.size(); i++) {
	                Partner_Order__c d = orderList.get(i); 
	                if (ids.get(i) != null) {
	                    d.Partner_Order_Batch__c = ids.get(i);
	                }
	            }
	        }    
	    }
  }
}