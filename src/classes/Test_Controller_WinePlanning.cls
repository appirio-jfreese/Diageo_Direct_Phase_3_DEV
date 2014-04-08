/*****************************************************************************
 * Name           : Test_Controller_WinePlanning
 * Created On     : June 11, 2013
 * Created By     : Parul Gupta(Appirio Offshore)
 * Implementation : Test class for Controller_WinePlanning
 
Updated By	: Vikash Goyal (Appirio JDC)
Date        : 02/04/2014
Story/Task  : Code Coverage and Data Cleanup
******************************************************************************/
@isTest(SeeAllData = false)
private class Test_Controller_WinePlanning {

    /* static testMethod void testWinePlanningController() {
        Test_Helper.generateTestMDUser('12345', false, [SELECT Name FROM Profile Limit 1].Name);
        Organizational_Unit__c division = new Organizational_Unit__c(Label__c = 'Division', Name = 'SWS');
        insert division;        
        Account a = Test_Helper.testGetDiageoAccount();
        Contact c = Test_Helper.testInsertContact('TestFirst', 'TestLast', a.ID);
        User u = Test_Helper.testInsertDiageoPortalUser(c.ID);
                
        Folder__c folderParentP = Test_Helper.testInsertFolder(false, false, division.Id, false, false, CONSTANT.PLANNING, null, null);
        Folder__c folderChildP = Test_Helper.testInsertFolder(false, false, division.Id, false, false, CONSTANT.PLANNING, folderParentP.ID, null);

        Test.startTest();
        
        System.runAs(u){
            PageReference pageRef = Page.WinePlanning;
            Test.setCurrentPage(pageRef);
            
            Controller_WinePlanning cw = new Controller_WinePlanning();
            Apexpages.currentPage().getParameters().put('section', folderParentP.Id);
            cw = new Controller_WinePlanning();
            cw.currentSection = folderParentP.Id;
            string tmp = cw.requestedFolderName;
            tmp = cw.requestedFolder;
            
            Calendar__c cal = Test_Helper.testInsertPCalendar('test1','test1 desc', date.today(), date.today().addDays(10));
            File__c file = Test_Helper.testInsertFile(folderParentP.Id, Constant.PLANNING, cal, division); 

            Brand__c brand = Test_Helper.testCreateBrand('test brand', null, null);
            Brand__c childBrand = Test_Helper.testCreateBrand('test child brand', brand.id, null);            
            
            cw.detailId = cal.Id;
            cw.switchSection();          
        }        
        Test.stopTest();
    } */
    
    static testMethod void testWinePlanningController() {
        Test_Helper.generateTestMDUser('12345', false, [SELECT Name FROM Profile Limit 1].Name);
        Organizational_Unit__c division = new Organizational_Unit__c(Label__c = 'Division', Name = 'SWS');
        insert division;        
        //Account a = Test_Helper.testGetDiageoAccount();
        /*Account a = Test_Helper.testInsertAccount('Diageo', division.Id);
        Contact c = Test_Helper.testInsertContact('TestFirst', 'TestLast', a.ID);
        User u = Test_Helper.testInsertDiageoPortalUser(c.ID);
        Brand__c brand = Test_Helper.testInsertBrand('brand1');*/
        TestSettings ts = new TestSettings();
        ts.insertContentBrands();
        
        Calendar__c cal = Test_Helper.testInsertPCalendar('test1','test1 desc', date.today(), date.today().addDays(10));
                
        Folder__c folderParentP = Test_Helper.testInsertFolder(false, false, division.Id, false, false, CONSTANT.PLANNING, null, null);
        Folder__c folderChildP = Test_Helper.testInsertFolder(false, false, division.Id, false, false, CONSTANT.PLANNING, folderParentP.ID, null);
		
		cal.Folder__c = folderChildP.Id;
		update cal;
		
		List<contentCategory__c> lstCategories = new List<contentCategory__c>();
        lstCategories.add(Test_Helper.createContentCategory('Planning1', 'Spirits;Wine;Beer', 'Planning', 'Planning',
    											 1));
		insert lstCategories;
		
        Test.startTest();
        
        System.runAs(ts.user){
            PageReference pageRef = Page.WinePlanning;
            Test.setCurrentPage(pageRef);
            
            Controller_WinePlanning cw = new Controller_WinePlanning();
            Apexpages.currentPage().getParameters().put('subsection', folderChildP.Id);
            Apexpages.currentPage().getParameters().put('section', folderParentP.Id);
            Apexpages.currentPage().getParameters().put('date', String.valueOf(date.today()));
            cw = new Controller_WinePlanning();
            cw.refreshPageContent();
            cw.currentSection = folderParentP.Id;
            //string tmp = cw.requestedFolderName;
            String tmp = cw.requestedFolder;
            
            //Calendar__c cal = Test_Helper.testInsertPCalendar('test1','test1 desc', date.today(), date.today().addDays(10));
            //File__c file = Test_Helper.testInsertFile(folderParentP.Id, Constant.PLANNING, cal, division); 

            //Brand__c brand = Test_Helper.testCreateBrand('test brand', null, null);
            //Brand__c childBrand = Test_Helper.testCreateBrand('test child brand', brand.id, null);            
            
            //cw.detailId = cal.Id;
            //cw.switchSection();          
        }        
        Test.stopTest();
    }
    
