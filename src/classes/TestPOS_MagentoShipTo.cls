@isTest
private class TestPOS_MagentoShipTo {
	public static void createTestData(){
		POS_Magento_Configuration__c settings = Test_Helper.createPOSMagentoConfigSettings();
	   // Test_Helper.testInsertAccount('testaccount');
		//insert tAcc;
		
		Ship_To__c shpTO = new Ship_To__c();
		shpTO.Name = 'test';
		shpTO.Account__c = Test_Helper.testInsertAccount('testaccount').id;
		shpTo.Address_Type__c = 'Residential';
		shpTo.Attention__c = 'test';
		shpTo.Street__c = 'test street';
		shpTo.City__c = 'test city';
		shpTo.State__c = 'test state';
		shpTo.Phone__c = '22221111';
		shpTo.Zip__c = '22222';
		insert shpTo;
		
		List<User_Ship_To__c> lstusrShips = new List<User_Ship_To__c>();
		User_Ship_To__c usrShip = new User_Ship_To__c();
		usrShip.User__c = userInfo.getUserId();
		usrShip.Ship_To__c = shpTo.Id;
		usrShip.Magento_Ship_To_ID__c = '123';
		lstusrShips.add(usrShip);
		
		User_Ship_To__c usrShip1 = new User_Ship_To__c();
		usrShip1.User__c = userInfo.getUserId();
		usrShip1.Ship_To__c = shpTo.Id;
		usrShip.Magento_Ship_To_ID__c = '124';
		lstusrShips.add(usrShip1);
		insert lstusrShips;
	}
	
    static testMethod void testPOSMagentoShipTo() {
    	createTestData();
    	Test.startTest();
    	List <User_Ship_To__c> usrShipTO = [SELECT Id, Ship_To__c, Ship_To__r.attention__c,  Ship_To__r.city__c, Magento_Ship_To_ID__c,
    										 Ship_To__r.street__c,  Ship_To__r.phone__c,  Ship_To__r.zip__c, Ship_To__r.state__c,
    										 Ship_to__r.Account__r.Name, Ship_To__r.Name
    										FROM User_Ship_To__c ];
      //  POS_MagentoShipTo.deleteMagentoShipTo('abc');
       // POS_MagentoShipTo.deleteMagentoShipTos(usrShipTO);
       // POS_MagentoShipTo.getUpdateApiArgs(usrShipTO);
       // POS_MagentoShipTo.updateMagentoShipTos(usrShipTO);
     //   POS_MagentoShipTo.handleEmptyValues(usrShipTO);
      //  POS_MagentoShipTo.updateMagentoShipTos(usrShipTO);
        POS_MagentoShipTo.insertMagentoShipTo(userInfo.getUserId() ,' attention', 
	  											' phone', 'zip', ' state',' city',' street', 
	  											' name',  'testaccount',usrShipTO.get(0).Id );
        system.assertEquals(usrShipTO.size(), 2);
        
        POS_MagentoShipTo.updateMagentoShipTo(usrShipTO[0]);
        POS_MagentoShipTo.updateMagentoShipTos(usrShipTO);
        POS_MagentoShipTo.deleteMagentoShipTo('abc');
        POS_MagentoShipTo.deleteMagentoShipTos(usrShipTO);
        Test.stopTest();
        
    }
}