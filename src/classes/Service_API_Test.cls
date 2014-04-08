@IsTest(SeeAllData=false)
public class Service_API_Test{
    
    static testmethod void testResponsive() {
        PageReference homePage = Page.HomePage;
        PageReference r_homePage = Page.R_HomePage;
        
        Test.setCurrentPage(homePage);        
        Service_API.isResponsive();
        
        Test.setCurrentPage(r_homePage);
        r_homePage.getHeaders().put('USER-AGENT', 'Android');
        Service_API.isResponsive();
        
        Service_API.getSectionTheme();
        Service_API.getSectionThemeDefault();        
    }
    
    static testmethod void testNumberOfItemsToggled() {           
        Test.setCurrentPage(Page.MonthlyExecutionPlan);
        ApexPages.currentPage().getParameters().put('toggledThemeDef', 'Spirits');
        ApexPages.currentPage().getParameters().put('toggledTheme', 'Wine');
        ApexPages.currentPage().getParameters().put('toggledNum', null);
        ApexPages.currentPage().getParameters().put('toggled', 'true');
        
        Service_API.getUserNumberOfItemsPerPage();
        Service_API.setUserNumberOfItemsPerPage('22');
        Service_API.getSectionTheme();
        Service_API.getSectionThemeDefault();        
    }
    
    static testmethod void testNumberOfItemsNotToggled() {
        Test.setCurrentPage(Page.MonthlyExecutionPlan);
        ApexPages.currentPage().getParameters().put('toggledThemeDef', 'Spirits');
        ApexPages.currentPage().getParameters().put('toggledTheme', 'Wine');
        ApexPages.currentPage().getParameters().put('toggledNum', null);
        
        Service_API.getUserNumberOfItemsPerPage();
        Service_API.setUserNumberOfItemsPerPage(null);
    }
    
    static testmethod void testSectionThemesSpirits() {
        Test.setCurrentPage(Page.SpiritsPlanning);
        ApexPages.currentPage().getParameters().put('toggledThemeDef', 'Spirits');
        ApexPages.currentPage().getParameters().put('toggledTheme', 'Wine');
        ApexPages.currentPage().getParameters().put('toggledNum', null);
        
        Service_API.getSectionTheme();
        Service_API.getSectionThemeDefault();
    }
    
    static testmethod void testSectionThemesWine() {
        Test.setCurrentPage(Page.WinePlanning);
        ApexPages.currentPage().getParameters().put('toggledThemeDef', 'Spirits');
        ApexPages.currentPage().getParameters().put('toggledTheme', 'Wine');
        ApexPages.currentPage().getParameters().put('toggledNum', null);
        
        Service_API.getSectionTheme();
        Service_API.getSectionThemeDefault();
    }
    
    static testmethod void testSectionThemesBeer() {
        Test.setCurrentPage(Page.BeerPlanning);
        ApexPages.currentPage().getParameters().put('toggledThemeDef', 'Spirits');
        ApexPages.currentPage().getParameters().put('toggledTheme', 'Wine');
        ApexPages.currentPage().getParameters().put('toggledNum', null);
        
        Service_API.getSectionTheme();
        Service_API.getSectionThemeDefault();
    }
   