    class TestSettings {
	  	 Contact contact;
         Account account;
         User user;
         Brand__c brand;
         Calendar__c calendar;
         Content_Description__c[] contentDescriptionList;
         Content_Property__c[] contentPropertyList;
         
         String baseDate;
         
         public TestSettings(){
         		account = Test_Helper.testInsertAccount('DIAGEO');
         		contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
         		        
        		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];   
        		System.runAs (thisUser) {
         			user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        		}
         		brand = Test_Helper.testInsertBrand('brand1');
         		
         		calendar = Test_Helper.testInsertCalendar('calendar1', 'Distribution', 'GLBT', '1', 'description1', date.valueOf('2011-11-1'), date.valueOf('2011-11-10'), false, true);        		
         		
         		Test_Helper.testInsertAccountBrand(account.id, brand.id);
 				Test_Helper.testInsertCalendarBrand(calendar.id, brand.id);
 				 				
 				contentDescriptionList = Test_Helper.testInsertContentDescriptionExtended(new List<String>
 										{'title1','title2','title3','title4','title5','title6','title7'});				
 				
 				contentPropertyList = new Content_Property__c[]{
 					Test_Helper.testCreateContentProperty('property1', calendar.id, contentDescriptionList[0].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.VIDEOS_AND_MEDIA, 'PR', null),
 					Test_Helper.testCreateContentProperty('property2', calendar.id, contentDescriptionList[1].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.VIDEOS_AND_MEDIA, 'PR', null),
 					Test_Helper.testCreateContentProperty('property3', calendar.id, contentDescriptionList[2].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.SELL_SHEETS, 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property4', calendar.id, contentDescriptionList[3].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.SELL_SHEETS, 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property5', calendar.id, contentDescriptionList[4].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.SELL_SHEETS, 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property6', calendar.id, contentDescriptionList[5].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.OTHERS, 'PR', null),
 					Test_Helper.testCreateContentProperty('property7', calendar.id, contentDescriptionList[6].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.OTHERS, 'PR', null),
 					Test_Helper.testCreateContentProperty('property8', calendar.id, contentDescriptionList[1].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.OTHERS, 'PR', null),
 					Test_Helper.testCreateContentProperty('property9', calendar.id, contentDescriptionList[2].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.OTHERS, 'PR', null)
 				};
 				insert contentPropertyList;
         }
         
         public void insertContentBrands(){
         	List<ContentBrand__c> lstContentBrands = new List<ContentBrand__c>();
         	for(Content_Description__c cont : contentDescriptionList){
 				lstContentBrands.add(Test_Helper.testCreateContentBrand(cont.id, brand.id));
 			}
 			insert lstContentBrands;
         }
	 }
}