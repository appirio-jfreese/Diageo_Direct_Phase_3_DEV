/********************************************************************************************************************
Name        : APPIRIO_WebServiceCallRecpClasifDtl_JSON
Updated By  : Appirio Offshore(Rishi Khirbat)
Date        : 27th Jan, 2014
Purpose     : Create Web Service Call for Recipe Classifications & Values
Ref         :
********************************************************************************************************************/
@RestResource(urlMapping='/CallRecipeClassificationDetailsJSON/*')
global with sharing class APPIRIO_WebServiceCallRecpClasifDtl_JSON {
	//Web Service Call for Recipe Classifications & Values
	@HttpGet
	webservice static void WebServiceCallRecipeClassificationDetails() {
		APPIRIO_WrapperUtility_JSON.RecipeClassificationsDtl responseResult = new APPIRIO_WrapperUtility_JSON.RecipeClassificationsDtl();
		APPIRIO_WrapperUtility_JSON.Error error;

		RestRequest req = RestContext.request;

		Publishing_API_User_Setting__c setting;
	    if(Publishing_API_User_Setting__c.getAll().size() > 0) {
	      setting = Publishing_API_User_Setting__c.getAll().values()[0];
	    } else {
	    	error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('Publishing API User Setting is not defined', '');
    		responseResult.Error = error;
    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringForRecipeClassificationsDtl(responseResult));
            return;
	    }

        String publishingapiuser = req.headers.get(setting.Name);
        if(String.isNotBlank(publishingapiuser) && publishingapiuser.equalsIgnoreCase(setting.API_Header_Value__c)) {

			map<String,String> paramMap = req.params;

			string xmlString;
			String key = paramMap.get('Key');
			map<string,List<Attribute__c>> setAttributeDetails = new map<string,List<Attribute__c>>();

			if(key != null && key.trim() != '') {
				for(Attribute__c attribute :[Select Attribute_Type__c, Attribute_value__c, API_External_ID__c, Locale__c From Attribute__c
														Where Dynamic__c = false
														And Attribute_Type__c =: key
														order by Attribute_Type__c, Attribute_value__c]) {

					if(attribute.Attribute_Type__c != null) {
						if(!setAttributeDetails.containsKey(attribute.Attribute_Type__c)){
							setAttributeDetails.put(attribute.Attribute_Type__c, new List<Attribute__c>());
						}
						if(attribute.Attribute_value__c != null)
							setAttributeDetails.get(attribute.Attribute_Type__c).add(attribute);
					}
				}
			} else {
				for(Attribute__c attribute :[Select Attribute_Type__c, Attribute_value__c, API_External_ID__c, Locale__c From Attribute__c
														Where Dynamic__c = false order by Attribute_Type__c, Attribute_value__c]) {

					if(attribute.Attribute_Type__c != null) {
						if(!setAttributeDetails.containsKey(attribute.Attribute_Type__c)){
							setAttributeDetails.put(attribute.Attribute_Type__c, new List<Attribute__c>());
						}
						if(attribute.Attribute_value__c != null)
							setAttributeDetails.get(attribute.Attribute_Type__c).add(attribute);
					}
				}
			}

			//recipeClassifications
	        //APPIRIO_WrapperUtility_JSON.RecipeClassificationsDtl  recipeClassificationsDtl = new APPIRIO_WrapperUtility_JSON.RecipeClassificationsDtl();
	        List<APPIRIO_WrapperUtility_JSON.RecipeClassificationDtl> lstRecipeClassificationDtl = new List<APPIRIO_WrapperUtility_JSON.RecipeClassificationDtl>();
	        APPIRIO_WrapperUtility_JSON.RecipeClassificationDtl recipeClassificationDtl;

			//---Attribute--//
			for(string ky :setAttributeDetails.keySet()) {
				//recipeClassification
				//key
				recipeClassificationDtl = new APPIRIO_WrapperUtility_JSON.RecipeClassificationDtl();
                recipeClassificationDtl.key = ky;
                recipeClassificationDtl.Values = new List<APPIRIO_WrapperUtility_JSON.Value>();
                //end of key
				for(Attribute__c attribute :setAttributeDetails.get(ky)) {
					APPIRIO_WrapperUtility_JSON.Value value = new APPIRIO_WrapperUtility_JSON.Value();
					value.Id = attribute.API_External_ID__c;
                    value.Locale = attribute.Locale__c;
                    value.Name = String.valueOf(attribute.Attribute_value__c);
                    value.Type = String.valueOf(attribute.Attribute_Type__c);
                    recipeClassificationDtl.Values.add(value);
				}
				lstRecipeClassificationDtl.add(recipeClassificationDtl);
				//end of recipeClassification
			}

			Boolean display = true;
			if(key != null && key.trim() != '') {
				display = key.equals('Occasion') ? true : false;
			} else {
				display = true;
			}

			if(display) {
				//---Occasion--//
				//recipeClassification
				//key
				recipeClassificationDtl = new APPIRIO_WrapperUtility_JSON.RecipeClassificationDtl();
                recipeClassificationDtl.key = 'Occasion';
                //end of key
                recipeClassificationDtl.Values = new List<APPIRIO_WrapperUtility_JSON.Value>();
				for(Occasion__c occasion :[Select Name_Of_The_Occasion__c, API_External_ID__c, Locale__c, Occasion_Tags__c, Occasion_Type__c From Occasion__c order by Name_Of_The_Occasion__c]) {
					APPIRIO_WrapperUtility_JSON.Value value = new APPIRIO_WrapperUtility_JSON.Value();
					value.Id = occasion.API_External_ID__c;
                    value.Locale = occasion.Locale__c;
                    value.Name = occasion.Name_Of_The_Occasion__c;
                    value.Type = occasion.Occasion_Type__c;
                    value.Tags = occasion.Occasion_Tags__c;
                    recipeClassificationDtl.Values.add(value);
				}
				lstRecipeClassificationDtl.add(recipeClassificationDtl);
				//end of recipeClassification
			}


			if(key != null && key.trim() != '') {
				display = key.equals('Brand') ? true : false;
			} else {
				display = true;
			}

			if(display) {
				//---Brand--//
				//recipeClassification
				//key
				recipeClassificationDtl = new APPIRIO_WrapperUtility_JSON.RecipeClassificationDtl();
                recipeClassificationDtl.key = 'Brand';
                //end of key
                recipeClassificationDtl.Values = new List<APPIRIO_WrapperUtility_JSON.Value>();
				for(Diageo_Brand__c brand :[Select Name, API_External_ID__c, Locale__c, Category__c From Diageo_Brand__c order by Name]) {
					APPIRIO_WrapperUtility_JSON.Value value = new APPIRIO_WrapperUtility_JSON.Value();
					value.Id = brand.API_External_ID__c;
                    value.Locale = brand.Locale__c;
                    value.Name = brand.Name;
                    value.Category = brand.Category__c;
                    recipeClassificationDtl.Values.add(value);
				}
				lstRecipeClassificationDtl.add(recipeClassificationDtl);
				//end of recipeClassification
			}

			if(key != null && key.trim() != '') {
				display = key.equals('Product') ? true : false;
			} else {
				display = true;
			}

			if(display) {
				//---Product--//
				//recipeClassification
				//key
				recipeClassificationDtl = new APPIRIO_WrapperUtility_JSON.RecipeClassificationDtl();
                recipeClassificationDtl.key = 'Product';
                //end of key
                recipeClassificationDtl.Values = new List<APPIRIO_WrapperUtility_JSON.Value>();
				for(Diageo_Product__c product :[Select Name, API_External_ID__c, Locale__c, Category__c, Diageo_Brand_Id__r.API_External_ID__c From Diageo_Product__c order by Name]) {
					APPIRIO_WrapperUtility_JSON.Value value = new APPIRIO_WrapperUtility_JSON.Value();
					value.Id = product.API_External_ID__c;
                    value.Locale = product.Locale__c;
                    value.Name = product.Name;
                    value.Category = product.Category__c;
                    value.BrandId = product.Diageo_Brand_Id__r.API_External_ID__c;
                    recipeClassificationDtl.Values.add(value);
				}
				lstRecipeClassificationDtl.add(recipeClassificationDtl);
				//end of recipeClassification
			}

			if(lstRecipeClassificationDtl != null && lstRecipeClassificationDtl.size() > 0) {
	        	responseResult.RecipeClassificationDetails = lstRecipeClassificationDtl;
	        }

			//responseResult.RecipeClassificationDetails = lstRecipeClassificationDtl;
    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringForRecipeClassificationsDtl(responseResult));
            return;
        } else {
        	error = APPIRIO_WrapperUtility_JSON.generateErrorResponse(setting.Message__c, '');
    		responseResult.Error = error;
    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringForRecipeClassificationsDtl(responseResult));
            return;
	    }
	}
}