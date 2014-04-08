@IsTest(SeeAllData=false)
public class GPS_LocatorUtil_Test{
    static testmethod void testStoreLocatorUtil(){
        // Test distance from CA to FL
        Double lat1 = 37.386339;
        Double lat2 = 27.8132980;
        Double lon1 = -122.085823;
        Double lon2 = -82.6067290;
        Double db = GPS_LocatorUtil.calculateDistance(lat1, lon1, lat2, lon2);
        
        Double db1 = GPS_LocatorUtil.getEarthRadius();
        Double db3 = GPS_LocatorUtil.toRadians(lat2);
        GPS_LocatorUtil.getWTBServiceSettings();
        GPS_LocatorUtil.setGlobalConstants();
    }
}