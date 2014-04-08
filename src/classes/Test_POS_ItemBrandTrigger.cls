/*******************************************************************************
Name 		: Test_POS_ItemBrandTrigger
Created By	: Vikash Goyal (Appirio JDC)
Date		: 10th Mar, 2014
Reason 		: For Code Coverage of trigger POS_ItemBrand
*******************************************************************************/
@isTest
private class Test_POS_ItemBrandTrigger {

    static testMethod void testItemBrand() {
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
      item.Status__c = 'Approved w/Est Price';
      item.RecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'Standard' limit 1].Id;
      insert item;
      
      Item_Brand__c itemBrand = Test_Helper.createItemBrand(item.Id, portfolioBrand.Id, true);
      try{
      	insert itemBrand;
      }
      catch(Exception e){
      	System.assert((e.getMessage()).contains('\'Potfolio\' brand cannot be marked as Primary'));
      }
      
      itemBrand.Brand__c = childBrand.Id;
      try{
        insert itemBrand;
      }
      catch(Exception e){
      	System.assert((e.getMessage()).contains('One and only one Brand must be designated as the "Primary" for an Item.'));
      }
      
      itemBrand.Primary__c = false;
      insert itemBrand;
    }
}