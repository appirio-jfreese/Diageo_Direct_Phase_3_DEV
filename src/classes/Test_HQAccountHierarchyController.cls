/*******************************************************************************
Name        : Test_HQAccountHierarchyController
Created By  : Basant Verma (Appirio JDC)   

Updated By	: Basant Verma (Appirio JDC)
Date        : 02/03/2014
Story/Task  : Code Coverage and Data Cleanup
*******************************************************************************/
@isTest
private class Test_HQAccountHierarchyController {
    private static Campaign cmpObj;
    private static National_Account_Group__c NAGObj;
    private static Marketing_Group__c MGObj;
    private static Key_Account_Group__c KAGObj;
    private static List<Account> distributorAccounts;
    private static List<Account> storeAccounts;
    private static Account headQuarterAccount;
    private static Account divisionAccount;
    private static List<Contact> distributorContacts;
    private static List<Brand__c> brandList;
    private static Map<String, String> accRecordTypeMap {
        get{
            if(accRecordTypeMap == null){
                accRecordTypeMap = new Map<String, String>();
                for(RecordType rt : [Select Id, Name From RecordType Where SobjectType = :'Account']){
                    if(!accRecordTypeMap.containsKey(rt.Name)){
                        accRecordTypeMap.put(rt.Name, rt.Id);
                    }
                }
            }
            return accRecordTypeMap;
        }
    }
    
    private static List<States__c> allStates;
    
    static testMethod void testHierarchyController2(){
        createTestData();
        Test.startTest();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(cmpObj);
        Apexpages.currentPage().getParameters().put('id',cmpObj.Id);
        Test.setCurrentPage(Page.HQAccountHierarchyPage);
        GroupHierarchyController component = new GroupHierarchyController(stdCon);
        Test.stopTest();
    }
    
    static testMethod void testHierarchyController(){
        createTestData();
        Test.startTest();
        System.assert(cmpObj.Id != null);
        ApexPages.StandardController stdCon = new ApexPages.StandardController(cmpObj);
        Apexpages.currentPage().getParameters().put('id',cmpObj.Id);
        Test.setCurrentPage(Page.HQAccountHierarchyPage);
        HQAccountHierarchyController cont = new HQAccountHierarchyController(stdCon);
        System.assert(!cont.campaignObj.Members_Selected__c);
        System.assertEquals(cont.campaignObj.National_Account_Group__c, null);
        System.assertEquals(cont.campaignObj.Marketing_Group__c, null);
        System.assertEquals(cont.campaignObj.Key_Account_Group__c, null);
        System.assertEquals(cont.storeAccList.size(), 0);
        
        // Populate Groups
        cont.campaignObj.National_Account_Group__c = NAGObj.Id;
        cont.campaignObj.Marketing_Group__c = MGObj.Id;
        cont.campaignObj.Key_Account_Group__c = KAGObj.Id;
        cont.selectAccount();
        System.assertNotEquals(cont.scheduleButtonText, null);
        System.assertEquals(cont.existingCampStatesNames.size(), 0);
        System.assertEquals(cont.parentBrandList, null);
        System.assertEquals(cont.distributorList, null);
        System.assertEquals(cont.existingDistributors, null);
        
        GroupHierarchyController component = new GroupHierarchyController();
        component.campaignId = cmpObj.Id;
        component.init();
        System.assert(component.accounts != null);
        System.assertEquals(component.accounts.size(), 2);
        
        // Select Outlate Stores and States
        cont.allSelectedStoreAccounts = '';
        cont.allSelectedStateCheckBox = '';
        String glue = '';
        System.debug('============== component.accounts: '+component.accounts);
        for(Account acc : component.accounts){
            cont.allSelectedStoreAccounts += glue + acc.Id;
            glue = ','; 
        }
        System.debug('============== cont.storeAccList: '+cont.storeAccList);
        glue = '';
        for(States__c st : allStates){
            cont.allSelectedStateCheckBox += glue + st.Abbreviation__c;
            glue = ','; 
        }
        
        System.debug('============== allSelectedStoreAccounts: '+cont.allSelectedStoreAccounts);
        System.debug('============== allSelectedStateCheckBox: '+cont.allSelectedStateCheckBox);
        
        cont.createCampaignMembers();
        
        List<Campaign_Distributor__c> cmpDstrb = [Select Id From Campaign_Distributor__c Where Campaign__c = :cmpObj.Id];
        List<CampaignMember> cmpMem = [Select Id From CampaignMember Where CampaignId = :cmpObj.Id];
        
        cont.reSet();
        cmpDstrb = [Select Id From Campaign_Distributor__c Where Campaign__c = :cmpObj.Id];
        cmpMem = [Select Id From CampaignMember Where CampaignId = :cmpObj.Id];
        System.assertEquals(cmpDstrb.size(), 0);
        System.assertEquals(cmpMem.size(), 0);
        System.assert(!cont.campaignObj.Members_Selected__c);
        cont.setCampaignStatus();
        cont.setCommunicationTemplateName();
        
        stdCon = new ApexPages.StandardController(cmpObj);
        Apexpages.currentPage().getParameters().put('id',cmpObj.Id);
        Test.setCurrentPage(Page.HQAccountHierarchyPage);
        cont = new HQAccountHierarchyController(stdCon);
        System.assertNotEquals(cont.allSelectedStoreAccounts, null);
        Test.stopTest();
  }
  
