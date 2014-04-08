/*******************************************************************************
Name        : HQAccountHierarchyController

Created By  : Vikash Goyal (Appirio JDC)   
Date        : 31/10/13
Story/Task  : US807/TA1571

Updated By  : Basant Verma (Appirio JDC)   
Date        : 12/11/13
Story/Task  : US871/TA1589

Updated By  : Basant Verma (Appirio JDC)   
Date        : 01/16/2014
Story/Task  : US1035/TA1859

Updated By  : Basant Verma (Appirio JDC)   
Date        : 01/17/2014
Story/Task  : DE989

Updated By  : Basant Verma (Appirio JDC)   
Date        : 01/17/2014
Story/Task  : DE987

Updated By  : Basant Verma (Appirio JDC)   
Date        : 01/23/2014
Story/Task  : DE987/TA1877

Updated By  : Basant Verma (Appirio JDC)   
Date        : 01/23/2014
Story/Task  : US1035/TA1900

Updated By  : Basant Verma (Appirio JDC)   
Date        : 01/29/2014
Story/Task  : TA1924/DE1006

Updated By  : Basant Verma (Appirio JDC)   
Date        : 02/03/2014
Story/Task  : Code Coverage and Data Cleanup
*******************************************************************************/
public without sharing class HQAccountHierarchyController {
    public List<Brand__c> calendarBrands {get; set;}
    // START - Changed for US871/TA1589 : Add Brand Filter
    public Boolean disableFilter {get; private set;}
    public Integer activeFilter {get; private set;}
    public Boolean expandFilter {get;set;}
    public Boolean selectAllBrands {public get; public set;}
    public String siteTheme {get; set;}
    public List<Brand__c> parentBrandList {get; set;}
    public List<Brand__c> additionalBrandList{get; set;}
    public List<Brand__c> childBrandList {get; set;}
    protected List<Id> selectedBrandIdsList {protected get; protected set;}
    public Integer brandBoxToRender {get;set;}
    public String selectedBrandIds {get; set;}
    public Boolean selectedRTS {get; set;}
    public Boolean selectedPortfolio {get; set;}
    public Boolean selectedTBA {get; set;}
    public Boolean isSelected { get; set; }
    public String communicationTemplateName { get; set; }
    
    public Lead lead {get;set;}
    public Boolean isMemberRequest {get;set;}
    
    public List<Account> distributorList {get; set;}
    public List<Account> existingDistributors {get; set;}
    public List<Contact> distributorContacts {get; set;}
    public String allSelectedDistributorAccounts {get; set;}
    // END - Changed for US871/TA1589 : Add Brand Filter
    // Error Messages
    private final String INVALID_RT_ERROR = 'INVALID RECORD TYPE: This is applicable only on '+Label.Outlet_Store_Record_Type+' Accounts';
    private final String INVALID_PARAM = 'INVALID PARAMETER: Account Id did not passed';
    private final String MISMATCHED_STATES = 'MISMATCHED STATES: There are few missmatched state names, please contact Administrator';
    private final String NO_MATCH = 'NO MATCH FOUND: No '+Label.Outlet_Store_Record_Type+' Accounts found by selected combination of National Account Group, Marketing Group and Key Account Group';
    private boolean isFirst = true;
    
    // Public propeties which we will use on Page
    public Id campaignId { get; set; }
    public Campaign campaignObj { get; set; }
    public String allSelectedStateCheckBox { get; set; }
    public String allSelectedStoreAccounts { get; set; }
    public Map<String, Integer> existingCampStates {get; set;}
    public Set<String> existingCampStatesNames {
        get{
            if(existingCampStates != null)
                existingCampStatesNames = existingCampStates.keySet();
            return existingCampStatesNames;
        }
        protected set;
    }
    
    public String scheduleButtonText {
        get {
            if(scheduleButtonText == null) {
                scheduleButtonText = 'Schedule';
            }
            return scheduleButtonText;
        }
        
        protected set;
    }
    
    public List<Account> storeAccList {get; protected set;}
    public Map<String, String> states {
        get{
            if(states == null){
                states = new Map<String, String>();
            }
            return states;
        } 
        protected set;
    }
    public List<String> statesSet {
        get{
            if(states != null){
                List<String> lst = new List<String>();
                lst.addAll(states.keySet());
                lst.sort();
                return lst;
            }   
            else{
                return new List<String>();
            }
        }
        protected set;
    }
    
    public Map<String, Marketing_Group__c> mrktGrps {get; protected set;}
    public Map<String, String> mrktGrpsClass {get; protected set;}
    public List<String> marketingGroupsSet {
        get{
            if(mrktGrpsClass != null){
                List<String> lst = new List<String>();
                lst.addAll(mrktGrpsClass.keySet());
                lst.sort();
                return lst;
            }
            else{
                return new List<String>();
            }
        }
        protected set;
    }
    // START  : Changed for TA1924/DE1006 : By Basant Verma
    public String allSelectedMarketingGrps {get; set;}
    // END      : Changed for TA1924/DE1006 : By Basant Verma
    public String selectedState {set; get;}
    public Map<String, String> stageAbbrevations {set; get;}
    // START : Changed for DE987 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
    public Map<String, String> stageReverseAbbrevations {set; get;}
    public List<SelectOption> allStatesList {
        get{
            if(allStatesList == null){
                allStatesList = new List<SelectOption>();
                stageAbbrevations = new Map<String, String>();
                stageReverseAbbrevations = new Map<String, String>();
                for(States__c st : [Select Id, Name, Abbreviation__c From States__c Order by Name]){
                    allStatesList.add(new SelectOption(st.Abbreviation__c, st.Name));
                    stageAbbrevations.put(st.Abbreviation__c, st.Name);
                    stageReverseAbbrevations.put(st.Name, st.Abbreviation__c);
                    if(!states.containsKey(st.Abbreviation__c)){
                        states.put(st.Abbreviation__c,'');
                    }
                }
            }
            return allStatesList;
        }
        protected set;
    }
    // END : Changed for DE987 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
    public integer arSize { get; set; }
    
    // Constructor
    public HQAccountHierarchyController(ApexPages.StandardController stdController) {
      // Check for National Account Group
    	try{
    		campaignId = stdController.getId();
        init();
        setCampaignStatus();
        setCommunicationTemplateName();
        isFirst = false;
        isSelected = false;
        if(Apexpages.currentPage().getParameters().containsKey('isSelected')
        	&& Apexpages.currentPage().getParameters().get('isSelected').trim().equalsIgnoreCase('true')){
        	isSelected = true;
        }
        
      }catch(Exception e){
        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
      }
    }
    
    private void init(){
        // START : Changed for US1035/TA1859 : By Basant Verma(Appirio JDC), 16th Jan, 2014
        //START : Changed for DE987/TA1877 : By Basant Verma
        lead = new Lead();
        isMemberRequest = false;
	      if(ApexPages.currentPage().getParameters().get('method') != null && ApexPages.currentPage().getParameters().get('method') == 'CreateMember'){
	        isMemberRequest = true;
	      }
      
        campaignObj = [Select Id, Name, Communication_Template__c, Key_Account_Group__c, 
        Marketing_Group__c, National_Account__c, National_Account_Group__c, Program__c, Members_Selected__c,
        Scheduled_Send_Date__c, Status, Program__r.Classification__c, Program__r.Sales_Channel__c, Campaign_States__c
        // START : Changed for TA1924/DE1006 : By Basant Verma
        ,(Select Campaign__c, Account__c From Campaign_Accounts__r), (Select Campaign__c, Marketing_Group__c From Campaign_Marketing_Groups__r)
        // END : Changed for TA1924/DE1006 : By Basant Verma
        From Campaign Where Id = :campaignId limit 1].get(0);
        //END : Changed for DE987/TA1877 : By Basant Verma
        // END  : Changed for US1035/TA1859 : By Basant Verma(Appirio JDC), 16th Jan, 2014
        calendarBrands = new List<Brand__c>();
        
        if(!isMemberRequest){
        Set<String> calendarBrandIDs = new Set<String>();
        if(campaignObj.Program__c != null){
            for(CalendarBrand__c cb : [Select Id, Name, Calendar__c, Brand__c From CalendarBrand__c Where Calendar__c = :campaignObj.Program__c]){
                calendarBrandIDs.add(cb.Brand__c);
            }
            
            if(calendarBrandIDs.size() > 0){
                    // START : Changed for US1035/TA1900 : By Basant Verma
                calendarBrands = [Select Id, Name, Classification__c From Brand__c Where Id IN :calendarBrandIDs];
                // END   : Changed for US1035/TA1900 : By Basant Verma
            }
        }
      
        states = new Map<String, String>();
        mrktGrpsClass = new Map<String, String>();
        storeAccList = new List<Account>();
        existingCampStates = new Map<String, Integer>();
        for(CampaignMember cm : [Select Id, Contact.Distributor_State__c From CampaignMember Where CampaignId = :campaignId]){
          
          if(!existingCampStates.containsKey(cm.Contact.Distributor_State__c)) { existingCampStates.put(cm.Contact.Distributor_State__c, 0); }
                    //START : Changed for DE987/TA1877 : By Basant Verma          
          /*// START : Changed for DE987 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
          if(allStatesList != null && !states.containsKey(cm.Contact.Distributor_State__c) 
            && stageReverseAbbrevations.containsKey(cm.Contact.Distributor_State__c)){ 
            states.put(stageReverseAbbrevations.get(cm.Contact.Distributor_State__c), 'AlwaysShow'); 
          }
          // END : Changed for DE987 : By Basant Verma (Appirio JDC) : 17th Jan, 2014*/
          //END : Changed for DE987/TA1877 : By Basant Verma
        }
        //START : Changed for DE987/TA1877 : By Basant Verma 
        if(campaignObj.Campaign_States__c != null){
            for(String st : campaignObj.Campaign_States__c.split(',')){
                if(!states.containsKey(st))
                    states.put(st, '');
                states.put(st, states.get(st)+' AlwaysShow');
            }      
        } 
        //END : Changed for DE987/TA1877 : By Basant Verma 
        
        // START : Changed for TA1924/DE1006 : By Basant Verma
        for(Campaign_Marketing_Groups__c cmg :  campaignObj.Campaign_Marketing_Groups__r){
            if(!mrktGrpsClass.containsKey(cmg.Marketing_Group__c)) {
                        mrktGrpsClass.put(cmg.Marketing_Group__c, '');
            }
            mrktGrpsClass.put(cmg.Marketing_Group__c, mrktGrpsClass.get(cmg.Marketing_Group__c)+' AlwaysShow');
        }
        System.debug('==================== allSelectedStoreAccounts : '+allSelectedStoreAccounts);
        String glue = '';
        allSelectedStoreAccounts = '';
        for(Campaign_Accounts__c ca :  campaignObj.Campaign_Accounts__r){
            if(!allSelectedStoreAccounts.contains(ca.Account__c)) {
                        allSelectedStoreAccounts += glue + ca.Account__c;
                        glue = ',';
            }
        }
        System.debug('==================== allSelectedStoreAccounts : '+allSelectedStoreAccounts);
        // END   : Changed for TA1924/DE1006 : By Basant Verma
//        String queryString = 'SELECT Id, Name, RecordTypeId, RecordType.Name, ParentId, TDLinx_Outlet_City__c, '+
//            ' TDLinx_Outlet_State__c, Marketing_Group__c, Marketing_Group__r.Name ' +  
//            ' From Account ' +
//            ' WHERE RecordType.Name = \''+Label.Outlet_Store_Record_Type+'\' AND ParentId != null';

        String queryString = 'SELECT TDLinx_Outlet_State__c, Marketing_Group__c, Marketing_Group__r.Name MarketingGroupName, ParentId, COUNT(ID) ' +  
            'From Account ' +
            'WHERE RecordType.Name = \''+Label.Outlet_Store_Record_Type+'\' AND ParentId != null ';
            
        String conditionClause = '';
        if(campaignObj.National_Account_Group__c != null){
            conditionClause += ' AND National_Account_Group__c = \''+campaignObj.National_Account_Group__c+'\' ';
        }
        if(campaignObj.Marketing_Group__c != null){
            conditionClause += ' AND Marketing_Group__c = \''+campaignObj.Marketing_Group__c+'\' ';
        }
        if(campaignObj.Key_Account_Group__c != null){
            conditionClause += ' AND Key_Account_Group__c = \''+campaignObj.Key_Account_Group__c+'\' ';
        }       
        
        arSize = 0;
        
        if(conditionClause != null && !conditionClause.trim().equals('')){
        
            queryString += conditionClause + ' GROUP BY TDLinx_Outlet_State__c, Marketing_Group__c, Marketing_Group__r.Name, ParentId ORDER BY Marketing_Group__r.Name, TDLinx_Outlet_State__c';
            AggregateResult [] ar = Database.query(queryString);
            arSize = ar.size();
            if(ar.size() >0) {
                for(AggregateResult a : ar) {
                    String stateValue = (String)a.get('TDLinx_Outlet_State__c');
                    String parentId = (String)a.get('ParentId');
                    String mktgGroup = (String)a.get('Marketing_Group__c');
                    String mktgGroupName = (String)a.get('MarketingGroupName');
                    
                    // START : Changed for DE989 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
                    if(stateValue != null && !stateValue.trim().equals('')){
                        if(!states.containsKey(stateValue)) {
                            states.put(stateValue, parentId);
                        } else if(!states.get(stateValue ).contains(parentId)) {
                            states.put(stateValue ,states.get(stateValue)+' '+parentId);
                        }
                    }
                    // END  : Changed for DE989 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
                        
                    if(mktgGroup != null && mktgGroupName != null){
                        // Also add Marketing Group Id
                        // START : Changed for DE989 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
                        if(states.containsKey(stateValue) && !states.get(stateValue ).contains(mktgGroup)) { 
                            states.put(stateValue ,states.get(stateValue)+' '+mktgGroup);
                        }
                        // END  : Changed for DE989 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
                        
                        if(!mrktGrpsClass.containsKey(mktgGroup)) {
                            mrktGrpsClass.put(mktgGroup, parentId);
                        } else if(!mrktGrpsClass.get(mktgGroup).contains(parentId)) {
                            mrktGrpsClass.put(mktgGroup, mrktGrpsClass.get(mktgGroup)+' '+parentId);
                        }
     
                    }
                    
                    List<SelectOption> stateOptionList = allStatesList;
                    List<String> statesNameSet = statesSet;
                    if(statesNameSet.size() != stateOptionList.size() && isFirst){
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.WARNING, MISMATCHED_STATES));
                    }
                    
                    if(existingCampStates.containsKey(stateValue)){
                        existingCampStates.put(stateValue, existingCampStates.get(stateValue)+1);
                    }
                    
                }
                mrktGrps = new Map<String, Marketing_Group__c>([Select Id, Name From Marketing_Group__c Where Id IN :marketingGroupsSet]);
                
            }else{
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, NO_MATCH));
                storeAccList = new List<Account>();
            }
