trigger NonDiageoIngredientTrigger on Non_Diageo_Ingredient__c (before insert, before update) {
  CombineKeyUtility cku = new CombineKeyUtility();
  cku.checkCombineKey(trigger.new);
}