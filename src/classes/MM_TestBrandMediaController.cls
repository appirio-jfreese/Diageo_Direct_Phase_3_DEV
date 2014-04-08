/****************************************************************************************************
   Test to check the Controller Associated with MM_BrandMedia Visualforce page.
   @Author  : Rahul Mittal
   @Date    : Feb 18 2014
   @Version : 1.0
   The @isTest class annotation indicates this class only contains test methods.
   Classes defined with the @isTest annotation do not count against the organization size limit for all Apex scripts.
******************************************************************************************************/
@isTest
private class MM_TestBrandMediaController {
	static Diageo_Brand__c diagBrnd;
	static Diageo_Product__c diagPrdct1;
	static ContentVersion myImage;
	static ContentVersion myImage1;
    static Recipe_Media__c recm;
    static Recipe_Media__c recm1;

	static
	{
		myImage = new ContentVersion();
        myImage.title='TITLE';
        myImage.contentUrl='http://www.salesforce.com';
        insert myImage;

        myImage1 = new ContentVersion();
        myImage1.title='TITLE1';
        myImage1.contentUrl='http://www.salesforce.com';
        insert myImage1;

        recm = new Recipe_Media__c();
        recm.Content_id__c = myImage.Id;
        recm.Name = 'ATestImage';
        insert recm;

        recm1 = new Recipe_Media__c();
        recm1.Content_id__c = myImage1.Id;
        recm1.Name = 'BTestImage';
        insert recm1;

		//Creating a Diageo Brand(Parent Product)
		diagBrnd  = TestUtil.createDiageoBrand('ModelBrand',recm.Id);

		//Creating a Recipe Diageo Product(Categeory/Sub Brand of Daigeo Brand)
		diagPrdct1 = TestUtil.createDiageoProduct('ModelBrandCaramel',diagBrnd.Id, recm.Id);

	}

    static testMethod void testScenarioWithBrandId() {
        Test.startTest();
	        pageReference pRef = page.MM_BrandMedia;
	    	Test.setCurrentPage(pRef);
	    	ApexPages.currentPage().getParameters().put('brandId', diagBrnd.Id);
	    	MM_BrandMediaController controller = new MM_BrandMediaController();
	    	controller.getUserAgent();
	    	controller.getAlphabets();
	    	controller.loadAllImages();
	    	controller.upload();
	    	controller.saveImages();
	    	controller.close();
	    	controller.selectedAlphabet = 'B';
	    	controller.filterImages();
	    Test.stopTest();
    }

    static testMethod void testScenarioWithProductId() {
        Test.startTest();
	        pageReference pRef = page.MM_BrandMedia;
	    	Test.setCurrentPage(pRef);
	    	String productId = String.valueOf(diagPrdct1.Id);
	    	MM_BrandMediaController controller = new MM_BrandMediaController(null, productId);
	    	controller.getAlphabets();
	    	controller.loadAllImages();
	    	controller.upload();
	    	controller.saveImages();
	    	controller.close();
	    	controller.imageNameFilter = 'ATest';
	    	controller.filterImages();

	    	ApexPages.currentPage().getParameters().put('editMode', 'false');
	    	ApexPages.currentPage().getParameters().put('productId', diagPrdct1.Id);
	    	controller = new MM_BrandMediaController();
	    	controller.mediaId = String.valueOf(recm1.id);
	    	controller.getRecipeMedia(controller.mediaId);
	    	controller.associateMedia();
	    	controller.disassociateMedia();

	    Test.stopTest();
    }
}