/*
            queryString += conditionClause;
            storeAccList = (List<Account>)Database.query(queryString);
            if(storeAccList != null && storeAccList.size() > 0) {
            
                // Build Distinct States Map, with their Parent Banner info
                for(Account storeAcc : storeAccList){
                    if(!states.containsKey(storeAcc.TDLinx_Outlet_State__c ))
                        states.put(storeAcc.TDLinx_Outlet_State__c ,storeAcc.ParentId);
                    else if(!states.get(storeAcc.TDLinx_Outlet_State__c).contains(storeAcc.ParentId))
                        states.put(storeAcc.TDLinx_Outlet_State__c ,states.get(storeAcc.TDLinx_Outlet_State__c )+' '+storeAcc.ParentId);
                    
                    if(storeAcc.Marketing_Group__c != null && storeAcc.Marketing_Group__r != null){
                        // Also add Marketing Group Id
                        if(!states.get(storeAcc.TDLinx_Outlet_State__c).contains(storeAcc.Marketing_Group__c))
                            states.put(storeAcc.TDLinx_Outlet_State__c ,states.get(storeAcc.TDLinx_Outlet_State__c )+' '+storeAcc.Marketing_Group__c);
                        
                        if(!mrktGrpsClass.containsKey(storeAcc.Marketing_Group__c))
                            mrktGrpsClass.put(storeAcc.Marketing_Group__c, storeAcc.ParentId);
                        else if(!mrktGrpsClass.get(storeAcc.Marketing_Group__c).contains(storeAcc.ParentId))
                            mrktGrpsClass.put(storeAcc.Marketing_Group__c, mrktGrpsClass.get(storeAcc.Marketing_Group__c)+' '+storeAcc.ParentId);
                              
                    }
                    
                    List<SelectOption> stateOptionList = allStatesList;
                    List<String> statesNameSet = statesSet;
                    if(statesNameSet.size() != stateOptionList.size() && isFirst){
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, MISMATCHED_STATES));
                    }
                    
                    if(existingCampStates.containsKey(storeAcc.TDLinx_Outlet_State__c)){
                        existingCampStates.put(storeAcc.TDLinx_Outlet_State__c, existingCampStates.get(storeAcc.TDLinx_Outlet_State__c)+1);
                    }
                }
                mrktGrps = new Map<String, Marketing_Group__c>([Select Id, Name From Marketing_Group__c Where Id IN :marketingGroupsSet]);              
            }else{
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, NO_MATCH));
                storeAccList = new List<Account>();
            }
*/
        }
        }
    }
    
    public Pagereference selectAccount(){
        try{
            isSelected = false;
            update campaignObj;
// RKW 02-10-2014            init();            
            reSet();
            isSelected = true;
        }catch(DMLException e){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
    
    public Pagereference createCampaignMembers(){
    		Pagereference pg = null;
        try{
            System.debug('=============== allSelectedStateCheckBox '+allSelectedStateCheckBox);
            System.debug('=============== allSelectedStoreAccounts '+allSelectedStoreAccounts);
            campaignObj.Members_Selected__c = true;
            Set<String> states = new Set<String>();
            Set<String> statesAbb = new Set<String>();
            Set<String> accounts = new Set<String>();
            //START : Changed for DE987/TA1877 : By Basant Verma
            campaignObj.Campaign_States__c = allSelectedStateCheckBox;
            //END : Changed for DE987/TA1877 : By Basant Verma
            for(String str : allSelectedStateCheckBox.split(',')){
                str = str.trim();
                statesAbb.add(str);
                if(stageAbbrevations.containsKey(str))
                    states.add(stageAbbrevations.get(str));
            }
            for(String str : allSelectedStoreAccounts.split(',')){
                str = str.trim();
                accounts.add(str);
            }
            
            // START : Changed for US1035/TA1900 : By Basant Verma
            Set<String> brandClassifications = new Set<String>();
            for(Brand__c b : calendarBrands){
                if(b.Classification__c != null && !b.Classification__c.trim().equals('') 
                    && !brandClassifications.contains(b.Classification__c)){
                    brandClassifications.add(b.Classification__c);
                }   
            }
            // END : Changed for US1035/TA1900 : By Basant Verma
            
            // START : Changed for US1035/TA1859 : By Basant Verma(Appirio JDC), 16th Jan, 2014
            String stateList = getStateListForInclude(states);
            
            String contactSoql = 'Select Id, Name, AccountId, Account.Name, Select_Managed_States__c '+
            ' From Contact Where (Distributor_State__c IN :states OR Select_Managed_States__c INCLUDES (' + stateList + ') OR Select_Managed_States__c = \'All\') ' +
            ' AND Unsubscribe__c != true AND NAC_Unsubscribe__c != true ' +
            ' AND (Subscribe_Status__c = \'Approved\' OR NAC_Update_Request_Status__c = \'Submitted\')';
            
            if(campaignObj != null && campaignObj.Program__c != null){
                    // START : Changed for US1035/TA1900 : By Basant Verma
                /*if(campaignObj.Program__r.classification__c != null 
                    && !campaignObj.Program__r.classification__c.trim().equals('')
                    && !campaignObj.Program__r.classification__c.trim().equalsIgnoreCase('Mixed')){
                    contactSoql += ' AND Subscribe_Interested_In__c INCLUDES (\''+campaignObj.Program__r.classification__c+'\') ';
                }*/
                if(brandClassifications.size() > 0){
                    contactSoql += ' AND ( ';
                    for(String th : brandClassifications){
                        contactSoql += ' Subscribe_Interested_In__c INCLUDES (\''+th+'\') OR ';
                    }
                    contactSoql = contactSoql.substring(0,contactSoql.length()-3) + ' ) ';
                }
                // END : Changed for US1035/TA1900 : By Basant Verma
                
                if(campaignObj.Program__r.sales_channel__c != null 
                    && !campaignObj.Program__r.sales_channel__c.trim().equals('')){
                    contactSoql += ' AND Subscribe_Premise__c INCLUDES (\''+campaignObj.Program__r.sales_channel__c+'\') ';
                }
            }
            distributorContacts = (List<Contact>)Database.query(contactSoql);
            // END : Changed for US1035/TA1859 : By Basant Verma(Appirio JDC), 16th Jan, 2014   
            fetchDistributors();
            
            update campaignObj;
            
            // START  : Changed for TA1924/DE1006 : By Basant Verma
            System.debug('======================= allSelectedStoreAccounts '+allSelectedStoreAccounts);
            System.debug('======================= allSelectedMarketingGrps '+allSelectedMarketingGrps);
            System.debug('======================= allSelectedStateCheckBox '+allSelectedStateCheckBox);
            createCampaignMarketingGrps(allSelectedMarketingGrps);
            createCampaignAccounts(allSelectedStoreAccounts);
            // END    : Changed for TA1924/DE1006 : By Basant Verma
            
            List<Contact> contacts = new List<Contact>();
            Set<String> distributorAccIds = new Set<String>();
            if(distributorList != null && distributorList.size()>0){
                for(Account acc : distributorList){
                    distributorAccIds.add(acc.Id);
                }
            }
            if(distributorAccIds != null && distributorAccIds.size() > 0){
                createCampaignDistributors(distributorAccIds);
            }
            
            if(distributorContacts != null && distributorContacts.size() > 0){
                createCampaignMembers(distributorContacts);
            }
            // So we do not need to refresh the page
            init();
        }catch(Exception e){
             Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
        }
        return pg;
    }
    
    // START  : Changed for DE1038 : by Randy Wandell
    public String getStateListForInclude(Set<String> states) {
        String returnValue='';
        for(String s : states) {
            System.debug(s);
            if(returnValue != '') { returnValue += ',\''; } else { returnValue='\''; }
            returnValue += s + '\'';
        }
        
        return returnValue;
    }
    // END    : Changed for DE1038 : by Randy Wandell
    
    // START  : Changed for TA1924/DE1006 : By Basant Verma
    private void createCampaignMarketingGrps(String allChecekd){
        if(campaignObj.Campaign_Marketing_Groups__r != null && campaignObj.Campaign_Marketing_Groups__r.size() > 0){
        delete campaignObj.Campaign_Marketing_Groups__r;
      }
        List<Campaign_Marketing_Groups__c> cmgList = new List<Campaign_Marketing_Groups__c>();
        if(allChecekd != null)
        for(String mgId : allChecekd.split(',')){
            if(!mgId.trim().equals('')){
                cmgList.add(new Campaign_Marketing_Groups__c(Campaign__c = campaignObj.Id, Marketing_Group__c = mgId));
            }
        }
        if(cmgList.size() > 0)
            insert cmgList;
    }
    
    private void createCampaignAccounts(String allChecekd){
        if(campaignObj.Campaign_Accounts__r != null && campaignObj.Campaign_Accounts__r.size() > 0){
        delete campaignObj.Campaign_Accounts__r;
      }
        List<Campaign_Accounts__c> caList = new List<Campaign_Accounts__c>();
        if(allChecekd != null)
        for(String accId : allChecekd.split(',')){
            if(!accId.trim().equals('')){
                caList.add(new Campaign_Accounts__c(Campaign__c = campaignObj.Id, Account__c = accId));
            }
        }
        if(caList.size() > 0)
            insert caList;
    }
    // END  : Changed for TA1924/DE1006 : By Basant Verma
     
    private void createCampaignMembers(List<Contact> contacts){
        Set<String> existingCampaignMembers = new Set<String>();
        for(CampaignMember cm : [Select Id, CampaignId, ContactId From CampaignMember Where CampaignId = :campaignId]){
            existingCampaignMembers.add(cm.ContactId);
        }
        
        List<CampaignMember> campaignMembers = new List<CampaignMember>();
        for(Contact con : contacts){
            if(!existingCampaignMembers.contains(con.Id)){
                CampaignMember cm = new CampaignMember();
                cm.CampaignId = campaignId;
                cm.ContactId = con.Id;
                cm.Manually_Created__c = false;
                campaignMembers.add(cm);
            }
        }
        if(campaignMembers != null && campaignMembers.size() > 0){
            try{
                insert campaignMembers;
                init();
            }catch(DMLException e){
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
                System.debug('Exception when Creating Campaign Members '+e.getMessage());
            }
        }
    }
    
    private void createCampaignDistributors(Set<String> distributorsIds){
        Set<String> existingCampaignDistributors = new Set<String>();
        for(Campaign_Distributor__c cd : [Select Id, Campaign__c, Distributor_Account__c From Campaign_Distributor__c Where Campaign__c = :campaignId]){
            existingCampaignDistributors.add(cd.Distributor_Account__c);
        }
        
        List<Campaign_Distributor__c> campaignDistributor = new List<Campaign_Distributor__c>();
        for(String accId : distributorsIds){
            if(!existingCampaignDistributors.contains(accId)){
                Campaign_Distributor__c cd = new Campaign_Distributor__c();
                cd.Campaign__c = campaignId;
                cd.Distributor_Account__c = accId;
                cd.Manually_Created__c = false;
                campaignDistributor.add(cd);
            }
        }
        if(campaignDistributor != null && campaignDistributor.size() > 0){
            try{
                insert campaignDistributor;
                init();
            }catch(DMLException e){
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
                System.debug('Exception when Creating Campaign Distributor '+e.getMessage());
            }
        }
    }
        
    public void fetchDistributors(){
        existingDistributors = new List<Account>();
        distributorList = new List<Account>();
        Set<String> accountIds = new Set<String>();
        for(Campaign_Distributor__c cd : [Select Id, Name, Campaign__c, Distributor_Account__c, Distributor_Account__r.Name From Campaign_Distributor__c Where Campaign__c = :campaignId]){
            if(!accountIds.contains(cd.Distributor_Account__c))
                accountIds.add(String.valueOf(cd.Distributor_Account__c));
        }
        if(accountIds.size() > 0){
            for(Account acc : [Select Id, Name From Account Where RecordType.Name = 'Distributor' AND Id IN :accountIds]){
                existingDistributors.add(acc);
            }
            accountIds.clear();
        }
        
        for(CampaignMember cm : [Select Id, CampaignId, Contact.AccountId, Contact.Account.Name From CampaignMember Where CampaignId = :campaignId]){
            if(!accountIds.contains(cm.Contact.AccountId))
                accountIds.add(String.valueOf(cm.Contact.AccountId));
        }
        for(Contact con : distributorContacts){
            if(!accountIds.contains(con.AccountId))
                accountIds.add(String.valueOf(con.AccountId));
        }
        if(accountIds.size() > 0){
            Set<String> tempAccIds = new Set<String>();
            if(calendarBrands != null && calendarBrands.size() > 0){
                for(AccountBrand__c ab : [Select Id, Account__c From AccountBrand__c Where Brand__c IN :calendarBrands]){
                    if(accountIds.contains(ab.Account__c))
                        tempAccIds.add(ab.Account__c);
                }
            }/*else{
                tempAccIds.addAll(accountIds);
            }*/
            distributorList = [Select Id, Name From Account Where RecordType.Name = 'Distributor' AND Id IN :tempAccIds];
            accountIds.clear();
        }
    }
    
    public void reSet(){
        try{
            campaignObj.Members_Selected__c = false;
            //START : Changed for DE987/TA1877 : By Basant Verma
            campaignObj.Campaign_States__c = '';
            //END : Changed for DE987/TA1877 : By Basant Verma
            update campaignObj;
            List<CampaignMember> cmList = [Select Id From CampaignMember Where CampaignId = :campaignId AND Manually_Created__c = false AND ContactId != null];
            delete cmList;
            List<Campaign_Distributor__c>  cdList = [Select Id From Campaign_Distributor__c Where Campaign__c = :campaignId AND Manually_Created__c = false];
            delete cdList;
            
            /// START : Cahnaged for TA1924/DE1006 : By Basant Verma
            if(campaignObj.Campaign_Accounts__r != null){
                delete campaignObj.Campaign_Accounts__r;
            }
            if(campaignObj.Campaign_Marketing_Groups__r != null){
                delete campaignObj.Campaign_Marketing_Groups__r;
            }
            /// END : Cahnaged for TA1924/DE1006 : By Basant Verma
            init();
        }catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
                System.debug('Exception when ReSeting Campaign'+e.getMessage());
        }
        
    }
    // END - Changed for US871/TA1589 : Add Brand Filter
    
    public PageReference setCampaignStatus() {
        Campaign campaign = [Select Id, Status, Scheduled_Send_Date__c From Campaign Where Id = :campaignId].get(0);
        if(!isFirst) {
            if(campaignObj.Scheduled_Send_Date__c != null && (campaignObj.Status == 'Planned' || campaignObj.Status == 'Aborted')) {
                campaign.Status = 'Scheduled';
                campaignObj.Status = 'Scheduled';
                scheduleButtonText = 'Abort';
            } else if(campaignObj.Scheduled_Send_Date__c != null && campaignObj.Status == 'Scheduled') {
                campaign.Status = 'Aborted';
                campaignObj.Status = 'Aborted';
                scheduleButtonText = 'Schedule';
            }
            campaign.Scheduled_Send_Date__c = campaignObj.Scheduled_Send_Date__c;
            
            update campaign;
        } else {
            campaign.Status = campaignObj.Status;
            if(campaignObj.Scheduled_Send_Date__c == null) {
                scheduleButtonText = 'Schedule';
            } else if(campaignObj.Scheduled_Send_Date__c != null && (campaignObj.Status == 'Planned' || campaignObj.Status == 'Aborted')) {
                scheduleButtonText = 'Schedule';
            } else {
                scheduleButtonText = 'Abort';
            }
        }
        
        return null;
    }
    
    public void setCommunicationTemplateName() {
        List<EmailTemplate> emailTemplates = [SELECT Id, Name FROM EmailTemplate WHERE Id =: campaignObj.Communication_Template__c];
        if(emailTemplates .size()>0) {
            communicationTemplateName = emailTemplates[0].Name;
        } else {
            communicationTemplateName = '--- Communication Template Not Set ---';
        }
    }
    
    public Pagereference createNewLeadCampaignMember(){
        try{
            lead.Status = 'Open';
            insert lead;
            CampaignMember cm = new CampaignMember();
          	cm.CampaignId = campaignObj.Id;
            cm.LeadId = lead.Id;
            insert cm;
            init();
        }
        catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
        }
        return null;
   }
}