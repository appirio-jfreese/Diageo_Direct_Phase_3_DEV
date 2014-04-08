@RestResource(urlMapping='/GetPrograms/*')
global with sharing class POS_APIGetPrograms {
	
	private static String fieldList = 'Brand__c, Calendar__c, Id, Magento_Id__c, '+
	  'Order_Window__c, Order_Window_Close_Date__c, Order_Window_Start_Date__c, '+
	  'Order_Window_Status__c, Name, Sales_Channel_Group__c from Program__c '+
	  'where Order_Window_Status__c != \'New\'';
 	  
 	@HttpGet
    global static APIProgramResponse doGet () {
    	RestRequest req=RestContext.request;
    	RestResponse res=RestContext.response;
    	
        String UpdateTime = req.params.get('UpdateTime');   
    	
    	String soql = 'select '+fieldList;
    	if (UpdateTime!=null) {
    		UpdateTime = String.escapeSingleQuotes(UpdateTime);
    		soql = soql +' and SystemModstamp > '+UpdateTime;
    	}
    	String WindowId = req.params.get('WindowId');
    	if (WindowId != null) {
    		WindowId = String.escapeSingleQuotes(WindowId);
    		soql = soql +' and Order_Window__c = \''+WindowId+'\'';
    	}
    	
    	System.debug('Query: '+soql); 
    	
    	List<Program__c> programs = (List<Program__c>)Database.query(soql);
    	
    	APIProgramResponse response = new APIProgramResponse();
    	response.Programs=programs;
    	return response;
    
    }
    
    global class APIProgramResponse {
    	public List<Program__c> Programs;
    }

}