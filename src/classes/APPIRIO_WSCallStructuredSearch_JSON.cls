/********************************************************************************************************************
Name        : APPIRIO_WSCallStructuredSearch_JSON
Created By  : Appirio India(Rahul Mittal)
Date        : 28th Jan, 2014
Purpose     : Create Web Service Call for Structured Search and return response in JSON format.
Ref         : T-240640
********************************************************************************************************************/
@RestResource(urlMapping='/CallStructuredSearchJSON/*')
global class APPIRIO_WSCallStructuredSearch_JSON {

	//Web Service Call for Structured Search.
	@HttpGet
	webservice static void WebServiceCallStructuredSearch() {
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
			String KeyValues = paramMap.get('KeyValues');

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

			Integer offSet = resumePoint -1;
			List<Published_Recipe__c> lstPublishedRecipe = new List<Published_Recipe__c>();

			set<String> searchKeys = new set<String>();
			set<String> searchRecipeIds = new set<String>();
			set<String> searchBrandRecipeIds = new set<String>();
	        set<String> searchProductRecipeIds = new set<String>();
	        set<String> searchOccasionRecipeIds = new set<String>();
	        set<String> searchArributeRecipeIds = new set<String>();

	        if(KeyValues != null && KeyValues != '') {
		        for(String str :KeyValues.split(':')) {
		        	String key = str.split('=')[0];

		        	if(str.split('=')[1] == null) {
		        		error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('Values of key "'+key+'" cannot be blank.', '');
			    		responseResult.Error = error;
			            APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
            			return;
		        		//return 'Values of key "'+key+'" cannot be blank.';
		        	}

		        	set<String> values = new set<String>();
		        	for(String value :str.split('=')[1].split(';')) {
		        		values.add(value.trim());
		        	}

		        	if(key.equals('Brand') && values.size() > 0) {
		        		searchKeys.add('Brand');
		            	for(Recipe__c recipe :[select id from Recipe__c where id IN (select Recipe__c FROM Diageo_Ingredient__c Where Recipe_Brand__r.Name IN: values Or Recipe_Brand__r.API_External_ID__c IN: values)]) {
			            	searchBrandRecipeIds.add(recipe.Id);
			            }
		            } else if(key.equals('Product') && values.size() > 0) {
		            	searchKeys.add('Product');
		            	for(Recipe__c recipe :[select id from Recipe__c where id IN (select Recipe__c FROM Diageo_Ingredient__c Where Recipe_Diageo_Product__r.Name IN: values Or Recipe_Diageo_Product__r.API_External_ID__c IN: values)]) {
			            	searchProductRecipeIds.add(recipe.Id);
			            }
		            } else if(key.equals('Occasion') && values.size() > 0) {
		            	searchKeys.add('Occasion');
		            	for(Recipe__c recipe :[select id from Recipe__c where id IN (select Recipe__c from Recipe_Occasion__c where Occasion__r.Name_Of_The_Occasion__c IN: values Or Occasion__r.API_External_ID__c IN: values)]) {
			            	searchOccasionRecipeIds.add(recipe.Id);
			            }
		            } else {
		            	if(values.size() > 0)
		            		searchKeys.add('Arribute');
		            	for(Recipe__c recipe :[select id from Recipe__c where id IN (select Recipe__c from Recipe_Attribute__c where Attribute__r.Attribute_Type__c =:key And (Attribute__r.Attribute_Value__c IN: values Or Attribute__r.API_External_ID__c IN: values))]) {
			            	searchArributeRecipeIds.add(recipe.Id);
			            }
		            }
		        }

		        searchRecipeIds.add('TempRecipeId');
	            if(searchKeys.contains('Brand'))
	            	searchRecipeIds = matchRecipeIds(searchRecipeIds, searchBrandRecipeIds);
	            if(searchKeys.contains('Product'))
	            	searchRecipeIds = matchRecipeIds(searchRecipeIds, searchProductRecipeIds);
	            if(searchKeys.contains('Occasion'))
	            	searchRecipeIds = matchRecipeIds(searchRecipeIds, searchOccasionRecipeIds);
	            if(searchKeys.contains('Arribute'))
	            	searchRecipeIds = matchRecipeIds(searchRecipeIds, searchArributeRecipeIds);

		        totalRecords = searchRecipeIds.size();

		        //Query all Published_Recipe__c records where Asset__c = input parameter AND Status = Published.
		        lstPublishedRecipe = [Select Recipe__c From Published_Recipe__c
			                                                        Where Status__c = 'Published'
			                                                        And Recipe__r.recordSaved__c = true
			                                                        And Recipe__c IN :searchRecipeIds
			                                                        And Digital_Published_Asset__r.API_External_ID__c =:APIExternalID
			                                                        order by Recipe__r.API_External_ID__c limit 500 OFFSET :offSet];

	        } else {
	        	//Query all Published_Recipe__c records where Asset__c = input parameter AND Status = Published.
	        	totalRecords = [Select Count() From Published_Recipe__c
			                                                        Where Status__c = 'Published'
			                                                        And Recipe__r.recordSaved__c = true
			                                                        And Digital_Published_Asset__r.API_External_ID__c =:APIExternalID];

		        lstPublishedRecipe = [Select Recipe__c From Published_Recipe__c
			                                                        Where Status__c = 'Published'
			                                                        And Recipe__r.recordSaved__c = true
			                                                        And Digital_Published_Asset__r.API_External_ID__c =:APIExternalID
			                                                        order by Recipe__r.API_External_ID__c limit 500 OFFSET :offSet];
	        }

	        List<Id> recipeIds = new List<Id>();
			set<Id> setRcipeIds = new set<Id>();
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
	        //Return the JSON output.
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

	//-----------------------------------------------------------------------------------------
	//Method to generate JSON format response for Structured Search
	//-----------------------------------------------------------------------------------------
	static APPIRIO_WrapperUtility_JSON.Recipes generateJSON(String APIExternalID, List<Id> recipeIds,
																Integer resumePoint, Integer newResumePoint,
																Boolean endOfResponse) {
		List<Id> newRecipeIds;
		APPIRIO_GenerateXMLRecipeHeaderInfo_JSON generateJSONRecipeHeader = new APPIRIO_GenerateXMLRecipeHeaderInfo_JSON();

    	newRecipeIds = new List<Id>();
    	Integer cnt = 1;
    	for(Id recipeId :recipeIds) {
    		if(cnt <= (newResumePoint+1)) {
    			newRecipeIds.add(recipeId);
    		}
    		cnt = cnt+1;
    	}

        generateJSONRecipeHeader.recipeIds = newRecipeIds;
        generateJSONRecipeHeader.endOfResponse = endOfResponse;
        generateJSONRecipeHeader.resumePoint = resumePoint+newResumePoint+1;
    	if(endOfResponse)
    		generateJSONRecipeHeader.resumePoint = null;

        //Generate the JSON output.
        return generateJSONRecipeHeader.generateJSONRecipeIinfo();
	}

	//-----------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------
	static set<String> matchRecipeIds(set<String> recipeIds, set<String> filterIds) {
		if(recipeIds.contains('TempRecipeId')) {
			return filterIds;
		}
		if(recipeIds.size() == 0 || filterIds.size() == 0) {
			return (new set<String>());
		}
		for(String id : recipeIds) {
    		if(!filterIds.contains(id)) {
    			recipeIds.remove(id);
    		}
    	}
    	return recipeIds;
	}
}