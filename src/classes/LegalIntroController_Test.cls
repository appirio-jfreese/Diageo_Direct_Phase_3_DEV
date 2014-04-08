@isTest(SeeAllData=false)
public class LegalIntroController_Test{
    static testmethod void testController() {
        PageReference pageRef = Page.HomePage;
        Test.setCurrentPage(pageRef);
        LegalIntroController l = new LegalIntroController();
        
    }
}