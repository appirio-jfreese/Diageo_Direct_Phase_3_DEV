@RestResource(urlMapping='/GetKitItems/*')
global with sharing class POS_APIGetKitItems {
 	
 	private static String fieldList = ' k.SystemModstamp,  k.Packout_Quantity__c,'+
 	  '  k.Kit__c, k.Item__c, k.Id From Kit_Item__c k';
 	
 	
 	private static Integer TEST_ROW_LIMIT=10;
 	
 	@HttpPost
    global static APIKitItemResponse doPost (String UpdateTime, List<String> KitItems, Integer Offset) {
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
    	
    
    	
    	if (KitItems!=null && KitItems.size()>0) {
    		soql=soql + ' and Id in (';
    		integer itemCount=0;
    		for (String kitItem:KitItems) {
    			kitItem=String.escapeSingleQuotes(kitItem);
    			soql=soql+'\''+kitItem+'\'';
    			itemCount++;
    			if (itemCount<KitItems.size()) {
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
    	
    	List<Kit_Item__c> itemsReturned = (List<Kit_Item__c>)Database.query(soql);
    
    	APIKitItemResponse apiResponse = new APIKitItemResponse();
    	if (itemsReturned != null) {
    		System.debug('Items returned: '+itemsReturned.size());
	    	if (itemsReturned.size()>ROW_LIMIT) {
	    		//We hit the limit, so set the flag and remove the 101st item from the list
	    		apiResponse.moreResults=true;
	    		itemsReturned.remove(ROW_LIMIT); 
	    	}
	    	else {
	    		apiResponse.moreResults=false;
	    	}
	    	
	        apiResponse.lastRowIndex = Offset+itemsReturned.size();
	    	apiResponse.kitItems=itemsReturned;
    	}


    	return apiResponse;
    	
    }
    
    
    global class APIKitItemResponse {

        global List <Kit_Item__c> kitItems { get; set; }
        global Integer lastRowIndex {get; set;}
        global Boolean moreResults {get;set;}

    }   
    

}