/********************************************************************************************************************
Name        : APPIRIO_WebServiceCallBulkRecipe_JSON
Created By  : Appirio India(Rahul Mittal)
Date        : 26th Jan, 2014
Purpose     : Create Web Service Call for bulk recipes and return response in JSON format.
Ref         : T-239639
********************************************************************************************************************/
@RestResource(urlMapping='/CallBulkRecipeJSON/*')
global class APPIRIO_WebServiceCallBulkRecipe_JSON {

    //Creating Web Service Call for Bulk Recipe output
    @HttpGet
    webservice static void WebServiceCallBulkRecipe() {
        RestRequest req = RestContext.request;
		APPIRIO_WrapperUtility_JSON.Recipes responseResult = new APPIRIO_WrapperUtility_JSON.Recipes();
		APPIRIO_WrapperUtility_JSON.Error error;

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
          Integer totalRecords = 0;
          Integer resumePoint = 1;
          Boolean endOfResponse = true;
          String APIExternalID = paramMap.get('APIExternalID');

          if(APIExternalID == null || APIExternalID.trim() == '') {
            error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('APIExternalID cannot be blank.', '');
    		responseResult.Error = error;
    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
        	return;
          }

          if(paramMap.get('resumePoint') != null && paramMap.get('resumePoint').trim() != null){
              resumePoint = Integer.valueOf(paramMap.get('resumePoint'));
          }

          if(resumePoint == null || resumePoint == 0) {
              resumePoint = 1;
          }

          totalRecords = [Select Count() From Published_Recipe__c
                                              Where Status__c = 'Published'
                                              And Recipe__r.recordSaved__c = true
                                              And Digital_Published_Asset__r.API_External_ID__c =:APIExternalID];

          Integer offSet = resumePoint -1;
          set<Id> setRcipeIds = new set<Id>();
          List<Id> recipeIds = new List<Id>();
          //Query all Published_Recipe__c records where Asset__c = input parameter AND Status = Published.
          List<Published_Recipe__c> lstPublishedRecipe = [Select Recipe__c From Published_Recipe__c
                                                              Where Status__c = 'Published'
                                                              And Recipe__r.recordSaved__c = true
                                                              And Digital_Published_Asset__r.API_External_ID__c =:APIExternalID
                                                              order by Recipe__r.API_External_ID__c limit 400 OFFSET :offSet];

          for(Published_Recipe__c publishedRecipe :lstPublishedRecipe) {
              if(!setRcipeIds.contains(publishedRecipe.Recipe__c)) {
                  recipeIds.add(publishedRecipe.Recipe__c);
                  setRcipeIds.add(publishedRecipe.Recipe__c);
              }
          }

          setRcipeIds = null;
          lstPublishedRecipe = null;
          Integer newResumePoint = 299;

          if((resumePoint+newResumePoint) < totalRecords) {
              endOfResponse = false;
          }

			responseResult = generateJSON(APIExternalID, recipeIds, resumePoint, newResumePoint, endOfResponse);
			APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
        	return;
        } else {
        	error = APPIRIO_WrapperUtility_JSON.generateErrorResponse(setting.Message__c, '');
    		responseResult.Error = error;
    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
            return;
        }
    }

    static APPIRIO_WrapperUtility_JSON.Recipes generateJSON(String APIExternalID, List<Id> recipeIds,
	    														Integer resumePoint, Integer newResumePoint,
	    														Boolean endOfResponse) {
        List<Id> newRecipeIds;
        APPIRIO_GenerateXMLRecipeIinfo_JSON generateXMLRecipeIinfo = new APPIRIO_GenerateXMLRecipeIinfo_JSON();
        generateXMLRecipeIinfo.digitalPublishedAssetIds.add(APIExternalID);

        newRecipeIds = new List<Id>();
        Integer cnt = 1;
        for(Id recipeId :recipeIds) {
            if(cnt <= (newResumePoint+1)) {
                newRecipeIds.add(recipeId);
            }
            cnt = cnt+1;
        }
        generateXMLRecipeIinfo.recipeIds = newRecipeIds;
        generateXMLRecipeIinfo.endOfResponse = endOfResponse;

        generateXMLRecipeIinfo.resumePoint = resumePoint+newResumePoint+1;
        if(endOfResponse)
            generateXMLRecipeIinfo.resumePoint = null;

        //Generate the JSON output.
        return generateXMLRecipeIinfo.generateJSONRecipeIinfo();
    }
}