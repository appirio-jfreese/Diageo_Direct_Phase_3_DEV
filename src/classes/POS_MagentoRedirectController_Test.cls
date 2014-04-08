@IsTest(SeeAllData=true)
public class POS_MagentoRedirectController_Test{

	static testmethod void testRedirect () {
		Program__c p = POS_TestDataUtil.createProgram();
		Item__c i = POS_TestDataUtil.createItem(p);
		Test.setCurrentPageReference(new PageReference('Page.POS_MagentoRedirect'));
		System.currentPagereference().getParameters().put('itemid',(String)i.Id);
		System.currentPageReference().getHeaders().put('referer','TESTREFERER');
		POS_MagentoRedirectController controller = new POS_MagentoRedirectController();
		
		//Should have the item ID in the url
		System.assert(controller.destination.indexOf(i.Id)>-1);
		
		//Now test the return case
		System.currentPagereference().getParameters().put('itemid',null);
		controller = new POS_MagentoRedirectController();
		System.assert(controller.destination.indexOf('TESTREFERER')>-1);
		
		System.currentPagereference().getParameters().put('magentoid','TESTVAL');
		controller = new POS_MagentoRedirectController();
		POS_Magento_Configuration__c settings = POS_Magento_Configuration__c.getOrgDefaults();
			
		System.assert(controller.destination.indexof(settings.IDP_Url__c)>-1);
		
	}
}