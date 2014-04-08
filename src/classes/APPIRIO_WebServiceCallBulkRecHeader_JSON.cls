/********************************************************************************************************************
Name        : APPIRIO_WebServiceCallBulkRecHeader_JSON
Updated By  : Appirio India(Rahul Mittal)
Date        : 27th Jan, 2014
Purpose     : Create Web Service Call for Bulk Recipe header output.
Ref         : T-240636
********************************************************************************************************************/
@RestResource(urlMapping='/CallBulkRecipeHeaderJSON/*')
global with sharing class APPIRIO_WebServiceCallBulkRecHeader_JSON {

	//Web Service Call for Bulk Recipe header output
	@HttpGet
	webservice static void WebServiceCallBulkRecipeHeader() {
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
			Integer resumePoint=1;
			Boolean endOfResponse = true;
			String APIExternalID = paramMap.get('APIExternalID');
			String brandNames =  paramMap.get('brandNames');

			if(paramMap.get('resumePoint') != null && paramMap.get('resumePoint').trim() != ''){
				resumePoint = Integer.valueOf(paramMap.get('resumePoint'));
			}

			if(APIExternalID == null || APIExternalID.trim() == '') {
				error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('APIExternalID cannot be blank.', '');
	    		responseResult.Error = error;
	    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
            	return;
	        }

			if(resumePoint == null || resumePoint == 0) {
				resumePoint = 1;
			}

	        set<Id> setRcipeIds = new set<Id>();
	        List<Id> recipeIds = new List<Id>();
	        //String userRole = [SELECT UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()].UserRole.Name;
	        //Query all Published_Recipe__c records where Asset__c = input parameter AND Status = Published.
	        for(Published_Recipe__c publishedRecipe :[Select Recipe__c From Published_Recipe__c
	        											Where Status__c = 'Published'
	        											And Recipe__r.recordSaved__c = true
	        											And Digital_Published_Asset__r.API_External_ID__c =:APIExternalID
	        											order by Recipe__r.API_External_ID__c]) {

	        	if(!setRcipeIds.contains(publishedRecipe.Recipe__c)) {
	        		//Only Admins can see Archived Recipes
					//if (!userRole.equals('Recipe - Admin') && publishedRecipe.Recipe__r.Status__c.equals('Archive')) {
					//} else {
						recipeIds.add(publishedRecipe.Recipe__c);
					//}
	        		setRcipeIds.add(publishedRecipe.Recipe__c);
	        	}
	        }

	        set<String> bNames = new set<String>();
	        if(brandNames != null && brandNames.trim() != '') {
	        	for(String str :brandNames.split(';')) {
	        		bNames.add(str.trim());
	        	}
	        }

	        List<Id> featuredBrandRcipeIds;
	        //IF the brand parameter is provided, filter the result set down to only Recipe__c where Featured brand contains the query string.
	        if(bNames != null && bNames.size() > 0) {
	        	featuredBrandRcipeIds = new List<Id>();
	        	setRcipeIds = new set<Id>();
	        	for(Diageo_Ingredient__c featuredBrandRcipe :[Select Recipe__c From Diageo_Ingredient__c
	        													Where Featured_Brand__c = true
	        													And Recipe__r.recordSaved__c = true
	        													And Recipe_Brand__r.Name IN :bNames
	        													And Recipe__c IN :recipeIds
	        													order by Recipe__r.API_External_ID__c]) {

	        		if(!setRcipeIds.contains(featuredBrandRcipe.Recipe__c)) {
	            		featuredBrandRcipeIds.add(featuredBrandRcipe.Recipe__c);
	            		setRcipeIds.add(featuredBrandRcipe.Recipe__c);
	            	}
	        	}
	        }

	        recipeIds = featuredBrandRcipeIds != null ? featuredBrandRcipeIds : recipeIds;

	        setRcipeIds = null;
	        featuredBrandRcipeIds = null;

	        Integer newResumePoint = 499;

	        if((resumePoint+newResumePoint) < recipeIds.size()) {
				endOfResponse = false;
			}
        	APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(generateJSON(APIExternalID, recipeIds, resumePoint, newResumePoint, endOfResponse)));
        	return;
        }else {
        	error = APPIRIO_WrapperUtility_JSON.generateErrorResponse(setting.Message__c, '');
    		responseResult.Error = error;
    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
        	return;
        }
	}

	static APPIRIO_WrapperUtility_JSON.Recipes generateJSON(String APIExternalID, List<Id> recipeIds, Integer resumePoint, Integer newResumePoint, Boolean endOfResponse) {
		List<Id> newRecipeIds;
		//Place all Recipe__c objects contained within the result set into the XML template generated in T-104967.
		APPIRIO_GenerateXMLRecipeHeaderInfo_JSON generateXMLRecipeHeaderInfo = new APPIRIO_GenerateXMLRecipeHeaderInfo_JSON();

    	newRecipeIds = new List<Id>();
    	Integer cnt = 1;
    	for(Id recipeId :recipeIds) {
    		if(resumePoint <= cnt && cnt <= (resumePoint+newResumePoint)) {
    			newRecipeIds.add(recipeId);
    		}
    		cnt = cnt+1;
    	}

        generateXMLRecipeHeaderInfo.recipeIds = newRecipeIds;
        generateXMLRecipeHeaderInfo.endOfResponse = endOfResponse;
        generateXMLRecipeHeaderInfo.resumePoint = resumePoint+newResumePoint+1;
    	if(endOfResponse)
    		generateXMLRecipeHeaderInfo.resumePoint = null;

        //Generate the XML output.
        APPIRIO_WrapperUtility_JSON.Recipes recipesResult = generateXMLRecipeHeaderInfo.generateJSONRecipeIinfo();

        return recipesResult;
	}
}