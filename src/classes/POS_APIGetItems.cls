@RestResource(urlMapping='/GetItems/*')
global with sharing class POS_APIGetItems {
 	
 	private static String fieldList = 'Agency_Item_ID__c, Status__c, Estimated_Shipping_Tax__c, '+
 	  'Current_Price__c, Description__c,  Estimated_Price__c, Item_Id__c, '+
 	  'Gang__c, Id, Name, Category__c, Minimum_Quantity__c, Packout_Quantity__c, Program__c, Kit_Only__c, '+
 	  'SystemModstamp, Parent__c, Incremental_Charges__c, Customer_Marketing_Category__c, Item_Category__c, '+
 	  '(Select Id,Brand__c, Primary__c From Item_Brands__r), (Select Id, File_Name__c, Image_Types__c, Magento_File_Name__c From Item_Images__r), '+
 	  ' RecordType.Name from Item__c i ';
 	
 	/*private static String fieldList = 'Agency_Item_ID__c, i.SystemModstamp, i.Program__c, i.Name, i.Id, i.Gang__c, '+
 	  'i.Description__c, i.Current_Price__c, i.Category__c, Packout_Quantity__c'+
 	  '(Select Id,Brand__c, Primary__c From Item_Brands__r) from Item__c i ';*/
 
 	private static Integer TEST_ROW_LIMIT=10;
 	
 	
 	@HttpPost
    global static APIItemResponse doPost (String UpdateTime, String WindowId, List<String> Items, Integer Offset) {
    	RestRequest req = RestContext.request; 
        RestResponse res = RestContext.response;	
        
        POSAPIConfiguration__c settings;
        if (Test.isRunningTest()) {
        	settings=new POSAPIConfiguration__c(Row_Limit__c=TEST_ROW_LIMIT);	
        }
        else {
        	settings = POSAPIConfiguration__c.getOrgDefaults();
        }
        Integer ROW_LIMIT = (Integer)settings.Row_Limit__c;
    	
    	if (UpdateTime==null) {
    		res.StatusCode = 400;
    		res.addHeader('Error','UpdateTime is a required field');
    		
			return null;
    	}
    	
		String soql = 'select '+fieldList+' where SystemModstamp > '+UpdateTime;
    	
    	
    	if (WindowId!=null) {
    		WindowId = String.escapeSingleQuotes(WindowId);
    		soql=soql + ' and Program__c in (select Id from Program__c where Order_Window__c = \''+WindowId+'\')';
    	}
    	
    	if (Items!=null && Items.size()>0) {
    		soql=soql + ' and Id in (';
    		integer itemCount=0;
    		for (String item:Items) {
    			item=String.escapeSingleQuotes(item);
    			soql=soql+'\''+item+'\'';
    			itemCount++;
    			if (itemCount<Items.size()) {
    				soql=soql+',';
    			}
    		}
    		soql=soql+')';
    	}
    	
    	//We limit to ROW_LIMIT results in a response, but we query for 101 so that we know if we hit the limit
   		System.debug('Row limit: '+ROW_LIMIT);
    	soql = soql + ' limit '+(ROW_LIMIT+1);
    	
    	if (Offset!=null) {
    		soql = soql + ' offset '+Offset;
    	}
    	else {
    		Offset = 0; //Set this to zero going forward
    	}
    	
    	System.debug('Query: '+soql);
    	
    	List<Item__c> itemsReturned = (List<Item__c>)Database.query(soql);
    
    	APIItemResponse apiResponse = new APIItemResponse();
    	if (itemsReturned != null) {
    		System.debug('Items returned: '+itemsReturned.size());
	    	if (itemsReturned.size()>ROW_LIMIT) {
	    		//We hit the limit, so set the flag and remove the 101st item from the list
	    		apiResponse.moreResults=true;
	    		itemsReturned.remove(ROW_LIMIT); //
	    	}
	    	else {
	    		apiResponse.moreResults=false;
	    	}
	    	
	        apiResponse.lastRowIndex = Offset+itemsReturned.size();
	    	apiResponse.items=itemsReturned;
    	}


    	return apiResponse;
    	
    }
    
    
    global class APIItemResponse {

        global List <Item__c> items { get; set; }
        global Integer lastRowIndex {get; set;}
        global Boolean moreResults {get;set;}

    }   
  	
}