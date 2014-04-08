@RestResource(urlMapping='/GetBrands/*')
global with sharing class POS_APIGetBrands {
	
	private static String fieldList = 'Name, Brand_Type__c, Generic_Brand__c, Id, '+
	  'Magento_Id__c, Parent_Brand__c,Portfolio_Brand__c, WBS_Level_3__c, '+
	  'WBS_Level_5__c, Classification__c from Brand__c';
 	  
 	@HttpGet
    global static APIBrandResponse doGet () {
    	RestRequest req=RestContext.request;
    	RestResponse res=RestContext.response;
    	
        String UpdateTime = req.params.get('UpdateTime');   
    	
    	String soql = 'select '+fieldList;
    	if (UpdateTime!=null) {
    		UpdateTime = String.escapeSingleQuotes(UpdateTime);
    		soql = soql +' where SystemModstamp > '+UpdateTime;
    	}
    	
    	System.debug('Query: '+soql); 
    	
    	List<Brand__c> brands = (List<Brand__c>)Database.query(soql);
    	
    	APIBrandResponse response = new APIBrandResponse();
    	response.Brands=brands;
    	return response;
    
    }
    
    global class APIBrandResponse {
    	public List<Brand__c> Brands;
    }
}