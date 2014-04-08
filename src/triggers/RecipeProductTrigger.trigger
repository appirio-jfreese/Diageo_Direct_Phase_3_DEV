trigger RecipeProductTrigger on Recipe_Brand__c (before insert, before update) {
  CombineKeyUtility cku = new CombineKeyUtility();
  cku.checkCombineKey(trigger.new);
}