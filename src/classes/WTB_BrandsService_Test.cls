/*
* @author Neeraj Sharma
* @date 13/09/2013
* @description : Test class for WTB Brands service class(WTB_BrandsService)
*/
@isTest
private class WTB_BrandsService_Test {
	
	static testMethod void brandServiceAccessTest() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/brands';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		WTB_BrandsService.WTB_BrandsResponseMain result = WTB_BrandsService.doGet();
		test.stopTest();
		System.assertEquals('Access denied. Not a wtb user.', result.statusCode);
	}
	static testMethod void brandServiceTest() {
		Diageo_Brand__c brand = WTB_TestUtil.createDiageoBrand();
		Diageo_Product__c product = WTB_TestUtil.createDiageoProduct(brand.Id); 
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/brands';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		req.headers.put('wtbapiuser','verified');
		test.startTest();
		WTB_BrandsService.WTB_BrandsResponseMain result = WTB_BrandsService.doGet();
		test.stopTest();
		System.assertEquals('OK', result.statusCode);
		System.assert(result.results.size() > 0);
	}
	static testMethod void brandServiceWithProductTest() {
		Diageo_Brand__c brand = WTB_TestUtil.createDiageoBrand();
		Diageo_Product__c product = WTB_TestUtil.createDiageoProduct(brand.Id); 
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/brands';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		req.headers.put('wtbapiuser','verified');
		req.addParameter('includeProducts', 'true');
		test.startTest();
		WTB_BrandsService.WTB_BrandsResponseMain result = WTB_BrandsService.doGet();
		test.stopTest();
		System.assertEquals('OK', result.statusCode);
		System.assert(result.results.size() > 0);
		System.assert(result.results[0].products.size() > 0);
	}	
	static testMethod void brandServiceByBrandIdTest() {
		Diageo_Brand__c brand = WTB_TestUtil.createDiageoBrand();
		Diageo_Product__c product = WTB_TestUtil.createDiageoProduct(brand.Id); 
		brand = [Select Name, Brand_Category__c, API_External_ID__c from Diageo_Brand__c Where Id = :brand.Id ];
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/brands';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		req.headers.put('wtbapiuser','verified');
		req.addParameter('brandId', brand.API_External_ID__c);
		test.startTest();
		WTB_BrandsService.WTB_BrandsResponseMain result = WTB_BrandsService.doGet();
		test.stopTest();
		System.assertEquals('OK', result.statusCode);
		System.assert(result.results.size() > 0);
		System.assert(result.results[0].products.size() > 0);
	}	
}