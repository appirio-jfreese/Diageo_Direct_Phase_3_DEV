global class BatchToDeleteRecipeAttribute implements Database.Batchable<sObject>{
   global final String Query;
  

   global BatchToDeleteRecipeAttribute(String q){
             Query=q; 
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(Query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<Recipe__c> scope){
                        System.debug('*********execute tsart');
      set<Id> recipeIds = new set<Id>();
      for(Recipe__c rc : scope){
          recipeIds.add(rc.Id);
      }
      list<Recipe_Attribute__c> deleteRecipeAttrTemp = new list<Recipe_Attribute__c>();
      list<Recipe_Attribute__c> nonDeleteRecipeAttributeTemp = new list<Recipe_Attribute__c>();
      Set<String> key = new Set<String>();
      list<Recipe_Attribute__c> recipeAttributes = new list<Recipe_Attribute__c>([select Id,Attribute__c,Attribute__r.Attribute_Type__c,Attribute__r.Dynamic__c,Recipe__c,Recipe__r.Id,Dynamic_Value__c,Attribute_Value__c from Recipe_Attribute__c where Recipe__r.Id in :recipeIds Order by CreatedDate DESC]);
      for(Recipe__c rec : scope){
        for(Recipe_Attribute__c rt : recipeAttributes){
            if(rt.Recipe__r.Id==rec.Id){
                if(key.size()==0 || !key.contains(rec.Recipe_Title__c+rt.Attribute__r.Attribute_Type__c)){
                    key.add(rec.Recipe_Title__c+rt.Attribute__r.Attribute_Type__c);
                    nonDeleteRecipeAttributeTemp.add(rt);
                }   
                else
                    deleteRecipeAttrTemp.add(rt);
            }
        }
      }
      if(nonDeleteRecipeAttributeTemp.size() > 0){
        for(Recipe_Attribute__c rt : nonDeleteRecipeAttributeTemp){
            if(rt.Attribute__r.Dynamic__c==true && rt.Dynamic_value__c==''){
                deleteRecipeAttrTemp.add(rt);
            }
        }
      }
      System.debug('----- delete Recipe Attribute' +deleteRecipeAttrTemp);
      if(deleteRecipeAttrTemp.size() > 0){
      delete deleteRecipeAttrTemp;
      }
   }

   global void finish(Database.BatchableContext BC){

   }

}