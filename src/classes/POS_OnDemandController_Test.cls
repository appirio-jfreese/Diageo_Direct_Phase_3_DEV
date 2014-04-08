@IsTest(SeeAllData=false)
public class POS_OnDemandController_Test{
	
    static testmethod void testOnDemandController () {
    	Test.startTest();
    	
    	PageReference currPage = new PageReference('/apex/POS_OnDemand');
		Test.setCurrentPage(currPage);
			
    	POS_OnDemandController cont = new POS_OnDemandController();
    	
    	Test.stopTest();
    }
}