@isTest
private class Test_Controller_BrandAccount {
	
	 static testMethod void testController() {
	 	List<RecordType> accountRecordTypes = new List<RecordType>([Select r.Name, r.Id From RecordType r WHERE r.SobjectType = 'Account' 
	 	               AND r.Name = 'Distributor']);	

        Account account = Test_Helper.testInsertAccount('test_account');
        Contact contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
             
        User user;        
        User user2;
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];   
        System.runAs (thisUser) {
        	user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        }
        
        Account account2 = Test_Helper.testInsertAccount('Diageo');
        Contact contact2 = Test_Helper.testInsertContact('firstName2', 'lastName2', account2.id);
        System.runAs (thisUser) {
        	user2 = Test_Helper.testInsertDistributorPortalUser(contact2.id);
        }
        
        if(accountRecordTypes.size() > 0){
          List<Account> lstAcc = new List<Account>();
          account.RecordTypeId = accountRecordTypes[0].Id;
          account2.RecordTypeId = accountRecordTypes[0].Id;
          lstAcc.add(account);
          lstAcc.add(account2);
          update lstAcc;	
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
		
		ApexPages.currentPage().getParameters().put('id', brandFirst.id);
		
		ApexPages.StandardSetController sc = new ApexPages.standardSetController(lac);			
		Controller_BrandAccount controller =  new Controller_BrandAccount(sc);		
		
		controller.populateAccountBrands();
		controller.populateAccounts();

		AccountBrand__c accountBraThird = Test_Helper.testInsertAccountBrand(account.Id, brandThird.Id);
		AccountBrand__c accountBraFourth = Test_Helper.testInsertAccountBrand(account2.Id, brandFourth.Id);	
				
		controller.populateAccountBrands();
		controller.populateAccounts();

		controller.pageUtilAccBrand.searchStr = 'Diageo';			
		controller.populateAccountBrands();	
		
		controller.pageUtilAcc.searchStr = 'Diageo';			
		controller.populateAccounts();	
		
		controller.pageUtilAccBrand.searchStr = '';			
		controller.populateAccountBrands();
		controller.pageUtilAcc.searchStr = '';
		controller.populateAccounts();
		
		//controller.distribList[0].selected = true;
		controller.addRelations();
		//controller.brandAccountList[0].selected = true;
		controller.deleteRelations();
		
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
		controller.doSortAccounts();	
		controller.addAll();
		controller.deleteAll();
		controller.cloneId = brandFirst.id;
		controller.cloneRelationsFrom();
		controller.cloneRelationsTo();		
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
		Controller_BrandAccountEdit controller =  new Controller_BrandAccountEdit(sc);		
		
		controller.reloadLists();

		AccountBrand__c accountBraThird = Test_Helper.testInsertAccountBrand(account.Id, brandThird.Id);
		AccountBrand__c accountBraFourth = Test_Helper.testInsertAccountBrand(account2.Id, brandFourth.Id);	
				
		controller.reloadLists();

		controller.avaliableS = 'Diageo';			
		controller.reloadListsAfterSearch();	
		String filter = '%'+controller.avaliableS+'%';
		
		controller.avaliableS = '';			
		controller.reloadLists();
		
		controller.reloadListsAfterSearch();		
		controller.distribList[0].selected = true;
		controller.addRelations();
		controller.brandAccountList[0].selected = true;
		controller.deleteRelations();
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
		controller.cloneId = brandFirst.id;
		controller.cloneRelationsFrom();
		controller.cloneRelationsTo();		
	 }	 */
}