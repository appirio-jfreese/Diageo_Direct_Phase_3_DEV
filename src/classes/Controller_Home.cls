public with sharing class Controller_Home extends Controller_Base {

	// video
    public String videoId{get; private set;}
    public String videoDesc{get; private set;}
    public String showPlayer{get; private set;}
    // Added by Rahul Chitkara, Case 00006383 on 31 August , 2013
    public Boolean showLatestNews {get; private set;}
	// End changes 00006383
    public Id contentBrand{get; set;}

	// articles
	public list<NewsAndArticles__c> articles {get; set;}
    public String articleUrl {get; set; }
    
    public Boolean innovationSectionName {
 		get{
 			return (siteTheme == 'Spirits');
		}
		private set;
	}
    	    
    public Controller_Home() {
    	// Start: Changes for Responsive Site - Randy Wandell (Appirio) 7/10/13
//		pageUrl = Page.HomePage.getUrl();
		setResponsiveState();
		// End:
        
        //articles
        
        articles = Service_API.getNewsAndArticles();
				articleUrl = Page.NewsAndArticles.getUrl();
		
        HomeVideo__c[] videos = [Select videoId__c, description__c FROM HomeVideo__c WHERE current__c=true and Classification__c = :Service_API.getSectionTheme()];
        if (videos.size() == 1) {
            videoId      = videos[0].videoId__c;
            videoDesc    = videos[0].description__c;
            showPlayer   = 'block';
        } else {
            showPlayer = 'none';            
        }
        // Added by Rahul Chitkara , 00006383 on 31th August 2013
        showLatestNews = [Select Id,Access_dd_latest_news__c from User where Id =:UserInfo.getUserId() limit 1].Access_dd_latest_news__c;
        // End Changes 00006383
    }

	// Start: Changes for Responsive Site - Randy Wandell (Appirio) 7/10/13    
    public void setResponsiveState() {
		pageUrl = ApexPages.currentPage().getUrl();
		if(pageUrl.toLowerCase().indexOf('r_homepage') > -1) {
			isResponsive = true;
			preapareSiteNavigationMenu();
		} else {
			isResponsive = false;
			preapareSiteNavigationMenu();
		}    	
    }
    // End:
}