@isTest
public class TestDropOffMobileController 
{
    public static testMethod void FunctionalTest() 
    {
        // TO DO: implement unit test
        Map<String,Object> dataMap = InitializeTestData();
        
        //Get All Contacts, Campaigns and Accounts
        ActionResult actionResult = DropOffMobileController.GetAllData();
        System.assert( actionResult.IsSuccess);
        
        actionResult = DropOffMobileController.GetContacts('SAC');
        System.assert( actionResult.IsSuccess);
        
        actionResult = DropOffMobileController.GetCampaigns('Campaign');
        System.assert( actionResult.IsSuccess);
        
        actionResult = DropOffMobileController.GetAccounts('Sputnik Moment');
        System.assert( actionResult.IsSuccess);
        
        //Create Contact
        DropOffMobileController.ContactInfo contactInfoNew = CreateContactInfoWithDefaults( 'Mukesh', 'Ambani', 'mukesh.ambure@enzigma.com', '50055-5555');
        actionResult = DropOffMobileController.AddContact( contactInfoNew);
        System.assert( actionResult.IsSuccess);
        
        //Update Contact
        contactInfoNew.LastName = 'Ambure';
        actionResult = DropOffMobileController.UpdateContact( contactInfoNew);
        System.assert( actionResult.IsSuccess);
        
        //Create Campaign
        Account account = (Account) dataMap.get('Account');
        DropOffMobileController.CampaignInfo campaignInfoNew = CreateCampaignInfoWithDefaults( '[Drive', '[Bo]Campaign', account.Id, 'Private');
       
        actionResult = DropOffMobileController.AddCampaign( campaignInfoNew);
        System.assert( actionResult.IsSuccess);
        
        //Update Campaign
        campaignInfoNew.Type = 'Corporate';
        actionResult = DropOffMobileController.UpdateCampaign( campaignInfoNew);
        System.assert( actionResult.IsSuccess);
        
        //Add ReceivingLog
        Contact contactNew = ((List<Contact>) dataMap.get('ContactList'))[0];
        Campaign campaignNew = ((List<Campaign>) dataMap.get('CampaignList'))[0];
        DropOffMobileController.ReceivingLogInfo receivingLogInfoNew = CreateReceivingLogInfoWithDefaults( contactNew.Id, campaignNew.Id, null, '1010', 'Delivery of PO', 'Full', 'All Items Collected');
        actionResult = DropOffMobileController.AddReceivingLog( receivingLogInfoNew);
        System.assert( actionResult.IsSuccess);
    }
    
    public static Account CreateAccountWithDefaults( String strName, String strType)
    {
        Account accountNew = new Account(
            Name = strName,
            Type = strType
        );
        
        return accountNew;  
    }
    
    public static Contact CreateContactWithDefaults( String strFirstName, String strLastName, String strEmail, String strHomeZip)
    {
        Contact contactNew = new Contact(
            FirstName = strFirstName,
            LastName = strLastName,
            Email = strEmail,
            MailingPostalCode = strHomeZip
        );
        
        return contactNew;  
    }
    
    public static DropOffMobileController.ContactInfo CreateContactInfoWithDefaults( String strFirstName, String strLastName, String strEmail, String strHomeZip)
    {
        DropOffMobileController.ContactInfo contactInfoNew = new DropOffMobileController.ContactInfo();
        contactInfoNew.FirstName = strFirstName;
        contactInfoNew.LastName = strLastName;
        contactInfoNew.Email = strEmail;
        contactInfoNew.HomeZip = strHomeZip;
        
        return contactInfoNew;  
    }
    
    public static Campaign CreateCampaignWithDefaults( String strRecordTypeId, String strName, String strType, String strPrimaryContactId, String strOrganizationId, Date dtStartDate, Date dtEndDate, String strSite)
    {
        Campaign campaignNew = new Campaign(
            RecordTypeId = strRecordTypeId,
            Name = strName,
            Primary_Contact__c = strPrimaryContactId,
            Primary_Organization__c = strOrganizationId,
            StartDate =dtStartDate,
            EndDate = dtEndDate,
            Site__c = strSite,
            IsActive = true
        );
        
        return campaignNew;     
    }
    
    public static DropOffMobileController.CampaignInfo CreateCampaignInfoWithDefaults( String strName, String strRecordType, String strOrganizationId, String strType)
    {
        DropOffMobileController.CampaignInfo campaignInfoNew = new DropOffMobileController.CampaignInfo();
        campaignInfoNew.Name = strName;
        campaignInfoNew.RecordType = strRecordType;
        campaignInfoNew.OrganizationId = strOrganizationId;
        campaignInfoNew.Type = strType;
        
        return campaignInfoNew;     
    }
    
