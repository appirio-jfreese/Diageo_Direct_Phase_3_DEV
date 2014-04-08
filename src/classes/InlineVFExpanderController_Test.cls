@IsTest(SeeAllData=false)
public class InlineVFExpanderController_Test{
    
    public static testMethod void testMyController() {
        String testPageName = 'MyCustomPage';
        String testPageID = '066123456789012';
        InlineVFExpander_Pages__c customVFPage = new InlineVFExpander_Pages__c();
        customVFPage.name = testPageName;
        customVFPage.Page_Id__c = testPageID;
        insert customVFPage;
        
        PageReference pageRef = Page.InlineVFExpander;
        Test.setCurrentPage(pageRef);
      
        InlineVFExpanderController controller = new InlineVFExpanderController();
        List<String> pages = controller.inlineVFPages;
        for (String pageID : pages)
        {
            if (pageID == testPageID)
            {
                System.assertEquals(testPageID,pageID,'Test page ID not found');
                return;
            }
        }
        System.assert(false, 'Test page ID not found');
    }
}