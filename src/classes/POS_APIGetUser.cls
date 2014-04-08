@RestResource(urlMapping='/GetUser/*')
global with sharing class POS_APIGetUser {

	
 	@HttpGet
    global static User doGet () { 
    	RestRequest req = RestContext.request; 
        RestResponse res = RestContext.response;	

		String SFDCId = req.params.get('UserId');

    	User user = [select Id, FirstName, LastName, Email, Contact.Account.Name, Phone from User where Id = :SFDCId];
    
    	return user;

    }
}