@IsTest(SeeAllData=true)
public class POS_OrderHistoryDetailController_Test{
	
	static testmethod void testOrderHistoryDetail () {
		Profile p = [select id from profile where name='POS - API User Agency'];
         
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
			
			Ship_To__c shipTo = POS_TestDataUtil.createShipTo();
			
			Program__c pg = POS_TestDataUtil.createProgram();
			
			System.debug('Setup complete, adding items');
			
			Test.startTest();
			
			Item__c item = POS_TestDataUtil.createItem(pg);
			Cart_Item__c cartItem = new Cart_Item__c();
			cartItem.Item__c = item.Id;
			cartItem.Cart__c = cart.Id;
			cartItem.Quantity__c = 10;
			cartItem.Ship_To__c = shipTo.Id;
			cartItem.Status__c = 'Shipped';
			insert cartItem;
			
			System.debug('Adding Item 2');
			
			Ship_To__c shipTo2 = POS_TestDataUtil.createShipTo();
			//Create second item
			Item__c item2 = POS_TestDataUtil.createItem(pg);
			Cart_Item__c cartItem2 = new Cart_Item__c();
			cartItem2.Item__c = item2.Id;
			cartItem2.Cart__c = cart.Id;
			cartItem2.Quantity__c = 10;
			cartItem2.Ship_To__c = shipTo2.Id;
			cartItem2.Status__c = 'Processing';
			insert cartItem2;
			
			Apexpages.currentPage().getParameters().put('id',cart.Id);
			POS_OrderHistoryDetailController controller = new POS_OrderHistoryDetailController();
			System.assert(controller.lineItemsToDisplay.size()==2);
			
			//Now go back and forth in the results to confirm that works.  Since we only have 
			//Two shiptos, it's really just going from 2 to 0 and back
			controller.nextOrders();
			System.assert(controller.lineItemsToDisplay.size()==0);
			
			controller.previousOrders();
			System.assert(controller.lineItemsToDisplay.size()==2);
			
			Test.stopTest();
		}
	}
}