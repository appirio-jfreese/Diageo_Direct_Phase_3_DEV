/**
 * Name    : GPS_LocatorUtil<br/>
 * Usage   : Utility class provides methods to find a distance based on
 *           longetude and latetude to find shortest distances to destinations.
 *           This class uses kilometers as default measurement of distance.
 * <br/>
 * Created By      : Igor Androsov<br/>
 * Created Date    : April 06, 2011<br/>
 * Modified By     : Neeraj Sharma(Sep 10, 2013)
 */
public without sharing class GPS_LocatorUtil {
    private static Double DEFAULT_SEARCH_RADIUS = 50.00; // Default radius 20KM
    private static Double EARTH_RADIUS = 3959.00; // Radius in miles default, for Kilometers use 6371.00 
    private static Double EARTH_RADIUS_MILES = 3959.00;
    private static Double EARTH_RADIUS_KILOMETERS = 6371.00;
    /**
     * Method calculates a shortest distance for  2 location in latedute adn longetude
     * This method impliments a Haversine formula in APEX that assumes a spherical earth.
     * Earths radius used 6371 km (≈3,959 mi)
     * <br/>
     * Input Parameters:<br/>
     * @lat1 - type Double defines latedude of starting location<br/>
     * @lon1 - type Double defines longetude of starting location<br/>
     * @lat2 - type Double defines latedude of target location<br/>
     * @lon2 - type Double defines longetude of target location<br/>
     */
        public static Double calculateDistance(Double lat1, Double lon1, Double lat2, Double lon2){
            Double Radius = EARTH_RADIUS;//GPS_LocatorUtil.getEarthRadius(); //3959.00 miles
            Double dLat = (lat2-lat1) * 3.1415926 / 180;
            Double dLon = (lon2-lon1) * 3.1415926 / 180;            
            Double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos((lat1 * 3.1415926 / 180)) * Math.cos((lat2 * 3.1415926 / 180)) *
            Math.sin(dLon/2) * Math.sin(dLon/2);
            Double c = 2 * Math.asin(Math.sqrt(a));
            return Radius * c;      
    }
    
    /**
     * Convert degrees to radians, returns number radians in Double
     * type.
     * <br/>
     * Input Parameters:<br/>
     * @param degree type Double number to be converted<br/>
     */ 
    public static Double toRadians(Double degree){
        // Value degree * Pi/180
        Double res = degree * 3.1415926 / 180;
        return res; 
    }

    public static Double getEarthRadius(){
        Double rad = GPS_LocatorUtil.EARTH_RADIUS_MILES;
        //Proximity_Settings__c prop = Proximity_Settings__c.getOrgDefaults();
        //if (prop != null && prop.Distance_Unit__c != null && prop.Distance_Unit__c == 'KM') {
        //  rad = GPS_LocatorUtil.EARTH_RADIUS_KILOMETERS;
        //}     
        return rad;
    }
    public static WTB_Service_Settings__c getWTBServiceSettings(){
        WTB_Service_Settings__c setting = WTB_Service_Settings__c.getInstance('wtb');
        system.debug(setting);
        return setting;
    }   
    public static void setGlobalConstants(){
        WTB_Service_Settings__c setting = WTB_Service_Settings__c.getInstance('wtb');
        if(setting != null){
            WTB_Constants.GOOGLE_GEOCODE_URL = setting.Geo_Code_URL__c;
            WTB_Constants.DEFAULT_LOCALE = setting.Locale__c;
            WTB_Constants.WTBAPIUSERID = setting.WTB_API_User_Id__c;
            WTB_Constants.WTBAPIUSERVALUE = setting.WTB_API_User_Value__c;
            WTB_Constants.NUM_RESULTS = Integer.valueOf(setting.Num_Results__c);
            
        }
    }
    ////////////////////////////////////////////////////
    //
    //  Example use case to get Store locations within
    //  proximity radius
    //
    ////////////////////////////////////////////////////
    /**
     * this methods query JD_Deli--c object for store location within given radius
     * from position defined by starting latetude and longetude.
     * <br/>
     * Input Parameters:<br/>
     * @param lat - Latetude type Double of the start position<br/>
     * @param lon - Longetude Double for starting position<br/>
     * @param radius - type Double radiuis to search within<br/>
     *
    public static List<StoreLocator> getFullDeliList(Double lat, Double lon, Double radius){
        List<JD_Deli__c> deliList = [select Id, Name, LSM__c, Address__c, City__c, State__c, Phone__c, Store_ID__c, Latitude__c, Longitude__c from JD_Deli__c where Latitude__c != null and Longitude__c != null];
        Map<Double,StoreLocator> slMap = new Map<Double,StoreLocator>();
        List<Double> dblList = new List<Double>();
        for (JD_Deli__c store : deliList){
            StoreLocator sl = new StoreLocator();
            sl.store = store;
            sl.distance = JD_StoreLocatorUtil.calculateDistance(lat, lon, (Double)store.Latitude__c, (Double)store.Longitude__c);
            slMap.put(sl.distance,sl);
            if (sl.distance <= radius)
                dblList.add(sl.distance);
        }
        dblList.sort();
        List<StoreLocator> officeListEX = new List<StoreLocator>();
        for(Double d : dblList){
            StoreLocator sli = (StoreLocator)slMap.get(d);
            if (sli != null)
                officeListEX.add(sli);
        }
        return officeListEX;

    }
    */
    /**
     * Lookup SF custom settings Proximity_Settings to get a unit
     * KM/ML kilometers/US Miles respective and return default value
     * in that unit for Earthe radius. returns type Double
     * 3959.00 - miles, for Kilometers use 6371.00, US mile is default.
     * <br/>
     * Input Parameters:
     *
     */
    /**
     * Inner class presents store location
     *
    public class StoreLocator {
        public JD_Deli__c store {get;set;}
        public Double distance {get; set;}      
    }
    */
    

}