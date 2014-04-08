public with sharing class POS_MagentoRedirectController {
	
	public String destination {get;set;}
	
	public POS_MagentoRedirectController () { 
		String itemId = System.currentPagereference().getParameters().get('itemid');
		String magentoItemId = System.currentPagereference().getParameters().get('magentoid');
		if (itemId==null && magentoItemId==null) {
			//This is a return back to magento so 
			Cookie returnUrlCookie = ApexPages.currentPage().getCookies().get('returnUrl');
			destination = returnUrlCookie.getValue();
			System.debug('destination: '+destination);
		}
		else if (itemId!=null) {
			String referer = ApexPages.currentPage().getHeaders().get('Referer');
			Cookie returnUrl = new Cookie('returnUrl',referer,'/',null,false);
			List<Cookie> cookies = new List<Cookie>();
			cookies.add(returnUrl);
			ApexPages.currentPage().setCookies(cookies);
			destination = '/'+itemid+'/e?retURL=/apex/POS_MagentoRedirect';
			System.debug('destination: '+destination);
		}
		else if (magentoItemId!=null) {
			POS_Magento_Configuration__c settings = POS_Magento_Configuration__c.getOrgDefaults();
			String itemPath = settings.Item_URL__c;
			Cookie returnUrl = new Cookie('returnUrl',itemPath+magentoItemId,'/',null,false);
			List<Cookie> cookies = new List<Cookie>();
			cookies.add(returnUrl);
			ApexPages.currentPage().setCookies(cookies);
			destination=settings.IDP_Url__c;
			
			System.debug('destination: '+destination);
		}
	}

}