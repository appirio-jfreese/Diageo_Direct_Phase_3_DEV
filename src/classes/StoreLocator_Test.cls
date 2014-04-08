@isTest
private class StoreLocator_Test {

    static testMethod void getStoresTest() {
    	
        GeoCodeApiData__c gCode = WTB_TestUtil.createStoresData(true);
        //Case 1 when store type is B
        test.startTest();
        WTB_SearchService.WTB_SearchRequestWrapper input = WTB_TestUtil.getSearchRequestInput();
        input.searchType = 'B'; 
        List<StoreLocator.StoreInfo> stores = StoreLocator.getStores(input);
        system.assert(stores.size()>0);
        //Case 2 when store type is S
        input.searchType = 'P';
        stores = StoreLocator.getStores(input);
        system.assert(stores.size()>0);
        test.stopTest();
    }
}