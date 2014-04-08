/****************************************************************************************************
   Test to check the Controller Associated with MM_RecipeBrandProduct Visualforce page.
   @Author  : Rahul Mittal
   @Date    : Feb 18 2014
   @Version : 1.0
   The @isTest class annotation indicates this class only contains test methods.
   Classes defined with the @isTest annotation do not count against the organization size limit for all Apex scripts.
******************************************************************************************************/
@isTest
private class MM_TestRecipeBrandProductController {
	static Diageo_Brand__c diagBrnd;
	static Diageo_Product__c diagPrdct1;
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
		diagPrdct1 = TestUtil.createDiageoProduct('ModelBrandCaramel',diagBrnd.Id, recm.Id);

	}

	//Test Method if product exist or product in editable mode
    static testMethod void testWithBrandProduct() {
    	Test.startTest();
	    	pageReference pRef = page.MM_RecipeBrandProduct;
	    	Test.setCurrentPage(pRef);
	    	ApexPages.currentPage().getParameters().put('brandId', diagBrnd.Id);
	        ApexPages.Standardcontroller stdCon = new ApexPages.Standardcontroller(diagPrdct1);
	        MM_RecipeBrandProductController controller = new MM_RecipeBrandProductController(stdCon);
	        controller.getUserAgent();
	        controller.editRecipeProduct();
	        controller.saveRecipeProduct();
	        system.assertEquals(controller.cancelEdit().getUrl(), '/apex/MM_RecipeBrandProduct?Id=' + controller.productId);
	        system.assert(controller.getHasImages() == true);
	        controller.upsertTempRecipeProduct();

	        ApexPages.currentPage().getParameters().put('editMode', 'true');
	        controller = new MM_RecipeBrandProductController(stdCon);
		Test.stoptest();
    }

	//Test Method when create a new product
    static testMethod void testWithoutBrandProduct() {
    	Test.startTest();
	    	pageReference pRef = page.MM_RecipeBrand;
	    	Test.setCurrentPage(pRef);
	    	ApexPages.currentPage().getParameters().put('brandId', diagBrnd.Id);
	        ApexPages.Standardcontroller stdCon = new ApexPages.Standardcontroller(new Diageo_Product__c());
	        MM_RecipeBrandProductController controller = new MM_RecipeBrandProductController(stdCon);
	        controller.getUserAgent();
	        controller.editRecipeProduct();
	        controller.saveRecipeProduct();
	        system.assert(controller.cancelEdit().getUrl() == '/apex/MM_RecipeBrandProduct');
	        controller.addError('Please provide Product Name.');

			controller.brandProduct.Name = 'Test Brand Product';
	        controller.saveRecipeProduct();
	        system.assert(controller.productId != null);
		Test.stoptest();
    }
}