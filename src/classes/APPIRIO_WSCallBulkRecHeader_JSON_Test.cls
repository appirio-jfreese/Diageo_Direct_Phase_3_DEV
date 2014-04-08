/********************************************************************************************************************
Name        : APPIRIO_WSCallBulkRecHeader_JSON_Test
Created By  : Appirio India(Rahul Mittal)
Date        : 28th Jan, 2014
Purpose     : Test Class for
                - APPIRIO_WebServiceCallBulkRecHeader_JSON and APPIRIO_GenerateXMLRecipeHeaderInfo_JSON classes
********************************************************************************************************************/
@isTest(SeeAllData=true)
private class APPIRIO_WSCallBulkRecHeader_JSON_Test {

	//variable declaration
	static	Master_Recipe__c mastRec;
	static Recipe__c recipe;
	static Recipe__c recipe1;

	static Attribute__c attr;
	static Attribute__c attr1;
	static Attribute__c attr2;
	static Attribute__c attr3;
	static Attribute__c attr4;
	static Attribute__c attr5;
	static Attribute__c attr6;
	static Attribute__c attr7;
	static Attribute__c attr8;
	static Attribute__c attr9;
	static Attribute__c attr10;
	static Attribute__c attr11;
	static Attribute__c attr12;

	static Recipe_Attribute__c recattr;
	static Recipe_Attribute__c recattr1;
	static Recipe_Attribute__c recattr2;
	static Recipe_Attribute__c recattr3;
	static Recipe_Attribute__c recattr4;
	static Recipe_Attribute__c recattr5;
	static Recipe_Attribute__c recattr6;
	static Recipe_Attribute__c recattr7;
	static Recipe_Attribute__c recattr8;
	static Recipe_Attribute__c recattr9;
	static Recipe_Attribute__c recattr10;
	static Recipe_Attribute__c recattr11;
	static Recipe_Attribute__c recattr12;

	static Diageo_Brand__c diagBrnd;
	static Diageo_Product__c diagPrdct;
	static Recipe_Non_Diageo_Product__c nonDiagPrdct;
	static Diageo_Ingredient__c diagIng;
	static Diageo_Ingredient__c diagIng1;
	static Diageo_Ingredient__c nonDiagIng;

	static Digital_Published_Asset__c digitalPublishedAsset;
	static Published_Recipe__c publishedRecipe;
	static Published_Recipe__c publishedRecipe1;
	static ContentVersion myImage;
    static Recipe_Media__c recm;

	static {
		myImage = new ContentVersion();
        myImage.title='TITLE';
        myImage.contentUrl='http://www.salesforce.com';
        insert myImage;

        recm = new Recipe_Media__c();
        recm.Content_id__c = myImage.Id;
        recm.Content_Display_ID__c = myImage.Id;
        recm.Name = 'TestImage';
        insert recm;

		//creating a Master Recipe
		mastRec = TestUtil.createMasterRecipe('MasterRecipe');

		//Creates a Recipe
		recipe = createRecipe('TestRecipe1',mastRec.Id,recm.Id, 'Draft',true, true);

		//Creates a Recipe
		recipe1 = createRecipe('TestRecipe2',mastRec.Id,recm.Id, 'Draft',true, true);

		//Creating a bunch of Attribute Records
		attr = TestUtil.createAttribute('Color','TestBlue',null);
		attr1= TestUtil.createAttribute('Language','TestEnglish',null);
		attr2 = TestUtil.createAttribute('Flavor','TestStrawberry',null);
		attr3 = TestUtil.createAttribute('Flavor','TestBanana',null);
		attr4 = TestUtil.createAttribute('Drink Type','TestCocktails',null);
		attr5 = TestUtil.createAttribute('Drink Type','TestBloody-Marys',null);
		attr6 = TestUtil.createAttribute('Glassware','TestGlassware',null);
        attr7 = TestUtil.createAttribute('Effort Level','TestEffortLevel',null);
        attr8 = TestUtil.createAttribute('Serving Style','TestServingStyle',null);
        attr9 = TestUtil.createAttribute('Wine Type','TestWineType',null);
        attr10 = TestUtil.createAttribute('Wine Taste','TestWineTaste',null);
        attr11 = TestUtil.createAttribute('Barware Needed','TestBarwareNeeded',null);
        attr12 = TestUtil.createAttribute('Drink Classification','TestDrinkClassification',null);

		//Mapping Recipes to the Attributes(Creating Junction Object Records)
		recattr = TestUtil.createRecipeAttribute(recipe.Id,attr.Id);
		recattr1 = TestUtil.createRecipeAttribute(recipe.Id,attr1.Id);
		recattr2 = TestUtil.createRecipeAttribute(recipe.Id,attr2.Id);
		recattr3 = TestUtil.createRecipeAttribute(recipe.Id,attr3.Id);
		recattr4 = TestUtil.createRecipeAttribute(recipe.Id,attr4.Id);
		recattr5 = TestUtil.createRecipeAttribute(recipe.Id,attr5.Id);
		recattr6 = TestUtil.createRecipeAttribute(recipe.Id,attr6.Id);
		recattr7 = TestUtil.createRecipeAttribute(recipe.Id,attr7.Id);
		recattr8 = TestUtil.createRecipeAttribute(recipe.Id,attr8.Id);
		recattr9 = TestUtil.createRecipeAttribute(recipe.Id,attr9.Id);
		recattr10 = TestUtil.createRecipeAttribute(recipe.Id,attr10.Id);
		recattr11 = TestUtil.createRecipeAttribute(recipe.Id,attr11.Id);
		recattr12 = TestUtil.createRecipeAttribute(recipe.Id,attr12.Id);

		//Creating a Diageo Brand(Parent Product)
		diagBrnd  = TestUtil.createDiageoBrand('ModelBrand',null);

		//Creating a Recipe Diageo Product(Categeory/Sub Brand of Daigeo Brand)
		diagPrdct = TestUtil.createDiageoProduct('ModelBrandCaramel',diagBrnd.Id,null);

		//Creating a Recipe Non Diageo Product
		nonDiagPrdct = TestUtil.createNonDiageoProduct('Big Banana',null);

		//Creating Recipe Ingredients
		diagIng = TestUtil.createRecipeIngredient(true,'1.25','Oz.',recipe.Id,diagBrnd.Id,diagPrdct.id,null,1);
		diagIng1 = TestUtil.createRecipeIngredient(true,'118.294','ml.',recipe1.Id,diagBrnd.Id,diagPrdct.id,null,1);
		nonDiagIng = TestUtil.createRecipeIngredient(true,'118.294','ml.',recipe.Id,null,null,nonDiagPrdct.id,2);

		//Creating Digital Published Asset
		digitalPublishedAsset =  TestUtil.createDigitalPublishedAsset('TestDigitalPublishedAsset1', 'Website', 'EN-US');

		//Creating Published Recipe
		publishedRecipe = TestUtil.createPublishedRecipe(digitalPublishedAsset.Id, recipe.Id,'Published');
		publishedRecipe1 = TestUtil.createPublishedRecipe(digitalPublishedAsset.Id, recipe1.Id,'Published');
	}

