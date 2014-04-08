/**
 * @author      Model Metrics {Venkatesh Kamat}
 * @date        06/19/2012
 * @description Class exposing Active Carts as REST Outbound service.
 */
 
@RestResource(urlMapping='/GetCartItems/*')
global with sharing class POS_APIGetCartItems {
	
 	@HttpPost
    global static APICartResponse doPost (String UpdateTime, Integer Offset, String WindowId) {
    	RestRequest req = RestContext.request; 
        RestResponse res = RestContext.response;	
        
        POSAPIConfiguration__c settings;
        if (Test.isRunningTest()) {
        	settings=new POSAPIConfiguration__c(Row_Limit__c=100);	
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
    	
    	//c.IsDeleted,
		String soql = 'Select c.Id, c.Name, c.Status__c, c.Shopper__c, c.Order_Window__c, c.Order_Window__r.Status__c, c.Order_Window__r.Name, ' +
			'(Select i.Status__c, i.Ship_To__c, i.Quantity__c, i.Name, i.Item__c, i.Id, i.WBS__c, i.Company_Code__c, ' +
			'Custom_Attribute_Value__c, Item_Customization__r.Name, '+
			'i.Carrier__c, i.Tracking_Code__c From Carts__r i where Quantity__c>0) From Cart__c c where '+
			'c.id in (select ci.cart__c from Cart_Item__c ci where ci.SystemModstamp > '+ UpdateTime +' OR ci.Cart__r.SystemModstamp > '+ UpdateTime +')';
    	
    	if (WindowId!=null) {
    		soql = soql + ' AND c.Order_Window__c = \''+WindowId+'\' ';
    	}
    	
    	//We limit to ROW_LIMIT results in a response, but we query for 101 so that we know if we hit the limit
   		System.debug('Row limit: '+ROW_LIMIT);
    	soql = soql + ' limit '+(ROW_LIMIT+1);
    	
    	
    	if (Offset!=null) {
    		soql = soql + ' offset '+Offset;
    	}else {
    		Offset = 0; //Set this to zero going forward
    	}
    	
    	System.debug('Query: '+soql);
    	List<Cart__c> cartsReturned = (List<Cart__c>)Database.query(soql);
    
    	APICartResponse apiResponse = new APICartResponse();
    	if (cartsReturned != null) {
    		System.debug('Carts returned: '+cartsReturned.size());
    		
	    	if (cartsReturned.size()>ROW_LIMIT) {
	    		//We hit the limit, so set the flag and remove the 101st item from the list
	    		apiResponse.moreResults=true;
	    		cartsReturned.remove(ROW_LIMIT); // remove the last element
	    		
	    	} else {
	    		apiResponse.moreResults=false;
	    	}
	    	
	        apiResponse.lastRowIndex = Offset+cartsReturned.size();
	    	apiResponse.carts=cartsReturned;
    	}


    	return apiResponse;
    	
    }
    
    
    global class APICartResponse {

        global List <Cart__c> carts { get; set; }
        global Integer lastRowIndex {get; set;}
        global Boolean moreResults {get;set;}

    } 
    
}