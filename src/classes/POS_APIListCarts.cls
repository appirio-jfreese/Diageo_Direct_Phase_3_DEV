@RestResource(urlMapping='/ListCarts/*')
global with sharing class POS_APIListCarts {
	
 	@HttpPost
    global static APICartResponse doPost (String WindowId) {
    	RestRequest req = RestContext.request; 
        RestResponse res = RestContext.response;	
        
    	List<Cart__c> cartsReturned = [Select c.Id, c.Name, c.Status__c, c.Shopper__c, c.Order_Window__c, 
    		c.Order_Window__r.Status__c, c.Order_Window__r.Name From Cart__c c where c.Order_Window__c=:WindowId];
    
    	APICartResponse apiResponse = new APICartResponse();
    	apiResponse.carts=cartsReturned;
    	
    	return apiResponse;
    	
    }
    
    
    global class APICartResponse {

        global List <Cart__c> carts { get; set; }
       

    } 

}