  private static void createTestData(){
    allStates = new List<States__c>();
    States__c st = new States__c();
    st.Name = 'Alabama';
    st.Abbreviation__c = 'AL';
    allStates.add(st);
    st = new States__c();
    st.Name = 'Alaska';
    st.Abbreviation__c = 'AK';
    allStates.add(st);
    st = new States__c();
    st.Name = 'Arizona';
    st.Abbreviation__c = 'AZ';
    allStates.add(st);
    st = new States__c();
    st.Name = 'Arkansas';
    st.Abbreviation__c = 'AR';
    allStates.add(st);
    st = new States__c();
    st.Name = 'California';
    st.Abbreviation__c = 'CA';
    allStates.add(st);
    insert allStates;
    
    cmpObj = new Campaign();
    cmpObj.Name = 'Test Campaign';
    insert cmpObj;
    
    NAGObj = new National_Account_Group__c();
    NAGObj.Name = 'Test National Acc Grp';
    NAGObj.National_Account_Group_Code__c = 'TestNAGObj';
    insert NAGObj;
    
    MGObj = new Marketing_Group__c();
    MGObj.Name = 'Test Mrktng Grp';
    MGObj.Marketing_Group_Code__c = 'TestMGObj';
    insert MGObj;
    
    KAGObj = new Key_Account_Group__c();
    KAGObj.Name = 'Test Key Acc Grp';
    KAGObj.Key_Account_Group_Code__c = 'TestKAGObj';
    insert KAGObj;
    
    headQuarterAccount = new Account();
    headQuarterAccount.RecordTypeId = accRecordTypeMap.get(Label.Outlet_Headquarters_Record_Type);
    headQuarterAccount.Name = 'Test HQ Acc ';
    headQuarterAccount.National_Account_Group__c = NAGObj.Id;
    headQuarterAccount.Marketing_Group__c = MGObj.Id;
    headQuarterAccount.Key_Account_Group__c = KAGObj.Id;
    insert headQuarterAccount;
    
    divisionAccount = new Account();
    divisionAccount.RecordTypeId = accRecordTypeMap.get(Label.Outlet_Banner_Record_Type);
    divisionAccount.Name = 'Test Division Acc ';
    divisionAccount.ParentId = headQuarterAccount.Id;
    divisionAccount.TDLINX_Account_Level_A__c = headQuarterAccount.Id;
    divisionAccount.TDLINX_Account_Level_B__c = headQuarterAccount.Id;
    divisionAccount.TDLINX_Account_Level_C__c = headQuarterAccount.Id;
    divisionAccount.TDLINX_Account_Level_D__c = headQuarterAccount.Id;
    divisionAccount.National_Account_Group__c = NAGObj.Id;
    divisionAccount.Marketing_Group__c = MGObj.Id;
    divisionAccount.Key_Account_Group__c = KAGObj.Id;
    insert divisionAccount;
    
    storeAccounts = new List<Account>();
    for(Integer i=0; i<5; i++){
        Account storeAcc = new Account();
        storeAcc.RecordTypeId = accRecordTypeMap.get(Label.Outlet_Store_Record_Type);
        storeAcc.Name = 'Test Store Acc '+i;
        storeAcc.ParentId = divisionAccount.Id;
        storeAcc.TDLINX_Account_Level_A__c = divisionAccount.Id;
        storeAcc.TDLINX_Account_Level_B__c = divisionAccount.Id;
        storeAcc.TDLINX_Account_Level_C__c = divisionAccount.Id;
        storeAcc.TDLINX_Account_Level_D__c = divisionAccount.Id;
        storeAcc.Outlet_State__c = allStates.get(i).Abbreviation__c;
        storeAcc.TDLinx_Outlet_State__c = allStates.get(i).Abbreviation__c;
        storeAcc.National_Account_Group__c = NAGObj.Id;
        storeAcc.Marketing_Group__c = MGObj.Id;
        storeAcc.Key_Account_Group__c = KAGObj.Id;
        storeAccounts.add(storeAcc);
    }
    for(Integer i=0; i<5; i++){
        Account storeAcc = new Account();
        storeAcc.RecordTypeId = accRecordTypeMap.get(Label.Outlet_Store_Record_Type);
        storeAcc.Name = 'Test Store Acc '+i;
        storeAcc.ParentId = headQuarterAccount.Id;
        storeAcc.TDLINX_Account_Level_A__c = headQuarterAccount.Id;
        storeAcc.TDLINX_Account_Level_B__c = headQuarterAccount.Id;
        storeAcc.TDLINX_Account_Level_C__c = headQuarterAccount.Id;
        storeAcc.TDLINX_Account_Level_D__c = headQuarterAccount.Id;
        storeAcc.Outlet_State__c = allStates.get(i).Abbreviation__c;
        storeAcc.TDLinx_Outlet_State__c = allStates.get(i).Abbreviation__c;
        storeAcc.National_Account_Group__c = NAGObj.Id;
        storeAcc.Marketing_Group__c = MGObj.Id;
        storeAcc.Key_Account_Group__c = KAGObj.Id;
        storeAccounts.add(storeAcc);
    }
    insert storeAccounts;
    
    distributorAccounts = new List<Account>();
    for(Integer i=0; i<5; i++){
        Account dtrbAcc = new Account();
        dtrbAcc.RecordTypeId = accRecordTypeMap.get('Distributor');
        dtrbAcc.Name = 'Test Distributor Acc '+i;
        distributorAccounts.add(dtrbAcc);
    }
    insert distributorAccounts;
    
    String UserCurrentTheme = [Select Id, Diageo_Direct_Theme__c From User Where Id = :Userinfo.getUserId()].get(0).Diageo_Direct_Theme__c;
    Calendar__c cal = Test_Helper.createCalendar('Test Calendar', 'On Premise', '', 'National', System.Today().addDays(-10), 
    	System.Today().addDays(10), '2014', UserCurrentTheme, 'test', 'test', Constant.NATIONAL_ACCOUNTS, true);    	
    
    brandList = new List<Brand__c>();
    for(Integer i=0; i<5; i++){
        brandList.add(Test_Helper.testInsertBrand('Test Brand'+i));
    }
    //insert brandList;
    
    List<AccountBrand__c> accountBrandList = new List<AccountBrand__c>();
    List<CalendarBrand__c> calBrandList = new List<CalendarBrand__c>();
    List<Account_Member__c> accMembersList = new List<Account_Member__c>();
    for(Integer i=0; i<5; i++){
        AccountBrand__c ab = new AccountBrand__c();
        ab.Account__c = distributorAccounts.get(i).Id;
        ab.Brand__c = brandList.get(i).Id;
        accountBrandList.add(ab);
        
        Account_Member__c am = new Account_Member__c();
        am.Account__c = distributorAccounts.get(0).Id;
        am.User__c = UserInfo.getUserId();
        accMembersList.add(am);
        
        calBrandList.add(Test_Helper.testInsertCalendarBrand(cal.Id, brandList.get(i).Id));
    }
    insert accountBrandList;
    insert accMembersList;
    //insert calBrandList;
    
    distributorContacts = new List<Contact>();
    for(Integer i=0; i<5; i++){
        Contact con = new Contact();
        con.AccountId = distributorAccounts.get(i).Id;
        con.FirstName = 'Test';
        con.LastName = 'Contact '+i;
        con.email = 'testContact'+i+'@test.com';
        con.Distributor_State__c = allStates.get(i).Name; 
        con.Unsubscribe__c = false;
        con.NAC_Unsubscribe__c = false;
        con.Subscribe_Status__c = 'Approved';
        con.Subscribe_Interested_In__c = UserCurrentTheme;
        con.Subscribe_Premise__c = cal.sales_channel__c;
        distributorContacts.add(con);
    }
    insert distributorContacts;
    
    
    cmpObj.Program__c = cal.Id;
    update cmpObj;
  }
}