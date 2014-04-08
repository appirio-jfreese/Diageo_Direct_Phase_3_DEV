@isTest
private class Test_Controller_AccountBrand {
	 
	 static testMethod void testController() {	 	

        Account account = Test_Helper.testInsertAccount('test_account');
        Contact contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
        User user;
        User user2;
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];   
        System.runAs (thisUser) {
        	user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        }

        Account account2 = Test_Helper.testInsertAccount('test_account2');
        Contact contact2 = Test_Helper.testInsertContact('firstName2', 'lastName2', account2.id);
        System.runAs (thisUser) {
        	user2 = Test_Helper.testInsertDistributorPortalUser(contact2.id);
        }
        
        List<Brand__c> lstBrands = new List<Brand__c>();
		Brand__c brandFirst 	 = Test_Helper.testCreateBrand('smirnoff', false) ;    		
		Brand__c brandSecond	 = Test_Helper.testCreateBrand('smirnoff ice', false); 	
		Brand__c brandThird 	 = Test_Helper.testCreateBrand('Johnnie Walker Black', false);
		Brand__c brandFourth  	 = Test_Helper.testCreateBrand('Johnnie Walker Blue', false);
		Brand__c brandFive  	 = Test_Helper.testCreateBrand('Johnnie Walker Gold', false);		
		lstBrands.add(brandFirst);
		lstBrands.add(brandSecond);
		lstBrands.add(brandThird);
		lstBrands.add(brandFourth);
		lstBrands.add(brandFive);
		insert lstBrands;
		
		AccountBrand__c acountBra = Test_Helper.testInsertAccountBrand(account.Id, brandFirst.Id);	
		AccountBrand__c accountBra2 = Test_Helper.testInsertAccountBrand(account2.Id, brandFive.Id);	
						
		
		List<AccountBrand__c> lac = new List<AccountBrand__c>();
		lac.add(acountBra);
		
		ApexPages.currentPage().getParameters().put('id', account.id);
		
		ApexPages.StandardSetController sc = new ApexPages.standardSetController(lac);		
		Controller_AccountBrand controller =  new Controller_AccountBrand(sc);		
		
		controller.populateAccountBrands();
		controller.populateBrands();
		
		System.assertequals(1, (controller.pageUtilAccBrand.setCtrl).getResultSize());		
		
		AccountBrand__c accountBraThird = Test_Helper.testInsertAccountBrand(controller.AccountId, brandThird.Id);
		AccountBrand__c accountBraFourth = Test_Helper.testInsertAccountBrand(controller.AccountId, brandFourth.Id);	
				
		controller.populateAccountBrands();
		controller.populateBrands();
		System.assertequals(3, (controller.pageUtilAccBrand.setCtrl).getResultSize());
				
		controller.pageUtilAccBrand.searchStr = 'Johnnie';
		controller.pageUtilAccBrand.brand.Classification__c	= 'Spirits';
		controller.pageUtilAccBrand.brand.Brand_Type__c = 'Individual';
		controller.pageUtilAccBrand.brand.Diageo_direct_visible__c = true;		
		controller.populateAccountBrands();	
	
		controller.pageUtilBrand.searchStr = 'Johnnie';
		controller.pageUtilBrand.brand.Classification__c	= 'Spirits';
		controller.pageUtilBrand.brand.Brand_Type__c = 'Individual';
		controller.pageUtilBrand.brand.Diageo_direct_visible__c = true;
		controller.populateBrands();
		
		controller.pageUtilAccBrand.searchStr = '';
		controller.pageUtilAccBrand.brand.Classification__c	= '';
		controller.pageUtilAccBrand.brand.Brand_Type__c = '';
		controller.pageUtilAccBrand.brand.Diageo_direct_visible__c = false;
		controller.pageUtilBrand.searchStr = '';
		controller.pageUtilBrand.brand.Classification__c	= '';
		controller.pageUtilBrand.brand.Brand_Type__c = '';
		controller.pageUtilBrand.brand.Diageo_direct_visible__c = false;
		controller.populateAccountBrands();	
		controller.populateBrands();
				
		controller.brandList[0].selected = true;
		controller.addRelations();
		controller.populateAccountBrands();	
		System.assertequals(4, (controller.pageUtilAccBrand.setCtrl).getResultSize());
		
		controller.accountBrandList[0].selected = true;
		controller.deleteRelations();
		controller.populateAccountBrands();	
		System.assertequals(3, (controller.pageUtilAccBrand.setCtrl).getResultSize());
		
		controller.nextB();
		controller.previousB();
		controller.lastB();
		controller.firstB();
		Integer a = controller.totalPagesB;	
		