    static testmethod void testBrands() {
        Account a = Test_Helper.testInsertAccount('Test Corporate Account');
        Account diageo = Test_Helper.testInsertAccount('Diageo');
        Set<Id> accountRecordTypes = Service_API.getAccountRecordTypeIds();
        Id distributorRecordTypeId;
        for(Id recordTypeId : accountRecordTypes) {
            distributorRecordTypeId = recordTypeId;
            break;
        }
        
        diageo.RecordTypeId = distributorRecordTypeId;
        update diageo;
        
        Contact c = Test_Helper.testInsertContact('Test', 'Contact', a.ID);
        User u = Test_Helper.testInsertDiageoPortalUser(c.ID);
        
        
        Account_Member__c am = new Account_Member__c();
        am.Account__c = diageo.Id;
        am.User__c = u.id;
        am.Default__c = false;
        insert am;
        
        System.runAs(u) {
            Set <String> themes = new Set<String>();
            themes.add('Spirits');
            themes.add('Wine');
            
            Service_API.getUserAccounts();
            Service_API.getAccBrandIdsForUser(u.Id);
            
            Service_API.getAccBrandIds();
            Service_API.getAccBrandIds(themes);
            
            Service_API.getAccBrandIdsForNAC();
            Service_API.getAccBrandIdsForNAC(themes);
            
            themes.add('Catalyst');
            Service_API.getAccBrandIds();
            Service_API.getAccBrandIds(themes);
            
            Service_API.getAccBrandIdsForNAC();
            Service_API.getAccBrandIdsForNAC(themes);            
            
            Set<String> userCategories = Service_API.getUserBrandCategories();
            String [] userCategoryArray = new String[userCategories.size()];
            List<String> userCategoriesList = new List<String>();
            Integer x=0;
            for(String s : userCategories) { userCategoriesList.add(s); userCategoryArray[x] = s; x++; }
            Service_API.getBrandsByCategories(userCategoryArray);
            if(userCategoryArray.size()>0) { Service_API.getBrandsForFilters(userCategoryArray[0]); }
            Service_API.getBrandsForFilters(userCategoriesList);
            Service_API.getBrandsForFiltersForNAC(userCategoriesList);

            Set<String> userBrandTypes = Service_API.getUserBrandTypes();
            
            Service_API.getRTSBrands();
            Service_API.getAllBrands();
            Service_API.getAllBrands(themes);
            Service_API.getAllBrandsForNAC(themes);

            Service_API.getPILBrandsNew2(true);
            Service_API.getPILBrandsNew2(false);
            Service_API.getPILBrandsNew2(true, true);
            Service_API.getPILBrandsNew2(false, true);
            Service_API.getPILBrandsNewSearch('Ciroc');            
            
            Service_API.getAIDs();
            Service_API.getAIDsForUser(u.Id); 
 
            Service_API.getAccBrandIdsIndpntTheme();
            
            Service_API.prepareSiteThemeAfterLogin(u.Id);            
        }
    }
    
    static testmethod void testQueryRecords() {
        Map<String, Account> paramMap = new Map<String, Account>();
        paramMap.put('Account', new Account());        
        Service_API.queryRecords('Select Id, Name FROM Account ORDER BY Name' , paramMap);
        Service_API.queryRecords('Select Name, count(Id) NameCount FROM Account GROUP BY Name ORDER BY Name' , paramMap);
        Service_API.queryRecords('Select Id, Name FROM Account WHERE Name=\'Diageo\'' , paramMap);
    }
    
    static testmethod void testOrganizationalUnits() {
    }
    
    static testmethod void testGetCID() {
        Account a = Test_Helper.testInsertAccount('Test Corporate Account');
        Contact c = Test_Helper.testInsertContact('Test', 'Contact', a.ID);
        User u = Test_Helper.testInsertDiageoPortalUser(c.ID);
        
        System.runAs(u) {
            Service_API.getCID();
        }
    }
    
    static testmethod void testGetAID() {
        Account a = Test_Helper.testInsertAccount('Test Corporate Account');
        Contact c = Test_Helper.testInsertContact('Test', 'Contact', a.ID);
        User u = Test_Helper.testInsertDiageoPortalUser(c.ID);
        
        System.runAs(u) {
            Service_API.getAID();
        }
    }
    
    static testmethod void testGetDistributorNames() {
        Account a = Test_Helper.testInsertAccount('Test Corporate Account');
        Contact c = Test_Helper.testInsertContact('Test', 'Contact', a.ID);
        User u = Test_Helper.testInsertDiageoPortalUser(c.ID);
        
        System.runAs(u) {
            Service_API.getDistributorNames();
        }
    }
    
    static testmethod void testDivisions() {
        Account a = Test_Helper.testInsertAccount('Test Corporate Account');
        Contact c = Test_Helper.testInsertContact('Test', 'Contact', a.ID);
        User u = Test_Helper.testInsertDiageoPortalUser(c.ID);
        
        System.runAs(u) {
            Service_API.getDivisions();
        }
    }
    
