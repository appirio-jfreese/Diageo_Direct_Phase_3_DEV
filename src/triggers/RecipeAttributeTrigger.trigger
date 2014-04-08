trigger RecipeAttributeTrigger on Recipe_Attribute__c (before insert, before update) {
  CombineKeyUtility cku = new CombineKeyUtility();
  cku.checkCombineKey(trigger.new);
}