@RestResource(urlMapping='/DeleteItemImage/*')
global with sharing class POS_APIDeleteImage {
	
	@HttpPost
    global static String doDelete (Item_Image__c ItemImage) {
    	
    	POS_Magento_Configuration__c settings = POS_Magento_Configuration__c.getOrgDefaults();
    	String productImageFolderPath = settings.ProductImage_FolderPath__c;
    	
    	RestResponse res = RestContext.response;
    	System.debug('itemImage.Id -' + itemImage.Id); 
    	//Check to make sure Item sku is passed by the caller of the service
    	if (itemImage==null || itemImage.Item__c==null) {
    		res.StatusCode = 400;
    		res.addHeader('Error','Item SKU (SFDC Id) is a required field');
			return null;
			
    	} // Additional check for update to make sure the magento and SFDC unique identifier fo the image is passed by the agency 
    	/*else if (itemImage.Id==null || itemImage.Id == '') {
    		res.StatusCode = 400;
    		res.addHeader('Error','Image SFDC Id is a required field');
			return null;    		
    		
    	}*/ else if (itemImage.Magento_File_Name__c==null || itemImage.Magento_File_Name__c == '') {
    		res.StatusCode = 400;
    		res.addHeader('Error','Image Magento File Name is a required field');
			return null;    		
    		
    	}

 		String API_ARGUMENTS = '&arg2[id]=' + EncodingUtil.urlEncode(itemImage.Item__c+'','UTF-8') +  
 	    	'&arg2[file]=' + EncodingUtil.urlEncode(itemImage.Magento_File_Name__c+'','UTF-8');
 

		System.debug('API_ARGUMENTS -' +API_ARGUMENTS); 
        Dom.Document doc = POS_MagentoIntegrationUtil.getMagentoCallDocument('product_media.remove', API_ARGUMENTS);
        String responseId = POS_MagentoIntegrationUtil.getMagentoResponseElement(doc, 'response');
        String status = POS_MagentoIntegrationUtil.getMagentoResponseElement(doc, 'status');

		System.debug('status -' +status + ' responseId -' +responseId);  
		
		if(status == 'success') {
			Item_Image__c dImage = new item_Image__c(id=itemImage.Id);
			delete dImage;
			
		} 
		
		return status;
		
    }

}