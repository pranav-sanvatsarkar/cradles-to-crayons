@isTest
private class ScreenStepsLiveRemoteLoginControllerTest {
    static testmethod void testSSLiveRemoteAuthToken() {
        ScreenStepsLiveRemoteLoginController test = new ScreenStepsLiveRemoteLoginController();
        System.assert(test.md5String != '');
    }
}