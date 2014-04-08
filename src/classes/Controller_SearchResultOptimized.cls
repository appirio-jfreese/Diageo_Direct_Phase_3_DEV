/*******************************************************************************
Name        : Controller_SearchResultOptimized
Created By  : Vikash Goyal (Appirio JDC)
Date        : 12th Mar, 2014
Reason      : Controller class for SearchResultOptimized Page
*******************************************************************************/
public with sharing class Controller_SearchResultOptimized extends Controller_Base {
    public Boolean displayAsList {get; set;}
    public Boolean isDetails {get; set;}
    public String searchValue {get; set;}
      
    public Integer minNoOfChar {
      get {
        try {
            return Integer.valueOf(Service_API.getSetting('minSearchNoOfChars'));
        } catch (Exception e) {
            return 2;
        }
      }
        protected set;
    }
      
    public List<AggregateResult> sectionContent {get; protected set;}
    public List<AggregateResultHolder> sectionContentHolder {
       get {
           List<AggregateResultHolder> contentHolder1 = new List<AggregateResultHolder>();
           if(sectionContent!=null){
             for(AggregateResult ar : sectionContent){
               AggregateResultHolder tmp = new AggregateResultHolder();
               tmp.result = ar;
               contentHolder1.add(tmp);
             }
           }
           return contentHolder1;
       }
       set;
    }
    
    protected transient String brandIdsString {get; protected set;}
    
    public String ordertByStr {get; set;}
    public String R_OrdertByAlpha {get; set;}
  public String R_OrdertByDate {get; set;}
    
    public Boolean firstZeroResult {get; set;}
    public Boolean secondZeroResult {get; set;} 
    
    public Controller_SearchResultOptimized() {
      displayAsList = true;
      sectionContent = new List<AggregateResult>();
      searchValue = '';
      firstZeroResult = false;
    secondZeroResult = false;
    isDetails = true;
      ordertByStr = 'Date_Desc';
      
      try{
        if(ApexPages.currentPage().getParameters().get('query') != null && ApexPages.currentPage().getParameters().get('query') != ''){
          searchValue = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('query'), 'UTF-8');
          searchValue = searchValue.replaceAll('[^a-zA-Z0-9]',' '); // search for alphanumeric 
          addBreadcrumbItem(Apexpages.currentPage().getUrl(), 'Search results for: ' + searchValue);              
        }
      } catch(Exception e){
          ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Unable to load data from url. '));
          return;        
      }
      
      if(searchValue.length() < minNoOfChar){
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Minimum length of search value is '+minNoOfChar+' chars. '));
        return;        
      }
      initPager();
      sortRecords();
      //refreshPageContent();      
    }
    
    public List<SelectOption> getSortingoptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Alpha_Asc', 'Alphabetical, A-Z'));
        options.add(new SelectOption('Alpha_Desc', 'Alphabetical, Z-A'));
        options.add(new SelectOption('Date_Asc', 'Date, Ascending'));
        options.add(new SelectOption('Date_Desc', 'Date, Descending'));
    return options;
  }
  
  public void sortRecords(){
    R_OrdertByAlpha = '';
    R_OrdertByDate = '';
    
    if(ordertByStr != null && ordertByStr.trim() != ''){
        if(ordertByStr.startsWith('Alpha')){
            R_OrdertByAlpha = ordertByStr.substring(6);
        }
        else{
            R_OrdertByDate = ordertByStr.substring(5);
        }
    }
    
    refreshPageContent();
  }
    
    public override void refreshPageContent() {
      try{
        Set<ID> brandIdsSet = new Set<Id>();
        Set<ID> userBrands = new Set<ID>(Service_API.getAccBrandIdsIndpntTheme());
        brandIdsSet = Service_API.getContentBrandIDsIndpntTheme(userBrands);
            
        if(!brandIdsSet.isEmpty()){
          brandIdsString = IdSetToString(brandIdsSet);
        }
        
        String queryString = ' SELECT Tags__c, is_video__c is_video, video_id__c video_id, Title__c title, Description__c description, Content_Version_Id__c cvid, filetype__c filetype, Preview_Available__c previewAvailable, Preview_Id__c previewId, filesize__c filesize, filesize_low__c filesize_low, Content_Version_Id_Low__c cvidlow, max(Uploaded_date__c) createdDate, image_resolution__c imageRes FROM content_description__c ' 
                        + ' WHERE (Content_Id__c in ('+brandIdsString+') OR ( Portfolio__c = true ) ) '                        
                        + ' AND ((Title__c like \'%'+searchValue+'%\' OR Description__c like \'%'+searchValue+'%\' OR Tags__c like \'%'+searchValue+'%\'))' + 
                        + ' GROUP BY Tags__c, is_video__c, video_id__c, Title__c, Description__c, Content_Version_Id__c, filetype__c, Preview_Available__c, Preview_Id__c, filesize__c, filesize_low__c, Content_Version_Id_Low__c, image_resolution__c  '+ 
                        + ' ORDER BY Description__c '+ (R_OrdertByAlpha != null && R_OrdertByAlpha.trim() != '' ? R_OrdertByAlpha+' ' : 'ASC ') ;
        
        sectionContent = customSortByDate(database.query(queryString + ' limit 1000'));
        numberOfItems = Integer.valueOf(sectionContent.size());
        sectionContent = getRequestedPage(sectionContent);
                
        currentBasketIds = Service_Basket.getBasketIds();
        currentFollowIds = Service_Notification.getFollowIds();
        } catch(Exception ex){
            Apexpages.addmessage(new apexpages.message(apexpages.severity.info, ex.getMessage()+' '+ex.getStackTraceString()));
        }
    }
    
    private List<AggregateResult> customSortByDate(List<AggregateResult> inList){
      if(R_OrdertByDate == null || R_OrdertByDate.trim().equals('')){
        return inList;
      }
        
      List<AggregateResult> resultList = new List<AggregateResult>();
      if(inList == null || inList.size() <= 1){
        return inList;
      }
        
      List<AggregateResult> left = new List<AggregateResult>(), right = new List<AggregateResult>();
      Integer middle = inList.size() / 2;
        
      for(integer iCount = 0; iCount < middle; iCount++){
        left.add(inList.get(iCount));
      }
      for(integer iCount = middle; iCount < inList.size(); iCount++){
        right.add(inList.get(iCount));
      }
        
      left = customSortByDate(left);
      right = customSortByDate(right);
        
      return applyCustomeSorting(left, right);
    }
    
    private List<AggregateResult> applyCustomeSorting(List<AggregateResult> list1, List<AggregateResult> list2){
      List<AggregateResult> result = new List<AggregateResult>();
      
      while(list1.size() > 0 || list2.size() > 0){
        if( list1.size() > 0 && list2.size() > 0){
          if( ((R_OrdertByDate == null || R_OrdertByDate.trim().equalsIgnoreCase('ASC')) && String.valueOf(list1.get(0).get('createdDate')).toUpperCase().compareTo(String.valueOf(list2.get(0).get('createdDate')).toUpperCase()) <= 0 )
               || ((R_OrdertByDate != null && R_OrdertByDate.trim().equalsIgnoreCase('DESC')) && String.valueOf(list1.get(0).get('createdDate')).toUpperCase().compareTo(String.valueOf(list2.get(0).get('createdDate')).toUpperCase()) >= 0 ) ){
               result.add(list1.get(0));
               list1.remove(0);
          }
          else{
            result.add(list2.get(0));
            list2.remove(0);
          }
        }
        else if( list1.size() > 0){
           result.add(list1.get(0));
           list1.remove(0);
        }
        else if( list2.size() > 0){
           result.add(list2.get(0));
           list2.remove(0);
        }
        }   
      return result;
    }
    
    private String IdSetToString(Set<ID> valueList){
        String result = '';
        String glue = '';
        for (String value : valueList) {         
            result += glue + '\''+value+'\' ';
            glue = ',';
        }       
        return result;
    }
    
    public PageReference userResearch(){
        PageReference pr = ApexPages.currentPage();
        String refine = '';
        if(firstZeroResult || secondZeroResult){
            refine = '&refine=true';
        }
        if(searchPhrase != null && searchPhrase.length() != 0){
            pr = new PageReference( Page.SearchResultOptimized.getUrl() + '?query='+EncodingUtil.urlEncode(searchPhrase,'UTF-8')+ refine );
            pr.setRedirect(true);
        }
        return pr;
    }
}