    static testMethod void WebServiceCallBulkRepHeaderTest() {
    	String xmlString;
    	digitalPublishedAsset = [Select API_External_ID__c From Digital_Published_Asset__c Where Id =: digitalPublishedAsset.Id];
		Publishing_API_User_Setting__c setting;
      	if(Publishing_API_User_Setting__c.getAll().size() > 0) {
	      	setting = Publishing_API_User_Setting__c.getAll().values()[0];
	    } else {
	    	setting = new Publishing_API_User_Setting__c();
	      	setting.Name = 'publishingapiuser';
	      	setting.API_Header_Value__c = 'verified';
	      	setting.Message__c = 'Access denied. Not a verified user.';
	      	insert setting;
	    }

    	Test.startTest();
	    	// set up the request object
	        System.RestContext.request = new RestRequest();
	        RestContext.request.requestURI = '/CallBulkRecipeHeaderJSON/';

	        // Invoke the method directly
	        APPIRIO_WebServiceCallBulkRecHeader_JSON.WebServiceCallBulkRecipeHeader();
			//System.assert(responseResult.Error.ErrorMessage.contains(setting.Message__c));
			//Added to check the publishingapiuser header in request
			System.RestContext.request.headers.put(setting.Name, setting.API_Header_Value__c);
			RestContext.request.addParameter('resumePoint', '1');
			APPIRIO_WebServiceCallBulkRecHeader_JSON.WebServiceCallBulkRecipeHeader();
			//System.assert(responseResult.Error.ErrorMessage.contains('APIExternalID cannot be blank.'));

	        RestContext.request.addParameter('APIExternalID', digitalPublishedAsset.API_External_ID__c);

	        // Invoke the method directly
	        APPIRIO_WebServiceCallBulkRecHeader_JSON.WebServiceCallBulkRecipeHeader();
			//System.assert(responseResult.Recipe.size() == 2);

	        RestContext.request.addParameter('BrandNames', 'ModelBrand');
	        APPIRIO_WebServiceCallBulkRecHeader_JSON.WebServiceCallBulkRecipeHeader();
			//System.assert(responseResult.Recipe.size() > 0);
        Test.stopTest();
	}

	/*static testMethod void WebServiceCallBulkRepHeaderInfoTest() {
    	String xmlString;
    	digitalPublishedAsset = [Select API_External_ID__c From Digital_Published_Asset__c Where Id =: digitalPublishedAsset.Id];

    	Test.startTest();
	    	APPIRIO_GenerateXMLRecipeHeaderInfo_JSON jsonRecipeIinfo = new APPIRIO_GenerateXMLRecipeHeaderInfo_JSON();
	        jsonRecipeIinfo.recipeIds = new List<Id>();
	        jsonRecipeIinfo.recipeIds.add(recipe.Id);
	        jsonRecipeIinfo.recipeIds.add(recipe1.Id);
	        jsonRecipeIinfo.generateJSONRecipeIinfo();
        Test.stopTest();
	}*/

	/**
     * Method to create recipe record for recipe
     **/
     public static Recipe__c createRecipe(string recipeName,Id masterRecipeId,Id recmId, string currentStatus,boolean saveStatus, boolean isInsert){
     	Recipe__c rec = new Recipe__c();
     	rec.Recipe_Title__c = recipeName;
     	rec.Master_Recipe__c = masterRecipeId;
     	rec.Status__c = currentStatus;
     	rec.recordSaved__c = saveStatus;
     	rec.Locale__c = 'EN-US';
     	rec.Main_Drink_Image__c = recmId;
     	rec.Thumbnail_Drink_Image__c = recmId;
     	rec.Main_Ingredient_Image__c = recmId;
     	rec.Additional_Image_3__c = recmId;
     	rec.Additional_Image_4__c = recmId;
     	rec.Additional_Image_5__c = recmId;
        rec.Mobile_Drink_Image__c = recmId;
        rec.Mobile_Selected_Image__c = recmId;
        rec.Mobile_Unselected_Image__c = recmId;
        rec.Background_Image__c = recmId;
        rec.Brand_Recipe_Image__c = recmId;
        rec.Search_Recipe_Image__c = recmId;
        rec.Additional_Image_1__c = recmId;
        rec.Additional_Image_2__c = recmId;

     	if(isInsert)
     		insert rec;
     	return rec;
     }
}