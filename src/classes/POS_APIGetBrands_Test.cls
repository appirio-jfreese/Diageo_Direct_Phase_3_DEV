@IsTest(SeeAllData=false)
public class POS_APIGetBrands_Test{
   
    static testmethod void testGetBrands () {
    	POS_TestDataUtil.initializeTestData();
    	RestRequest req = new RestRequest();
    	RestResponse res = new RestResponse();
    	
	    RestContext.request = req;
	    RestContext.response = res;
    	
    	//Try query with no populated data first
    	POS_APIGetBrands.APIBrandResponse response = POS_APIGetBrands.doGet();
    	List<Brand__c> brands = response.Brands;
    	System.assert(brands.size()==1); //Should have Portfolio default and that's it
    	
    	//Now add data and test again
    	Brand__c brand = POS_TestDataUtil.createBrand();
    	
    	response = POS_APIGetBrands.doGet();
    	brands = response.Brands;
    	System.assert(brands.size()==2);
    	
    	//Now try using a more recent update time and see if we get no results again
    	req=new RestRequest();
    	Datetime now = System.now();
    	now=now.addDays(2);
    	
    	String dateString = now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    	req.addParameter('UpdateTime',dateString);
    	RestContext.request=req;
    	
    	response = POS_APIGetBrands.doGet();
    	brands = response.Brands;
    	System.assert(brands.size()==0);

    }
   
}