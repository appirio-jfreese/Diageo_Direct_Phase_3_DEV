/********************************************************************************************************************
Name        : APPIRIO_WSCallShoppingList_JSON
Updated By  : Appirio India(Rahul Mittal)
Date        : 28th Jan, 2014
Purpose     : Create web service call which returns a rolled-up list of ingredients for multiple recipes in JSON format.
Ref         : T-241202
			  input parameters:
				1. Recipe API External ID
				2. Servings for Recipe
				3. ** There can be more than one recipe included, in that case it would be: param1 = R-00001, param2 = 2, param3= R-00002, param4 = 4 ...
********************************************************************************************************************/
@RestResource(urlMapping='/CallShoppingListJSON/*')
global class APPIRIO_WSCallShoppingList_JSON {
	//Web Service Call for Shopping List
	@HttpGet
	webservice static void WebServiceCallShoppingList() {
        RestRequest req = RestContext.request;
        APPIRIO_WrapperUtility_JSON.ShoppingList responseResult = new APPIRIO_WrapperUtility_JSON.ShoppingList();
		APPIRIO_WrapperUtility_JSON.Error error;

		Publishing_API_User_Setting__c setting;
	    if(Publishing_API_User_Setting__c.getAll().size() > 0) {
			setting = Publishing_API_User_Setting__c.getAll().values()[0];
	    } else {
	    	error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('Publishing API User Setting is not defined', '');
    		responseResult.Error = error;
    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringForShoppingList(responseResult));
            return;
	    }

        String publishingapiuser = req.headers.get(setting.Name);
        if(String.isNotBlank(publishingapiuser) && publishingapiuser.equalsIgnoreCase(setting.API_Header_Value__c)) {
			map<String,String> paramMap = req.params;

	    	//input parameter
	    	String RecipeAPIExternalIDs = paramMap.get('RecipeAPIExternalIDs');

	    	if(RecipeAPIExternalIDs == null || RecipeAPIExternalIDs.trim() == '') {
	    		error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('Recipe APIExternalIDs cannot be blank.', '');
	    		responseResult.Error = error;
	    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringForShoppingList(responseResult));
            	return;
	        }

	        //input parameter
	        map<String,Integer> recipeAPIExternalIDServings = new map<String,Integer>();
	        for(String str :RecipeAPIExternalIDs.split(';')) {
	        	if(str.split('=').size() == 2 &&
	        							str.split('=')[0] != null && str.split('=')[0].trim() != '' &&
	        							str.split('=')[1] != null && str.split('=')[1].trim() != '') {
	        		recipeAPIExternalIDServings.put(str.split('=')[0].trim(),Integer.valueOf(str.split('=')[1].trim()));
	        	}
	    	}

	        //Place all Recipe__c objects contained within the result set into the XML template generated in APPIRIO_GenerateJSONShoppingList.
			APPIRIO_GenerateJSONShoppingList generateJSONShoppingList = new APPIRIO_GenerateJSONShoppingList();
	        generateJSONShoppingList.recipeAPIExternalIDServings = recipeAPIExternalIDServings;
	        responseResult = generateJSONShoppingList.generateJSONRecipeIinfo();
	        APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringForShoppingList(responseResult));
        	return;
		} else {
			error = APPIRIO_WrapperUtility_JSON.generateErrorResponse(setting.Message__c, '');
    		responseResult.Error = error;
    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringForShoppingList(responseResult));
        	return;
        }
    }

	//------------------------------------------------------------------------------------
    //Create a new class which will generate an JSON with Shopping List.
    //------------------------------------------------------------------------------------
    public class APPIRIO_GenerateJSONShoppingList {
		map<String,Integer> recipeAPIExternalIDServings;

		//private variable declaration
		private transient map<String, Convert_Measurements__c> mapConvertMeasurements;
		private map<String, String> mapOZTo5Mils;
		private map<String, String> mapMLToOZ;

	    //Constructor of calss APPIRIO_GenerateXMLRecipeIinfo
		public APPIRIO_GenerateJSONShoppingList() {
			recipeAPIExternalIDServings = new map<String,Integer>();

			mapOZTo5Mils = new map<String, String>();
			mapMLToOZ = new map<String, String>();
			mapConvertMeasurements = Convert_Measurements__c.getAll();

			//getting Convert Measurements values.
			for(String name :mapConvertMeasurements.keySet()) {
	      		Convert_Measurements__c convertMeasurements = mapConvertMeasurements.get(name);
	      		if(convertMeasurements != null) {
	      			mapOZTo5Mils.put(convertMeasurements.fl_Oz__c.trim(),convertMeasurements.X5Mils__c.trim());
					mapMLToOZ.put(convertMeasurements.mL__c.trim(),convertMeasurements.fl_Oz__c.trim());
	      		}
	      	}
		}

		//Generating an JSON with Recipe info.
		public APPIRIO_WrapperUtility_JSON.ShoppingList generateJSONRecipeIinfo() {
			map<String, String> mapDiageoIngredient_APIExternalID = new map<String, String>();
			map<String, String> mapDiageoIngredient_Locale = new map<String, String>();
			map<String, Decimal> mapDiageoIngredient_Unit_Quantity = new map<String, Decimal>();
			map<String, Decimal> mapNonDiageoIngredient_Unit_Quantity = new map<String, Decimal>();

			//Grabbing/getting all the details of the recipes that is already created.
			for(Recipe__c recipe :[SELECT API_External_ID__c, (select id, API_External_ID__c,Ingredient_Number__c, Quantity__c,Ingredient_Unit__c,Featured_Brand__c,
											Recipe_Diageo_Product__r.Name, Recipe_Diageo_Product__r.API_External_ID__c, Recipe_Diageo_Product__r.Locale__c,
	                                      	Recipe_Non_Diageo_Product__r.Name, Recipe_Non_Diageo_Product__r.API_External_ID__c, Recipe_Non_Diageo_Product__r.Locale__c
	                                      	from Diageo_Ingredients__r order by Ingredient_Number__c)
	                                      FROM Recipe__c WHERE API_External_ID__c IN :recipeAPIExternalIDServings.keySet() order by API_External_ID__c]) {

				string str;
				for(Diageo_Ingredient__c diageoIngredient: recipe.Diageo_Ingredients__r) {

		  			string diageoProduct;
		  			string diageoProductUnit;
		  			string unit = diageoIngredient.Ingredient_Unit__c;
		  			decimal quantity = decimal.valueOf(diageoIngredient.Quantity__c) * recipeAPIExternalIDServings.get(recipe.API_External_ID__c);

		  			if(diageoIngredient.Recipe_Diageo_Product__r.Name != null)
		  			 	diageoProduct = diageoIngredient.Recipe_Diageo_Product__r.Name;
		  			else if(diageoIngredient.Recipe_Non_Diageo_Product__r.Name != null)
		  			 	diageoProduct = diageoIngredient.Recipe_Non_Diageo_Product__r.Name;

		  			diageoProductUnit = diageoProduct.trim()+'__'+unit.trim();

		  			if(diageoIngredient.Recipe_Diageo_Product__r.Name != null) {

		  				mapDiageoIngredient_APIExternalID.put(diageoProductUnit, diageoIngredient.Recipe_Diageo_Product__r.API_External_ID__c);
		  				mapDiageoIngredient_Locale.put(diageoIngredient.Recipe_Diageo_Product__r.API_External_ID__c,diageoIngredient.Recipe_Diageo_Product__r.Locale__c+'');

		  			 	if(!mapDiageoIngredient_Unit_Quantity.containsKey(diageoProductUnit)) {
			  				mapDiageoIngredient_Unit_Quantity.put(diageoProductUnit, 0);
			  			}
			  			mapDiageoIngredient_Unit_Quantity.put(diageoProductUnit, mapDiageoIngredient_Unit_Quantity.get(diageoProductUnit) + quantity);

		  			} else if(diageoIngredient.Recipe_Non_Diageo_Product__r.Name != null) {

		  				mapDiageoIngredient_APIExternalID.put(diageoProductUnit, diageoIngredient.Recipe_Non_Diageo_Product__r.API_External_ID__c);
		  				mapDiageoIngredient_Locale.put(diageoIngredient.Recipe_Non_Diageo_Product__r.API_External_ID__c,diageoIngredient.Recipe_Non_Diageo_Product__r.Locale__c+'');

		  			 	if(!mapNonDiageoIngredient_Unit_Quantity.containsKey(diageoProductUnit)) {
			  				mapNonDiageoIngredient_Unit_Quantity.put(diageoProductUnit, 0);
			  			}
			  			mapNonDiageoIngredient_Unit_Quantity.put(diageoProductUnit, mapNonDiageoIngredient_Unit_Quantity.get(diageoProductUnit) + quantity);
		  			}
				}
			}

			string unit;
			string productName;

			//ShoppingList
			APPIRIO_WrapperUtility_JSON.ShoppingList shoppingList = new APPIRIO_WrapperUtility_JSON.ShoppingList();

			//diageoIngredients
			List<APPIRIO_WrapperUtility_JSON.DiageoIngredient> diageoIngredients = new List<APPIRIO_WrapperUtility_JSON.DiageoIngredient>();

			if(mapDiageoIngredient_Unit_Quantity.size() > 0) {
				for(string str :mapDiageoIngredient_Unit_Quantity.keySet()){
					productName = str.left(str.indexOf('__', 0));
					unit = str.replace(productName+'__','');
					//diageoIngredient
					APPIRIO_WrapperUtility_JSON.DiageoIngredient diageoIngredientElem = new APPIRIO_WrapperUtility_JSON.DiageoIngredient();
                    diageoIngredientElem.Id = ''+mapDiageoIngredient_APIExternalID.get(str);
                    diageoIngredientElem.Locale = ''+mapDiageoIngredient_Locale.get(mapDiageoIngredient_APIExternalID.get(str));
                    diageoIngredientElem.name = productName;
                    diageoIngredientElem.quantity = mapDiageoIngredient_Unit_Quantity.get(str)+'';
                    diageoIngredientElem.units = unit;

					diageoIngredients.add(diageoIngredientElem);
					//end of diageoIngredients
				}
			}
			if(diageoIngredients != null && diageoIngredients.size() > 0) {
            	shoppingList.diageoIngredients = diageoIngredients;
            }

			//shoppingList.diageoIngredients = diageoIngredients;
			//end of DiageoIngredients

			//otherIngredients
			List<APPIRIO_WrapperUtility_JSON.OtherIngredient> otherIngredients = new List<APPIRIO_WrapperUtility_JSON.OtherIngredient>();

			if(mapNonDiageoIngredient_Unit_Quantity.size() > 0) {
				for(string str :mapNonDiageoIngredient_Unit_Quantity.keySet()){
					productName = str.left(str.indexOf('__', 0));
					unit = str.replace(productName+'__','');
					//otherIngredient
					APPIRIO_WrapperUtility_JSON.OtherIngredient otherIngredientElem = new APPIRIO_WrapperUtility_JSON.OtherIngredient();
                    otherIngredientElem.Id = ''+mapDiageoIngredient_APIExternalID.get(str);
                    otherIngredientElem.Locale = ''+mapDiageoIngredient_Locale.get(mapDiageoIngredient_APIExternalID.get(str));
                    otherIngredientElem.name = productName;
                    otherIngredientElem.quantity = mapNonDiageoIngredient_Unit_Quantity.get(str)+'';
                    otherIngredientElem.units = unit;

					otherIngredients.add(otherIngredientElem);
					//end of otherIngredient
				}
			}
			if(otherIngredients != null && otherIngredients.size() > 0) {
            	shoppingList.otherIngredients = otherIngredients;
            }

			//shoppingList.otherIngredients = otherIngredients;
			//end of otherIngredients
			//end of shoppingList
			return shoppingList;
		}
	}
}