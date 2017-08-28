public class ScreenStepsLiveRemoteLoginController {
    public string md5String {get;set;}
    private string ssliveToken = '72f977790465d4e71e8b631b1b62fe';

    public ScreenStepsLiveRemoteLoginController () {
        // UserInfo does not expose the email address
        String theUserName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : theUserName limit 1];
        String theEmail = activeUser.Email;
        String theOrgName = ''; //UserInfo.getOrganizationName(); (not available in apex page)
        String theReturnToURL = ApexPages.CurrentPage().getParameters().get('return_to_url');
        String theTimeStamp = ApexPages.CurrentPage().getParameters().get('timestamp');
        String theStringToHash = UserInfo.getFirstName() + UserInfo.getLastName() + 
        theEmail + UserInfo.getUserId() + theOrgName + 
        this.ssliveToken + theTimeStamp;
        Blob keyblob = Blob.valueof(theStringToHash);
        Blob key = Crypto.generateDigest('MD5',keyblob);
        md5String = encodingUtil.convertToHex(key);
    }
}