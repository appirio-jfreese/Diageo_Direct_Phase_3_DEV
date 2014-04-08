/********************************************************************************************************************
Name        : APPIRIO_WSCallRecipeClasifiDtl_JSON_Test
Updated By  : Appirio Offshore(Rishi Khirbat)
Date        : 28th Jan, 2014
Purpose     : Test Class for
				- APPIRIO_WebServiceCallRecpClasifDtl_JSON
********************************************************************************************************************/
@isTest(SeeAllData=false)
private class APPIRIO_WSCallRecipeClasifiDtl_JSON_Test {

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
	static Diageo_Brand__c diagBrnd;
    static Diageo_Product__c diagPrdct;
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

        //Creating a Diageo Brand(Parent Product)
        diagBrnd  = TestUtil.createDiageoBrand('ModelBrand',null);

        //Creating a Recipe Diageo Product(Categeory/Sub Brand of Daigeo Brand)
        diagPrdct = TestUtil.createDiageoProduct('ModelBrandCaramel',diagBrnd.Id,null);
	}

	//Test Web Service Call for Recipe Classifications
    static testMethod void WebServiceCallRecipeClasifictinsTest() {

    	attr = [Select API_External_ID__c, Locale__c From Attribute__c Where Id=:attr.id];
    	diagPrdct = [Select Name, Locale__c, API_External_ID__c, Category__c, Diageo_Brand_Id__r.API_External_ID__c From Diageo_Product__c Where Id=:diagPrdct.id];
        diagBrnd = [Select Name, Locale__c, API_External_ID__c, Category__c From Diageo_Brand__c Where Id=:diagBrnd.id];

        if(diagPrdct.Category__c == null) diagPrdct.Category__c = '';
        if(diagBrnd.Category__c == null) diagBrnd.Category__c = '';

    	Test.startTest();
	    	// set up the request object
	        System.RestContext.request = new RestRequest();
	        RestContext.request.requestURI = '/CallRecipeClassificationDetailsJSON/';

	         // Invoke the method directly
	        //APPIRIO_WrapperUtility_JSON.RecipeClassificationsDtl responseResult
	        APPIRIO_WebServiceCallRecpClasifDtl_JSON.WebServiceCallRecipeClassificationDetails();

	      	//System.assert(responseResult.Error != null);
		    //System.assert(responseResult.Error.ErrorMessage.contains(setting.Message__c));

		    //Added to check the publishingapiuser header in request
			System.RestContext.request.headers.put(setting.Name, setting.API_Header_Value__c);

			// Invoke the method directly
		    APPIRIO_WebServiceCallRecpClasifDtl_JSON.WebServiceCallRecipeClassificationDetails();
		    /*system.debug('==========================responseResult: '+responseResult);
		    System.assertEquals(responseResult.RecipeClassificationDetails.size(), 13);
		    System.assertEquals(responseResult.RecipeClassificationDetails[0].key, 'Flavor');
		    System.assertEquals(responseResult.RecipeClassificationDetails[1].key, 'Drink Type');
		    System.assertEquals(responseResult.RecipeClassificationDetails[10].key, 'Occasion');
		    System.assertEquals(responseResult.RecipeClassificationDetails[11].key, 'Brand');
		    System.assertEquals(responseResult.RecipeClassificationDetails[12].key, 'Product');
			*/

		    // Invoke the method directly
		    RestContext.request.addParameter('Key', 'Color');
			APPIRIO_WebServiceCallRecpClasifDtl_JSON.WebServiceCallRecipeClassificationDetails();
		    /*system.debug('==========================responseResult: '+responseResult);
		    System.assertEquals(responseResult.RecipeClassificationDetails.size(), 1);
		    System.assertEquals(responseResult.RecipeClassificationDetails[0].key, 'Color');
			*/

		    RestContext.request.addParameter('Key', 'Brand');
			APPIRIO_WebServiceCallRecpClasifDtl_JSON.WebServiceCallRecipeClassificationDetails();
		    /*system.debug('==========================responseResult: '+responseResult);
		    System.assertEquals(responseResult.RecipeClassificationDetails.size(), 1);
		    System.assertEquals(responseResult.RecipeClassificationDetails[0].key, 'Brand');
			*/

		    RestContext.request.addParameter('Key', 'Product');
			APPIRIO_WebServiceCallRecpClasifDtl_JSON.WebServiceCallRecipeClassificationDetails();
		    /*system.debug('==========================responseResult: '+responseResult);
		    System.assertEquals(responseResult.RecipeClassificationDetails.size(), 1);
		    System.assertEquals(responseResult.RecipeClassificationDetails[0].key, 'Product');*/

		    RestContext.request.addParameter('Key', 'Occasion');
			APPIRIO_WebServiceCallRecpClasifDtl_JSON.WebServiceCallRecipeClassificationDetails();
		    /*system.debug('==========================responseResult: '+responseResult);
		    System.assertEquals(responseResult.RecipeClassificationDetails.size(), 1);
		    System.assertEquals(responseResult.RecipeClassificationDetails[0].key, 'Occasion');*/

		Test.stopTest();
    }
}