		controller.next(); 
		controller.previous();
		controller.last();
		controller.first();
		Integer e = controller.totalPages;
		
		Boolean i = controller.accountEditable;
	
		controller.doSortAccBrands();
		controller.doSortBrands();
		controller.addAll();
		controller.deleteAll();
		controller.cloneAccount = accountBraThird.id;
		controller.cloneRelationsFrom();
		controller.cloneRelationsTo();
		
		ApexPages.StandardController screl = new ApexPages.standardController(acountBra);	
		Apexpages.currentpage().getparameters().put('retURL', '/001');
		Controller_AccountBrandRelationEdit controllerrel =  new Controller_AccountBrandRelationEdit(screl);
		controllerrel.redirect();
		Apexpages.currentpage().getparameters().put('retURL', '/'+acountBra.Id);
		controllerrel.redirect();		
	 }
	 
	 /*static testMethod void testControllerEdit() {	 	

        Account account = Test_Helper.testInsertAccount('test_account');
        Contact contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
        User user;
        User user2;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];   
        System.runAs (thisUser) {
        	user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        }

        Account account2 = Test_Helper.testInsertAccount('test_account2');
        Contact contact2 = Test_Helper.testInsertContact('firstName2', 'lastName2', account2.id);
        System.runAs (thisUser) {
        	user2 = Test_Helper.testInsertDistributorPortalUser(contact2.id);
        }

		Brand__c brandFirst 	 = Test_Helper.testInsertBrand('smirnoff') ;    		
		Brand__c brandSecond	 = Test_Helper.testInsertBrand('smirnoff ice'); 	
		Brand__c brandThird 	 = Test_Helper.testInsertBrand('Johnnie Walker Black');
		Brand__c brandFourth  	 = Test_Helper.testInsertBrand('Johnnie Walker Blue');
		Brand__c brandFive  	 = Test_Helper.testInsertBrand('Johnnie Walker Gold');		
		
		AccountBrand__c acountBra = Test_Helper.testInsertAccountBrand(account.Id, brandFirst.Id);	
		AccountBrand__c accountBra2 = Test_Helper.testInsertAccountBrand(account2.Id, brandFive.Id);	
		
		ApexPages.StandardController sc = new ApexPages.standardController(acountBra);		
		Controller_AccountBrandEdit controller =  new Controller_AccountBrandEdit(sc);		
		
		controller.reloadLists();
		
		System.assertequals(1, (controller.setCtrl).getResultSize());		
		
		AccountBrand__c accountBraThird = Test_Helper.testInsertAccountBrand(controller.AccountId, brandThird.Id);
		AccountBrand__c accountBraFourth = Test_Helper.testInsertAccountBrand(controller.AccountId, brandFourth.Id);	
				
		controller.reloadLists();
		System.assertequals(3, (controller.setCtrl).getResultSize());
				
		controller.avaliableS = 'Johnnie';			
		controller.reloadListsAfterSearch();	
		
		controller.avaliableS = '';			
		controller.reloadLists();
		
		controller.avaliableS = 'Johnnie';
		controller.reloadListsAfterSearch();		
		controller.brandList[0].selected = true;
		controller.addRelations();
		System.assertequals(4, (controller.setCtrl).getResultSize());
		controller.accountBrandList[0].selected = true;
		controller.deleteRelations();
		System.assertequals(3, (controller.setCtrl).getResultSize());
		
		controller.nextB();
		controller.previousB();
		controller.lastB();
		controller.firstB();
		Integer a = controller.totalPagesB;	
		Integer b = controller.pageNumberB;
		Boolean c = controller.hasPreviousB;
		Boolean d = controller.hasNextB;
		controller.next(); 
		controller.previous();
		controller.last();
		controller.first();
		Integer e = controller.totalPages;
		Integer f = controller.pageNumber;
		Boolean g = controller.hasPrevious;
		Boolean h = controller.hasNext;
		Boolean i = controller.accountEditable;
	
		
		controller.addAll();
		controller.deleteAll();
		controller.cloneAccount = accountBraThird.id;
		controller.cloneRelationsFrom();
		controller.cloneRelationsTo();	
		
		//Updated by Akanksha(offshore) for case  00003540
		ApexPages.StandardController screl = new ApexPages.standardController(acountBra);	
		Apexpages.currentpage().getparameters().put('retURL', '/001');	
		Controller_AccountBrandRelationEdit controllerrel =  new Controller_AccountBrandRelationEdit(screl);	
		controllerrel.redirect();	
	 }*/
}