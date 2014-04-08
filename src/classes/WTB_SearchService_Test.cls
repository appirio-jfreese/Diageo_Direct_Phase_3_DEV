/*
* @author Neeraj Sharma
* @date 07/09/2013
* @description : Test class for WTB Search service class(WTB_SearchService)
*/
@isTest
private class WTB_SearchService_Test {
	
	static testMethod void searchServiceAccessTest() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/search';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		WTB_SearchService.WTB_SearchRequestWrapper input = WTB_TestUtil.getSearchRequestInput();
		test.startTest();
		WTB_SearchService.WTB_SearchResponseMain result = WTB_SearchService.doPost(input);
		test.stopTest();
		System.assertEquals('Access denied. Not a wtb user.', result.statusCode);
	}
	static testMethod void searchByAddressServiceTest() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/search';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		req.headers.put('wtbapiuser','verified');
		WTB_TestUtil.createStoresData(true);
		WTB_SearchService.WTB_SearchRequestWrapper input = WTB_TestUtil.getSearchRequestInput();
		test.startTest();
		WTB_SearchService.WTB_SearchResponseMain result = WTB_SearchService.doPost(input);
		test.stopTest();
		System.assertEquals('OK', result.statusCode);
		System.assert(result.results.size() > 0);
	}
	static testMethod void searchByLatLonServiceTest() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/search';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		req.headers.put('wtbapiuser','verified');
		WTB_TestUtil.createStoresData(true);
		WTB_SearchService.WTB_SearchRequestWrapper input = WTB_TestUtil.getSearchRequestInput();
		input.address = null;
		test.startTest();
		WTB_SearchService.WTB_SearchResponseMain result = WTB_SearchService.doPost(input);
		test.stopTest();
		System.assertEquals('OK', result.statusCode);
		System.assert(result.results.size() > 0);
	}	
}