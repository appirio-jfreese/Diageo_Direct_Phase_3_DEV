/*******************************************************************************
	(c) 2013 Appirio, Inc.
Created By 	:	Vikash Goyal	(Appirio JDC) 
Story/Task	: US900/TA1651
Description	: Controller class for ProgramMaterial
*******************************************************************************/
public without sharing class ProgramMaterialController {
  
  public list<String> lstLabel {get;set;}
  public list<String> lstSubLabel {get;set;}
  public Map<String, Map<String, List<Content_Description__c>>> mapCategoryToContentDesc{get;set;}
  private String calendarId;
  public boolean hasItems{get;set;}
  
  public ProgramMaterialController(){
  	calendarId = Apexpages.currentPage().getParameters().get('Id');
  	mapCategoryToContentDesc = new Map<String, Map<String, List<Content_Description__c>>>();
  	lstLabel = new List<String>{'Label1', 'Label2', 'Label3'};
  	lstSubLabel = new List<String>{'sLabel1', 'sLabel2', 'sLabel3'};
  	hasItems = true;
  	init();
  }
  
  public void init(){
  	Set<Id> contentDescIds = new Set<Id>();
  	List<Content_Property__c> lstContentProperty = new List<Content_Property__c>([SELECT Id, Sub_Category__c, Sub_Sub_Category__c, Content_Description__c, Category__c FROM Content_Property__c  
  	      WHERE Calendar__c = :calendarId AND Category__c = :CONSTANT.NATIONAL_ACCOUNTS AND Sub_Category__c = :CONSTANT.NATIONAL_ACCOUNTS_CALENDAR]);
  	if(lstContentProperty.size() == 0){
  	  hasItems = false;	
  	}
  	
  	for(Content_Property__c contentProp : lstContentProperty){
  		contentDescIds.add(contentProp.Content_Description__c);
  	}
  	
  	Map<Id,Content_Description__c> mapContentDesc = new Map<Id, Content_Description__c> (
  	                     [SELECT Title__c, Title_Display__c, share_link__c, share_link_low__c FROM Content_Description__c WHERE Id IN : contentDescIds]);
  	
  	for(Content_Property__c contentProp : lstContentProperty){
  		if(!mapCategoryToContentDesc.containsKey(contentProp.Category__c)){
  			mapCategoryToContentDesc.put(contentProp.Category__c, new Map<String, List<Content_Description__c>>());
  		}
  		if(!mapCategoryToContentDesc.get(contentProp.Category__c).containsKey(contentProp.Sub_Sub_Category__c)){
  			mapCategoryToContentDesc.get(contentProp.Category__c).put(contentProp.Sub_Sub_Category__c, new List<Content_Description__c>());
  		}
  		mapCategoryToContentDesc.get(contentProp.Category__c).get(contentProp.Sub_Sub_Category__c).add(mapContentDesc.get(contentProp.Content_Description__c));
  	}
  }
}