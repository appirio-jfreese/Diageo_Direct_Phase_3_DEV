/*******************************************************************************
Name 		: Test_POS_BudgetTrigger
Created By	: Vikash Goyal (Appirio JDC)
Date		: 10th Mar, 2014
Reason 		: For Code Coverage of trigger POS_Budget
*******************************************************************************/
@isTest
private class Test_POS_BudgetTrigger {

    static testMethod void testPOSBudgetTrigger() {
      settings__c customSetting = new settings__c(Name = 'maxNoItemsForFutureCall', value__c = '2');
      insert customSetting;
      
      List<Brand__c> lstBrands = new List<Brand__c>(); 
      Brand__c portfolioBrand = Test_Helper.testCreateBrand('Portfolio', false); 
      portfolioBrand.Brand_Type__c = 'Individual Variant';
      lstBrands.add(portfolioBrand);     
      Brand__c parentBrand = Test_Helper.testCreateBrand('Test P Brand', false); 
      parentBrand.Brand_Type__c = 'Individual Variant';
      lstBrands.add(parentBrand);
      Brand__c childBrand = Test_Helper.testCreateBrand('Test C Brand', parentBrand.Id, null); 
      childBrand.Brand_Type__c = 'Individual Variant';
      lstBrands.add(childBrand);
      insert lstBrands;
      
      Account agency = POS_TestDataUtil.createProductionAgency();
      Account dist = POS_TestDataUtil.createDistributorAccount();
      
      AccountBrand__c ab = POS_TestDataUtil.createAccountBrand(dist, childBrand);
      
      Order_Window__c orderWindow = POS_TestDataUtil.createOrderWindow();
      
      Program__c program = POS_TestDataUtil.createProgram(childBrand.Id, orderWindow.Id);
      
      Item__c item = POS_TestDataUtil.populateItem(program, agency);
      item.RecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'Standard' limit 1].Id;
      insert item;
      
      Item_Brand__c itemBrand = POS_TestDataUtil.createItemBrand(item.Id, childbrand.Id);
      
      User budgeter = Test_Helper.testInsertDiageoEmployee();
      User shopper = Test_Helper.testInsertDiageoEmployee();
      
      List<Account_Member__c> lstAccMembers = new List<Account_Member__c>();
      lstAccMembers.add(new Account_Member__c(Account__c = dist.id, User__c = budgeter.id));
      lstAccMembers.add(new Account_Member__c(Account__c = dist.id, User__c = shopper.id));
      insert lstAccMembers;
      
      List<Budget__c> lstParBudgets = new List<Budget__c>();
      Budget__c parentBudget1 = Test_Helper.createBudgetRecord(budgeter.Id, shopper.Id, childBrand.Id, orderWindow.Id);
      lstParBudgets.add(parentBudget1);
      Budget__c parentBudget2 = Test_Helper.createBudgetRecord(budgeter.Id, shopper.Id, childBrand.Id, orderWindow.Id);
      lstParBudgets.add(parentBudget2);
      insert lstParBudgets;
      
      Test.startTest();
	      List<Budget__c> lstBudgets = new List<Budget__c>();
	      Budget__c childbudget1 = Test_Helper.createBudgetRecord(budgeter.Id, shopper.Id, childBrand.Id, orderWindow.Id);
	      childbudget1.Parent__c = parentBudget1.Id;
	      lstBudgets.add(childbudget1);	      
	      Budget__c childbudget2 = Test_Helper.createBudgetRecord(budgeter.Id, shopper.Id, null, orderWindow.Id);
	      childbudget2.Budget_Creator__c = null;
	      childbudget2.Item__c = item.Id;
	      childbudget2.Parent__c = parentBudget2.Id;
	      childbudget2.Item_Allocation_Quantity__c = 2;
	      childbudget2.Spent_Item_Quantity__c = 2;
	      lstBudgets.add(childbudget2);
	      insert lstBudgets;
	      
	      childbudget1.Amount__c = 1000;
	      childbudget1.Sub_Allocated_Amount__c = 1100;
	      childbudget2.Item_Allocation_Quantity__c = 4;
	      childbudget2.Spent_Item_Quantity__c = 4;
	      childbudget2.Sub_Allocated_Item_Quantity__c = 5;
	      update lstBudgets;
	      
	      //delete lstBudgets;	      	      
      Test.stopTest();
    }
}