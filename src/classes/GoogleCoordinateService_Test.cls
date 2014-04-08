@isTest
private class GoogleCoordinateService_Test {

    static testMethod void getGeoCodeTest() {
    	WTB_TestUtil.createWTBServiceSettings(); 
        test.startTest();
        WTB_CoordinatesService.WTB_CoordinatesRequestWrapper input = WTB_TestUtil.getGoogleGeoCodeRequestInput();
        WTB_GoogleCoordinatesResponseWrapper result = GoogleCoordinateService.getCoordinates(input);
        test.stopTest();
    }
}