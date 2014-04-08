/*
* @author Neeraj Sharma
* @date 10/09/2013
* @description : This class is used to get the all the stores nearest to given coordinates.
*/

public with sharing class StoreLocator {
    /**
     * this methods query GeoCodeApiData__c object for store location within given lat,lon and radius
     * from position defined by starting latetude and longetude.
     * Input Parameters: input contains all details like lat, lon, radius etc.
     */
    public static Integer NUM_RESULTS = WTB_Constants.NUM_RESULTS;
    public static Double radius = WTB_Constants.RADIUS;
    public static List<StoreInfo> getStores(WTB_SearchService.WTB_SearchRequestWrapper input){  
        
        if(String.isNotBlank(input.numResults)){
            NUM_RESULTS = Integer.valueOf(input.numResults);
        }
        if(String.isNotBlank(input.radius)){
            radius = Double.valueOf(input.radius);
        }
        String distanceFormula = ' DISTANCE(Location__c, GEOLOCATION('+input.lat+', '+input.lon+'), \'mi\') ';
        String query = 'Select Zip__c, Telephone__c, Store_Type__c, StoreName__c, StoreId1__c, State__c, OnPrem__c, Longitude__c, Latitude__c, City__c, Address__c, Locale__c From GeoCodeApiData__c where OnPrem__c = '+input.onPrem+' and Latitude__c != null and Longitude__c != null and Locale__c = \''+input.locale+'\'';
        if(String.isNotBlank(input.searchType)){

            if(input.searchType.equalsIgnoreCase('B') && input.brandId != null && input.brandId.size() > 0){
                set<String> brandIds = new set<String>(); 
                brandIds.addAll(input.brandId);
                query += ' and RB_API_External_ID__c IN : brandIds ';
            }
            if(input.searchType.equalsIgnoreCase('P') && input.productId != null && input.productId.size() > 0){
                set<String> productIds = new set<String>();
                productIds.addAll(input.productId);
                query += ' and RDP_API_External_ID__c IN : productIds ';
            }            
        }
        
        if(String.isNotBlank(input.onPrem) && input.onPrem == 'true' && input.storeType != null && input.storeType.size() > 0){
            set<String> storeTypes = new set<String>();
            storeTypes.addAll(input.storeType);
            query += ' and Store_Type__c IN : storeTypes ';
        }
        
        query+=' and '+distanceFormula+ ' < '+radius; 
        query+= ' limit 50000';
        Integer storeCount = 1;
        system.debug('query:'+query);
        List<GeoCodeApiData__c> availableStores = (List<GeoCodeApiData__c>)database.query(query);
        Map<Double,StoreInfo> storeDistanceMap = new Map<Double,StoreInfo>();
        List<Double> distanceList = new List<Double>();
        for (GeoCodeApiData__c store : availableStores){
            StoreInfo sl = new StoreInfo(store,GPS_LocatorUtil.calculateDistance(double.valueOf(input.lat), double.valueOf(input.lon), double.valueOf(store.Latitude__c), double.valueOf(store.Longitude__c)));
            if (sl.distance <= radius ){
                if(!storeDistanceMap.containsKey(sl.distance)){
                    storeDistanceMap.put(sl.distance,sl);
                    storeCount++;  
                }                        
            }
             
            if(storeCount > NUM_RESULTS){
                break;
            } 
        }
        /*distanceList.sort();
        List<StoreInfo> storeList = new List<StoreInfo>();
        Integer storeCount = 0;
        for(Double d : distanceList){
            if(storeDistanceMap.containsKey(d) && storeCount < NUM_RESULTS){
                GeoCodeApiData__c sli = (GeoCodeApiData__c)storeDistanceMap.get(d).store;
                if (sli != null){
                    storeList.add(new StoreInfo(sli,d));
                    storeCount++;
                }
            }
        }
        return storeList;*/
        return storeDistanceMap.values();

    }
    public static void setWtbSettings(){
        WTB_Service_Settings__c wtbSettings = GPS_LocatorUtil.getWTBServiceSettings();
        system.debug(wtbSettings);
        if(wtbSettings != null){
            radius = Double.valueOf(wtbSettings.Radius__c);
            NUM_RESULTS = Integer.valueOf(wtbSettings.Num_Results__c);      
        }
    }
    /**
     * Inner class presents store location
     */
    public class StoreInfo {
        public GeoCodeApiData__c store {get;set;}
        public Double distance {get; set;}  
        public StoreInfo(GeoCodeApiData__c store,Double distance){
            this.store = store;
            this.distance = distance;
        }
        public StoreInfo(){}    
    }
    
}