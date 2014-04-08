@RestResource(urlMapping='/GetItemCategories/*')
global with sharing class POS_APIGetItemCategories {

	
	private static String fieldList = ' Name, Customer_Marketing_Category__c, Friendly_Name__c, Material_Code__c, '+ 
	 'Primary_Group__c, Primary_Type__c, IMS_Specification_Id__c from Item_Category__c';
 	  
 	@HttpGet
    global static APICategoryResponse doGet () {
    	RestRequest req=RestContext.request;
    	RestResponse res=RestContext.response;
    	
        String UpdateTime = req.params.get('UpdateTime');   
    	
    	String soql = 'select '+fieldList;
    	if (UpdateTime!=null) {
    		UpdateTime = String.escapeSingleQuotes(UpdateTime);
    		soql = soql +' where SystemModstamp > '+UpdateTime;
    	}
    	
    	System.debug('Query: '+soql); 
    	
    	List<Item_Category__c> categories = (List<Item_Category__c>)Database.query(soql);
    	
    	APICategoryResponse response = new APICategoryResponse();
    	response.categories = categories;
    	return response;
    
    }
    
    global class APICategoryResponse {
    	public List<Item_Category__c> Categories;
    }

}