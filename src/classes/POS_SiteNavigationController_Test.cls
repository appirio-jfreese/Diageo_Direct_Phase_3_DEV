@isTest
public class POS_SiteNavigationController_Test {
    static testmethod void testNav () {
        POS_TestDataUtil.initializeTestData();
        PageReference pageRef = Page.HomePage;
        Test.setCurrentPage(pageRef);
        POS_SiteNavigationController controller = new POS_SiteNavigationController();
    }
}