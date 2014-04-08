@isTest
private class RecipeProductTrigger_Test {

    static Recipe__c recipe;
    static Diageo_Brand__c diageoBrand;
    static Recipe_Brand__c recipeBrand;

    static {
        recipe = APPIRIO_HelperTestUtility.createRecipe('Test Published Recipe', 'Approved', 'EN-US');
        insert recipe;
        diageoBrand = APPIRIO_HelperTestUtility.createDiageoBrand('ModelBrand',null);
        insert diageoBrand;
    }

    static testMethod void myUnitTest() {
        Test.startTest();
            recipeBrand = APPIRIO_HelperTestUtility.createRecipeBrand(recipe.Id, diageoBrand.Id);
            insert recipeBrand;
        Test.stopTest();
    }
}