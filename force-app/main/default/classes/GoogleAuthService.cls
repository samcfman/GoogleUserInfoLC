public class GoogleAuthService {
    //API Secret Key
    private static string key = 'XXXXXXXXX';
    //API Secret
    private Static string secert = 'XXXXXXXXX';
    //API Redirect. Use your Lightning Tab or Lightning community URL
    private Static string redirect_uri = 'https://sfdx1-demo-developer-edition.ap17.force.com/customer/s/';
    private static string authUrl='https://accounts.google.com/o/oauth2/auth';
    //Scope of API. It will be API for which you are authenticate 
   // private static string scope='https://www.googleapis.com/auth/fitness.activity.read';
   private static string scope='https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email'; 
    
   
    //Token genetion API URL
    private static string tokenUrl='https://accounts.google.com/o/oauth2/token';
    
    @AuraEnabled
    public static String createAuthURL() {
        String key = EncodingUtil.urlEncode(key,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = authUrl+'?'+
            'client_id='+key+
            '&response_type=code'+
            '&scope='+scope+
            '&redirect_uri='+uri+
            '&access_type=offline';
        return authuri;
    }
    
    @AuraEnabled
    public static string getAccessToken(String code)
    {
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(tokenUrl);
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        
        String messageBody ='code='+code+'&client_id='+key+
            '&client_secret='+secert+
            '&redirect_uri='+redirect_uri+
            '&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);
        
        Http callout = new Http();
        String responseText;
        HttpResponse response = callout.send(req);
        responseText = response.getBody();
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText) ;  
        String token =  String.valueOf(responseMap.get('access_token'));
        system.debug('token:'+token);
        
        //Update token in custom metadata. You can also use Cache or any custom Object 
        //I have used custome metadat for demo purpose.
       // MetadataService.UpdateCustomMetadata(token);
        //return true;
        return token;
    }


    @AuraEnabled
    public static string getUserInfo(String accessCode)
    {
        
        Http http = new Http();
        String responseText;
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.googleapis.com/oauth2/v1/userinfo?alt=json');
        request.setMethod('GET');

        String authorizationHeader = 'Bearer ' + accessCode;
        system.debug(authorizationHeader);
        request.setHeader('Authorization', authorizationHeader );
        // Set the body as a JSON object
 
        HttpResponse response = http.send(request);
     

        responseText = response.getBody();
        
       // system.debug(responseText);
   //     Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText) ;  
     //   String given_name =  String.valueOf(responseMap.get('given_name'));        
      //  system.debug(given_name);
        return responseText;
    }    
    
}