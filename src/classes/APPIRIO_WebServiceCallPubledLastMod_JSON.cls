/********************************************************************************************************************
Name        : APPIRIO_WebServiceCallPubledLastMod_JSON
Created By  : Appirio India(Rahul Mittal)
Date        : 24th Jan, 2014
Purpose     : T-240637
********************************************************************************************************************/
@RestResource(urlMapping='/CallPubledLastModifiedJSON/*')
global with sharing class APPIRIO_WebServiceCallPubledLastMod_JSON {
	//Web Service Call for Published Status Last modified Date
	@HttpGet
	webservice static void WebServiceCallPublishedLastModified() {
	    RestRequest req = RestContext.request;

	    Publishing_API_User_Setting__c setting;
	    if(Publishing_API_User_Setting__c.getAll().size() > 0) {
	      setting = Publishing_API_User_Setting__c.getAll().values()[0];
	    } else {
	    	APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(APPIRIO_WrapperUtility_JSON.getErrorMessage('Publishing API User Setting is not defined')));
            return;
	    }

        String publishingapiuser = req.headers.get(setting.Name);
        if(String.isNotBlank(publishingapiuser) && publishingapiuser.equalsIgnoreCase(setting.API_Header_Value__c)) {
        	map<String,String> paramMap = req.params;

		    //input parameter
			Integer totalRecords = 0;
			Boolean endOfResponse = true;
			Integer resumePoint=1;
			Integer year;
			Integer month;
			Integer day;
			Date lastModified;

			String APIExternalID = paramMap.get('APIExternalID');
			if(APIExternalID == null || APIExternalID.trim() == '') {
				APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(APPIRIO_WrapperUtility_JSON.getErrorMessage('APIExternalID cannot be blank.')));
            	return;
			}

			if(paramMap.get('year') != null) {
				year = Integer.valueOf(paramMap.get('year'));
			}
			if(paramMap.get('month') != null) {
				month = Integer.valueOf(paramMap.get('month'));
			}
			if(paramMap.get('day') != null) {
				day = Integer.valueOf(paramMap.get('day'));
			}

			if(year == null || month == null || day == null) {
				APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(APPIRIO_WrapperUtility_JSON.getErrorMessage('Last modified date cannot be invalid or blank.')));
            	return;
			}

			lastModified = date.newInstance(year, month, day);

			if(lastModified == null) {
				APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(APPIRIO_WrapperUtility_JSON.getErrorMessage('Last modified date is not valid.')));
            	return;
			}

			if(paramMap.get('resumePoint') != null && paramMap.get('resumePoint').trim() != null){
				resumePoint = Integer.valueOf(paramMap.get('resumePoint'));
			}
			if(resumePoint == null || resumePoint == 0) {
				resumePoint = 1;
		    }

			totalRecords = [Select Count()
								From Published_Recipe__c
								Where Recipe__r.recordSaved__c = true
								And LastModifiedDate >= :lastModified
								And Digital_Published_Asset__r.API_External_ID__c =:APIExternalID];

			Integer offSet = resumePoint -1;
			set<Id> setRcipeIds = new set<Id>();
			List<Id> recipeIds = new List<Id>();
			//Query all Published_Recipe__c records where Asset__c = input parameter AND LastModifiedDate >= lastModified.
			List<Published_Recipe__c> lstPublishedRecipe = [Select Recipe__c From Published_Recipe__c
		                                                          	Where Recipe__r.recordSaved__c = true
																	And LastModifiedDate >= :lastModified
																	And Digital_Published_Asset__r.API_External_ID__c =:APIExternalID
		                                                          	order by Recipe__r.API_External_ID__c limit 500 OFFSET :offSet];

		    for(Published_Recipe__c publishedRecipe :lstPublishedRecipe) {
				if(!setRcipeIds.contains(publishedRecipe.Recipe__c)) {
					recipeIds.add(publishedRecipe.Recipe__c);
					setRcipeIds.add(publishedRecipe.Recipe__c);
				}
			}

			setRcipeIds = null;
			lstPublishedRecipe = null;
			Integer newResumePoint = 499;

			if((resumePoint+newResumePoint) < totalRecords) {
				endOfResponse = false;
		    }

			APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(generateJSON(APIExternalID, recipeIds, resumePoint, newResumePoint, endOfResponse)));
        	return;
		} else {
        	APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(APPIRIO_WrapperUtility_JSON.getErrorMessage(setting.Message__c)));
        	return;
        }
	}

	//--------------------------------------------------------------------------------------------------------
	// Method to get response in json format
	//--------------------------------------------------------------------------------------------------------
    static APPIRIO_WrapperUtility_JSON.Recipes generateJSON(String APIExternalID, List<Id> recipeIds, Integer resumePoint, Integer newResumePoint, Boolean endOfResponse) {
		List<Id> newRecipeIds;
		//Place all Recipe__c objects contained within the result set into the XML template generated in T-104967.
		APPIRIO_GenXMLRecipeLstModifiedInfo_JSON generateXMLRecipeLstModifiedInfo = new APPIRIO_GenXMLRecipeLstModifiedInfo_JSON();
		generateXMLRecipeLstModifiedInfo.digitalPublishedAssetIds.add(APIExternalID);

		newRecipeIds = new List<Id>();
		Integer cnt = 1;
		for(Id recipeId :recipeIds) {
			if(cnt <= (newResumePoint+1)) {
				newRecipeIds.add(recipeId);
			}
			cnt = cnt+1;
		}

		generateXMLRecipeLstModifiedInfo.recipeIds = newRecipeIds;
		generateXMLRecipeLstModifiedInfo.endOfResponse = endOfResponse;
		generateXMLRecipeLstModifiedInfo.resumePoint = resumePoint+newResumePoint+1;
		if(endOfResponse)
			generateXMLRecipeLstModifiedInfo.resumePoint = null;

		//Generate the JSON output.
		APPIRIO_WrapperUtility_JSON.Recipes recipesResult = generateXMLRecipeLstModifiedInfo.generateJSONRecipeIinfo();
		return recipesResult;
    }
}