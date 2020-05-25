({
    doInit : function(component, event, helper) {
    	 var myPageRef = component.get("v.pageReference");
    	// var code = myPageRef.state.code;
  //  cmp.set("v.oppId", opportunityId);       
       	var url = window.location.href;
        function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, '\\$&');
            var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                results = regex.exec(url);
            console.log('===results==',results);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        }
        var code = getParameterByName('code',url);
      //  alert (code);
        if(code !== undefined && code!=='' && code!==null) {
            var action = component.get('c.getAccessToken');
            action.setParams({
                'code' : code
            });
            action.setCallback(this, function(response){
                var status = response.getState();
                //alert (status);
               	if(status === "SUCCESS"){
                //    alert (success);
                    var accessToken = response.getReturnValue();
               /*     if (accessToken) {
                        component.set("v.access", "Authenticated")
                    } else {
                        component.set("v.access", "Not Authenticated")
                    }
                 */   
               //     alert (accessToken);
                    component.set("v.accessToken", accessToken);
                    component.set("v.access", accessToken==true?'Authenticated..':'Not Authenticated..');
                }
            });
            
            $A.enqueueAction(action);
        }
    },
    doAuth : function(component, event, helper) {
        var action  = component.get("c.createAuthURL");
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var authUrl = response.getReturnValue();
                window.location.href = response.getReturnValue();
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    doGetUserInfo : function(component, event, helper) {
       // alert ('click');
        var accessCode = component.get ("v.accessToken");
     //   alert (accessCode);
        var action  = component.get("c.getUserInfo");
            action.setParams({
                'accessCode' : accessCode
            });        
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var response = response.getReturnValue();
                
          		var responseObj = JSON.parse(response);
          //this.SPOUSE_FIELD = responseObj.spouse;
         // this.ADDRESS_FIELD = responseObj.mailingAddress;                
    			component.set("v.fullName", responseObj.name);
                component.set("v.email", responseObj.email);
                component.set("v.pictureurl", responseObj.picture);
                component.set("v.locale", responseObj.locale);
                component.set("v.userInfo", response);
                //window.location.href = response.getReturnValue();
            }
        });
        
        $A.enqueueAction(action);
    }    
})