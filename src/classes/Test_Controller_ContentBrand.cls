@isTest
private class Test_Controller_ContentBrand {
	 
	 static testMethod void testController() {	 	
	 		 	       		
		Content_Description__c contentDesc  = Test_Helper.testInsertContentDescription(); 
		Content_Description__c contentDesc2 = Test_Helper.testInsertContentDescription();		
		
		List<Brand__c> lstBrands = new List<Brand__c>();
		Brand__c brandFirst 	 = Test_Helper.testCreateBrand('smirnoff', false) ;    		
		Brand__c brandSecond	 = Test_Helper.testCreateBrand('smirnoff ice', false); 	
		Brand__c brandThird 	 = Test_Helper.testCreateBrand('Johnnie Walker Black', false);
		Brand__c brandFourth  	 = Test_Helper.testCreateBrand('Johnnie Walker Blue', false);
		Brand__c brandFive  	 = Test_Helper.testCreateBrand('Johnnie Walker Gold', false);		
		lstBrands.add(brandFirst);
		lstBrands.add(brandSecond);
		lstBrands.add(brandThird);
		lstBrands.add(brandFourth);
		lstBrands.add(brandFive);
		insert lstBrands;
		
		List<ContentBrand__c> lstContentBrands = new List<ContentBrand__c>();
		ContentBrand__c contentBra = Test_Helper.testCreateContentBrand(contentDesc.Id, brandFirst.Id);	
		ContentBrand__c contentBra2 = Test_Helper.testCreateContentBrand(contentDesc2.Id, brandFive.Id);
		lstContentBrands.add(contentBra);
		lstContentBrands.add(contentBra2);
		insert lstContentBrands;	
						
		
		ApexPages.StandardController sc = new ApexPages.standardController(contentBra);			
		ControllerContentBrand controller =  new ControllerContentBrand(sc);		
		
		controller.populateContentBrands();
		controller.populateBrands();
		
		System.assertequals(1, (controller.pageUtilContentBrand.setCtrl).getResultSize());		
		
		
		ContentBrand__c contentBraThird = Test_Helper.testInsertContentBrand(controller.ContentDescriptionId, brandThird.Id);
		ContentBrand__c contentBraFourth = Test_Helper.testInsertContentBrand(controller.ContentDescriptionId, brandFourth.Id);	
				
		controller.populateContentBrands();
		controller.populateBrands();
		System.assertequals(3, (controller.pageUtilContentBrand.setCtrl).getResultSize());
		
		controller.pageUtilContentBrand.searchStr = 'Johnnie';
		controller.pageUtilContentBrand.brand.Classification__c	= 'Spirits';
		controller.pageUtilContentBrand.brand.Brand_Type__c = 'Individual';
		controller.pageUtilContentBrand.brand.Diageo_direct_visible__c = true;		
		controller.reloadListsAfterSearch();	
	
		controller.pageUtilBrand.searchStr = 'Johnnie';
		controller.pageUtilBrand.brand.Classification__c	= 'Spirits';
		controller.pageUtilBrand.brand.Brand_Type__c = 'Individual';
		controller.pageUtilBrand.brand.Diageo_direct_visible__c = true;
		controller.reloadListsAfterSearch1();
		
		controller.pageUtilContentBrand.searchStr = '';
		controller.pageUtilContentBrand.brand.Classification__c	= '';
		controller.pageUtilContentBrand.brand.Brand_Type__c = '';
		controller.pageUtilContentBrand.brand.Diageo_direct_visible__c = false;
		controller.pageUtilBrand.searchStr = '';
		controller.pageUtilBrand.brand.Classification__c	= '';
		controller.pageUtilBrand.brand.Brand_Type__c = '';
		controller.pageUtilBrand.brand.Diageo_direct_visible__c = false;
		controller.populateContentBrands();	
		controller.populateBrands();
		
		controller.brandList[0].selected = true;
		controller.addRelations();
		controller.populateContentBrands();
		System.assertequals(4, (controller.pageUtilContentBrand.setCtrl).getResultSize());
		controller.contentBrandList[0].selected = true;
		controller.deleteRelations();
		controller.populateContentBrands();
		System.assertequals(3, (controller.pageUtilContentBrand.setCtrl).getResultSize());
		
		controller.nextB();
		controller.previousB();
		controller.lastB();
		controller.firstB();
		Integer a = controller.totalPagesB;	
		
		controller.next(); 
		controller.previous();
		controller.last();
		controller.first();
		Integer e = controller.totalPages;
		
		Boolean i = controller.contentDescriptionEditable;	
		
	 }
}