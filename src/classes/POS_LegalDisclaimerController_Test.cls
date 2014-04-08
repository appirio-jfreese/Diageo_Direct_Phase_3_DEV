@IsTest(SeeAllData=false)
public class POS_LegalDisclaimerController_Test{
   
	static testmethod void testController() {
       
       // Insert LegalDisclaimer MessageRecord
       Legal_Disclaimer__c ld = new Legal_Disclaimer__c(Message__c='Test DL Message', Alternative_Message__c='Test Alt Message');
       insert ld;
       
       //Use the PageReference Apex class to instantiate a page
       PageReference pageRef = Page.POS_LegalDisclaimer;
       Test.setCurrentPage(pageRef);
     
       //Check that the agree() method returns the proper URL.
       POS_LegalDisclaimerController controller = new POS_LegalDisclaimerController();
       String nextPage = controller.agree().getUrl();

       System.assertEquals('/apex/pos_orderwindowview', nextPage);

       //Check that the disagree() method returns the proper URL.
       controller = new POS_LegalDisclaimerController();
       nextPage = controller.disagree().getUrl();

       System.assertEquals('/apex/homepage', nextPage);
   }

}