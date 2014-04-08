/****************************************************************************************************
   Test to check the Controller Associated with MM_RecipeBrand Visualforce page.
   @Author  : Rahul Mittal
   @Date    : Feb 18 2014
   @Version : 1.0
   The @isTest class annotation indicates this class only contains test methods.
   Classes defined with the @isTest annotation do not count against the organization size limit for all Apex scripts.
******************************************************************************************************/
@isTest
private class MM_TestRecipeBrandController {
	static Diageo_Brand__c diagBrnd;
	static Diageo_Product__c diagPrdct1;
	static Diageo_Product__c diagPrdct2;
	static ContentVersion myImage;
    static Recipe_Media__c recm;

	static
	{
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

		//Creating a Recipe Diageo Product(Categeory/Sub Brand of Daigeo Brand)
		diagPrdct1 = TestUtil.createDiageoProduct('ModelBrandCaramel',diagBrnd.Id,null);

		//Creating a Recipe Diageo Product(Categeory/Sub Brand of Daigeo Brand)
		diagPrdct2 = TestUtil.createDiageoProduct('ModelBrandCaramel1',diagBrnd.Id,null);
	}

    static testMethod void testWithBrand() {
    	Test.starttest();
	    	pageReference pRef = page.MM_RecipeBrand;
	    	Test.setCurrentPage(pRef);
	        ApexPages.Standardcontroller stdCon = new ApexPages.Standardcontroller(diagBrnd);
	        MM_RecipeBrandController controller = new MM_RecipeBrandController(stdCon);
	        controller.getUserAgent();
	        controller.editBrand();
	        controller.saveBrand();
	        system.assertEquals(controller.cancelEdit().getUrl(), '/apex/MM_RecipeBrand?id=' + controller.brandId);
	        system.assert(controller.recipeBrandProducts.size() == 2);

	        system.assert(controller.getHasImages() == true);
	        controller.addAProduct();
	        controller.upsertTempRecipeBrand();

	        ApexPages.currentPage().getParameters().put('editMode', 'true');
	        controller = new MM_RecipeBrandController(stdCon);
		Test.stoptest();
    }


    static testMethod void testWithoutBrand() {
    	Test.starttest();
	    	pageReference pRef = page.MM_RecipeBrand;
	    	Test.setCurrentPage(pRef);
	        ApexPages.Standardcontroller stdCon = new ApexPages.Standardcontroller(new Diageo_Brand__c());
	        MM_RecipeBrandController controller = new MM_RecipeBrandController(stdCon);
	        controller.getUserAgent();
	        controller.editBrand();
	        controller.saveBrand();
	        system.assert(controller.cancelEdit().getUrl() == '/apex/MM_RecipeBrand');
	        controller.addError('Please provide Brand Name.');

	        controller.recipeBrand.Name = 'Test Brand';
	        controller.saveBrand();
		Test.stoptest();
    }
}