/*
* @author Neeraj Sharma
* @date 10/09/2013
* @description : This class implements a Rest service which takes some input 
                    parameters and returns the store list on the basis of given values
*/

@RestResource(urlMapping='/search/*')
global class WTB_SearchService {
    
    @HttpPost
    global static WTB_SearchResponseMain doPost(WTB_SearchService.WTB_SearchRequestWrapper input){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        WTB_SearchResponseMain result = new WTB_SearchResponseMain();
        list<WTB_SearchResponseWrapper> results = null;
        try{
            GPS_LocatorUtil.setGlobalConstants();
            String wtbAPIUser = req.headers.get(WTB_Constants.WTBAPIUSERID);
            if(String.isNotBlank(wtbAPIUser) && wtbAPIUser.equalsIgnoreCase(WTB_Constants.WTBAPIUSERVALUE)){
                if(input.address != null){
                    //Coordinates service will be called to get the coordinate of given address
                    WTB_CoordinatesService.WTB_CoordinatesRequestWrapper coordinateInput = new WTB_CoordinatesService.WTB_CoordinatesRequestWrapper();
                    coordinateInput.address = input.address.address;
                    coordinateInput.city = input.address.city;
                    coordinateInput.state = input.address.state;
                    coordinateInput.zipCode = input.address.zipCode;
                    WTB_CoordinatesService.WTB_CoordinateResponseMain coordinateInfo = WTB_CoordinatesService.getCoordinates(coordinateInput);
                    system.debug('coordinateinfo:'+coordinateinfo); 
                    system.debug('coordinateInfo.results.size():'+coordinateInfo.results.size());
                    if(coordinateInfo != null && coordinateInfo.results != null && coordinateInfo.results.size() > 0){
                        WTB_CoordinatesService.WTB_CoordinatesResponseWrapper coordinateDetails = coordinateInfo.results[0];
                        if(coordinateDetails.statusCode == WTB_Constants.STATUS_OK){
                            input.lat = String.valueOf(coordinateDetails.latitude);
                            input.lon = String.valueOf(coordinateDetails.longitude);
                        }
                    }
                }
                if(String.isBlank(input.locale)){
                    input.locale = WTB_Constants.DEFAULT_LOCALE;
                }

                if(String.isNotBlank(input.lat) && String.isNotBlank(input.lon)){
                    List<StoreLocator.StoreInfo> storeList = StoreLocator.getStores(input);   
                    results = processResult(storeList);
                    
                    result.results = results; 
                }
            }
            else{
                result.statusCode = WTB_Constants.ACCESS_DENIED_MESSAGE;
            }
        }
        catch(Exception e){
            system.debug(e.getStackTraceString());
        }
        return result;
        
    }
    /*
    @description: processes the google geocode api response and returns required values
    */
    public static list<WTB_SearchResponseWrapper> processResult(List<StoreLocator.StoreInfo> storeList){
        system.debug('storeList:'+storeList);
        list<WTB_SearchResponseWrapper> results = new list<WTB_SearchResponseWrapper>();
        WTB_SearchResponseWrapper result = null;
        system.debug('storeList:'+storeList.size());
        
        if(storeList != null && storeList.size() > 0){
            for(StoreLocator.StoreInfo res : storeList){ 
                result = new WTB_SearchResponseWrapper();
                result.id = res.store.StoreId1__c;
                result.name = res.store.StoreName__c;
                result.storeType = res.store.Store_Type__c;
                result.phone = res.store.Telephone__c;
                result.latitude = res.store.Latitude__c;
                result.longitude = res.store.Longitude__c;
                result.distance = res.distance;
                result.address = new Address(res.store.Address__c,res.store.City__c,res.store.State__c,res.store.Zip__c, '');
                results.add(result);
            }
        }
        system.debug('results:'+results);
        return results;
    }
    /*
    @description: Wrapper class used to store Search url response
    */
    global class WTB_SearchResponseWrapper{
        global String id;
        global String name;
        global String storeType;
        global String phone;
        global Address address;
        global String latitude;
        global String longitude;
        global Double distance;
    }
    global class Address{
        global String address;
        global String city;
        global String state;
        global String zipCode;      
        global String country;
        global Address(String address,String city,String state,String zipCode,String country){
            this.address = address;
            this.city = city;
            this.state = state;
            this.zipCode = zipCode;
            this.country = country;
        }
    }
    /*
    @description: Wrapper class used to store Search url request
    */
    global class WTB_SearchRequestWrapper{
        global Address address;
        global String lon;
        global String lat;
        global String radius;
        global String numResults;
        global String locale = WTB_Constants.DEFAULT_LOCALE;
        global list<String> brandId;
        global list<String> productId;
        global String searchType;
        global String onPrem = 'false';
        global list<String> storeType;
    }
    global class WTB_SearchResponseMain{
        global list<WTB_SearchResponseWrapper> results;     
        global String statusCode = WTB_Constants.STATUS_OK;
    }
    
}