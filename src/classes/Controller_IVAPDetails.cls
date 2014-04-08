/*******************************************************************************
Name        : Controller_IVAPDetails.cls

Updated By  : Basant Kumar Verma (Appirio OffShore)
Date                : 7/5/2013
Story/Task  : US585/TA1082

Updated By  : Basant Kumar Verma (Appirio JDC)
Date                : 9/26/2013
Story/Task  : US826/TA1515

Updated By  : Basant Kumar Verma (Appirio JDC)
Date        : 2/28/2014
Story/Task  : DE1001/TA2133
*******************************************************************************/
public with sharing class Controller_IVAPDetails extends Controller_Base {
        // display as list (true) or box (false)
    public Boolean displayAsList {get; set;}

    public Id detailId {public get; protected set;}
    public Calendar__c ivapItem {public get; protected set;}
    public String dateDescription {public get; protected set;}
    public String salesDriverDescription {public get; protected set;}
    public String description {public get; protected set;}
    public String styleBackgroundLogoImage {public get; protected set;}

    public String specification {public get; protected set;}
    public String situation {public get; protected set;}
    public String idea {public get; protected set;}
    public String consumerTarget {public get; protected set;}
    public String howItWorks {public get; protected set;}

    // show section
    public MAP<string, List<AggregateResult>> detailsMap {public get; protected set;}
    public MAP<string, List<AggregateResultHolder>> detailsHolderMap {
        get {
            MAP<string, List<AggregateResultHolder>> contentHolder1 = new MAP<string, List<AggregateResultHolder>>();
            if(detailsMap!=null){
                for(string key : detailsMap.keySet()){
                    List<AggregateResultHolder> tmpList = new List<AggregateResultHolder>();
                    for(AggregateResult ar : detailsMap.get(key)){
                        AggregateResultHolder tmp = new AggregateResultHolder();
                        tmp.result = ar;
                        tmpList.add(tmp);
                    }
                    contentHolder1.put(key,tmpList);
                }
            }
            return contentHolder1;
        }
        set;
    }
    
    public MAP<string, string> detailsMapParser {public get; protected set;}
    public MAP<string, Integer> detailsMapSize {public get; protected set;}
    public List<String> detailsMapOrder {public get; protected set;}
    public integer detailsMapOrderSize { public get { return detailsMapOrder.size(); } protected set; }  // Randy Wandell (Appirio) 7/10/13 - Used to return the size of detailsMapOrder
    
    public String currentSectionConstant {get; private set;}
    
    public String backToInnovationAndVAPUrl {get; private set;}
        
    public Controller_IVAPDetails() {
        if(siteTheme == 'Spirits') { currentSectionConstant = Constant.INNOVATION_AND_SUSTAINOVATION; }
        else if(siteTheme == 'Wine') { currentSectionConstant = Constant.INNOVATION_SUSTAINOVATION_AND_VINTAGE; }
        else if(siteTheme == 'Beer') { currentSectionConstant = Constant.INNOVATION_AND_PACK_CHANGES; }
        
//        currentSectionConstant = (siteTheme == 'Spirits' || siteTheme == 'Beer') ? (Constant.INNOVATION_AND_SUSTAINOVATION) : (Constant.INNOVATION_SUSTAINOVATION_AND_VINTAGE);

        // Start: Changes for responsive site - Randy Wandell (Appirio) 7/10/13
        //pageUrl = Page.IVAPDetails.getUrl();
        setResponsiveState();
        pageUrl = ApexPages.currentPage().getUrl();
        //backToInnovationAndVAPUrl = Page.InnovationAndVAP.getUrl();
        if(isResponsive) {
            backToInnovationAndVAPUrl = Page.R_InnovationAndVAP.getUrl();
        } else {
            backToInnovationAndVAPUrl = Page.InnovationAndVAP.getUrl();
        }
        // End:
        
        displayAsList = true;
        

        try{
            if(ApexPages.currentPage().getParameters().get('date') != null){
                backToInnovationAndVAPUrl += '?date='+ApexPages.currentPage().getParameters().get('date');
                if(ApexPages.currentPage().getParameters().get('time') != null){
                    backToInnovationAndVAPUrl += '&time='+Integer.valueOf(ApexPages.currentPage().getParameters().get('time'));
                }
                if(ApexPages.currentPage().getParameters().get('driver') != null){
                    backToInnovationAndVAPUrl += '&driver='+ApexPages.currentPage().getParameters().get('driver');
                }
            }
            // Start: Existing bug when building url - Randy Wandell (Appirio) 7/10/13
//          backToInnovationAndVAPUrl += '&'+parseSelectedThemesToUrl();
            if(backToInnovationAndVAPUrl.indexOf('?') >-1) {
                backToInnovationAndVAPUrl += '&';
            } else {
                backToInnovationAndVAPUrl += '?';
            }
            backToInnovationAndVAPUrl += parseSelectedThemesToUrl();
            // End;
        } catch(Exception e){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Unable to load data from url. '));
            // Start: Changes for responsive site - Randy Wandell (Appirio) 7/10/13
//          backToInnovationAndVAPUrl = Page.InnovationAndVAP.getUrl();
            if(isResponsive) {
                backToInnovationAndVAPUrl = Page.R_InnovationAndVAP.getUrl();
            } else {
                backToInnovationAndVAPUrl = Page.InnovationAndVAP.getUrl();
            }
            // End:
        }
        
        // Start: Changes for responsive site - Randy Wandell (Appirio) 7/10/13
//        addBreadcrumbItem(Page.InnovationAndVAP.getUrl(), currentSectionConstant);
        addBreadcrumbItem(backToInnovationAndVAPUrl, currentSectionConstant);
        // End:

        if(ApexPages.currentPage().getParameters().get('id') != null){
            try {
                detailId = Id.valueOf(ApexPages.currentPage().getParameters().get('id'));
                system.debug('selectedThemes()---'+selectedThemes()+'::: detailId '+detailId );
                ivapItem = Service_API.getIVAP(detailId, selectedThemes());
                // Start : Changed for DE1001/TA2133 : Basant
                // Start : Changed for TA1515 : Basant
                currentSectionConstant = (ivapItem.Classification__c == 'Spirits') 
                	? (Constant.INNOVATION_AND_SUSTAINOVATION) 
                	: ((ivapItem.Classification__c == 'Wine') 
                		? (Constant.INNOVATION_SUSTAINOVATION_AND_VINTAGE) 
                		: (Constant.INNOVATION_AND_PACK_CHANGES));
                // End : Changed for TA1515 : Basant
                // End : Changed for DE1001/TA2133 : Basant
                dateDescription = ''+ivapItem.Start_Date__c.format()+' - '+ivapItem.End_Date__c.format();
                salesDriverDescription = String.valueof(ivapItem.Sales_Channel__c);

                description = ivapItem.Description__c==null?ivapItem.Description__c:ivapItem.Description__c.replaceAll('\n','<br/>');
                specification = ivapItem.Specification_Text__c==null?ivapItem.Specification_Text__c:ivapItem.Specification_Text__c.replaceAll('\n','<br/>');
                situation = ivapItem.Situation_Text__c==null?ivapItem.Situation_Text__c:ivapItem.Situation_Text__c.replaceAll('\n','<br/>');
                idea = ivapItem.Idea_Text__c==null?ivapItem.Idea_Text__c:ivapItem.Idea_Text__c.replaceAll('\n','<br/>');
                consumerTarget = ivapItem.Consumer_Target_Text__c==null?ivapItem.Consumer_Target_Text__c:ivapItem.Consumer_Target_Text__c.replaceAll('\n','<br/>');
                howItWorks = ivapItem.How_it_Works_Text__c==null?ivapItem.How_it_Works_Text__c:ivapItem.How_it_Works_Text__c.replaceAll('\n','<br/>');

                addBreadcrumbItem(Apexpages.currentPage().getUrl(), ivapItem.name);
                if(ivapItem.Logo_Image_Large__r.content_id__c != null) {
                    ContentDocument[] cd = [SELECT LatestPublishedVersionId FROM ContentDocument WHERE Id=: ivapItem.Logo_Image_Large__r.content_id__c];
                    if (cd != null && cd.size()>0) {
                        // Start - Changes for US585/TA1082 - Basant Verma
                            if(currentUserPage().equalsIgnoreCase('/apex/R_IVAPDetails'))
                            styleBackgroundLogoImage = '/sfc/servlet.shepherd/version/download/' + cd[0].LatestPublishedVersionId;
                        else
                            styleBackgroundLogoImage = 'background-image: url(/sfc/servlet.shepherd/version/download/' + cd[0].LatestPublishedVersionId + ');';
                        // End - Changes for US585/TA1082 - Basant Verma
                    }
                }                
                          
            } catch( Exception err ){
                detailId = null;
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Unable to load details. '));
                system.debug('error--'+ApexPages.Severity.ERROR);
                return;
            }
        }
        
        detailsMap = new MAP<string, List<AggregateResult>>();
        detailsMapParser = new MAP<string,string>();
        detailsMapSize = new MAP<String,Integer>();
        detailsMapOrder = new list<String>();
        
        refreshPageContent();
    }
    
    public PageReference initTheme(){
        // Start : Changes for DE700 Parul Gupta : Added Parameter condition
        if(ApexPages.currentPage().getParameters().get('toggled') == null
        && ApexPages.currentPage().getParameters().get('toggled') == ''){
            
            if(ivapItem != null && Service_API.getSectionTheme() != ivapItem.classification__c && ivapItem.classification__c != 'Mixed'){
                Service_API.setUserSiteTheme(ivapItem.classification__c, false);
                PageReference pr = ApexPages.currentPage();
                pr.setRedirect(true);
                return pr;
            }
        }
        // End : Changes for DE700 Parul Gupta      
        return null;
    }
    
    public override void refreshPageContent() {
        // START : Changes for US585/TA1082 - Basant Verma
        detailsMapOrder = new list<String>();
        // END : Changes for US585/TA1082 - Basant Verma
        /*
        Modified by Rahul Chitkara
        Appirio Jaipur
        Date - 25th Oct- 2012
        Case - 00002915
        */
        Set<ID> brandIdsSet = new set<id>();
        // Start : Changed for DE1001/TA2133 : Basant
        // START : Changes for US826/TA1515 - Basant Verma
        /*if(currentSectionConstant == Constant.INNOVATION_AND_SUSTAINOVATION) {
            brandIdsSet = Service_API.getAllContentBrandIDs(Constant.INNOVATION_AND_SUSTAINOVATION, ivapItem.Classification__c);
        } else if (currentSectionConstant == Constant.INNOVATION_SUSTAINOVATION_AND_VINTAGE) {
             brandIdsSet  = Service_API.getAllContentBrandIDs(Constant.INNOVATION_SUSTAINOVATION_AND_VINTAGE, ivapItem.Classification__c);
        }*/
        // END : Changes for US826/TA1515 - Basant Verma
        brandIdsSet  = Service_API.getAllContentBrandIDs(currentSectionConstant, ivapItem.Classification__c);
        // END : Changed for DE1001/TA2133 : Basant
        /*
        End for Case 00002915
        */
        String glue = '';
        String brandIdsString = '';
        for (String id : brandIdsSet) {         
            brandIdsString += glue + '\''+id+'\' ';
            glue = ',';
        }
        
        List<String> subCategoriesList = new List<String>();
        // START : Changed for TA1515 : Basant
        list<Sections__c> sectionTabs = Service_API.getSectionTabs(currentSectionConstant, ivapItem.Classification__c);
        // END : Changed for TA1515 : Basant
        for(Sections__c s : sectionTabs ){
            if((s.Parent_Tab__c == null || s.Parent_Tab__c == '') && s.Sales_Driver__c == ivapItem.Sales_Channel__c){
                subCategoriesList.add(s.Tab__c);
                detailsMapOrder.add(s.Tab__c);
                detailsMap.put(s.Tab__c, new List<AggregateResult>() );
                detailsMapParser.put(s.Tab__c,s.Tab__c.replaceAll('[^a-zA-Z0-9]', ''));
                detailsMapSize.put(s.Tab__c, 0);                
            }
        }       
        
        String subCategoriesString = '';
        glue = '';
        for (String categoryName : subCategoriesList) {         
            subCategoriesString += glue + '\''+categoryName+'\' ';
            glue = ',';
        }

        isNewContent = false;                                   
        if(subCategoriesList.size() != 0 && brandIdsSet.size() != 0){
            // Start : Changed for TA1515 - Basant
            AggregateResult[] tmpList = database.query('SELECT Sub_Category__c, Sub_Sub_Category__c, content_description__r.is_video__c is_video, content_description__r.video_id__c video_id, content_description__r.Title__c title, content_description__r.Description__c description, content_description__r.Content_Version_Id__c cvid, content_description__r.filetype__c filetype, content_description__r.Preview_Available__c previewAvailable, content_description__r.Preview_Id__c previewId, content_description__r.filesize__c filesize, content_description__r.filesize_low__c filesize_low, content_description__r.Content_Version_Id_Low__c cvidlow, max(content_description__r.Uploaded_date__c) createdDate, content_description__r.image_resolution__c imageRes  FROM content_property__c ' +
                +' WHERE content_description__r.Classification__c includes (\''+ivapItem.Classification__c+'\') and category__c=\''+currentSectionConstant+'\' and Sub_Category__c in ('+subCategoriesString+') AND content_description__r.Content_Id__c in ('+brandIdsString+') AND Calendar__c=\''+detailId+'\' '
                +' GROUP BY Sub_Category__c, Sub_Sub_Category__c, content_description__r.is_video__c, content_description__r.video_id__c, content_description__r.Title__c, content_description__r.Description__c, content_description__r.Content_Version_Id__c, content_description__r.filetype__c, content_description__r.Preview_Available__c, content_description__r.Preview_Id__c, content_description__r.filesize__c, content_description__r.filesize_low__c, content_description__r.Content_Version_Id_Low__c, content_description__r.image_resolution__c  '+ 
                +' ORDER BY Sub_Sub_Category__c, content_description__r.Description__c ASC');
            // END : Changed for TA1515 - Basant
            if (tmpList!= null) {
                for(AggregateResult ar: tmpList) {
                    string subCategoryName = (string)ar.get('Sub_Category__c');
                    String dateString = String.valueOf(ar.get('createdDate'));
                    DateTime itemTime = datetime.valueOf(dateString);
                    if(lastLoginDate < itemTime){
                        isNewContent = true;
                    }                     
                    if(detailsMap.containsKey(subCategoryName)){
                        List<AggregateResult> tempList = detailsMap.get(subCategoryName);
                        tempList.add(ar);
                        detailsMap.put(subCategoryName, tempList);
                        detailsMapSize.put(subCategoryName, tempList.size());
                    }

                }
            }                   
        }
        currentBasketIds = Service_Basket.getBasketIds();
        currentFollowIds = Service_Notification.getFollowIds();
        }
    
    public void renderAsListSlider() {
        displayAsList = true; // other action if needed
    }   

    public void renderAsBoxSlider() {
        displayAsList = false; // other action if needed        
    }
         
    // Start: Changes for Responsive Site - Randy Wandell (Appirio) 7/10/13    
    public void setResponsiveState() {
        pageUrl = ApexPages.currentPage().getUrl();
        if(pageUrl.toLowerCase().indexOf('r_ivapdetails') > -1) {
            isResponsive = true;
            preapareSiteNavigationMenu();
        } else {
            isResponsive = false;
            preapareSiteNavigationMenu();
        }       
    }
    // End:  
}