    static testmethod void testMiscellaneous() {
        Service_API.getAccountRecordTypeIds();
        Service_API.getLastLoginDate();
        Service_API.refreshUserPreferances();    
        
        Service_API.setUserSiteTheme('Spirits', false);
        Service_API.setUserSiteTheme('Wine', true);
        
        Service_API.getSSOId();
        Service_API.getGoalsFolderId();
        Service_API.getSpiritsPlaningId();
        Service_API.getBeerPlanningFolderId();
        Service_API.getSetting('nationalAccountsFolderId');
        Service_API.getPosAdHocFolderId();
        Service_API.getPosToolFolderId();
        Service_API.getVideoPlayerId();
        Service_API.getVideoPlayerKey();
        Service_API.getReserveEmails();

        Service_API.getSectionTabs('SellingMaterials');
        
        Integer userNumberOfItemsPerPage =  Service_API.getUserNumberOfItemsPerPage();
        String sectionTheme = Service_API.getSectionTheme();
        String sectionThemeDefault = Service_API.getSectionThemeDefault();
    }
    
    static testmethod void testLinks() {
        Service_API.getAllTags(); 
        Service_API.getSelectValues('Rating', null);
        Service_API.getIndustryLinks();
        Service_API.getBrandLinks();
        Service_API.getFacebookLinks();
        Service_API.getFAQs();
    }
    
    static testmethod void testArticles() {
        NewsAndArticles__c article = new NewsAndArticles__c(Classification__c='Spirits', BodyText__c='Test', Title__c='Here we go');
        insert article;
        
        Service_API.getNewsAndArticles();
        Service_API.getArticle(article.Id);
    }
    
    static testmethod void testCases() {
        Account a = Test_Helper.testInsertAccount('Test Corporate Account');
        Account diageo = Test_Helper.testInsertAccount('Diageo');
        Set<Id> accountRecordTypes = Service_API.getAccountRecordTypeIds();
        Id distributorRecordTypeId;
        for(Id recordTypeId : accountRecordTypes) {
            distributorRecordTypeId = recordTypeId;
            break;
        }
        
        diageo.RecordTypeId = distributorRecordTypeId;
        update diageo;
        
        Contact c = Test_Helper.testInsertContact('Test', 'Contact', a.ID);
        User u = Test_Helper.testInsertDiageoPortalUser(c.ID);
        
        
        Account_Member__c am = new Account_Member__c();
        am.Account__c = diageo.Id;
        am.User__c = u.id;
        am.Default__c = false;
        insert am;
        
        System.runAs(u) {
            Case newCase = new Case();
            newCase.Description = 'Case test description';
            newCase.Status = 'Open';
            newCase.Subject = 'Case test title';
            newCase.Phone__c = '000000';
            newCase.Email__c = 'text@test.com';
            newCase.First_Name__c = 'first name';
            newCase.Last_Name__c = 'last name';
            newCase.Type = 'Other';
            
            Case newCase1 = new Case();
            newCase1.Description = 'Case test description';
            newCase1.Status = 'Open';
            newCase1.Subject = 'Case test title';
            newCase1.Phone__c = '000000';
            newCase1.Email__c = 'text@test.com';
            newCase1.First_Name__c = 'first name';
            newCase1.Last_Name__c = 'last name';
            newCase1.Type = 'Other';            

            Service_API.insertCase(newCase);
            Service_API.insertUserCases(newCase1);
            
            CaseComment caseComment = new CaseComment(ParentId=newCase.Id, CommentBody='comment body');
            Service_API.insertCaseComment(caseComment);
            
            Service_API.getUserCases('Open');
            Service_API.getUserCases(null);
            Service_API.getCurrentUserCases('Open');
            Service_API.getCurrentUserCases(null);
            Service_API.getCase(newCase.Id);
            Service_API.getCaseModified(newCase.Id);
            Service_API.updateUserCases(newCase);
            Service_API.getCaseComment(newCase);
        }
    }
}