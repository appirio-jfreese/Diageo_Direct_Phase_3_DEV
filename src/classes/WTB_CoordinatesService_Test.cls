/*
* @author Neeraj Sharma
* @date 07/09/2013
* @description : Test class for WTB Coordinate service class(WTB_CoordinatesService)
*/
@isTest
private class WTB_CoordinatesService_Test {
	
	static testMethod void coordinateServiceAccessTest() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/coordinates?address=test';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		test.startTest();
		WTB_CoordinatesService.WTB_CoordinateResponseMain result = WTB_CoordinatesService.doGet();
		test.stopTest();
		System.assertEquals('Access denied. Not a wtb user.', result.statusCode);
	}
	static testMethod void coordinateServiceTest() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/coordinates?address=test&zipCode=testzip&city=testCity&state=testState';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		req.headers.put('wtbapiuser','verified');
		test.startTest();
		WTB_CoordinatesService.WTB_CoordinateResponseMain result = WTB_CoordinatesService.doGet();
		test.stopTest();
		System.assertEquals('OK', result.statusCode);
		System.assert(result.results.size() > 0);
	}
}