@IsTest(SeeAllData=true)
public class POS_OrderTimelineController_Test{

	static testmethod void testOrderTimeline () {
		Profile p = [select id from profile where name='System Administrator'];
         
		User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
		localesidkey='en_US', profileid = p.Id,
		timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
        Available_Themes__c='Spirits');
		
		System.runAs(u) {
			PageReference pageRef = Page.HomePage;
        	Test.setCurrentPage(pageRef);
        	
			Order_Window__c ow = POS_TestDataUtil.createOrderWindow();
			
			Order_Window_Customer__c owc = new Order_Window_Customer__c();
			owc.Customer__c = u.Id;
			owc.Order_Window__c = ow.Id;
			insert owc;
			
			Cart__c cart = POS_TestDataUtil.createCart(u, ow);
			cart.Status__c = 'Submitted';
			update cart;
			
			POS_OrderTimelineController controller = new POS_OrderTimelineController();
			System.assert(controller.orderWindowCustomers.size()==1);
			
		}
	}
	
}