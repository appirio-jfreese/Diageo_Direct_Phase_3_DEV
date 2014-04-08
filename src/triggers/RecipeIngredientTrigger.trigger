trigger RecipeIngredientTrigger on Diageo_Ingredient__c (before insert, before update) {
    // Randy Wandell 02-11-2014 : Added TriggerState framework
    if(TriggerState.isActive('RecipeIngredientTrigger')) {
        CombineKeyUtility cku = new CombineKeyUtility();
        cku.checkCombineKey(trigger.new);
    }
}