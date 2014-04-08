/**************************************************************************************
Name        : Test_NACExistingRecipientsController 
Created By  : Appirio Offshore(Siddharth Varshneya)   
Date        : 1/3/1014
Purpose     : Test class for 
                - NACExistingRecipientsController.cls
***************************************************************************************/
@isTest
private class Test_NACExistingRecipientsController {

    //Test function "populateData" of constructor
    public static TestMethod void testPopulateData() {
        Test.startTest();
        NACExistingRecipientsController obj = new NACExistingRecipientsController();
        System.assertEquals(obj.oid, UserInfo.getOrganizationId());
        
        Test.stopTest();
    }
}