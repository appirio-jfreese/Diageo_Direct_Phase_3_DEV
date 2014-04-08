/*******************************************************************************
Updated By  : Vikash Goyal(Appirio JDC)
Date 	    : 13th Feb, 2014
Task/Defect : TA2016
*******************************************************************************/
public with sharing class Controller_BrandAccount {
    
    public list<SelectOption> possibleBrands {public get; public set;}

	private set<Id> accountRecordTypesIds {private get; private set;}
    
    public PageUtils pageUtilAcc {get;set;}
    public PageUtils pageUtilAccBrand {get;set;}
    
    public accountBrand__c accountbrand {get;set;}
    
    public List<BrandAccount> brandAccountList     {
        public get {
            if (brandAccountList == null && pageUtilAccBrand.setCtrl != null) {
                brandAccountList = new List<BrandAccount>();
                for(sObject o : pageUtilAccBrand.setCtrl.getRecords()) {
                    BrandAccount accBr = new BrandAccount((AccountBrand__c) o);
                	if(pageUtilAccBrand.selectedRecords.contains(accBr.cb.Id)){
                	  accBr.selected = true;
                	}
                    brandAccountList.add(accBr);                    
                }
            }
            return brandAccountList;            
        }
        public set;
    }    
    
    public List<Distributor> distribList     {
        public get {
            if (distribList == null && pageUtilAcc.setCtrl != null) {
                distribList = new List<Distributor>();
                for(sObject o : pageUtilAcc.setCtrl.getRecords()) {
                	Distributor dist = new Distributor((Account) o);
                	if(pageUtilAcc.selectedRecords.contains(dist.a.Id)){
                	  dist.selected = true;
                	}
                    distribList.add(dist);
                }
            }
            return distribList;            
        }
        public set;
    }    
    public boolean accountEditable {
    	public get{
    	   return (accountbrand.brand__c == null);
    	} 
    	public set;
	}	
	public Id BrandId {
        public get {
		  return accountbrand.brand__c;
        }
        private set;
	}
	
	public Id cloneId {public get; public set;}
      
    public Controller_BrandAccount(ApexPages.StandardSetController controller) {
       	List<RecordType> accountRecordTypes =[Select r.Name, r.Id From RecordType r WHERE r.SobjectType = 'Account' AND r.Name = 'Distributor'];
       	accountRecordTypesIds = new set<id>();
       	for(RecordType r : accountRecordTypes ){
       		accountRecordTypesIds.add(r.Id);
       	}
       	
       	pageUtilAcc = new PageUtils('Name', 'ASC', 'Name', true);
       	pageUtilAccBrand = new PageUtils('Account__r.Name', 'ASC', 'Account__r.Name', true);
       	
        String isEditPage = apexpages.currentpage().getparameters().get('isEdit');
        if(isEditPage != null && isEditPage == '1'){
          string accountbrandId = apexpages.currentpage().getparameters().get('Id');
          accountbrand = [select Brand__c, Account__c, Id from AccountBrand__c where id = :accountbrandId];
        }
        else{
          string brandId = apexpages.currentpage().getparameters().get('Id');
          if(brandId==null || brandId=='') {
            accountbrand = new Accountbrand__c();
          } else {
            accountbrand = new Accountbrand__c(brand__c=brandId);
          }
        }
                
        possibleBrands = new list<SelectOption>();
		possibleBrands.add(new SelectOption('', 'Select Brand'));
        list<Brand__c> brands = [select id, name from Brand__c where id != :BrandId ORDER BY name limit 999];
        for(Brand__c brand : brands){
        	possibleBrands.add(new SelectOption(brand.Id, brand.Name));
        }
    }

    public void populateAccountBrands() {
    	String accBrandQueryStr = 'SELECT Id, Account__r.Name, Account__r.Spirits_Hierarchy__c, Account__r.Spirits_Hierarchy_Location__c, ' +
    							  'Account__r.Parent.name, Account__r.Wine_Hierarchy__c, Account__r.Wine_Hierarchy_Location__c, ' +
    							  'Account__r.Beer_Hierarchy__c, Account__r.Beer_Hierarchy_Location__c, Account__r.ParentId ' + 
        			              'FROM AccountBrand__c WHERE Brand__c = :BrandId AND Account__r.RecordTypeId in :accountRecordTypesIds ';        			              
        
        if(!String.isBlank(pageUtilAccBrand.searchStr)){
          accBrandQueryStr += 'AND Account__r.Name LIKE \'%'+pageUtilAccBrand.searchStr+'%\' ';
        }
        accBrandQueryStr += 'ORDER BY '  + pageUtilAccBrand.sortField + ' ' + pageUtilAccBrand.sortOrder + ' NULLS LAST LIMIT 9999';
        
        pageUtilAccBrand.setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(accBrandQueryStr));
 		
        pageUtilAccBrand.setCtrl.setPageSize(15);
       
        brandAccountList = null;
    }
    
    public void populateAccounts(){
    	Set<String> existingAccounts = new Set<String>();
        for(AccountBrand__c accBrand : [SELECT Account__c FROM AccountBrand__c WHERE Brand__c =:BrandId 
        												AND Account__r.RecordTypeId IN :accountRecordTypesIds]){
          existingAccounts.add(accBrand.Account__c);
        }   
        String accQuery = 'SELECT Id, Name, Spirits_Hierarchy__c, Spirits_Hierarchy_Location__c, ParentId, Parent.name, ' +
        				  'Wine_Hierarchy__c, Wine_Hierarchy_Location__c, Beer_Hierarchy__c, Beer_Hierarchy_Location__c ' +
		                  'FROM Account WHERE Account.RecordTypeId in :accountRecordTypesIds AND Id NOT IN :existingAccounts ' ;       
        
        if(!String.isBlank(pageUtilAcc.searchStr)){
          accQuery += 'AND Name LIKE \'%'+pageUtilAcc.searchStr+'%\' ';
        }
        accQuery += 'ORDER BY '  + pageUtilAcc.sortField + ' ' + pageUtilAcc.sortOrder + ' NULLS LAST LIMIT 9999';
        
        pageUtilAcc.setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(accQuery));                
        pageUtilAcc.setCtrl.setPageSize(15);
                
        distribList = null;
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
        List<AccountBrand__c> selected = [SELECT id FROM AccountBrand__c WHERE Brand__c = : BrandId and Account__r.RecordTypeId in :accountRecordTypesIds];

        if (selected.size()>0) {
            delete selected;
        }       
    }

    public void addAll() {
        List<AccountBrand__c> selected = new List<AccountBrand__c>();
        list<Account> allAccounts = new list<Account>();
        
        if(pageUtilAcc.searchStr == null){        		
	        allAccounts = 
	            [
	            	Select Id, Name FROM Account WHERE Account.RecordTypeId in :accountRecordTypesIds and Id NOT IN 
	                (SELECT Account__c FROM AccountBrand__c WHERE Brand__c=:BrandId and Account__r.RecordTypeId in :accountRecordTypesIds)
	            ];
    	} else {
    		 String filter = '%'+pageUtilAcc.searchStr+'%';
    		 allAccounts =
    		 	[ 	
    		 		Select Id, Name FROM Account WHERE Account.RecordTypeId in :accountRecordTypesIds and Id NOT IN 
	                (SELECT Account__c FROM AccountBrand__c WHERE Brand__c=:BrandId and Account__r.RecordTypeId in :accountRecordTypesIds)
	                AND Name LIKE :filter 
	            ];
    	}
    	
    	for(Account distrib : allAccounts){
    		selected.add(new AccountBrand__c(Account__c = distrib.id, Brand__c = BrandId));
    	}
    	
        if (selected.size()>0) {
            insert selected;
        }        
    }
    
	public PageReference cloneRelationsTo() {
       	if(cloneId != null){
       		list<AccountBrand__c> currentRelToDelete = [select id from AccountBrand__c where Brand__c = :cloneId and Account__r.RecordTypeId in :accountRecordTypesIds ];
       		delete currentRelToDelete;
       		list<AccountBrand__c> newRelToCopy = [select id, account__r.id from AccountBrand__c where Brand__c = :BrandId and Account__r.RecordTypeId in :accountRecordTypesIds];
       		list<AccountBrand__c> relToInsert = new list<AccountBrand__c>();
       		for(AccountBrand__c rel : newRelToCopy){
       			relToInsert.add(new AccountBrand__c(Account__c = rel.account__r.id, Brand__c = cloneId));
       		}
       		insert relToInsert;
       		return new PageReference('/'+cloneId);
       	}
      	return null;
    }
    
	public PageReference cloneRelationsFrom() {
       	if(cloneId != null){
       		list<AccountBrand__c> currentRelToDelete = [select id from AccountBrand__c where Brand__c = :BrandId and Account__r.RecordTypeId in :accountRecordTypesIds ];
       		delete currentRelToDelete;
       		list<AccountBrand__c> newRelToCopy = [select id, account__r.id from AccountBrand__c where Brand__c = :cloneId and Account__r.RecordTypeId in :accountRecordTypesIds]; //and brand__r.diageo_direct_visible__c = true];
       		list<AccountBrand__c> relToInsert = new list<AccountBrand__c>();
       		for(AccountBrand__c rel : newRelToCopy){
       			relToInsert.add(new AccountBrand__c(Account__c = rel.account__r.id, Brand__c = BrandId));
       		}
       		insert relToInsert;
			
       		return null;
       	}
       	
       	
       	return null;
    }    
    
    public void addRelations() {
        List<AccountBrand__c> selected = new List<AccountBrand__c>();
        
        populateSelectedAccounts();
        for(String accId : pageUtilAcc.selectedRecords){
          selected.add(
                    new AccountBrand__c(
                        Account__c = accId,
                        Brand__c   = BrandId
                    )
                );
        }
        if (selected.size()>0) {
            insert selected;
        }
        pageUtilAcc.selectedRecords = new Set<String>();        
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
        brandAccountList = null;
    }

    public void last() {
    	populateSelectedAccBrands();
        pageUtilAccBrand.setCtrl.last();
        brandAccountList = null;
    }

    public void previous() {
    	populateSelectedAccBrands();
        pageUtilAccBrand.setCtrl.previous();
        brandAccountList = null;
    }

    public void next() {
    	populateSelectedAccBrands();
        pageUtilAccBrand.setCtrl.next();
        brandAccountList = null;
    }
    
    public Integer totalPagesB {
        get {
        if(pageUtilAcc.setCtrl != null){
          Decimal totalSize = pageUtilAcc.setCtrl.getResultSize();
          Decimal pageSize = pageUtilAcc.setCtrl.getPageSize(); 
          Decimal pages = totalSize/pageSize; 
          return (Integer)pages.round(System.RoundingMode.CEILING);
        } 
        return 0;         
        }
        set;
    }
    
    public void firstB() {
    	populateSelectedAccounts();
        pageUtilAcc.setCtrl.first();
        distribList = null;
    }

    public void lastB() {
    	populateSelectedAccounts();
        pageUtilAcc.setCtrl.last();
        distribList = null;
    }

    public void previousB() {
    	populateSelectedAccounts();
        pageUtilAcc.setCtrl.previous();
        distribList = null;
    }

    public void nextB() {
    	populateSelectedAccounts();
        pageUtilAcc.setCtrl.next();
        distribList = null;
    }
    
    public void doSortAccBrands(){
  	  pageUtilAccBrand.doSort();		
	  populateAccountBrands();				
	}
	
	public void doSortAccounts(){  	
      pageUtilAcc.doSort();	
	  populateAccounts();				
	}
	
	private void populateSelectedAccounts(){
	  for(Distributor dist : distribList){
	  	if(dist.selected){
	  	  pageUtilAcc.selectedRecords.add(dist.a.Id);
	  	}
	  }
	}
	
	private void populateSelectedAccBrands(){
	  for(BrandAccount accBrandObj : brandAccountList){
	  	if(accBrandObj.selected){
	  	  pageUtilAccBrand.selectedRecords.add(accBrandObj.cb.Id);
	  	}
	  }
	}
    
    public class BrandAccount {
        public AccountBrand__c cb {get; set;}
        public Boolean selected {get; set;}
        
        public BrandAccount(AccountBrand__c c) {
            cb = c;
            selected = false;
        }
    }    

    public class Distributor {
        public Account a {get; set;}
        public Boolean selected {get; set;}
        
        public Distributor(Account aa) {
            a = aa;
            selected = false;
        }
    }    
}