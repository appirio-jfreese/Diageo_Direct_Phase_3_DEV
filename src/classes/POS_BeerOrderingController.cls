/*******************************************************************************
Created By  : Basant Verma (Appirio JDC)
Date        : 12/18/13
Story/Task  : US938/TA1762
*******************************************************************************/
public with sharing class POS_BeerOrderingController  extends Controller_Base {
	public String tangerineUrl {get;set;}
	
	public List<POS_BreadCrumb> breadcrumbs {get;set;} 
	
	public POS_BeerOrderingController () {
		POS_Magento_Configuration__c settings = POS_Magento_Configuration__c.getOrgDefaults();
    tangerineUrl = settings.Tangerine_Url__c;
    	
    breadCrumbs = new List<POS_BreadCrumb>();
    breadCrumbs.add(new POS_BreadCrumb('POS','/apex/POS_OrderWindowView'));
    breadCrumbs.add(new POS_BreadCrumb('Beer POS Ordering','#'));
	}

}