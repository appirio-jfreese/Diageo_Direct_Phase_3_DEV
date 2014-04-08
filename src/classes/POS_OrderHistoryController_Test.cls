@IsTest(SeeAllData=false)
public class POS_OrderHistoryController_Test{
	
	static testmethod void testOrderHistory () {
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
			
			POS_OrderHistoryController controller = new POS_OrderHistoryController();
			System.assert(controller.orderWindowCustomers.size()==1);
			
			controller.previousYear();
			System.assert(controller.orderWindowCustomers.size()==0);  //No windows in previous year
			controller.nextYear();
			System.assert(controller.orderWindowCustomers.size()==1);  //Back to current year so should see that record
			
			controller.filterValue='Quarterly';
			controller.filterList();
			System.assert(controller.orderWindowCustomers.size()==0); //Test window is monthly so shouldn't see it now
			
		}
	}
	
}