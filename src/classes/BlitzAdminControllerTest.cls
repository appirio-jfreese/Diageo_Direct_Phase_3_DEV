@isTest(SeeAllData=false)
private class BlitzAdminControllerTest {

    static testMethod void testMassArchival() {    	
    	Test.startTest();
        
    	User activeUser = new User(alias = 'unittest', email='unittestActive@modelmetrics.com', 
	        emailencodingkey='UTF-8', lastname='Testing', 
	        languagelocalekey='en_US', 
	        localesidkey='en_US', profileid = UserInfo.getProfileId(),
	        timezonesidkey='America/Chicago',
            Available_Themes__c = 'Spirits',
	        username='unittestActive@modelmetrics.com');
	    insert activeUser;
		
    	User inactiveUser = new User(alias = 'unittest', email='unittestInActive@modelmetrics.com', 
	        emailencodingkey='UTF-8', lastname='Testing', 
	        languagelocalekey='en_US', 
	        localesidkey='en_US', profileid = UserInfo.getProfileId(),
	        timezonesidkey='America/Chicago',
            Available_Themes__c = 'Spirits',
            isActive = false,
	        username='unittestInActive@modelmetrics.com');
	    insert inactiveUser;
		
    	Account acc = new Account();
    	acc.Name = 'Test Account';
        acc.OwnerId = activeUser.Id;
    	insert acc;
    	
    	Blitz__c blitz = new Blitz__c();
    	blitz.Account__c = acc.Id;
    	blitz.OwnerId = activeUser.Id;
    	blitz.Amount__c = 27;
    	blitz.Blitz_Brand__c = 'brand';
    	blitz.Blitz_Details__c = 'details';
    	blitz.Blitz_Program__c = 'program';
    	blitz.Comments__c = 'comments';
    	blitz.Date_Finished__c = Date.today().addDays(7);
    	blitz.PDF_Link__c = 'http://google.com';
    	insert blitz;
    	
    	List<Blitz__c> allBlitzes = [SELECT Id FROM Blitz__c];
    	List<Blitz_History__c> allHistories = [SELECT Id FROM Blitz_History__c];
    	
    	BlitzAdminController cont = new BlitzAdminController();
    	System.assertEquals(allBlitzes.size(), cont.activeCount);
        cont.doMassArchival();

        Test.stopTest();
    }
}