@isTest
private class GlobalResourcesTest {
	static testMethod void GlobalResourcesTest() {
        GlobalResources newGlobalResources = new  GlobalResources();        
        newGlobalResources.Application_JS_List = '';
        newGlobalResources.Application_JS_Files = new String[]{};
        newGlobalResources.Application_CSS_List = '';
        newGlobalResources.Application_CSS_Files = new String[]{};
        newGlobalResources.Vendor_JS_List = '';
        newGlobalResources.Vendor_JS_Files = new String[]{};
        newGlobalResources.Vendor_CSS_List = '';
        newGlobalResources.Vendor_CSS_Files = new String[]{};
    }
}