    public static DropOffMobileController.ReceivingLogInfo CreateReceivingLogInfoWithDefaults( String strContactId, String strDriveId, String strPOId, String strHomeZip, String strType, String strDeliveryStatus, String strDeliveryNotes)
    {
        DropOffMobileController.ReceivingLogInfo receivingLogInfoNew = new DropOffMobileController.ReceivingLogInfo();
        receivingLogInfoNew.ContactId = strContactId;
        receivingLogInfoNew.DriveId = strDriveId;
        receivingLogInfoNew.POId = strPOId;
        receivingLogInfoNew.HomeZip = strHomeZip;
        receivingLogInfoNew.Type = strType;
        receivingLogInfoNew.DeliveryStatus = strDeliveryStatus;
        receivingLogInfoNew.DeliveryNotes = strDeliveryNotes;
        
        receivingLogInfoNew.BooksRecQty = 10.2;
        receivingLogInfoNew.BooksRecUnit = '';
        receivingLogInfoNew.BabyGearRecQty = 11.5;
        receivingLogInfoNew.BabyGearRecUnit = '';
        receivingLogInfoNew.ToysRecQty = 12;
        receivingLogInfoNew.ToysRecUnit = '';
        //receivingLogInfoNew.MixedRecQty = 15;
       // receivingLogInfoNew.MixedRecUnit = '';
        receivingLogInfoNew.SchoolAndArtSuppliesRecQty = 18;
        receivingLogInfoNew.SchoolAndArtSuppliesRecUnit = '';
        receivingLogInfoNew.ClothingRecQty = 24;
        receivingLogInfoNew.ClothingRecUnit = '';
        receivingLogInfoNew.NurseryRecQty = 21;
        receivingLogInfoNew.NurseryRecUnit = '';
        receivingLogInfoNew.SocksUnderwearRecQty = 14;
        receivingLogInfoNew.SocksUnderwearRecUnit = '';
        receivingLogInfoNew.FootwearRecQty = 20;
        receivingLogInfoNew.FootwearRecUnit = '';
        receivingLogInfoNew.OuterwearRecQty = 14;
        receivingLogInfoNew.OuterwearRecUnit = '';
        receivingLogInfoNew.PajamasRecQty = 10;
        receivingLogInfoNew.PajamasRecUnit = '';
        receivingLogInfoNew.SurpriseDrive = true;
        return receivingLogInfoNew;     
    }
    
    public static Map<String,Object> InitializeTestData()
    {
        Map<String,Object> dataMap = new Map<String,Object>();
        Date dtStartDate = System.Today();
        Date dtEndDate = dtStartDate.addDays(5);
        
        Map<String, RecordType> recordTypeByNameMap = new Map<String, RecordType>();
        for( RecordType recordType : [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Campaign'])
        {
            recordTypeByNameMap.put( recordType.Name, recordType);
        }
        
        Account accountNew = CreateAccountWithDefaults('Enzigma', 'Corporate');
        insert accountNew;
        dataMap.put('Account', accountNew);
        
        List<Contact> contactListToBeInserted = new List<Contact>();
        contactListToBeInserted.add( CreateContactWithDefaults('Sachin', 'Chavan', 'sachin.chavan@enzigma.com', '10011-1111'));
        contactListToBeInserted.add( CreateContactWithDefaults('Gogi', 'Govardhan', 'gogi.govardhan@enzigma.com', '10022-1111'));
        contactListToBeInserted.add( CreateContactWithDefaults('Chandra', 'Kiran', 'chandra.kiran@enzigma.com', '10033-1111'));
        contactListToBeInserted.add( CreateContactWithDefaults('Neeraj', 'Maheshwari', 'neeraj.maheshwari@enzigma.com', '10044-1111'));
        contactListToBeInserted.add( CreateContactWithDefaults('Alpesh', 'Bhagat', 'alpesh.bhagat@enzigma.com', '10055-1111'));
        
        insert contactListToBeInserted;
        dataMap.put('ContactList', contactListToBeInserted);
        
        List<Campaign> campaignListToBeInserted = new List<Campaign>();
        campaignListToBeInserted.add( CreateCampaignWithDefaults( recordTypeByNameMap.get('Collection Campaign').Id, '[ABC Campaign', 'Corporate', contactListToBeInserted[0].Id, accountNew.Id, dtStartDate, dtEndDate, 'Boston'));
        campaignListToBeInserted.add( CreateCampaignWithDefaults( recordTypeByNameMap.get('Collection Campaign').Id, '[EFG Campaign', 'Corporate', contactListToBeInserted[1].Id, accountNew.Id, dtStartDate, dtEndDate, 'Boston'));
        campaignListToBeInserted.add( CreateCampaignWithDefaults( recordTypeByNameMap.get('Purchase Order').Id, '[HIJ Campaign', 'Private', contactListToBeInserted[2].Id, accountNew.Id, dtStartDate, dtEndDate, 'Philadelphia'));
        campaignListToBeInserted.add( CreateCampaignWithDefaults( recordTypeByNameMap.get('Purchase Order').Id, '[KLM Campaign', 'Private', contactListToBeInserted[3].Id, accountNew.Id, dtStartDate, dtEndDate, 'Philadelphia'));
        campaignListToBeInserted.add( CreateCampaignWithDefaults( recordTypeByNameMap.get('Purchase Order').Id, '[PQR Campaign', 'Private', contactListToBeInserted[4].Id, accountNew.Id, dtStartDate, dtEndDate, 'Philadelphia'));
        
        insert campaignListToBeInserted;
        dataMap.put('CampaignList', campaignListToBeInserted);
        
        return dataMap;
    }
}