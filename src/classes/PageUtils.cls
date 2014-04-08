/*******************************************************************************
Created By  : Vikash Goyal(Appirio JDC)
Date 	    : 11th Feb, 2014
Task/Defect : TA2015
*******************************************************************************/
public with sharing class PageUtils {
	
  public ApexPages.Standardsetcontroller setCtrl{get;set;}
  public String searchStr{get;set;}
  public Brand__c brand{get;set;}
  public String sortField {
    get;
    set {
      sortField = value;  
    }
  }
  public boolean isAsc{set; get;}
  public String sortOrder;
  public String previousSortField;
  public set<String> selectedRecords {get;set;}
  
  Public PageUtils(){
  	brand = new Brand__c();
  	selectedRecords = new Set<String>();
  }
  
  Public PageUtils(String sortField, String sortOrder, String previousSortField, Boolean isAsc){
  	brand = new Brand__c();
  	this.isAsc = isAsc;
  	this.sortField = sortField;
  	this.sortOrder = sortOrder;
  	this.previousSortField = previousSortField;
  	selectedRecords = new Set<String>();
  }
  
  public void doSort(){
  	if (previousSortField.equals(sortField)){
	  isAsc = !isAsc;  
	} else {
	  isAsc = true;
	}
		   
	sortOrder = isAsc ? 'ASC' : 'DESC';
	previousSortField = sortField;
  }

}