public with sharing class WTB_TestUtil {
	public static GeoCodeApiData__c createStoresData(boolean isInsert){
		GeoCodeApiData__c gCode = new GeoCodeApiData__c();
		gCode.StoreId1__c = '1';
		gCode.StoreName__c = 'test store';
		gCode.Address__c = 'test address';
		gCode.City__c = 'test city';
		gCode.State__c = 'test state';
		gCode.Latitude__c = '29.4118063';
		gCode.Longitude__c = '79.1326761';
		gCode.Location__Latitude__s = 29.4118063;
		gCode.Location__Longitude__s = 79.1326761;
		gCode.RB_API_External_ID__c = '10';
		gCode.RDP_API_External_ID__c = '20';
		gCode.Telephone__c = '1212121212';
		gCode.Locale__c = 'EN-US';
		if(isInsert){
			insert gCode;
		}
		return gCode;
	}
	public static WTB_SearchService.WTB_SearchRequestWrapper getSearchRequestInput(){
		WTB_SearchService.WTB_SearchRequestWrapper input = new WTB_SearchService.WTB_SearchRequestWrapper();
		input.address = new WTB_SearchService.Address('test address','test city','test state','302012','India');
		input.brandId = new list<String>{'10','20'};
		input.productId = new list<String>{'10','20'};
		input.lat = '29.3832222';
		input.lon = '79.11474559999999';
		input.numResults = '15';
		input.radius = '30';
		input.locale = 'EN-US';
		return input;
	}
	public static WTB_CoordinatesService.WTB_CoordinatesRequestWrapper getGoogleGeoCodeRequestInput(){
		WTB_CoordinatesService.WTB_CoordinatesRequestWrapper input = new WTB_CoordinatesService.WTB_CoordinatesRequestWrapper();
		input.address = 'test address';
		input.city = 'test city';
		input.state = 'test state';
		input.zipCode = '302012';
		return input;
	}
	public static void createWTBServiceSettings(){ 
		WTB_Service_Settings__c setting = new WTB_Service_Settings__c();
		setting.Name = 'wtb';
		setting.Geo_Code_Url__c = 'http://test.com';
		setting.Radius__c = '50';
		setting.Locale__c = 'EN-US';
		setting.WTB_API_User_Id__c = 'wtbapiuser';
		setting.WTB_API_User_Value__c = 'verified';
		setting.Num_Results__c = 15;
		insert setting;
	}
     public static Diageo_Brand__c createDiageoBrand(){
     	Diageo_Brand__c diagBrnd = new Diageo_Brand__c();
     	diagBrnd.Name = 'test brand';
     	diagBrnd.Locale__c = 'EN-US';
     	insert diagBrnd;
     	return diagBrnd;
     }
     
     public static Diageo_Product__c createDiageoProduct(Id brandId){
     	Diageo_Product__c diagPrdct = new Diageo_Product__c();
     	diagPrdct.Name = 'test product';
     	diagPrdct.Diageo_Brand_Id__c = brandId;
     	diagPrdct.Locale__c = 'EN-US';
     	insert diagPrdct;
     	return diagPrdct;	
     }	
}