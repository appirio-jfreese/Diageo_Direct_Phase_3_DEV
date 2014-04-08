@IsTest(SeeAllData=false)
public class RecipeWrapper_Test{
 
	public static testMethod void testMe() {
 
      	RecipeWrapper re = new RecipeWrapper();
      	System.assertEquals(re.checked,false);
 
 	  	Recipe__c recipe = new Recipe__c(Recipe_Title__c='Test1');
 	  
 	  	ContentVersion myImage = new ContentVersion();
 	  	//myImage.ContentDocumentId=Label.Drink_Image_Workspace_Name;
 		myImage.title='TITLE';
 		myImage.contentUrl='http://www.salesforce.com';
        insert myImage;
       
        Recipe_Media__c media = new Recipe_Media__c();
        media.Content_id__c=myImage.Id;
        insert media;
      
        
        recipe.Main_Drink_Image__c = media.Id;        
        RecipeWrapper re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Published');
        recipe.Main_Drink_Image__c = null;
        System.assertEquals(re2.checked,true);
        
        recipe.Search_Recipe_Image__c = media.Id;
        re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Suppressed');
        recipe.Search_Recipe_Image__c = null;
        
        recipe.Mobile_Selected_Image__c = media.Id;
        re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Published');
        recipe.Mobile_Selected_Image__c = null;
        
        recipe.Mobile_Unselected_Image__c = media.Id;
        re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Published');
        recipe.Mobile_Unselected_Image__c = null;
        
        
        recipe.Mobile_Drink_Image__c = media.Id;
        re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Published');
        recipe.Mobile_Drink_Image__c = null;
        
        recipe.Additional_Image_1__c =  media.Id;
        re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Published');
        recipe.Additional_Image_1__c = null;
        
        recipe.Additional_Image_2__c =  media.Id; 
        re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Published');
        recipe.Additional_Image_2__c = null;
       
        recipe.Search_Recipe_Image__c =  media.Id;
        re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Published');
        recipe.Search_Recipe_Image__c = null;
        
        recipe.Background_Image__c =  media.Id;
        re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Published');
        recipe.Background_Image__c = null;
        
        recipe.Brand_Recipe_Image__c =  media.Id;
        re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Published');
        recipe.Brand_Recipe_Image__c = null;
        
        recipe.Additional_Image_5__c =  media.Id;
        re2 = new RecipeWrapper(recipe);
        re2 = new RecipeWrapper(recipe,'Suppressed');
 	  
      	System.assertEquals(re2.rec.Recipe_Title__c,'Test1');
      	System.assertEquals(re2.checked,false);
    }
}