/********************************************************************************************************************
Name        : APPIRIO_WebServiceCallKeywordSearch_JSON
Updated By  : Appirio India(Rahul Mittal)
Date        : 27th Jan, 2014
Purpose     : Create Web Service Call for Keyword Search.
Ref         : T-240639
********************************************************************************************************************/
@RestResource(urlMapping='/CallKeywordSearchJSON/*')
global with sharing class APPIRIO_WebServiceCallKeywordSearch_JSON {
	//Web Service Call for Keyword Search.
	@HttpGet
	webservice static void WebServiceCallKeywordSearch() {
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
			Integer resumePoint;
			Boolean endOfResponse = true;
			String APIExternalID = paramMap.get('APIExternalID');
			String searchKeyword = paramMap.get('searchKeyword');

			if(searchKeyword == null || searchKeyword.trim() == '') {
	        	error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('Keyword Search cannot be blank.', '');
	    		responseResult.Error = error;
	    		APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
            	return;
	        }

			if(paramMap.get('resumePoint') != null){
				resumePoint = Integer.valueOf(paramMap.get('resumePoint'));
			}

			if(ResumePoint == null || ResumePoint == 0) {
				resumePoint = 1;
			}

	        searchKeyword = String.escapeSingleQuotes(searchKeyword);
	        String brandSearchTerm = searchKeyword.replace(' ','%');
		    searchKeyword = searchKeyword.replace('*','\\*');

		    String sa ='%'+brandSearchTerm+'%';
		    String st = '%'+searchKeyword+'%';

	        List<String> temp = new List<String>();
	        map<String,Id> searchKeywordRecipeIds = new map<String,Id>();

	        String query = 'select Id, API_External_ID__c from Recipe__c where recordSaved__c=true And (Recipe_Title__c like \'%'+searchKeyword+'%\' or Status__c like \'%'+searchKeyword+'%\' or Recipe_Tag__c like \'%'+searchKeyword+'%\') order by API_External_ID__c';
	        //for(Recipe__c recipe :[select id from Recipe__c where Recipe_Title__c like :st or Status__c like :st or Recipe_Tag__c like :st]) {
	        for(Recipe__c recipe :(List<Recipe__c>)Database.query(query)) {
	        	searchKeywordRecipeIds.put(recipe.API_External_ID__c, recipe.Id);
	        	temp.add(recipe.API_External_ID__c);
	        }

	        query = 'select Id, API_External_ID__c from Recipe__c where id IN (select Recipe__c from Recipe_Attribute__c where Recipe__r.recordSaved__c = true And Attribute__r.Attribute_Value__c like \'%'+searchKeyword+'%\') order by API_External_ID__c';
	        //for(Recipe__c recipe :[select id from Recipe__c where id IN (select Recipe__c from Recipe_Attribute__c where Attribute__r.Attribute_Value__c like:st)]) {
	        for(Recipe__c recipe :(List<Recipe__c>)Database.query(query)) {
	        	searchKeywordRecipeIds.put(recipe.API_External_ID__c, recipe.Id);
	        	temp.add(recipe.API_External_ID__c);
	        }

	        query = 'select Id, API_External_ID__c from Recipe__c where id IN (select Recipe__c from Recipe_Occasion__c where Recipe__r.recordSaved__c = true And (Occasion__r.Name_Of_The_Occasion__c like \'%'+searchKeyword+'%\' or Occasion__r.Occasion_Type__c like \'%'+searchKeyword+'%\'))  order by API_External_ID__c';
	        //for(Recipe__c recipe :[select id from Recipe__c where id IN (select Recipe__c from Recipe_Occasion__c where Occasion__r.Name_Of_The_Occasion__c like:st or Occasion__r.Occasion_Type__c like:st)]) {
	        for(Recipe__c recipe :(List<Recipe__c>)Database.query(query)) {
	        	searchKeywordRecipeIds.put(recipe.API_External_ID__c, recipe.Id);
	        	temp.add(recipe.API_External_ID__c);
	        }

	        query = 'select Id, API_External_ID__c from Recipe__c where id IN (Select Recipe__c from Preparation_Step__c where Recipe__r.recordSaved__c = true And Description__c like \'%'+searchKeyword+'%\')  order by API_External_ID__c';
	        //for(Recipe__c recipe :[select id from Recipe__c where id IN (Select Recipe__c from Preparation_Step__c where Description__c like :st)]) {
	        for(Recipe__c recipe :(List<Recipe__c>)Database.query(query)) {
	        	searchKeywordRecipeIds.put(recipe.API_External_ID__c, recipe.Id);
	        	temp.add(recipe.API_External_ID__c);
	        }

	        query = 'select Id, API_External_ID__c from Recipe__c where id IN (select Recipe__c FROM Diageo_Ingredient__c Where Recipe__r.recordSaved__c = true And (Recipe_Diageo_Product__r.Name like \'%'+searchKeyword+'%\' or Recipe_Non_Diageo_Product__r.Name like \'%'+searchKeyword+'%\' or Recipe_Diageo_Product__r.Short_Description__c like \'%'+searchKeyword+'%\' or Recipe_Brand__r.Short_Description__c like \'%'+searchKeyword+'%\'))  order by API_External_ID__c';
	        //for(Recipe__c recipe :[select id from Recipe__c where id IN (select Recipe__c FROM Diageo_Ingredient__c Where Recipe_Diageo_Product__r.Name like :sa or Recipe_Non_Diageo_Product__r.Name like :sa or Recipe_Diageo_Product__r.Short_Description__c like :st or Recipe_Brand__r.Short_Description__c like :st)]) {
	        for(Recipe__c recipe :(List<Recipe__c>)Database.query(query)) {
	        	searchKeywordRecipeIds.put(recipe.API_External_ID__c, recipe.Id);
	        	temp.add(recipe.API_External_ID__c);
	        }

	        set<Id> setRcipeIds = new set<Id>();
	        List<Id> recipeIds = new List<Id>();

	        if(APIExternalID == null || APIExternalID.trim() == '') {
	        	temp.sort();
	        	setRcipeIds = new set<Id>();
	        	for(String str :temp) {
	        		if(!setRcipeIds.contains(searchKeywordRecipeIds.get(str))) {
		        		recipeIds.add(searchKeywordRecipeIds.get(str));
		        		setRcipeIds.add(searchKeywordRecipeIds.get(str));
		        	}
	            }
	        } else {
	        	setRcipeIds = new set<Id>();
	        	//Query all Published_Recipe__c records where Asset__c = input parameter with Search Keyword.
	        	for(Published_Recipe__c publishedRecipe :[Select Recipe__c From Published_Recipe__c
	                                                        Where Digital_Published_Asset__r.API_External_ID__c =:APIExternalID
	                                                        And Recipe__c IN :searchKeywordRecipeIds.values()
	                                                        And Recipe__r.recordSaved__c = true
	                                                        order by Recipe__r.API_External_ID__c]) {
					if(!setRcipeIds.contains(publishedRecipe.Recipe__c)) {
		        		recipeIds.add(publishedRecipe.Recipe__c);
		        		setRcipeIds.add(publishedRecipe.Recipe__c);
		        	}
	            }
	        }

	        temp = null;
	        setRcipeIds = null;
	        searchKeywordRecipeIds = null;
	     	//4.3.2012-LSLEVIN-Case4405-START//
	       	// Integer newResumePoint = 199;
	       	Integer newResumePoint = 9;
	    	//Case4405-END//
	        if((resumePoint+newResumePoint) < recipeIds.size()) {
				endOfResponse = false;
			}
	        APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(generateJSON(APIExternalID, recipeIds, resumePoint, newResumePoint, endOfResponse)));
            return;
		} else {
        	error = APPIRIO_WrapperUtility_JSON.generateErrorResponse(setting.Message__c, '');
    		responseResult.Error = error;
            APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifier(responseResult));
            return;
        }
	}

	static APPIRIO_WrapperUtility_JSON.Recipes generateJSON(String APIExternalID, List<Id> recipeIds, Integer resumePoint, Integer newResumePoint, Boolean endOfResponse) {
		List<Id> newRecipeIds;
		//Place all Recipe__c objects contained within the result set into the XML template generated in T-104967.
		APPIRIO_GenerateXMLKeywordSearch_JSON generateJSONKeywordSearch = new APPIRIO_GenerateXMLKeywordSearch_JSON();
    	newRecipeIds = new List<Id>();
    	Integer cnt = 1;
    	for(Id recipeId :recipeIds) {
    		if(resumePoint <= cnt && cnt <= (resumePoint+newResumePoint)) {
    			newRecipeIds.add(recipeId);
    		}
    		cnt = cnt+1;
    	}

        generateJSONKeywordSearch.recipeIds = newRecipeIds;
        generateJSONKeywordSearch.endOfResponse = endOfResponse;
        generateJSONKeywordSearch.resumePoint = resumePoint+newResumePoint+1;
    	if(endOfResponse)
    		generateJSONKeywordSearch.resumePoint = null;

        //Generate the XML output.
        APPIRIO_WrapperUtility_JSON.Recipes responseResult = generateJSONKeywordSearch.generateJSONRecipeIinfo();
        return responseResult;
	}
}