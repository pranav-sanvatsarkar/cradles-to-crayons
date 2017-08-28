public with sharing class DropOffMobileController 
{
    @RemoteAction
    public static ActionResult GetAllData()
    {
        User userNew = [SELECT Id, Site__c, Location__c FROM User WHERE Id = :Userinfo.getUserId()];
        if(userNew.Location__c == null)
        {
            userNew.Location__c = 'Dock';
            update userNew;
        }
        Map<String,Object> dataMap = new Map<String,Object>();
        ActionResult result = new ActionResult();
        result.IsSuccess = true;
        
        List<ContactInfo> contactInfoList = new List<ContactInfo>();
        for( Contact contact : [SELECT Id, Name, FirstName, LastName, Email, MailingPostalCode FROM Contact LIMIT 100])
        {
            contactInfoList.add( new ContactInfo( contact));
        }
        
        Date earlierDate = System.today().addMonths(-3);
        Date laterDate = System.today().addMonths(3);
        List<CampaignInfo> campaignInfoList = new List<CampaignInfo>();
        for( Campaign campaign : [SELECT Id, RecordType.Name, Name, Type, Primary_Contact__r.Name, Primary_Organization__r.Name, StartDate, EndDate, Collection_Town_City__r.Name, Delivery_Information__c, Created_Via_Receiving_App__c FROM Campaign WHERE Site__c = :userNew.Site__c AND IsActive = true AND RecordType.Name In ('Collection Campaign', 'Purchase Order') AND ((StartDate >= :earlierDate AND StartDate <= :laterDate) OR (EndDate >= :earlierDate AND EndDate <= :laterDate)) LIMIT 100 ])
        {
            campaignInfoList.add( new CampaignInfo( campaign));
        }
        
        List<Account> accountList = [SELECT Id, Name FROM Account LIMIT 100];
        Map<String,List<String>> picklistValueMap = new Map<String,List<String>>();
        String []lstReceivingLog = new String[] {'Unit_Nursery_Items__c','Unit_School_Art_Supplies__c','Unit_Baby_Gear__c','Unit_Books__c','Unit_Clothing__c','Unit_Toys__c','Unit_Socks_Underwear__c','Unit_Footwear__c','Unit_Outerwear__c','Unit_Pajamas__c'};
        for(Integer i = 0; i < lstReceivingLog.Size(); i++)
        {
            List<String> lstRevingLog =  getPicklistValues('Receiving_Log__c',lstReceivingLog[i]);
            picklistValueMap.put(lstReceivingLog[i],lstRevingLog);
        }
        Map<String,String> picklistValueDefaultMap = new Map<String,String>();
        for(Integer i = 0; i < lstReceivingLog.Size(); i++)
        {
            String lstRevingLog =  getDefaultValue('Receiving_Log__c',lstReceivingLog[i]);
            picklistValueDefaultMap.put(lstReceivingLog[i],lstRevingLog);
        }
        
        dataMap.put( 'SessionId', Userinfo.getSessionId());
        dataMap.put( 'ContactInfoList', contactInfoList);
        dataMap.put( 'CampaignInfoList', campaignInfoList);
        dataMap.put( 'AccountList', accountList);
        dataMap.put( 'User', userNew);
        dataMap.put( 'picklistValueMap',picklistValueMap);
        dataMap.put( 'picklistValueDefaultMap',picklistValueDefaultMap);
        result.Data = dataMap;
        
        return result;
    }
    
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name)
    { 
          List<String> lstPickvals=new List<String>();
          Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
          Sobject Object_name = targetType.newSObject();
          Schema.sObjectType sobject_type = Object_name.getSObjectType();
          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
          List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); 
          for (Schema.PicklistEntry a : pick_list_values) 
          { 
              lstPickvals.add(a.getValue());
           }
      return lstPickvals;
    }
    public static String getDefaultValue(String ObjectApi_name,String Field_name)
    {
          String str;
          Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
          Sobject Object_name = targetType.newSObject();
          Schema.sObjectType sobject_type = Object_name.getSObjectType();
          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
          List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); 
          for (Schema.PicklistEntry a : pick_list_values) 
          { 
              if(a.isDefaultValue())
              {
                  str = a.getValue();
                  break;
              }
          }
          return str;
        
    }

      
    
    @RemoteAction
    public static ActionResult UpdateLocation( String strLocation)
    {
        User userNew = [SELECT Id, Location__c FROM User WHERE Id = :Userinfo.getUserId()];
        userNew.Location__c = strLocation;
        Database.Saveresult saveResult = Database.update( userNew);
        ActionResult result = new ActionResult( saveResult);
        result.Data = userNew;
        
        return result;    
    }
    
    @RemoteAction
    public static ActionResult GetContacts( String strCriteria)
    {
        String strEmail = strCriteria;
        strCriteria = '%' + strCriteria + '%';
        List<Contact> contactList = [SELECT Id, Name, FirstName, LastName, Email, MailingPostalCode FROM Contact WHERE Name LIKE :strCriteria OR Email =: strEmail  LIMIT 50000];
        List<ContactInfo> contactInfoList = new List<ContactInfo>();
        for( Contact contact : contactList)
        {
            contactInfoList.add( new ContactInfo( contact));
        }
        ActionResult result = new ActionResult();

        result.IsSuccess = true;
        result.Data = contactInfoList;
        
        return result;
    }
    
    @RemoteAction
    public static ActionResult GetCampaigns( String strCriteria)
    {
        User userNew = [SELECT Id, Site__c FROM User WHERE Id = :Userinfo.getUserId()];
        Date earlierDate = System.today().addMonths(-3);
        Date laterDate = System.today().addMonths(3);
        strCriteria = '%' + strCriteria + '%';
        List<Campaign> campaignList = [SELECT Id, RecordType.Name, Name, Type, Primary_Contact__r.Name, Primary_Organization__r.Name, StartDate, EndDate, Collection_Town_City__r.Name, Delivery_Information__c, Site__c, Created_Via_Receiving_App__c FROM Campaign WHERE IsActive = true AND Site__c = :userNew.Site__c AND RecordType.Name In ('Collection Campaign', 'Purchase Order') AND (Name LIKE :strCriteria OR Primary_Contact__r.Name LIKE :strCriteria OR Primary_Organization__r.Name LIKE :strCriteria OR Collection_Town_City__r.Name LIKE :strCriteria ) AND ((StartDate >= :earlierDate AND StartDate <= :laterDate) OR (EndDate >= :earlierDate AND EndDate <= :laterDate)) LIMIT 100];
        List<CampaignInfo> campaignInfoList = new List<CampaignInfo>();
        for( Campaign campaign : campaignList)
        {
            campaignInfoList.add( new CampaignInfo( campaign));
        }
        ActionResult result = new ActionResult();
        result.IsSuccess = true;
        result.Data = campaignInfoList;
        
        return result;
    }
    
    @RemoteAction
    public static ActionResult GetAccounts( String strCriteria)
    {
        strCriteria = '%' + strCriteria + '%';
        List<Account> accountList = [SELECT Id, Name FROM Account WHERE Name LIKE :strCriteria LIMIT 100];
        ActionResult result = new ActionResult();

        result.IsSuccess = true;
        result.Data = accountList;
        
        return result;
    }
    
    @RemoteAction
    public static ActionResult AddContact( ContactInfo contactRecord)
    {
        Contact contactNew = contactRecord.GetSObject();
        Database.Saveresult saveResult = Database.insert( contactNew);
        ActionResult result = new ActionResult( saveResult);
        
        contactRecord.Id = contactNew.Id;
        contactRecord.IsEditMode = false;
        result.Data = contactRecord;
        
        return result;
    }
    
    @RemoteAction
    public static ActionResult UpdateContact( ContactInfo contactRecord)
    {
        Contact contactNew = contactRecord.GetSObject();
        Database.Saveresult saveResult = Database.update( contactNew);
        ActionResult result = new ActionResult( saveResult);
        result.Data = contactRecord;
        
        return result;
    }
    
    @RemoteAction
    public static ActionResult AddCampaign( CampaignInfo campaignRecord)
    {
        User userNew = [SELECT Id, Site__c FROM User WHERE Id = :Userinfo.getUserId()];
        String strRecordType = campaignRecord.RecordType.equals('Drive') ? 'Collection Campaign' : 'Purchase Order';
        String strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Campaign' AND Name = :strRecordType][0].Id;
        Campaign campaignNew = campaignRecord.GetSObject();
        ///modified
        campaignNew.Created_Via_Receiving_App__c = true;
        
        campaignNew.RecordTypeId = strRecordTypeId;
        campaignNew.IsActive = true;
        campaignNew.Site__c = userNew.Site__c;
        Database.Saveresult saveResult = Database.insert( campaignNew);
        ActionResult result = new ActionResult( saveResult);
        campaignRecord.Id = campaignNew.Id;
        campaignRecord.IsEditMode = false;
        result.Data = campaignRecord;
       
        return result;
        
    }
    
    @RemoteAction
    public static ActionResult UpdateCampaign( CampaignInfo campaignRecord)
    {   
        Campaign campaignNew = campaignRecord.GetSObject();
        ///modified
        campaignNew.Created_Via_Receiving_App__c = true;
        Database.Saveresult saveResult = Database.update( campaignNew);
        ActionResult result = new ActionResult( saveResult);
        result.Data = campaignRecord;
        Campaign campaignTotal = [SELECT Books_Rollup__c, Baby_Gear_Rollup__c, Toys_Rollup__c, School_Art_Supplies_Rollup__c, Clothing_Rollup__c, Nursery_Items_Rollup__c, Socks_Underwear_Rollup__c, Footwear_Rollup__c, Outerwear_Rollup__c, PJ_s_Rollup__c, Drive_Format__c FROM Campaign WHERE Id = :campaignNew.Id];
        result.OtherData = new ReceivingLogDetail(campaignTotal);
        
        return result;
    }
    
    @RemoteAction
    public static ActionResult AddReceivingLog( ReceivingLogInfo receivingLogRecord)
    {
        User userNew = [SELECT Id, Site__c, Location__c FROM User WHERE Id = :Userinfo.getUserId()];
        if( receivingLogRecord.POId != null )
        {
            Campaign campaignForDelivery = [ SELECT Id, Delivery_Information__c FROM Campaign WHERE Id = :receivingLogRecord.POId ];
            campaignForDelivery.Delivery_Information__c = receivingLogRecord.DeliveryNotes;
            update campaignForDelivery;
        }
        
        Receiving_Log__c receivingLogNew = receivingLogRecord.GetSObject();
        receivingLogNew.Site__c = userNew.Site__c;
        receivingLogNew.Location__c = userNew.Location__c;
        receivingLogNew.Surprise_Drive__c = receivingLogRecord.SurpriseDrive;
        Database.Saveresult saveResult = Database.insert( receivingLogNew);
        ActionResult result = new ActionResult( saveResult);
        
        receivingLogRecord.Id = receivingLogNew.Id;
        result.Data = receivingLogRecord;
        
        return result;
    }
    
    public class ContactInfo
    {
        public String Id { get; set; }
        public String Name { get; set; }
        public String FirstName { get; set; }
        public String LastName { get; set; }
        public String Email { get; set; }
        public String HomeZip { get; set; }
        public Boolean IsEditMode { get; set; }
       
        
        public ContactInfo() {}
        
        public ContactInfo( Contact contactNew) 
        {
            Id = contactNew.Id;
            Name = contactNew.Name;
            FirstName = contactNew.FirstName;
            LastName = contactNew.LastName;
            Email = contactNew.Email;
            HomeZip = contactNew.MailingPostalCode;
            IsEditMode = false;
        }
        
        public Contact GetSObject()
        {
            Contact contactNew;
            if( this.Id == null)
                contactNew = new Contact();
            else
                contactNew = new Contact(Id = this.Id);
            contactNew.FirstName = this.FirstName;
            contactNew.LastName = this.LastName;
            contactNew.Email = this.Email;
            contactNew.MailingPostalCode = this.HomeZip;
            
            return contactNew;
        }
    }
    
    public class CampaignInfo
    {
        public String Id { get; set; }
        public String RecordType { get; set; }
        public String Name { get; set; }
        public String OrganizationId { get; set; }
        public String OrganizationName { get; set; }
        public String Type { get; set; }
        public String PrimaryContact { get; set; }
        public String StartDate { get; set; }
        public String EndDate { get; set; }
        public String TownCity { get; set; }
        public Boolean IsEditMode { get; set; }
        public String DeliveryInformation { get; set; }
        public Boolean Created_Via_Receiving_App {get;set;}
        
        
        public CampaignInfo() {}
        
        public CampaignInfo( Campaign campaignNew) 
        {
            Id = campaignNew.Id;
            RecordType = campaignNew.RecordType.Name.equals('Collection Campaign') ? 'Drive' : 'PO';
            Name = campaignNew.Name;
           
           
            if( campaignNew.StartDate != null )
            {
                Datetime tempStartDate = campaignNew.StartDate;
                tempStartDate = tempStartDate.AddDays(1);
                StartDate = tempStartDate.format('MM-dd-yy');
            }
           
            if( campaignNew.EndDate != null )
            {
                Datetime tempEndDate = campaignNew.EndDate;
                tempEndDate = tempEndDate.AddDays(1);
                EndDate = tempEndDate.format('MM-dd-yy');
            }
            
           
            
            this.Created_Via_Receiving_App = campaignNew.Created_Via_Receiving_App__c;
            this.OrganizationId = campaignNew.Primary_Organization__c;
            this.OrganizationName = campaignNew.Primary_Organization__r.Name;
            this.Type = campaignNew.Type;
            this.PrimaryContact = campaignNew.Primary_Contact__r.Name;
            this.TownCity = campaignNew.Collection_Town_City__r.Name;
            this.DeliveryInformation = campaignNew.Delivery_Information__c;
            IsEditMode = false;
        }
        
        public Campaign GetSObject()
        {
            Campaign campaignNew;
            if( this.Id == null)
                campaignNew = new Campaign();
            else
                campaignNew = new Campaign(Id = this.Id);
            
            String strRecordType = this.RecordType.equals('Drive') ? 'Collection Campaign' : 'Purchase Order';
            campaignNew.RecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Campaign' AND Name = :strRecordType][0].Id;
            
            campaignNew.Name = this.Name;
            campaignNew.Primary_Organization__c = this.OrganizationId;
            campaignNew.Type = this.Type;
            if(Test.isRunningTest())
                campaignNew.StartDate = System.Today();
            return campaignNew;
        }
    }
    
    public class ReceivingLogInfo
    {
        public String Id { get; set; }
        public String ContactId { get; set; }
        public String DriveId { get; set; }
        public String POId { get; set; }
        public String HomeZip { get; set; }
        public String Type { get; set; }
        
        public String DeliveryStatus { get; set; }
        public String DeliveryNotes { get; set; }
        
        public Decimal BooksRecQty { get; set; }
        public String BooksRecUnit { get; set; }
        public Decimal BabyGearRecQty { get; set; }
        public String BabyGearRecUnit { get; set; }
        public Decimal ToysRecQty { get; set; }
        public String ToysRecUnit { get; set; }
        public Decimal SchoolAndArtSuppliesRecQty { get; set; }
        public String SchoolAndArtSuppliesRecUnit { get; set; }
        public Decimal ClothingRecQty { get; set; }
        public String ClothingRecUnit { get; set; }
        public Decimal NurseryRecQty { get; set; }
        public String NurseryRecUnit { get; set; }
        public Decimal SocksUnderwearRecQty { get; set; }
        public String SocksUnderwearRecUnit { get; set; }
        public Decimal FootwearRecQty { get; set; }
        public String FootwearRecUnit { get; set; }
        public Decimal OuterwearRecQty { get; set; }
        public String OuterwearRecUnit { get; set; }
        public Decimal PajamasRecQty { get; set; }
        public String PajamasRecUnit { get; set; }
        public Boolean SurpriseDrive { get; set; }
        
        public ReceivingLogInfo() {} 
        
        public ReceivingLogInfo( Receiving_Log__c receivingLogNew) 
        {
            Id = receivingLogNew.Id;
            DeliveryStatus = receivingLogNew.Delivery_Status__c;
            DeliveryNotes = receivingLogNew.Notes__c;
        }
        
        public Receiving_Log__c GetSObject()
        {
            Receiving_Log__c receivingLogNew;
            if( this.Id == null)
                receivingLogNew = new Receiving_Log__c();
            else
                receivingLogNew = new Receiving_Log__c(Id = this.Id);
                
            receivingLogNew.Contact__c = this.ContactId;
            if( !String.isBlank(this.DriveId))
                receivingLogNew.Drive__c = this.DriveId;
            else
                receivingLogNew.Purchase_Order__c = this.POId;
            receivingLogNew.Home_Zip__c = this.HomeZip;
            receivingLogNew.Type__c = this.Type;
            
            receivingLogNew.Delivery_Status__c = this.DeliveryStatus;
            receivingLogNew.Notes__c = this.DeliveryNotes;
            
            receivingLogNew.Books_Received_Qty__c = this.BooksRecQty;
            receivingLogNew.Unit_Books__c = this.BooksRecUnit;
            receivingLogNew.Baby_Gear_Received_Qty__c = this.BabyGearRecQty;
            receivingLogNew.Unit_Baby_Gear__c = this.BabyGearRecUnit;
            receivingLogNew.Toys_Received_Qty__c = this.ToysRecQty;
            receivingLogNew.Unit_Toys__c = this.ToysRecUnit;
            receivingLogNew.School_Art_Supplies_Received_Qty__c = this.SchoolAndArtSuppliesRecQty;
            receivingLogNew.Unit_School_Art_Supplies__c = this.SchoolAndArtSuppliesRecUnit;
            receivingLogNew.Clothing_Received_Qty__c = this.ClothingRecQty;
            receivingLogNew.Unit_Clothing__c = this.ClothingRecUnit;
            receivingLogNew.Nursery_Items_Received_Qty__c = this.NurseryRecQty;
            receivingLogNew.Unit_Nursery_Items__c = this.NurseryRecUnit;
            
            receivingLogNew.Socks_Underwear_Received_Qty__c = this.SocksUnderwearRecQty;
            receivingLogNew.Unit_Socks_Underwear__c = this.SocksUnderwearRecUnit;
            receivingLogNew.footwear_Received_Qty__c = this.FootwearRecQty;
            receivingLogNew.Unit_Footwear__c = this.FootwearRecUnit;
            receivingLogNew.Outerwear_Received_Qty__c = this.OuterwearRecQty;
            receivingLogNew.Unit_Outerwear__c = this.OuterwearRecUnit;
            receivingLogNew.Pajamas_Received_Qty__c = this.PajamasRecQty;
            receivingLogNew.Unit_Pajamas__c = this.PajamasRecUnit;
            
            return receivingLogNew;
        }
    }
    
    public class ReceivingLogDetail
    {
        public String Id { get; set; }
        
        public Decimal BooksQtyTotal { get; set; }
        public String BooksUnit { get; set; }
        public Decimal BabyGearQtyTotal { get; set; }
        public String BabyGearUnit { get; set; }
        public Decimal ToysQtyTotal { get; set; }
        public String ToysUnit { get; set; }
        public Decimal SchoolAndArtSuppliesQtyTotal { get; set; }
        public String SchoolAndArtSuppliesUnit { get; set; }
        public Decimal ClothingQtyTotal { get; set; }
        public String ClothingUnit { get; set; }
        public Decimal NurseryQtyTotal { get; set; }
        public String NurseryUnit { get; set; }
        public Decimal SocksUnderwearQtyTotal { get; set; }
        public String SocksUnderwearUnit { get; set; }
        public Decimal FootwearQtyTotal { get; set; }
        public String FootwearUnit { get; set; }
        public Decimal OuterwearQtyTotal { get; set; }
        public String OuterwearUnit { get; set; }
        public Decimal PajamasQtyTotal { get; set; }
        public String PajamasUnit { get; set; }
        
        public ReceivingLogDetail( Campaign campaignNew)
        {
            this.Id = campaignNew.Id;
            this.BooksQtyTotal = (campaignNew.Books_Rollup__c == null) ? 0 : campaignNew.Books_Rollup__c;
            this.BabyGearQtyTotal = (campaignNew.Baby_Gear_Rollup__c == null) ? 0 : campaignNew.Baby_Gear_Rollup__c;
            this.ToysQtyTotal = (campaignNew.Toys_Rollup__c == null) ? 0 : campaignNew.Toys_Rollup__c;
            this.SchoolAndArtSuppliesQtyTotal = (campaignNew.School_Art_Supplies_Rollup__c == null) ? 0 : campaignNew.School_Art_Supplies_Rollup__c;
            this.ClothingQtyTotal = (campaignNew.Clothing_Rollup__c == null) ? 0 : campaignNew.Clothing_Rollup__c;
            this.NurseryQtyTotal = (campaignNew.Nursery_Items_Rollup__c == null) ? 0 : campaignNew.Nursery_Items_Rollup__c;
            this.SocksUnderwearQtyTotal = (campaignNew.Socks_Underwear_Rollup__c == null) ? 0 : campaignNew.Socks_Underwear_Rollup__c;
            this.FootwearQtyTotal = (campaignNew.Footwear_Rollup__c == null) ? 0 : campaignNew.Footwear_Rollup__c;
            this.OuterwearQtyTotal = (campaignNew.Outerwear_Rollup__c == null) ? 0 : campaignNew.Outerwear_Rollup__c;
            this.PajamasQtyTotal = (campaignNew.PJ_s_Rollup__c == null) ? 0 : campaignNew.PJ_s_Rollup__c;
         
        }
    }
}