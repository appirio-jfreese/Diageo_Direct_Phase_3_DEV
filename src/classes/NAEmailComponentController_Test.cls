/**************************************************************************************
Name        : NAEmailComponentController_Test 
Created By  : Appirio Offshore(Siddharth Varshneya)   
Date        : 20th Nov, 2013
Purpose     : Test class for 
                - NAEmailComponentController.cls
***************************************************************************************/
@isTest
private class NAEmailComponentController_Test {

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
        insert user;
        lead = new Lead(Email='siddharth.varshneya@appirio.com' , Phone = '9898784545' , LastName = 'Varshneya' , Company = 'sv');
        insert lead;    */
        
    } 
    
    //Test function "populateData" of NAEmailComponentController
    public static TestMethod void testPopulateData() {
        Test.startTest();
        Calendar__c cal = Test_RecordUtil.newCalendar('test cal','Distribution');
        cal.Text_Color__c = '000000';
        cal.background_color__c = 'B9B8B8';
        cal.background_color2__c = 'B9B8B8';
        insert cal;
        NAEmailComponentController obj=new NAEmailComponentController();
        obj.Cid = cal.Id;
        obj.contactId = contact.Id;
        obj.populateData();
         System.assertEquals(obj.Cid, cal.Id);
          obj=new NAEmailComponentController();
        obj.populateData();
       
        
        Test.stopTest();
    }
}