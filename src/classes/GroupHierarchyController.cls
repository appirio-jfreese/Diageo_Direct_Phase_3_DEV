/*******************************************************************************
Name        : GroupHierarchyController 

Created By  : Randy Wandell (Appirio)
Date        : 12/5/2013
Story/Task  : US923/TA1706
*******************************************************************************/
public without sharing class GroupHierarchyController {

    public without sharing class AccountHierarchy {
        public integer depth { get; set; }
        public Account a { get; set; }
        
        public AccountHierarchy(integer depth, Account a) {
            this.depth = depth;
            this.a = a;
        }
    }
    
    public String firstLoad {get; set;}
        
    public Map<Id, List<AccountHierarchy>> hierarchy { get; set; }
    public List<Account> accounts { get; set; }
    public List<Account> headquarters { 
        get{
            if(firstLoad != null && firstLoad.trim().equalsIgnoreCase('TRUE')){
                init();
                firstLoad = 'false';
            }
            return headquarters;
        }
    set; }
    public Campaign campaign { get; set; }
    public String campaignId { get; set; }
    public integer numberOfAccounts { get; set; }
    
    public GroupHierarchyController() {
        init();
    }
    
    public GroupHierarchyController(ApexPages.StandardController stdController) {
      campaignId = stdController.getId();
      init();
    }
    
    public Pagereference init(){
        // Check for National Account Group
        if ( campaignId == null ) {
            campaignId = System.currentPageReference().getParameters().get( 'id' );
        }
        if(campaignId != null && !campaignId.trim().equals('')){
            campaign = [SELECT Id, Name, National_Account_Group__c, Marketing_Group__c, Key_Account_Group__c FROM Campaign WHERE Id =: campaignId];
            getNationalAccountGroupHierarchy();
        }
        return null;
    }
    
    public void getNationalAccountGroupHierarchy() {
            firstLoad = 'false';
        String queryString = 'SELECT Id, Name, RecordTypeId, RecordType.Name, ParentId, TDLinx_Outlet_City__c, '+
            ' TDLinx_Outlet_State__c, Marketing_Group__c, Marketing_Group__r.Name, TDLINX_Account_Level_A__c, ' +
            ' TDLINX_Account_Level_B__c, TDLINX_Account_Level_C__c, TDLINX_Account_Level_D__c, TDLINX_Account_Level_E__c ' +  
            ' From Account ' +
            ' WHERE RecordType.Name = \''+Label.Outlet_Store_Record_Type+'\' ';
            
        String conditionClause = '';
        if(campaign.National_Account_Group__c != null){
            conditionClause += ' AND National_Account_Group__c = \''+campaign.National_Account_Group__c+'\' ';
        }
        if(campaign.Marketing_Group__c != null){
            conditionClause += ' AND Marketing_Group__c = \''+campaign.Marketing_Group__c+'\' ';
        }
        if(campaign.Key_Account_Group__c != null){
            conditionClause += ' AND Key_Account_Group__c = \''+campaign.Key_Account_Group__c+'\' ';
        }
        
        if(conditionClause != null && !conditionClause.trim().equals('')){
            queryString += conditionClause + ' ORDER BY NAME';
            accounts = getParentAccounts(queryString);
//            accounts = (List<Account>)Database.query(queryString);
            headquarters = new List<Account>();
            hierarchy = new Map<Id, List<AccountHierarchy>>();
            for(Account account : accounts) {
                if(account.RecordType.Name == Label.Outlet_Headquarters_Record_Type && account.ParentId == null) {
                    List<AccountHierarchy> childAccounts = getChildAccounts(account.Id, 0);
                    hierarchy.put(account.Id, childAccounts);
                    headquarters.add(account);
                }
            }
        }
    }
    
        
    public List<AccountHierarchy> getChildAccounts(Id parentId, integer depth) {
        depth = 20;
        List<AccountHierarchy> children = new List<AccountHierarchy>();
        for(Account child : accounts) {
            if(child.ParentId == parentId) {
                children.add(new AccountHierarchy(depth,child));
                List<AccountHierarchy> childAccounts = getChildAccounts(child.Id, depth);
                hierarchy.put(child.Id, childAccounts);
            }
        }
        return children;
    }
      
    public List<Account> getParentAccounts(String queryString) {
        Set<Id> parentIds = new Set<Id>();
        List<Account> accounts = Database.query(queryString);
        for(Account account :  accounts) {
//            if(!parentIds.contains(account.ParentId)) { parentIds.add(account.ParentId); }
            if(!parentIds.contains(account.TDLINX_Account_Level_A__c)) { parentIds.add(account.TDLINX_Account_Level_A__c); }
            if(!parentIds.contains(account.TDLINX_Account_Level_B__c)) { parentIds.add(account.TDLINX_Account_Level_B__c); }
            if(!parentIds.contains(account.TDLINX_Account_Level_C__c)) { parentIds.add(account.TDLINX_Account_Level_C__c); }
            if(!parentIds.contains(account.TDLINX_Account_Level_D__c)) { parentIds.add(account.TDLINX_Account_Level_D__c); }
            if(!parentIds.contains(account.TDLINX_Account_Level_E__c)) { parentIds.add(account.TDLINX_Account_Level_E__c); }
        }
        
        List<Account> parentAccounts = [SELECT Id, Name, RecordTypeId, RecordType.Name, ParentId, TDLinx_Outlet_City__c, TDLinx_Outlet_State__c, Marketing_Group__c, 
        Marketing_Group__r.Name, TDLINX_Account_Level_A__c, TDLINX_Account_Level_B__c, TDLINX_Account_Level_C__c, TDLINX_Account_Level_D__c, 
        TDLINX_Account_Level_E__c From Account WHERE Id IN : parentIds ORDER BY Name];
        
        return parentAccounts; 
    }   
}