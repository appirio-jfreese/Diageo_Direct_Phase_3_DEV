/*******************************************************************************
Name        : Test_Controller_Multicultural
Created By  : Vikash Goyal (Appirio JDC)
Date        : 19th Mar, 2014
Reason      : For Code Coverage of Controller_Multicultural 
*******************************************************************************/
@isTest
private class Test_Controller_Multicultural {
	
	  class TestSettings {
         Contact contact;
         Account account;
         User user;
         Brand__c brand1;
         Brand__c brand2;
         Calendar__c calendar1;
         Calendar__c calendar2;
         
         Calendar__c[] calendars;
         
         String baseDate;
         String nextMonthBase;
         String prevMonthBase;
         
         public TestSettings(){
                account = Test_Helper.testInsertAccount('test_account1');
                contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);               
                
                User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

                System.runAs (thisUser) {
                    user = Test_Helper.testInsertDistributorPortalUser(contact.id);
                }
                
                baseDate = date.today().year()+'-'+date.today().month();
         }
         
         public void insertTwoBrands(){
           List<Brand__c> lstBrand = new List<Brand__c>();
            brand1 = Test_Helper.testCreateBrand('brand1', false);
            brand2 = Test_Helper.testCreateBrand('brand2', false);
            lstBrand.add(brand1);
            lstBrand.add(brand2);
            insert lstBrand;
         }
         
         public void insertTwoCalendars(){
         	List<Calendar__c> lstCals = new List<Calendar__c>();
            calendar1 = Test_Helper.testCreateCalendar('calendar1', 'LGBT', 'GLBT', '1', 'description1', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, 'Multicultural');               
            calendar2 = Test_Helper.testCreateCalendar('calendar2', 'Distribution', 'GLBT', '1', 'description2', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, 'Multicultural');               
            lstCals.add(calendar1);
            lstCals.add(calendar2);
            insert lstCals;
         }
         
                  
         public void createSections(){
         	 List<Sections__c> lstSections = new List<Sections__c>();
		 				lstSections.add(Test_Helper.createSectionTab('MUL1', 'Spirits;Wine;Beer', null, null,
	    											'Multicultural', 'Multicultural Programs', 1));
	    			lstSections.add(Test_Helper.createSectionTab('MUL2', 'Spirits;Wine;Beer', null, null,
	    											'Multicultural', 'Consumer Info', 2));
	    			lstSections.add(Test_Helper.createSectionTab('MUL3', 'Spirits;Wine;Beer', 'Multicultural Programs', 'Hispanic',
	    											'Multicultural', 'General', 3));
	    			lstSections.add(Test_Helper.createSectionTab('MUL4', 'Spirits;Wine;Beer', 'Multicultural Programs', 'LGBT',
	    											'Multicultural', 'General', 3));
	    			insert lstSections;
         }
         
