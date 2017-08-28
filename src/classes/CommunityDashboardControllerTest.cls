@isTest
public class CommunityDashboardControllerTest {
    static testMethod void verifyRedirectToLogin(){ 
        CommunityDashboardController.redirectToLogin();
    }
    static testMethod void verifyCommunityDashboardController(){
        Portal_Configuration__c testPortal = C2CTestHelper.getPortalConfiguration();
		C2CTestHelper.InsertWithAssert(testPortal);
        CommunityDashboardController community = new CommunityDashboardController();
    }
    static testMethod void verifySearchOrder(){
       
        Partner_Order__c partnerOrderObj = new Partner_Order__c(); 
        partnerOrderObj.Child_First_Name__c = 'test first name';
        partnerOrderObj.Child_Last_Name__c = 'test last name';
       	List<Partner_Order__c> lstPartnerOrder  = new List<Partner_Order__c>();
        lstPartnerOrder.add(partnerOrderObj);
        
        partnerOrderObj = C2CTestHelper.getKidpackOreder(); 
        partnerOrderObj.IsBulkOrder__c = true;
        lstPartnerOrder.add(partnerOrderObj);
       
        partnerOrderObj = C2CTestHelper.getKidpackOreder(); 
        partnerOrderObj.Status__c = 'Test Status';
        lstPartnerOrder.add(partnerOrderObj);
        
        lstPartnerOrder.add(C2CTestHelper.getSpecialityOreder());
        
        lstPartnerOrder.add(C2CTestHelper.getKidpackOreder());
        for(Integer i= 0;i<50;i++){
            lstPartnerOrder.add(new Partner_Order__c(Child_First_Name__c = 'test first name'));
        }
        
        Integer beforeInsertSize = lstPartnerOrder.size();
        insert lstPartnerOrder;
        
        system.assertEquals(beforeInsertSize, lstPartnerOrder.size());
		ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lstPartnerOrder);
        
       CommunityDashboardController community = new CommunityDashboardController();
       community.key = 'test';
       community.searchOrder(); 
       community.refreshTable();   
    }
    static testMethod void verifyDeleteOrder(){
        
        Partner_Order__c partnerOrderObj = new Partner_Order__c(); 
        partnerOrderObj.Child_First_Name__c = 'test first name';
        partnerOrderObj.Child_Last_Name__c = 'test last name';
        insert partnerOrderObj; 
        
        PageReference myVfPage = Page.CommunityDashboard; 
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
        ApexPages.currentPage().getParameters().put('firstParam',partnerOrderObj.Id);
        
        CommunityDashboardController community = new CommunityDashboardController();
        community.DeleteOrder();
        List<Partner_Order__c> lstPartnerOrder = [select id from Partner_Order__c where id=:partnerOrderObj.Id limit 1];
        system.assertEquals(0,lstPartnerOrder.size());
        
     }
    static testMethod void verifyPagination(){
       CommunityDashboardController community = new CommunityDashboardController();
       community.first();
       community.next();
       community.last();
       community.previous();
       community.getItems();
       community.ItemsPerPage();
         
       community.PageNumber =2 ;
       community.TotalPages =5;
       community.Paginate();
        
       community.PageNumber =1 ;
       community.TotalPages =1;
       community.Paginate();
       System.assert(community.isEnableFirst && community.isEnableLast && community.isEnablePrevious && community.isEnableNext); 
        
       community.PageNumber =2 ;
       community.TotalPages =2;
       community.Paginate();
       System.assert(!community.isEnableFirst && community.isEnableLast && !community.isEnablePrevious && community.isEnableNext); 
        
    }
}