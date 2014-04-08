/**
 * Class	: APPIRIO_ManageBrandsController_Test
 * Created By : Rahul Mittal
 * Created Date : March 10, 2014
 * Test Class for APPIRIO_ManageBrands page and its controller APPIRIO_ManageBrandsController
 */
@isTest(SeeAllData=false)
private class APPIRIO_ManageBrandsController_Test {

  static Diageo_Brand__c diagBrnd;
  static Diageo_Brand__c diagBrnd1;
	static Diageo_Product__c diagPrdct1;
	static Diageo_Product__c diagPrdct2;
	static ContentVersion myImage;
  static Recipe_Media__c recm;
  static UserRole adminRole = [select Id from UserRole where Name =: MM_RecipeBase.RECIPE_ADMIN];
  static User admin;
	static{
		admin = new User(alias = 'unitadm', email='unitadm@diageorecipes.com', 
                     emailencodingkey='UTF-8', lastname='Testing', 
                     languagelocalekey='en_US', 
                     localesidkey='en_US', profileid = UserInfo.getProfileId(), userroleid = adminRole.Id,
                     timezonesidkey='America/Los_Angeles', 
                     username='unitadm@diageorecipes.com');
        
    admin.isActive=true;
    insert admin;
    system.runas(admin){
			myImage = new ContentVersion();
	    myImage.title='TITLE';
	    myImage.contentUrl='http://www.salesforce.com';
	    insert myImage;
	
	    recm = new Recipe_Media__c();
	    recm.Content_id__c = myImage.Id;
	    recm.Name = 'TestImage';
	    insert recm;
	
			//Creating a Diageo Brand(Parent Product)
			diagBrnd  = TestUtil.createDiageoBrand('ModelBrand',recm.Id);
			diagBrnd1  = TestUtil.createDiageoBrand('TestModelBrand',recm.Id);
	
			//Creating a Recipe Diageo Product(Categeory/Sub Brand of Daigeo Brand)
			diagPrdct1 = TestUtil.createDiageoProduct('ModelBrandCaramel',diagBrnd.Id,null);
	
			//Creating a Recipe Diageo Product(Categeory/Sub Brand of Daigeo Brand)
			diagPrdct2 = TestUtil.createDiageoProduct('ModelBrandCaramel1',diagBrnd1.Id,null);
    }
	}

  static testMethod void testManageBrandScenario1() {
  	system.runas(admin){
	    Test.starttest();
		  pageReference pRef = page.APPIRIO_ManageBrands;
		  Test.setCurrentPage(pRef);
		  APPIRIO_ManageBrandsController controller = new APPIRIO_ManageBrandsController();
		  controller.getUserAgent();
		  controller.selectedAlphabet = 'Test';
		  controller.PAGE_SIZE = 1;
		  controller.filterResults();
		  controller.getBrands();
		  controller.isSuperAdmin = true;
		  controller.getLocales();
		  controller.cloneBrands();
		  controller.getAlphabets();
		  controller.previous();
		  controller.cancel();
	
		  controller.selectedAlphabet = '';
		  controller.PAGE_SIZE = 1;
		  controller.filterResults();
	
		  controller.last();
		  controller.first();
		  controller.next();
		  controller.first();
		  controller.hasNext = true;
		  system.assertEquals(2,controller.totalRecords);
			Test.stoptest();
  	}
  }

  static testMethod void testManageBrandScenario2() {
  	system.runas(admin){
    	Test.starttest();
	    pageReference pRef = page.APPIRIO_ManageBrands;
	    Test.setCurrentPage(pRef);
	    APPIRIO_ManageBrandsController controller = new APPIRIO_ManageBrandsController();
	    controller.getUserAgent();
	    controller.PAGE_SIZE = 1;
	    controller.filterResults();
	    controller.getBrands();
	    controller.isPublisher = true;
	    controller.getLocales();

	    controller.last();
	    controller.first();
	    controller.next();
	    controller.first();
	    controller.hasNext = true;
	    system.assertEquals(2,controller.totalRecords);
		  Test.stoptest();
  	}
  }
}