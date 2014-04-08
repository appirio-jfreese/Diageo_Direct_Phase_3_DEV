public with sharing class POS_SiteNavigationController extends Controller_Base  {
    public String baseUrl {get;set;}
    
    public POS_SiteNavigationController () {
        baseUrl = ApexPages.currentPage().getHeaders().get('Host');
    }

}