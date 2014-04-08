/*******************************************************************************

Updated By  : Basant Verma (Appirio JDC)
Date 				: 15th Jan, 2014
Task/Defect : DE980

Updated By  : Vikash Goyal(Appirio JDC)
Date 	    : 11th Feb, 2014
Task/Defect : TA2015
*******************************************************************************/
public with sharing class Controller_AccountBrand {
   private set<Id> accountRecordTypesIds {private get; private set;}
    
    public PageUtils pageUtilBrand {get;set;}
    public PageUtils pageUtilAccBrand {get;set;}
    
    public list<SelectOption> possibleAccounts {public get; public set;}
    public accountBrand__c accountbrand {get;set;}
    
    public List<accountBrand> accountBrandList {
        public get {
            if (accountBrandList == null && pageUtilAccBrand.setCtrl != null) {
                accountBrandList = new List<accountBrand>();
                for(sObject o : pageUtilAccBrand.setCtrl.getRecords()) {
                	accountBrand accBr = new accountBrand((AccountBrand__c) o);
                	if(pageUtilAccBrand.selectedRecords.contains(accBr.cb.Id)){
                	  accBr.selected = true;
                	}
                    accountBrandList.add(accBr);
                }
            }
            return accountBrandList;            
        }
        public set;
    } 
       
    public List<brand> brandList{
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
        
    public boolean accountEditable {
        public get{
           return accountbrand.Account__c == null;
        } 
        public set;
    }
       
    public Id AccountId {
        public get {
          return accountbrand.Account__c;
        }
        private set;
    }
    
    public Id cloneAccount {public get; public set;}
    
    public Controller_AccountBrand(ApexPages.StandardSetController controller) {
       	List<RecordType> accountRecordTypes =[Select r.Name, r.Id From RecordType r WHERE r.SobjectType = 'Account' AND r.Name = 'Distributor'];
       	accountRecordTypesIds = new set<id>();
       	for(RecordType r : accountRecordTypes ){
       		accountRecordTypesIds.add(r.Id);
       	}
       	
       	pageUtilBrand = new PageUtils('Name', 'ASC', 'Name', true);
       	pageUtilAccBrand = new PageUtils('Brand__r.Name', 'ASC', 'Brand__r.Name', true);
       	
       	String isEditPage = apexpages.currentpage().getparameters().get('isEdit');
        if(isEditPage != null && isEditPage == '1'){
          string accountbrandId = apexpages.currentpage().getparameters().get('Id');
          accountbrand = [select Account__c,Brand__c, Id from AccountBrand__c where id = :accountbrandId];
        }
        else{
	      string accountId = apexpages.currentpage().getparameters().get('Id');
	      if(accountId == null || accountId == '') {
	          accountbrand = new Accountbrand__c();
	      } else {
	          accountbrand = new Accountbrand__c(account__c = accountId);
	      }
        }
        possibleAccounts = new list<SelectOption>();
        possibleAccounts.add(new SelectOption('', 'Select Distributor'));
        // START : Changed for DE980 : By Basant Verma (Appirio JDC) : 15th Jan, 2014
        list<Account> accountsDistr = [select id, name from Account where id != :AccountId and Account.RecordTypeId in :accountRecordTypesIds ORDER BY name LIMIT 999];
        // END   : Changed for DE980 : By Basant Verma (Appirio JDC) : 15th Jan, 2014
        for(Account distr : accountsDistr){
            possibleAccounts.add(new SelectOption(distr.Id, distr.Name));
        }
    }

    public void populateAccountBrands() {
    	
        String accBrandQueryStr = 'SELECT Id, Brand__r.Name, Brand__r.Classification__c, Brand__r.Brand_Type__c, '+
        						  'Brand__r.Diageo_direct_visible__c, Brand__r.L1_Classification__c, Brand__r.L2_Group_Type__c, ' +
        						  'Brand__r.L3_Brand__c, Brand__r.L4_Brand_Variant__c, Brand__r.L5_Individual_Variant__c, Brand__r.L6_Volume__c ' +
        						  'FROM AccountBrand__c WHERE Account__c = :AccountId AND Account__r.RecordTypeId IN :accountRecordTypesIds '; //+ 
        						 
        if(!String.isBlank(pageUtilAccBrand.searchStr)){
          accBrandQueryStr += 'AND Brand__r.Name LIKE \'%'+pageUtilAccBrand.searchStr+'%\' ';
        }
        if(!String.isBlank(pageUtilAccBrand.brand.Classification__c)){
          accBrandQueryStr += 'AND Brand__r.Classification__c = \''+pageUtilAccBrand.brand.Classification__c+'\' ';
        }
        if(!String.isBlank(pageUtilAccBrand.brand.Brand_Type__c)){
          accBrandQueryStr += 'AND Brand__r.Brand_Type__c = \''+pageUtilAccBrand.brand.Brand_Type__c+'\' ';
        }
        if(pageUtilAccBrand.brand.Diageo_direct_visible__c){
          accBrandQueryStr += 'AND Brand__r.Diageo_direct_visible__c = '+pageUtilAccBrand.brand.Diageo_direct_visible__c+' ';
        }
        accBrandQueryStr += 'ORDER BY '  + pageUtilAccBrand.sortField + ' ' + pageUtilAccBrand.sortOrder + ' NULLS LAST LIMIT 9999';
        
        pageUtilAccBrand.setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(accBrandQueryStr));                
        pageUtilAccBrand.setCtrl.setPageSize(15);
       
        accountBrandList = null;        
    }
    
    public void populateBrands() {
    	
        Set<String> existingBrands = new Set<String>();
        for(AccountBrand__c accBrand : [SELECT Brand__c FROM AccountBrand__c WHERE Account__c=:AccountId 
        						AND Account__r.RecordTypeId in :accountRecordTypesIds]){
          existingBrands.add(accBrand.Brand__c);
        }
        String brandQueryString = 'SELECT Id, Name, Classification__c, Brand_Type__c,  '+
        						  'Diageo_direct_visible__c, L1_Classification__c, L2_Group_Type__c, L3_Brand__c, L3_Brand__r.Name, ' +
        						  'L4_Brand_Variant__c, L5_Individual_Variant__c, L6_Volume__c ' +
        						  'FROM Brand__c ' + 
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
     
    public void deleteRelations() {
        List<AccountBrand__c> selected = new List<AccountBrand__c>();
        populateSelectedAccBrands();
        for(String accBrandId : pageUtilAccBrand.selectedRecords){
          selected.add(
                    new AccountBrand__c(
                        Id = accBrandId
                    )
                );
        }
        if (selected.size()>0) {
            delete selected;
        }
        pageUtilAccBrand.selectedRecords = new Set<String>();        
    }

    public void deleteAll() {
        List<AccountBrand__c> selected = [SELECT id FROM AccountBrand__c WHERE Account__c=:AccountId and Account__r.RecordTypeId in :accountRecordTypesIds];

        if (selected.size()>0) {
            delete selected;
        }        
    }

    public void addAll() {
        List<AccountBrand__c> selected = new List<AccountBrand__c>();
        list<brand__c> allBrands = new list<brand__c>();
        
        if(pageUtilBrand.searchStr == null){             
            allBrands = 
                [ Select Id FROM Brand__c WHERE Id NOT IN 
                    (SELECT Brand__c FROM AccountBrand__c WHERE Account__c=:AccountId and Account__r.RecordTypeId in :accountRecordTypesIds)
                ];
        } else {
             String filter = '%'+pageUtilBrand.searchStr+'%';
             allBrands =
                [ Select Id FROM Brand__c WHERE Id NOT IN 
                    (SELECT Brand__c FROM AccountBrand__c WHERE Account__c=:AccountId and Account__r.RecordTypeId in :accountRecordTypesIds)
                    AND Name LIKE :filter
                ];
        }
        
        for(Brand__c brand : allBrands){
            selected.add(new AccountBrand__c(Account__c = AccountId, Brand__c = brand.id));
        }
        
        if (selected.size()>0) {
            insert selected;
        }
    }
    
    public PageReference cloneRelationsTo() {
        if(cloneAccount != null){
        		list<AccountBrand__c> currentRelToDelete = [select id from AccountBrand__c where Account__c = :cloneAccount and Account__r.RecordTypeId in :accountRecordTypesIds];
            delete currentRelToDelete;
            list<AccountBrand__c> newRelToCopy = [select id, brand__r.id from AccountBrand__c where Account__c = :accountId and Account__r.RecordTypeId in :accountRecordTypesIds];
            list<AccountBrand__c> relToInsert = new list<AccountBrand__c>();
            for(AccountBrand__c rel : newRelToCopy){
                relToInsert.add(new AccountBrand__c(Account__c = cloneAccount, Brand__c = rel.brand__r.id));
            }
            insert relToInsert;
            return new PageReference('/'+cloneAccount);
        }
        
        return null;
    }
    
    public PageReference cloneRelationsFrom() {
        if(cloneAccount != null){
            list<AccountBrand__c> currentRelToDelete = [select id from AccountBrand__c where Account__c = :accountId and Account__r.RecordTypeId in :accountRecordTypesIds];
            delete currentRelToDelete;
            list<AccountBrand__c> newRelToCopy = [select id, brand__r.id from AccountBrand__c where Account__c = :cloneAccount and Account__r.RecordTypeId in :accountRecordTypesIds];
            list<AccountBrand__c> relToInsert = new list<AccountBrand__c>();
            for(AccountBrand__c rel : newRelToCopy){
                relToInsert.add(new AccountBrand__c(Account__c = accountId, Brand__c = rel.brand__r.id));
            }
            insert relToInsert;
            return null;
        }
        
        return null;
    }    
    
    public void addRelations() {    	
        List<AccountBrand__c> selected = new List<AccountBrand__c>();        
        
        populateSelectedBrands();
        for(String brandId : pageUtilBrand.selectedRecords){
          selected.add(
                    new AccountBrand__c(
                        Account__c = AccountId,
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
          if(pageUtilAccBrand.setCtrl != null){
          Decimal totalSize = pageUtilAccBrand.setCtrl.getResultSize();
          Decimal pageSize = pageUtilAccBrand.setCtrl.getPageSize(); 
          Decimal pages = totalSize/pageSize; 
          return (Integer)pages.round(System.RoundingMode.CEILING);
          }
          return 0;          
        }
        set;
    }
    
    public void first() {
    	populateSelectedAccBrands();
        pageUtilAccBrand.setCtrl.first();
        accountBrandList = null;
    }

    public void last() {
    	populateSelectedAccBrands();
        pageUtilAccBrand.setCtrl.last();
        accountBrandList = null;
    }

    public void previous() {
    	populateSelectedAccBrands();
        pageUtilAccBrand.setCtrl.previous();
        accountBrandList = null;
    }

    public void next() { 
    	populateSelectedAccBrands();   	
        pageUtilAccBrand.setCtrl.next();
        accountBrandList = null;
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
    
    public void doSortAccBrands(){
  	  pageUtilAccBrand.doSort();		
	  populateAccountBrands();				
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
	  	if(pageUtilBrand.selectedRecords.contains(brandObj.b.Id) && !brandObj.selected){
	  	  pageUtilBrand.selectedRecords.remove(brandObj.b.Id);
	  	}
	  }
	}
	
	private void populateSelectedAccBrands(){
	  for(accountBrand accBrandObj : accountBrandList){
	  	if(accBrandObj.selected){
	  	  pageUtilAccBrand.selectedRecords.add(accBrandObj.cb.Id);
	  	}
	  	if(pageUtilAccBrand.selectedRecords.contains(accBrandObj.cb.Id) && !accBrandObj.selected){
	  	  pageUtilAccBrand.selectedRecords.remove(accBrandObj.cb.Id);
	  	}
	  }
	}
    
    public class accountBrand {
        public AccountBrand__c cb {get; set;}
        public Boolean selected {get; set;}
        
        public accountBrand(AccountBrand__c c) {
            cb = c;
            selected = false;
        }
    }    

    public class brand {
        public Brand__c b {get; set;}
        public Boolean selected {get; set;}
        
        public brand(Brand__c bc) {
            b = bc;
            selected = false;
        }
    }   
}