/*******************************************************************************
Updated By  : Vikash Goyal(Appirio JDC)
Date 	    : 13th Feb, 2014
Task/Defect : TA2017
*******************************************************************************/
public with sharing class ControllerContentBrand {
    private ApexPages.StandardController con;
    
    public PageUtils pageUtilBrand {get;set;}
    public PageUtils pageUtilContentBrand {get;set;}
    
    public List<contentBrand> contentBrandList     {
        public get {
            if (contentBrandList == null && pageUtilContentBrand.setCtrl != null) {
                contentBrandList = new List<contentBrand>();
                for(sObject o : pageUtilContentBrand.setCtrl.getRecords()) {
                	contentBrand br = new contentBrand((ContentBrand__c) o);
                	if(pageUtilContentBrand.selectedRecords.contains(br.cb.Id)){
                	  br.selected = true;
                	}
                    contentBrandList.add(br);                    
                }
            }
            return contentBrandList;            
        }
        public set;
    }    
    public List<brand> brandList     {
        public get {
            if (brandList == null && pageUtilBrand.setCtrl != null) {
                brandList = new List<brand>();
                for(sObject o : pageUtilBrand.setCtrl.getRecords()) {
                    Brand br = new brand((Brand__c) o);
                	if(pageUtilBrand.selectedRecords.contains(br.b.Id)){
                	  br.selected = true;
                	}
                    brandList.add(br);                   
                }
            }
            return brandList;            
        }
        public set;
    }    
    public boolean contentDescriptionEditable {
    	public get{
    	   return ((ContentBrand__c)con.getRecord()).Content_Description__c == null;
    	} 
    	public set;
	}	
	public Id ContentDescriptionId {
        public get {
		  return ((ContentBrand__c)con.getRecord()).Content_Description__c;
        }
        private set;
	}
      
    public ControllerContentBrand(ApexPages.StandardController controller) {
        if (!system.Test.isRunningTest()) {
            controller.addFields(new list<String>{'Id', 'Content_Description__c'});
            //controller.reset();
        }        
        con = controller;
        pageUtilBrand = new PageUtils('Name', 'ASC', 'Name', true);
       	pageUtilContentBrand = new PageUtils('Brand__r.Name', 'ASC', 'Brand__r.Name', true);        
    }

    public void populateContentBrands() {    	
    	
    	String conBrandQueryString = 'SELECT Id, Content_Description__c, Brand__r.Name, Brand__r.Classification__c, Brand__r.Brand_Type__c, Brand__r.Parent_Brand__r.Name, '+
        						  'Brand__r.Brand_Variant_Grouping__c, Brand__r.Diageo_direct_visible__c, Brand__r.L1_Classification__c, Brand__r.L2_Group_Type__c, ' +
        						  'Brand__r.L3_Brand__c, Brand__r.L4_Brand_Variant__c, Brand__r.L5_Individual_Variant__c, Brand__r.L6_Volume__c ' +
        						  'FROM ContentBrand__c WHERE Content_Description__c=:ContentDescriptionId ';
    	
    	if(!String.isBlank(pageUtilContentBrand.searchStr)){
          conBrandQueryString += 'AND Brand__r.Name LIKE \'%'+pageUtilContentBrand.searchStr+'%\' ';
        }
        if(!String.isBlank(pageUtilContentBrand.brand.Classification__c)){
          conBrandQueryString += 'AND Brand__r.Classification__c = \''+pageUtilContentBrand.brand.Classification__c+'\' ';
        }
        if(!String.isBlank(pageUtilContentBrand.brand.Brand_Type__c)){
          conBrandQueryString += 'AND Brand__r.Brand_Type__c = \''+pageUtilContentBrand.brand.Brand_Type__c+'\' ';
        }
        if(pageUtilContentBrand.brand.Diageo_direct_visible__c){
          conBrandQueryString += 'AND Brand__r.Diageo_direct_visible__c = '+pageUtilContentBrand.brand.Diageo_direct_visible__c+' ';
        }
        conBrandQueryString += 'ORDER BY '  + pageUtilContentBrand.sortField + ' ' + pageUtilContentBrand.sortOrder + ' NULLS LAST LIMIT 9999';
        
        pageUtilContentBrand.setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(conBrandQueryString));
        pageUtilContentBrand.setCtrl.setPageSize(15);
       
        contentBrandList = null;
    }
    
    public void populateBrands(){
        
        Set<String> existingBrands = new Set<String>();
        for(ContentBrand__c conBrand : [SELECT Brand__c FROM ContentBrand__c WHERE Content_Description__c=:ContentDescriptionId]){
          existingBrands.add(conBrand.Brand__c);
        }        
        String brandQueryString = 'SELECT Id, Name, Classification__c, Brand_Type__c, Parent_Brand__r.Name, Brand_Variant_Grouping__c,  '+
        						  'Diageo_direct_visible__c, L1_Classification__c, L2_Group_Type__c, L3_Brand__c, L3_Brand__r.Name, ' +
        						  'L4_Brand_Variant__c, L5_Individual_Variant__c, L6_Volume__c ' +
        						  'FROM Brand__c '+ 
        						  'WHERE Id NOT IN :existingBrands ';
        						                 
        if(!String.isBlank(pageUtilBrand.searchStr)){
          brandQueryString += 'AND Name LIKE \'%'+pageUtilBrand.searchStr+'%\' ';
        }
        if(!String.isBlank(pageUtilBrand.brand.Classification__c)){
          brandQueryString += 'AND Classification__c = \''+pageUtilBrand.brand.Classification__c+'\' ';
        }
        if(!String.isBlank(pageUtilBrand.brand.Brand_Type__c)){
          brandQueryString += 'AND Brand_Type__c = \''+pageUtilBrand.brand.Brand_Type__c+'\' ';
        }
        if(pageUtilBrand.brand.Diageo_direct_visible__c){
          brandQueryString += 'AND Diageo_direct_visible__c = '+pageUtilBrand.brand.Diageo_direct_visible__c+' ';
        }
        brandQueryString += 'ORDER BY '  + pageUtilBrand.sortField + ' ' + pageUtilBrand.sortOrder + ' NULLS LAST LIMIT 9999';
        
        pageUtilBrand.setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(brandQueryString));        
        pageUtilBrand.setCtrl.setPageSize(15);
        
        brandList = null;
    }  
    
     public void reloadListsAfterSearch() {
     	if(!String.isBlank(pageUtilContentBrand.searchStr) && pageUtilContentBrand.searchStr.length() < 3){
     	  Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Search string should have minimum length 3.'));
     	  return;
     	}        
        populateContentBrands();     
    }
    
    public void reloadListsAfterSearch1() {
     	if(!String.isBlank(pageUtilBrand.searchStr) && pageUtilBrand.searchStr.length() < 3){
     	  Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Search string should have minimum length 3.'));
     	  return;
     	}        
        populateBrands();     
    } 
     
    public void deleteRelations() {
        List<ContentBrand__c> selected = new List<ContentBrand__c>();        
        populateSelectedContentBrands();
        for(String contentBrandId : pageUtilContentBrand.selectedRecords){
          selected.add(
                    new ContentBrand__c(
                        Id = contentBrandId
                    )
                );
        }
        if (selected.size()>0) {
            delete selected;
        }
        pageUtilContentBrand.selectedRecords = new Set<String>();        
    }

    public void addRelations() {
        List<ContentBrand__c> selected = new List<ContentBrand__c>();        
        populateSelectedBrands();
        for(String brandId : pageUtilBrand.selectedRecords){
          selected.add(
                    new ContentBrand__c(
                        Content_Description__c = ContentDescriptionId,
                        Brand__c   = brandId
                    )
                );
        }
        if (selected.size()>0) {
            insert selected;
        }
        pageUtilBrand.selectedRecords = new Set<String>();        
    }
            
    public Integer totalPages {
        get {
        if(pageUtilContentBrand.setCtrl != null){
          Decimal totalSize = pageUtilContentBrand.setCtrl.getResultSize();
          Decimal pageSize = pageUtilContentBrand.setCtrl.getPageSize(); 
          Decimal pages = totalSize/pageSize; 
          return (Integer)pages.round(System.RoundingMode.CEILING); 
        }
        return 0;         
        }
        set;
    }
    
    public void first() {
    	populateSelectedContentBrands();
        pageUtilContentBrand.setCtrl.first();
        contentBrandList = null;
    }

    public void last() {
    	populateSelectedContentBrands();
        pageUtilContentBrand.setCtrl.last();
        contentBrandList = null;
    }

    public void previous() {
    	populateSelectedContentBrands();
        pageUtilContentBrand.setCtrl.previous();
        contentBrandList = null;
    }

    public void next() {
    	populateSelectedContentBrands();
        pageUtilContentBrand.setCtrl.next();
        contentBrandList = null;
    }
        
    public Integer totalPagesB {
        get {
          if(pageUtilBrand.setCtrl != null){
          Decimal totalSize = pageUtilBrand.setCtrl.getResultSize();
          Decimal pageSize = pageUtilBrand.setCtrl.getPageSize(); 
          Decimal pages = totalSize/pageSize; 
          return (Integer)pages.round(System.RoundingMode.CEILING);
          }
          return 0;          
        }
        set;
    }
    
    public void firstB() {
    	populateSelectedBrands();
        pageUtilBrand.setCtrl.first();
        brandList = null;
    }

    public void lastB() {
    	populateSelectedBrands();
        pageUtilBrand.setCtrl.last();
        brandList = null;
    }

    public void previousB() {
    	populateSelectedBrands();
        pageUtilBrand.setCtrl.previous();
        brandList = null;
    }

    public void nextB() {
    	populateSelectedBrands();
        pageUtilBrand.setCtrl.next();
        brandList = null;
    }
    
    public void doSortContentBrands(){
  	  pageUtilContentBrand.doSort();		
	  populateContentBrands();				
	}
	
	public void doSortBrands(){  	
      pageUtilBrand.doSort();	
	  populateBrands();				
	}
	
	private void populateSelectedBrands(){
	  for(Brand brandObj : brandList){
	  	if(brandObj.selected){
	  	  pageUtilBrand.selectedRecords.add(brandObj.b.Id);
	  	}
	  }
	}
	
	private void populateSelectedContentBrands(){
	  for(ContentBrand contentBrandObj : contentBrandList){
	  	if(contentBrandObj.selected){
	  	  pageUtilContentBrand.selectedRecords.add(contentBrandObj.cb.Id);
	  	}
	  }
	}
	
    public class ContentBrand {
        public ContentBrand__c cb {get; set;}
        public Boolean selected {get; set;}
        
        public ContentBrand(ContentBrand__c c) {
            cb = c;
            selected = false;
        }
    }    

    public class Brand {
        public Brand__c b {get; set;}
        public Boolean selected {get; set;}
        
        public brand(Brand__c bc) {
            b = bc;
            selected = false;
        }
    }    
}