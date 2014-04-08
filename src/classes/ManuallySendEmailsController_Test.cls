/**************************************************************************************
Name        : ManuallySendEmailsController_Test 
Created By  : Appirio Offshore(Siddharth Varshneya)   
Date        : 19th Nov, 2013
Purpose     : Test class for 
                - ManuallySendEmailsController.cls
***************************************************************************************/
@isTest
private class ManuallySendEmailsController_Test {

    //variable declaration
    static Contact contact;
    static User user;
    static Lead lead;
    
    static {
        //creating a account
        contact = new Contact(Email='siddharth.varshneya@appirio.com' , LastName = 'Varshneya', Phone = '9898784545');
        insert contact;
       /* user = new User(Email='siddharth.varshneya@appirio.com' , LastName = 'Varshneya' , Username = 'siddharth.varshneya@appirio.com' , 
        			Phone = '9898784545' , LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1' , Alias = 'guest' , CommunityNickName = 'sv', 
        			TimeZoneSidKey = 'GMT' , LanguageLocaleKey = 'en_US' , ProfileId = '00eA0000000yaRDIAY' , ContactId = contact.Id);
        insert user;*/
        lead = new Lead(Email='siddharth.varshneya@appirio.com' , Phone = '9898784545' , LastName = 'Varshneya' , Company = 'sv');
        insert lead;
        
    } 
    
    //Test function "validateEmail" of ManuallySendEmailsController
    public static TestMethod void testValidateEmail() {
        Test.startTest();
		ManuallySendEmailsController obj =new ManuallySendEmailsController();
		obj.tempContact.Email = 'siddharth.varshneya@appirio.com';
		obj.validateEmail();
		obj.sendMail();
		
		obj =new ManuallySendEmailsController();
		obj.tempContact.Email = 'siddharth.varshneya@metacube.com';
		obj.validateEmail();
		obj.sendMail();
		System.assertEquals('siddharth.varshneya@metacube.com', obj.tempContact.Email);
		
		obj =new ManuallySendEmailsController();
		obj.tempContact.Email = 'siddhartcom';
		obj.validateEmail();
		obj.sendMail();
		
        Test.stopTest();
    }
}