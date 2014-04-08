@isTest(SeeAllData=false) 
private class TestBatchToDeleteRecipeAttribute {
    static testmethod void createData(){
        Recipe__c recipe = new Recipe__c();
        recipe.Recipe_Title__c = 'rt';
        insert recipe;
        Attribute__c attr = new Attribute__c();
        attr.Attribute_Type__c = 'Description/Overview';
        attr.Dynamic__c = true;
        insert attr;
        Recipe_Attribute__c rt = new Recipe_Attribute__c();
        rt.Attribute__c = attr.Id;
        rt.Recipe__c = recipe.Id;
        insert rt;
        Recipe_Attribute__c rt2 = new Recipe_Attribute__c();
        rt2.Attribute__c = attr.Id;
        rt2.Recipe__c = recipe.Id;
        insert rt2;
        
        
    }
    static testMethod void testMethod_TestBatchToDeleteRecipeAttribute() {
        createData();
        Test.startTest();
        List<Recipe_Attribute__c>  resAttr = [select id from Recipe_Attribute__c];
        String query = 'select Id,Recipe_Title__c from Recipe__c limit 100';
        BatchToDeleteRecipeAttribute batchTODelete = new BatchToDeleteRecipeAttribute(query);
         Database.executeBatch(batchTODelete);
         System.assertNotEquals(resAttr.size(), 3);
        Test.stopTest();
    }
}