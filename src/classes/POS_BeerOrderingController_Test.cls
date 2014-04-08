@isTest(SeeAllData=false)
public class POS_BeerOrderingController_Test {
	
    static testmethod void testPOSBeerOrdering() {
    	Test.startTest();
    	
    	PageReference currPage = new PageReference('/apex/POS_BeerOrdering');
			Test.setCurrentPage(currPage);
			
    	POS_BeerOrderingController cont = new POS_BeerOrderingController();
    	
    	Test.stopTest();
    }
}