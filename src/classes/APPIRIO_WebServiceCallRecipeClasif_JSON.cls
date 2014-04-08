/********************************************************************************************************************
Name        : APPIRIO_WebServiceCallRecipeClasif_JSON
Updated By  : Appirio Offshore(Rishi Khirbat)
Date        : 27th Jan, 2014
Purpose     : Write Web Service Call for Recipe Classifications
Ref         :
********************************************************************************************************************/
@RestResource(urlMapping='/CallRecipeClassificationsJSON/*')
global with sharing class APPIRIO_WebServiceCallRecipeClasif_JSON {
    //Web Service Call for Recipe Classifications
    @HttpGet
    webservice static void WebServiceCallRecipeClassification() {
        APPIRIO_WrapperUtility_JSON.RecipeClassifications responseResult = new APPIRIO_WrapperUtility_JSON.RecipeClassifications();
		APPIRIO_WrapperUtility_JSON.Error error;

        RestRequest req = RestContext.request;

        Publishing_API_User_Setting__c setting;
	    if(Publishing_API_User_Setting__c.getAll().size() > 0) {
	      setting = Publishing_API_User_Setting__c.getAll().values()[0];
	    } else {
	    	error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('Publishing API User Setting is not defined', '');
    		responseResult.Error = error;
    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringForRecipeClassifications(responseResult));
            return;
	    }

        String publishingapiuser = req.headers.get(setting.Name);
        if(String.isNotBlank(publishingapiuser) && publishingapiuser.equalsIgnoreCase(setting.API_Header_Value__c)) {

	        map<String,String> paramMap = req.params;

	        String key = paramMap.get('Key');
	        set<string> setAttributeType = new set<string>();

	        //recipeClassifications
	        //APPIRIO_WrapperUtility_JSON.RecipeClassifications  recipeClassifications = new APPIRIO_WrapperUtility_JSON.RecipeClassifications();
	        List<APPIRIO_WrapperUtility_JSON.RecipeClassification> lstRecipeClassification = new List<APPIRIO_WrapperUtility_JSON.RecipeClassification>();
	        APPIRIO_WrapperUtility_JSON.RecipeClassification recipeClassification;

	        if(key != null && key.trim() != '') {
	            for(Attribute__c attribute :[Select Attribute_Type__c From Attribute__c
	                                                                  Where Dynamic__c = false
	                                                                  And Attribute_Type__c =: key
	                                                                  order by Attribute_Type__c]) {
	                if(attribute.Attribute_Type__c != null && !setAttributeType.contains(attribute.Attribute_Type__c))  {
	                    setAttributeType.add(attribute.Attribute_Type__c);
	                    //recipeClassification
	                    recipeClassification = new APPIRIO_WrapperUtility_JSON.RecipeClassification();
	                    recipeClassification.AttributeType = attribute.Attribute_Type__c;
	                    lstRecipeClassification.add(recipeClassification);
	                    //end of recipeClassification
	                }
	            }

	            if(key.equals('Brand')) {
	                //recipeClassification
	                recipeClassification = new APPIRIO_WrapperUtility_JSON.RecipeClassification();
	                recipeClassification.AttributeType = 'Brand';
	                lstRecipeClassification.add(recipeClassification);
	                //end of recipeClassification
	            }

	            if(key.equals('Product')) {
	                //recipeClassification
	                recipeClassification = new APPIRIO_WrapperUtility_JSON.RecipeClassification();
	                recipeClassification.AttributeType = 'Product';
	                lstRecipeClassification.add(recipeClassification);
	                //end of recipeClassification
	            }

	            if(key.equals('Occasion')) {
	                //recipeClassification
	               	recipeClassification = new APPIRIO_WrapperUtility_JSON.RecipeClassification();
	                recipeClassification.AttributeType = 'Occasion';
	                lstRecipeClassification.add(recipeClassification);
	                //end of recipeClassification
	            }

	        } else {
	            for(Attribute__c attribute :[Select Attribute_Type__c From Attribute__c
	                                                                  Where Dynamic__c = false
	                                                                  order by Attribute_Type__c]) {
	                if(attribute.Attribute_Type__c != null && !setAttributeType.contains(attribute.Attribute_Type__c))  {
	                    setAttributeType.add(attribute.Attribute_Type__c);
	                    //recipeClassification
	                    recipeClassification = new APPIRIO_WrapperUtility_JSON.RecipeClassification();
	                    recipeClassification.AttributeType = attribute.Attribute_Type__c;
	                    lstRecipeClassification.add(recipeClassification);
	                    //end of recipeClassification
	                }
	            }
	            //recipeClassification
	            recipeClassification = new APPIRIO_WrapperUtility_JSON.RecipeClassification();
	            recipeClassification.AttributeType = 'Brand';
	            lstRecipeClassification.add(recipeClassification);
	            //end of recipeClassification

	            //recipeClassification
	            recipeClassification = new APPIRIO_WrapperUtility_JSON.RecipeClassification();
	            recipeClassification.AttributeType = 'Product';
	            lstRecipeClassification.add(recipeClassification);
	            //end of recipeClassification

	            //recipeClassification
	            recipeClassification = new APPIRIO_WrapperUtility_JSON.RecipeClassification();
	            recipeClassification.AttributeType = 'Occasion';
	            lstRecipeClassification.add(recipeClassification);
	            //end of recipeClassification
	        }
	        //end of recipeClassifications
	        if(lstRecipeClassification != null && lstRecipeClassification.size() > 0) {
	        	responseResult.RecipeClassifications = lstRecipeClassification;
	        }
	       	APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringForRecipeClassifications(responseResult));
            return;

		} else {
			error = APPIRIO_WrapperUtility_JSON.generateErrorResponse(setting.Message__c, '');
    		responseResult.Error = error;
    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringForRecipeClassifications(responseResult));
            return;
	    }
    }
}