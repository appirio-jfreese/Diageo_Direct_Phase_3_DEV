trigger RecipeOccasionTrigger on Recipe_Occasion__c (before insert, before update) {
  CombineKeyUtility cku = new CombineKeyUtility();
  cku.checkCombineKey(trigger.new);
}