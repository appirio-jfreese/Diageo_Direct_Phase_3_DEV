/**
 * @author      Model Metrics {Venkatesh Kamat}
 * @date        06/25/2012
 * @description Class exposing Update to Carts as REST Inbound service for Agency interface.
 */
 
@RestResource(urlMapping='/UpdateCartItems/*')
global with sharing class POS_APIUpdateCartItems {
	
	@HttpPost
    global static List<Cart_Item__c> doPost (List<Cart_Item__c> CartItems) {
    	RestRequest req = RestContext.request; 
        RestResponse res = RestContext.response;	
    	
    	if (cartItems==null || cartItems.size() == 0) {
    		res.StatusCode = 400;
    		res.addHeader('Error','CartItems list is a required field');
    		
			return null;
    	}
    	
		Map<Id, Cart_Item__c> cItmIdMap = new Map<Id, Cart_Item__c>();
    	for(Cart_Item__c cItm : cartItems) {
    		cItmIdMap.put(cItm.Id, cItm);
    	}
    	
    	List<Cart_Item__c> cartItemsForUpdate = [Select Id, Status__c, Tracking_Code__c, Carrier__c from Cart_Item__c where id in :cItmIdMap.keySet()];
    	
    	for(Cart_Item__c cItm : cartItemsForUpdate) {
    		if(cItmIdMap.get(cItm.id).Status__c != null) {
    			cItm.Status__c = cItmIdMap.get(cItm.id).Status__c;
    		}
    		if(cItmIdMap.get(cItm.id).Carrier__c != null) {
    			cItm.Carrier__c = cItmIdMap.get(cItm.id).Carrier__c;
    		}    		
    		if(cItmIdMap.get(cItm.id).Tracking_Code__c != null) {
    			cItm.Tracking_Code__c = cItmIdMap.get(cItm.id).Tracking_Code__c;
    		}
    		
    		System.debug('cItm.Tracking_Code__c - ' + cItmIdMap.get(cItm.id).Tracking_Code__c);
    	} 
    	
    	update(cartItemsForUpdate); 
    	System.debug('cartItemsForUpdate.size() - ' + cartItemsForUpdate.size());  	   	
 
		return cartItemsForUpdate;
    }   
}