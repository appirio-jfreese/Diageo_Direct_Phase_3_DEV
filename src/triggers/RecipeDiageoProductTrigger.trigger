trigger RecipeDiageoProductTrigger on Diageo_Product__c (before insert, before update) {
  CombineKeyUtility cku = new CombineKeyUtility();
  cku.checkCombineKey(trigger.new);
}