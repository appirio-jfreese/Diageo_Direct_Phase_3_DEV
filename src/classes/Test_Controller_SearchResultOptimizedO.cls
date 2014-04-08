@isTest
private class Test_Controller_SearchResultOptimizedO {
    static User u; 
    
    static testmethod void testControllerForResponsive(){
        PageReference pageRef = Page.R_SearchResult;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        createTestData();
        ApexPages.currentPage().getParameters().put('query', 'test');

        System.runAs(u){
            Controller_SearchResultOptimized controller = new Controller_SearchResultOptimized();

            controller.R_OrdertByDate = 'ASC';

            controller.getSortingoptions();
            controller.userResearch();
       }   

        Test.StopTest();
    }
    
    static void createTestData(){
        //Account diageo = Test_Helper.testInsertAccount('DIAGEO');
        Account a = Test_Helper.testInsertAccount('DIAGEO');
        for(Id recId : Service_API.getAccountRecordTypeIds()){
            a.RecordTypeId = recId;
            break;
        }
        update a;
        Contact c = Test_Helper.testInsertContact('TestFirst', 'TestLast', a.ID);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        System.runAs (thisUser) {
            u = Test_Helper.testInsertDistributorPortalUser(c.ID);
        }
                
        Brand__c testBrand1 = Test_Helper.testInsertBrand('Test Brand1');
        Brand__c testBrand2 = Test_Helper.testInsertBrand('Test Brand2');
        
        Test_Helper.testInsertAccountBrand(a.ID, testBrand1.ID);
        Test_Helper.testInsertAccountBrand(a.ID, testBrand2.ID);     
    }
}