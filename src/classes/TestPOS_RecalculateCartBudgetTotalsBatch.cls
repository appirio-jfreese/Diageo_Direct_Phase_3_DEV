@isTest
private class TestPOS_RecalculateCartBudgetTotalsBatch {
	// Create test data
	public static void createTestData(){
		Order_Window__c oWin = new Order_Window__c();
		oWin.Name = 'abc';
		oWin.Type__c = 'OnDemand';
		oWin.Status__c = 'open';
		//oWin.On_Demand_Site_URL__c = 'abc@gmail.com' ;
		insert oWin;
		
		Cart__c cart = new Cart__c();
		cart.Shopper__c = userinfo.getUserId();
		cart.Status__c = 'Submitted';
		cart.Order_Window__c = oWin.Id;
		insert cart;
		Cart__c cart1 = new Cart__c();
		cart1.Shopper__c = userinfo.getUserId();
		cart1.Status__c = 'Processing';
		cart1.Order_Window__c = oWin.Id;
		insert cart1;
	
	
	}

    static testMethod void testPOS_RecalculateCartBudgetTotalsBatch() {
    	createTestData();
    	Test.startTest();
    	List<Cart__c> c = [select id from Cart__c];
   		POS_RecalculateCartBudgetTotalsBatch pos = new POS_RecalculateCartBudgetTotalsBatch(c);
    	Database.executeBatch(pos);
    	System.assertEquals(c.size(), 2);
    	Test.stopTest();
    	
    }
}