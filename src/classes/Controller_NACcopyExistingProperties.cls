/*******************************************************************************
Name        : Controller_NACcopyExistingProperties

Updated By  : Siddharth Varshneya (Appirio JDC)   
Date        : 16/12/13
Story/Task  : US726/TA1770 
Updated By  : Siddharth Varshneya (Appirio JDC)   
Date        : 14/02/14
Story/Task  : US1122/TA2079
*******************************************************************************/
public with sharing class Controller_NACcopyExistingProperties{

    public Content_Property__c tempCp {get;set;}
    public map <string,CPWrapper> mapSR {get;set;}
    public Calendar__c cal {get;set;}
    public boolean isResultShow {get; private set;}
    private string query {get;set;}
    private List<Content_Property__c> lstCopyCP = new List<Content_Property__c>();
    
    //Constructor
    public Controller_NACcopyExistingProperties(){
        mapSR = new map <string,CPWrapper>();
        tempCp = new Content_Property__c();
        isResultShow = false;
        if(ApexPages.currentPage().getParameters().containsKey('calId')){
            cal = [SELECT Name,ID,RecordTypeId FROM Calendar__c WHERE Id =: ApexPages.currentPage().getParameters().get('calId')];
        }
        else{
            cal = new Calendar__c(); 
        }
        RecordType recType = [select id,name from recordtype where name like 'National Accounts' limit 1];
        if(cal.RecordTypeId == recType.Id){
            tempCp.Category__c = 'National Accounts';
        }
    }
    
    //Search button action 
    public void cpSearch(){
        mapSR.clear();
        isResultShow = true;
        string strWHERE = ' WHERE ';
        query = 'SELECT Content_Description__c,Sub_Sub_Sub_Category__c, Sub_Sub_Category__c, Sub_Category__c, Name, Id, Category__c, Calendar__c From Content_Property__c';
        
        if(tempCp.Name != null && tempCp.Name != ''){
            query += ' WHERE Name like  \'%'+  tempCp.Name +'%\'  ';
        }
        if(tempCp.Category__c != null){
            if(query.contains(strWHERE)){
                query += ' AND Category__c = \'' + tempCp.Category__c +'\'  ';
            }
            else{
                query += ' WHERE Category__c = \'' + tempCp.Category__c +'\'  ';
            }
        }
        if(tempCp.Sub_Category__c != null){
            if(query.contains(strWHERE)){
                query += ' AND Sub_Category__c=\'' + tempCp.Sub_Category__c +'\'  ';
            }
            else{
                query += ' WHERE Sub_Category__c=\'' + tempCp.Sub_Category__c +'\'  ';
            }
        }
        if(tempCp.Sub_Sub_Category__c != null){
            if(query.contains(strWHERE)){
                query += ' AND Sub_Sub_Category__c=\'' + tempCp.Sub_Sub_Category__c +'\'  ';
            }
            else{
                query += ' WHERE Sub_Sub_Category__c=\'' + tempCp.Sub_Sub_Category__c +'\'  ';
            }
        }
        if(tempCp.Sub_Sub_Sub_Category__c != null){
            if(query.contains(strWHERE)){
                query += ' AND Sub_Sub_Sub_Category__c=\'' + tempCp.Sub_Sub_Sub_Category__c +'\'  ';
            }
            else{
                query += ' WHERE Sub_Sub_Sub_Category__c=\'' + tempCp.Sub_Sub_Sub_Category__c +'\'  ';
            }
        }
        try{
            List <Content_Property__c> lstCP = Database.query(query);
            
            Content_Property__c newCP ;
            for(Content_Property__c tmp : lstCP){
                newCP = new Content_Property__c();
                newCP = tmp.clone();
                newCP.Content_Description__c = tmp.Content_Description__c;
                mapSR.put(tmp.Id,new CPWrapper(false,tmp,newCP));
            }
        }
        catch(exception e){
        
        }
    }
    
    //Close and copy of Content Property 
    public void cpCopy(){
        for(CPWrapper obj : mapSR.values()){
            if(obj.selected){
                obj.targetCp.Calendar__c = cal.Id;
                lstCopyCP.add(obj.targetCp);
            }
        }
        insert lstCopyCP;
    }
    
    //Wrapper class for search reults
    public class CPWrapper{
        public Boolean selected {get;set;}
        public Content_Property__c sourceCp {get;set;}
        public Content_Property__c targetCp {get;set;}
        
        public CPWrapper(Boolean sel, Content_Property__c sCP,Content_Property__c tCP){
            selected = sel;
            sourceCp = sCP;
            targetCp = tCP;
        }
    }
}