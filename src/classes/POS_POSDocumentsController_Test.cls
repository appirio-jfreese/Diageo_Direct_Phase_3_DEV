@IsTest(SeeAllData=true)
public class POS_POSDocumentsController_Test{
    
    static testmethod void testOnDemandController () {
        Test.startTest();
        
        PageReference currPage = new PageReference('/apex/POS_POSDocuments');
        Test.setCurrentPage(currPage);
            
        POS_POSDocumentsController cont = new POS_POSDocumentsController();
        
        Test.stopTest();
    }
}