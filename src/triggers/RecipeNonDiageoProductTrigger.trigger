trigger RecipeNonDiageoProductTrigger on Recipe_Non_Diageo_Product__c (before insert, before update) {
  CombineKeyUtility cku = new CombineKeyUtility();
  cku.checkCombineKey(trigger.new);
}