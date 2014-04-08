@isTest
private class Test_Controller_BeerPlanning {
    static User u;
    static Folder__c folderParent;
    static Folder__c folderChild;
    static Folder__c folderChild2;
    static File__c fileContent;
    static Calendar__c cal;
    static testMethod void testAsDiageoPortalUser() {
        createTestData();
        PageReference pageRef = Page.BeerPlanning;
        Test.setCurrentPage(pageRef);
        
        String section = folderParent.ID;
        String subSection = folderChild.ID;
        
        ApexPages.currentPage().getParameters().put('section', section);
        ApexPages.currentPage().getParameters().put('subsection', subSection);
        ApexPages.currentPage().getParameters().put('displayas', 'box');
        Apexpages.currentPage().getParameters().put('date', String.valueOf(date.today()));
        ApexPages.currentPage().getParameters().put('toggledTheme','Beer');
        // START : Basant : Assert Added for Realease 1 Testing on PROD at the time of Validation
        List<Brand__c> brndList = Service_API.getBrandsForFilters(new list<String>());
        System.debug('========================== Brands '+brndList);
//        System.assert(brndList.size() > 0);
        // END : Basant : Assert Added for Realease 1 Testing on PROD at the time of Validation
        System.runAs(u){
                Test.StartTest();
            Controller_BeerPlanning controller = new Controller_BeerPlanning();
//            System.assertEquals(controller.currentSection, section);
//            System.assertEquals(controller.currentSubSection, subSection);
//            System.assertEquals(controller.requestedFolder, folderChild.ID);
//            System.assertEquals(true,controller.contentHolderMap!=null);
//            System.assertEquals(true,controller.headers!=null);
            controller.detailId =  cal.Id; 
            controller.showDetails();
//            System.assertEquals(true, controller.detailsHolderMap != null);
            
            controller.setStartDateValue();
            controller.switchToMonthView();
            controller.nextMonth();
            controller.nextPeriod();
            controller.previousPeriod();
            controller.selectedTimePeriods='1,2,3';
            controller.changeFilter();
            controller.switchToQuarterView();
            controller.previousMonth();
            controller.getTimePeriods();
            controller.getSalesDrivers();
            controller.renderAsListSlider();
            controller.renderAsBoxSlider();
            controller.nextPeriod();
            controller.previousPeriod();
            controller.selectedTimePeriods='1,2';
            
            // START : Basant : Assert Added for Realease 1 Testing on PROD at the time of Validation
            List<Brand__c> brndList2 = Service_API.getBrandsForFilters(new list<String>());
                System.debug('========================== Brands '+brndList2);
//                System.assert(brndList2.size() > 0);
            // END : Basant : Assert Added for Realease 1 Testing on PROD at the time of Validation
            
//            System.assertEquals(controller.parentBrandList.size()>0 , true);
            controller.selectedBrandIds = controller.parentBrandList[0].Id;
            controller.selectedRTS = true;
            controller.selectedPortfolio = true;
            Test.StopTest();
            controller.changeFilter();              
        }               
        
    }
    
