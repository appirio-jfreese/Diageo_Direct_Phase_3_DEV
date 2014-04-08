@isTest(SeeAllData=false)
public class POS_APIGetItemCategories_Test{

    static testmethod void testGetItemCategories () {
    	POS_TestDataUtil.initializeTestData();
    	RestRequest req = new RestRequest();
    	RestResponse res = new RestResponse();
    	
	    RestContext.request = req;
	    RestContext.response = res;
    	
    	//Try query with no populated data first
    	POS_APIGetItemCategories.APICategoryResponse response = POS_APIGetItemCategories.doGet();
    	List<Item_Category__c> categories = response.Categories;
    	System.assert(categories.size()==0); 
    	
    	//Now add data and test again
    	Item_Category__c category = new Item_Category__c();
    	insert category;
    	
    	response = POS_APIGetItemCategories.doGet();
    	categories = response.Categories;
    	System.assert(categories.size()==1);
    	
    	//Now try using a more recent update time and see if we get no results again
    	req=new RestRequest();
    	Datetime now = System.now();
    	now=now.addDays(2);
    	
    	String dateString = now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    	req.addParameter('UpdateTime',dateString);
    	RestContext.request=req;
    	
    	response = POS_APIGetItemCategories.doGet();
    	categories = response.Categories;
    	System.assert(categories.size()==0);

    }
}