         public void prepareContentCategories(){
           List<contentCategory__c> lstCategories = new List<contentCategory__c>();
           lstCategories.add(Test_Helper.createContentCategory('MUL1', 'Spirits;Wine;Beer', 'Hispanic', 'Multicultural',
    											 1));
	 	   			lstCategories.add(Test_Helper.createContentCategory('MUL2', 'Spirits;Wine;Beer', 'LGBT', 'Multicultural',
    											 2));
  		   		lstCategories.add(Test_Helper.createContentCategory('MUL3', 'Spirits;Wine;Beer', 'Asian American', 'Multicultural',
    											 3));           
           insert lstCategories;
         }
        
      }

    static testMethod void testConstructor() {    	
	        Content_Description__c conDesc = Test_Helper.testInsertContentDescriptionExtended('title1');
       PageReference pageRef = Page.Multicultural;
        Test.setCurrentPage(pageRef);
        
        TestSettings ts = new  TestSettings();
        ts.insertTwoBrands();
        ts.insertTwoCalendars();
        
        ts.calendar1.background_color__c = 'FFFFFF';
        ts.calendar1.background_color2__c = 'AAFFFF';
        ts.calendar1.text_color__c = '000000';
        ts.calendar1.Logo_Image_Small__c = conDesc.Id;
        update ts.calendar1;
        
        ts.createSections();
        ts.prepareContentCategories();
        Test_Helper.testInsertAccountBrand(ts.account.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar1.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar2.id, ts.brand2.id);
        
        Test.StartTest();
        System.RunAs(ts.user){
            Controller_Multicultural c = new Controller_Multicultural();
            
            Date d = Date.today();
            System.assertEquals(d.year()+'-'+d.month()+'-01', c.startFromDate);
            System.assertEquals(1, c.timePeriod);
            System.assertEquals('All', c.salesDriver);
            System.assertEquals(false, c.isExport);
            c.nextMonth();
            c.previousMonth();
            c.getTimePeriods();
            c.getSalesDrivers();
            c.selectSalesDriver();
            c.updateVariantBrands();
            c.clearVariantBrands();
            c.clearVariantBrandsSelected();
            c.resetFilter();
            c.switchSection();
            c.switchSubSection();            
            c.renderAsList();
            c.renderAsBox();
            c.renderAsListSlider();
            c.renderAsBoxSlider();
            
        }
        
        Test.StopTest();
    }
    
    static testMethod void testDetail() {    	
	        
       PageReference pageRef = Page.Multicultural;
        Test.setCurrentPage(pageRef);
        List<Content_Description__c> contentDescriptionList = Test_Helper.testInsertContentDescriptionExtended(new List<String>
 										{'title1','title2','title3','title4','title5','title6','title7'});
 				
        TestSettings ts = new  TestSettings();
        ts.insertTwoBrands();
        ts.insertTwoCalendars();
        ts.createSections();
        ts.calendar1.background_color__c = 'FFFFFF';
        ts.calendar1.background_color2__c = 'AAFFFF';
        ts.calendar1.text_color__c = '000000';
        ts.calendar1.Logo_Image_Small__c = contentDescriptionList[0].Id;
        ts.calendar1.Logo_Image_Large__c = contentDescriptionList[0].Id;
        update ts.calendar1;
        
        List<Content_Property__c>  contentPropertyList = new List<Content_Property__c> {
 					//innovation
 					Test_Helper.testCreateContentProperty('property1', ts.calendar1.Id, contentDescriptionList[0].Id, CONSTANT.MULTICULTURAL, 'General', 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property2', ts.calendar2.Id, contentDescriptionList[1].Id, CONSTANT.MULTICULTURAL, 'General', 'Preliminary Long Lead Deck', null)
 				};
 				insert contentPropertyList;
 				
 				List<ContentBrand__c> lstContentBrand = new List<ContentBrand__c>();
        for(Content_Description__c cont : contentDescriptionList){
 				  lstContentBrand.add(Test_Helper.testCreateContentBrand(cont.id, ts.brand1.id));
 			  }
 			  insert lstContentBrand;
 				
        Test_Helper.testInsertAccountBrand(ts.account.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar1.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar2.id, ts.brand2.id);
        
        Test.StartTest();
        System.RunAs(ts.user){
            Controller_Multicultural c = new Controller_Multicultural();
            
            c.detailId = ts.calendar1.id;
            c.showDetails();
            MAP<string, List<AggregateResultHolder>> contentHolderMap = c.contentHolderMap;
            c.clearDetailsCalendar();
        }
        
        Test.StopTest();
    }
    
    static testmethod void testConstructorGetParameters(){
    	  PageReference pageRef = Page.Multicultural;
        Test.setCurrentPage(pageRef);
        
        TestSettings ts = new  TestSettings();
        ts.insertTwoBrands();
        ts.insertTwoCalendars();
        
        ts.createSections();
        ts.prepareContentCategories();
        Test_Helper.testInsertAccountBrand(ts.account.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar1.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar2.id, ts.brand2.id);
        Test.StartTest();
        System.RunAs(ts.user){
            ApexPages.currentPage().getParameters().put('date', '2011-10-1');
            ApexPages.currentPage().getParameters().put('time', '3');
            ApexPages.currentPage().getParameters().put('driver', 'LGBT');
            ApexPages.currentPage().getParameters().put('export', 'true');
            ApexPages.currentPage().getParameters().put('date', '2011-10-1');
            ApexPages.currentPage().getParameters().put('section', CONSTANT.TOOLS);
            ApexPages.currentPage().getParameters().put('subsection', 'LGBT');
            
            Controller_Multicultural c = new Controller_Multicultural();
            c.selectedTimePeriods = '1';
            c.refreshPageContent();            
            c.setStartDateValue();
            c.switchToMonthView();
            c.switchToQuarterView();            
            c.nextPeriod();
            c.previousPeriod();
            c.changeFilter();
        }
        Test.StopTest();
    }
}