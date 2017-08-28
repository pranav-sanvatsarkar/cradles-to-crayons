public class SecureLogin {
    public SecureLogin (CommunityDashboardController dashboard){
        redirectToLogin();
    }
    public static PageReference redirectToLogin(){
        if(UserInfo.getUserType() == 'Guest')
            return Network.communitiesLanding();
        else
            return null;
    }
}