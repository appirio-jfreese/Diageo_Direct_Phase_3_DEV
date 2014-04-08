/********************************************************************************************************************
Name        : APPIRIO_WebServiceCallIndividualRec_JSON
Updated By  : Appirio India(Rahul Mittal)
Date        : 27th Jan, 2014
Purpose     : Create Web Service Call for Individual Recipe output.
Ref         : T-240638
********************************************************************************************************************/
@RestResource(urlMapping='/CallIndividualRecipeJSON/*')
global class APPIRIO_WebServiceCallIndividualRec_JSON {

    //Creating Web Service Call for Individual Recipe output.
    @HttpGet
    webservice static void WebServiceCallIndividualRecipe(){
        APPIRIO_WrapperUtility_JSON.Recipes responseResult = new APPIRIO_WrapperUtility_JSON.Recipes();
        APPIRIO_WrapperUtility_JSON.Error error;
        try{
            RestRequest req = RestContext.request;
            Publishing_API_User_Setting__c setting;
            if(Publishing_API_User_Setting__c.getAll().size() > 0) {
              setting = Publishing_API_User_Setting__c.getAll().values()[0];
            } else {
                error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('Publishing API User Setting is not defined', '');
                responseResult.Error = error;
                APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
                return;
            }

            String publishingapiuser = req.headers.get(setting.Name);
            if(String.isNotBlank(publishingapiuser) && publishingapiuser.equalsIgnoreCase(setting.API_Header_Value__c)) {
                map<String,String> paramMap = req.params;
                //input parameter
                String APIExternalID = paramMap.get('APIExternalID');
                String RecipeAPIExternalID = paramMap.get('RecipeAPIExternalID');

                if(APIExternalID == null || APIExternalID.trim() == '') {
                    error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('APIExternalID cannot be blank.', '');
                    responseResult.Error = error;
                    APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
                	return;
                }
                if(RecipeAPIExternalID == null || RecipeAPIExternalID.trim() == '') {
                    error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('Recipe APIExternalID cannot be blank.', '');
                    responseResult.Error = error;
                    APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
                	return;
                }

                List<Id> recipeIds = new List<Id>();
                //Query all Published_Recipe__c records where Asset__c = input parameter AND Status = Published
                //AND Recipe__c.API_External_ID__c = RecipeAPIExternalID input parameter.
                /*
                for(Published_Recipe__c publishedRecipe :[Select Recipe__c From Published_Recipe__c
                                                            Where Status__c = 'Published'
                                                            And Digital_Published_Asset__c =:APIExternalID
                                                            And Recipe__r.API_External_ID__c =:RecipeAPIExternalID]) {
                    recipeIds.add(publishedRecipe.Recipe__c);
                }*/

                //Note: (Ref:S-81938) By "Will Price on 2nd Jan 2013"
                //"Please remove the check for whether the recipe is published for an Asset.
                //The single input parameter will be the Recipe API External ID, and the matching recipe will always be returned."
                //Query Recipe__c record where API_External_ID__c = input parameter.
                for(Recipe__c recipe :[Select Id From Recipe__c Where API_External_ID__c =:RecipeAPIExternalID order by API_External_ID__c]) {
                    recipeIds.add(recipe.Id);
                }

                //Place all Recipe__c objects contained within the result set into the XML template generated in T-104967.
                APPIRIO_GenerateXMLRecipeIinfo_JSON generateXMLRecipeIinfo = new APPIRIO_GenerateXMLRecipeIinfo_JSON();
                generateXMLRecipeIinfo.digitalPublishedAssetIds.add(APIExternalID);
                generateXMLRecipeIinfo.recipeIds = recipeIds;
                generateXMLRecipeIinfo.endOfResponse = true;
                //Generate the JSON output.
                APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(generateXMLRecipeIinfo.generateJSONRecipeIinfo()));
            	return;
            } else {
                error = APPIRIO_WrapperUtility_JSON.generateErrorResponse(setting.Message__c, '');
                responseResult.Error = error;
                APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
            	return;
            }
        }catch(Exception ex){
            error = APPIRIO_WrapperUtility_JSON.generateErrorResponse(ex.getMessage(), '');
            responseResult.Error = error;
			APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
        	return;
        }
    }
}