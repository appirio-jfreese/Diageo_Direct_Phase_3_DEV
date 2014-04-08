@isTest
private class NonDiageoIngredientTrigger_Test {
    static Recipe__c recipe;
    static Non_Diageo_Ingredient__c nonDiageoIngredient;

    static {
        recipe = APPIRIO_HelperTestUtility.createRecipe('Test Published Recipe', 'Approved', 'EN-US');
        insert recipe;
    }

    static testMethod void myUnitTest() {
        Test.startTest();
            nonDiageoIngredient = new Non_Diageo_Ingredient__c(Recipe__c = recipe.Id, LegacyID__c='1111111');
            insert nonDiageoIngredient;
        Test.stopTest();
    }
}