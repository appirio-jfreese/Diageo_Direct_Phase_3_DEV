/********************************************************************************************************************
Name        : APPIRIO_WSCallRecipeClasifi_JSON_Test
Updated By  : Appirio Offshore(Rishi Khirbat)
Date        : 28th Jan, 2014
Purpose     : Test Class for
				- APPIRIO_WebServiceCallRecipeClasif_JSON
********************************************************************************************************************/
@isTest(SeeAllData=false)
private class APPIRIO_WSCallRecipeClasifi_JSON_Test {

	//variable declaration
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
	static Publishing_API_User_Setting__c setting;

	static {

		if(Publishing_API_User_Setting__c.getAll().size() > 0) {
	      	setting = Publishing_API_User_Setting__c.getAll().values()[0];
	    } else {
	    	setting = new Publishing_API_User_Setting__c();
	      	setting.Name = 'publishingapiuser';
	      	setting.API_Header_Value__c = 'verified';
	      	setting.Message__c = 'Access denied. Not a verified user.';
	      	insert setting;
	    }

		//Creating a bunch of Attribute Records
		attr = TestUtil.createAttribute('Color','TestBlue',null);
		attr1= TestUtil.createAttribute('Language','TestEnglish',null);
		attr2 = TestUtil.createAttribute('Flavor','TestStrawberry',null);
		attr3 = TestUtil.createAttribute('Drink Type','TestCocktails',null);
		attr4 = TestUtil.createAttribute('Glassware','TestGlassware',null);
        attr5 = TestUtil.createAttribute('Effort Level','TestEffortLevel',null);
        attr6 = TestUtil.createAttribute('Serving Style','TestServingStyle',null);
        attr7 = TestUtil.createAttribute('Wine Type','TestWineType',null);
        attr8 = TestUtil.createAttribute('Wine Taste','TestWineTaste',null);
        attr9 = TestUtil.createAttribute('Barware Needed','TestBarwareNeeded',null);
        attr10 = TestUtil.createAttribute('Test Drink Classification','TestDrinkClassification',null);
        attr10.Dynamic__c = true;
        update attr10;
	}

	//Test Web Service Call for Recipe Classifications
    static testMethod void WebServiceCallRecipeClasifictinsTest() {
    	Test.startTest();
	    	// set up the request object
	        System.RestContext.request = new RestRequest();
	        RestContext.request.requestURI = '/CallRecipeClassificationsJSON/';

	        // Invoke the method directly
	        APPIRIO_WebServiceCallRecipeClasif_JSON.WebServiceCallRecipeClassification();

	      	//System.assert(responseResult.Error != null);
		    //System.assert(responseResult.Error.ErrorMessage.contains(setting.Message__c));

		    //Added to check the publishingapiuser header in request
			System.RestContext.request.headers.put(setting.Name, setting.API_Header_Value__c);

		    // Invoke the method directly
		    APPIRIO_WebServiceCallRecipeClasif_JSON.WebServiceCallRecipeClassification();
		    //system.debug('==========================responseResult: '+responseResult);
		    /*System.assertEquals(responseResult.RecipeClassifications.size(), 13);
		    System.assertEquals(responseResult.RecipeClassifications[0].AttributeType, 'Barware Needed');
		    System.assertEquals(responseResult.RecipeClassifications[1].AttributeType, 'Color');
		    System.assertEquals(responseResult.RecipeClassifications[10].AttributeType, 'Brand');
		    System.assertEquals(responseResult.RecipeClassifications[11].AttributeType, 'Product');
		    System.assertEquals(responseResult.RecipeClassifications[12].AttributeType, 'Occasion');*/

		    // Invoke the method directly
		    RestContext.request.addParameter('Key', 'Color');
			APPIRIO_WebServiceCallRecipeClasif_JSON.WebServiceCallRecipeClassification();
		    //system.debug('==========================responseResult: '+responseResult);
		    //System.assertEquals(responseResult.RecipeClassifications.size(), 1);
		    //System.assertEquals(responseResult.RecipeClassifications[0].AttributeType, 'Color');

		    RestContext.request.addParameter('Key', 'Brand');
			APPIRIO_WebServiceCallRecipeClasif_JSON.WebServiceCallRecipeClassification();
		    //system.debug('==========================responseResult: '+responseResult);
		    //System.assertEquals(responseResult.RecipeClassifications.size(), 1);
		    //System.assertEquals(responseResult.RecipeClassifications[0].AttributeType, 'Brand');

		    RestContext.request.addParameter('Key', 'Product');
			APPIRIO_WebServiceCallRecipeClasif_JSON.WebServiceCallRecipeClassification();
		    //system.debug('==========================responseResult: '+responseResult);
		    //System.assertEquals(responseResult.RecipeClassifications.size(), 1);
		    //System.assertEquals(responseResult.RecipeClassifications[0].AttributeType, 'Product');

		    RestContext.request.addParameter('Key', 'Occasion');
			APPIRIO_WebServiceCallRecipeClasif_JSON.WebServiceCallRecipeClassification();
		    //system.debug('==========================responseResult: '+responseResult);
		    //System.assertEquals(responseResult.RecipeClassifications.size(), 1);
		    //System.assertEquals(responseResult.RecipeClassifications[0].AttributeType, 'Occasion');

        Test.stopTest();
    }
}