    static testmethod void testRenderType(){
        createTestData();
        folderChild.Layout_Type__c =CONSTANT.PLANNING_CALENDAR;
        update folderChild;
        PageReference pageRef = Page.BeerPlanning;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('section', folderParent.ID);
        ApexPages.currentPage().getParameters().put('time', '3');
        ApexPages.currentPage().getParameters().put('driver', 'Planning');
        // START : Basant : Assert Added for Realease 1 Testing on PROD at the time of Validation
        List<Brand__c> brndList = Service_API.getBrandsForFilters(new list<String>());
        System.debug('========================== Brands '+brndList);
//        System.assert(brndList.size() > 0);
        // END : Basant : Assert Added for Realease 1 Testing on PROD at the time of Validation
        System.runAs(u){
            Controller_BeerPlanning controller = new Controller_BeerPlanning();
            controller.renderAsList();
//            System.assertEquals(controller.displayAsList , true);
            
            controller.renderAsBox();
//            System.assertEquals(controller.displayAsList , false);
            controller.updateVariantBrands();
            
            // START : Basant : Assert Added for Realease 1 Testing on PROD at the time of Validation
            List<Brand__c> brndList2 = Service_API.getBrandsForFilters(new list<String>());
                System.debug('========================== Brands '+brndList2);
//                System.assert(brndList2.size() > 0);
            // END : Basant : Assert Added for Realease 1 Testing on PROD at the time of Validation
            
//            System.assertEquals(controller.parentBrandList.size()>0 , true);
            controller.parentId = controller.parentBrandList[0].Id;
            controller.updateVariantBrands();
            controller.resetFilter();
            controller.clearDetailsCalendar();
            controller.clearVariantBrandsSelected();
            controller.clearVariantBrands();
            controller.selectSalesDriver();
            controller.switchSection();
            controller.switchSubSection();
            MAP<string, List<AggregateResultHolder>> contentHolderMap = controller.contentHolderMap;
            List<String> headers = controller.headers;
            Integer contentSize = controller.contentSize;
            List<AggregateResult> contentList = controller.contentList;
            String requestedFolderName = controller.requestedFolderName;
            MAP<string, List<AggregateResultHolder>> detailsHolderMap = controller.detailsHolderMap;
        }
        Test.StopTest();
    }
/*
    static testmethod void testSwitchSections(){
        createTestData();
        PageReference pageRef = Page.BeerPlanning;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        
        //ApexPages.currentPage().getParameters().put('section', folderParent.ID);
        ApexPages.currentPage().getParameters().put('toggledTheme','Beer');
        ApexPages.currentPage().getParameters().put('toggled','true');
        ApexPages.currentPage().getParameters().put('toggledThemeDef','Beer');
        
        
        System.runAs(u){
            Controller_BeerPlanning controller = new Controller_BeerPlanning();
            if(controller.sectionFolders != null && controller.sectionFolders.dirs != null) {
                System.assertEquals(true, controller.sectionFolders.dirs.size()>0);
                controller.currentSection = controller.sectionFolders.dirs[0].folderId;
                System.assertEquals(controller.requestedFolderName, controller.sectionFolders.dirs[0].folderName);
                
                controller.switchSection();
                System.assertEquals(controller.requestedFolderName, controller.subSectionFolders.dirs[0].folderName);
                System.assertEquals(true, controller.subSectionFolders.dirs.size()>0);
                controller.currentSubSection = controller.subSectionFolders.dirs[0].folderId;
                controller.switchSubSection();
            }
            
        }
        Test.StopTest();
    }
*/    
    
    static void createTestData(){
        Test_Helper.generateTestMDUser('12345', false, [SELECT Name FROM Profile Limit 1].Name);
        Organizational_Unit__c division = new Organizational_Unit__c(Label__c = 'Division', Name = 'divisionName');
        insert division;
        
        Account a = Test_Helper.testGetDiageoAccount();
        Contact c = Test_Helper.testInsertContact('TestFirst', 'TestLast', a.ID);
        u = Test_Helper.testInsertDiageoPortalUser(c.ID);
                
        folderParent = Test_Helper.testInsertFolder(false, false, null, true, true, CONSTANT.PLANNING, null, null);
        folderParent.Classification__c = 'Beer';
        update folderParent;
        folderChild = Test_Helper.testInsertFolder(false, false, null, true, true, CONSTANT.PLANNING, folderParent.ID, null);
        folderChild.Classification__c = 'Beer';
        //folderChild.Layout_Type__c =CONSTANT.PLANNING_CALENDAR;
        update folderChild;
        
        folderChild2 = Test_Helper.testInsertFolder(false, false, null, true, true, CONSTANT.PLANNING, folderChild.ID, null);
        folderChild2.Classification__c = 'Beer';
        //folderChild.Layout_Type__c =CONSTANT.PLANNING_CALENDAR;
        update folderChild2;
        
        Content_Description__c conDesc = Test_Helper.testInsertContentDescriptionExtended('title1');
        
        fileContent = Test_Helper.testInsertFile(folderChild.ID, Constant.PLANNING, division.name, division.Id, null);
        cal = Test_Helper.testInsertPCalendar('test1','test1 desc', date.today(), date.today().addDays(10));
        cal.Folder__c =folderChild.id;
        cal.Classification__c = 'Beer';
        cal.background_color__c = 'FFFFFF';
        cal.background_color2__c = 'AAFFFF';
        cal.text_color__c = '000000';
        cal.Logo_Image_Small__c = conDesc.Id;
        update cal;
        
        File__c file = Test_Helper.testInsertFile(folderChild.Id, Constant.PLANNING, cal, division); 
        //file.Classification__c = 'Beer';
        //update file;
        
        List<settings__c> settingList = new List<settings__c>([Select Id, Name, value__c From settings__c Where Name = 'beerPlanningFolderId']);
        settings__c s = new settings__c();
        if(settingList != null && settingList.size() > 0){
            s = settingList.get(0);
        }
        s.value__c = folderParent.Id;
        s.Name = 'beerPlanningFolderId';
        upsert s;
    }
}