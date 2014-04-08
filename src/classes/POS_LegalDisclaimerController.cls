/**
 * @author      Model Metrics {Venkatesh Kamat}
 * @date        08/09/2012
 * @description Takes care of displaying Legal Disclaimer Page before switching to POS Portal from Diageo Direct
 */
public class POS_LegalDisclaimerController extends Controller_Base {

	public String disclaimerText {get;set;}
	public Boolean posShopper {get;set;}
	
	public List<POS_BreadCrumb> breadcrumbs {get;set;} 
	
	
	public POS_LegalDisclaimerController () {
		
		User currentUser = [SELECT POS_Access__c, IsActive, IsPortalEnabled, Magento_Id__c, UserType FROM User where Id=:UserInfo.getUserId()];
		Legal_Disclaimer__c ld = [SELECT Message__c, Alternative_Message__c FROM Legal_Disclaimer__c where End_Date__c = null limit 1];
		
		posShopper = currentUser.POS_Access__c;
		if(posShopper) {
			disclaimerText = ld.Message__c;
		} else {
			disclaimerText = ld.Alternative_Message__c;
		}
		
       	breadCrumbs = new List<POS_BreadCrumb>();
       	breadCrumbs.add(new POS_BreadCrumb('POS','#'));
	}
	
	public PageReference agree() {
		Cookie ldCookie = new Cookie('legalDisclaimerAccepted','true',null,null,false);
		List<Cookie> cookies = new List<Cookie>();
		cookies.add(ldCookie);
		ApexPages.currentPage().setCookies(cookies);  
		      
        return Page.POS_OrderWindowView;
    }
    
    public PageReference disagree() {
        return Page.HomePage;
    } 
   
}