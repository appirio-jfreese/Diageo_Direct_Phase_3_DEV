/*******************************************************************************
Name 		: Test_POS_CartTrigger
Created By	: Vikash Goyal (Appirio JDC)
Date		: 10th Mar, 2014
Reason 		: For Code Coverage of trigger POS_CartTrigger
*******************************************************************************/
@isTest
private class Test_POS_CartTrigger {

    static testMethod void testPOSCartTrigger() {
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
      
      /*Budget__c parentBudget = Test_Helper.createBudgetRecord(budgeter.Id, shopper.Id, parentBrand.Id, orderWindow.Id);
      insert parentBudget;*/
      
      List<Budget__c> lstParBudgets = new List<Budget__c>();      
      Budget__c childBudget1 = Test_Helper.createBudgetRecord(budgeter.Id, shopper.Id, childBrand.Id, orderWindow.Id);
      childBudget1.Sub_Allocated_Amount__c = 50;
      childBudget1.Spent_Amount__c = 30;
      lstParBudgets.add(childBudget1);
      Budget__c childBudget2 = Test_Helper.createBudgetRecord(budgeter.Id, shopper.Id, null, orderWindow.Id);
      childBudget2.Item__c = item.Id;
      lstParBudgets.add(childBudget2);
      Budget__c childBudget3 = Test_Helper.createBudgetRecord(budgeter.Id, shopper.Id, childBrand.Id, orderWindow.Id);
      childBudget3.Sub_Allocated_Amount__c = 30;
      childBudget3.Spent_Amount__c = 30;
      childBudget3.My_Spent_Overage__c = 10;
      lstParBudgets.add(childBudget3);
      insert lstParBudgets;

      Cart__c cart = POS_TestDataUtil.createCart(shopper, orderWindow);
            
      Cart_Item__c cartItem = POS_TestDataUtil.populateCartItem(item, cart);
      insert cartItem;
      
      Test.startTest();
        cart.Status__c = 'Submitted';
        update cart;
      Test.stopTest();
    }
}