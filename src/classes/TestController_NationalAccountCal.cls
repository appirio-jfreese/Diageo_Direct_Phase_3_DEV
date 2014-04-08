/*******************************************************************************
    (c) 2013 Appirio, Inc.
Name				: TestController_NationalAccountCal

Created By  : Basant Verma (Appirio JDC) 
Story/Task  : US1198
Description : Test Class for Controller_NationalAccountCal
*******************************************************************************/
@isTest
private class TestController_NationalAccountCal {
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
			calendar1 = Test_Helper.createCalendar('calendar1', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false);
			calendar2 = Test_Helper.createCalendar('calendar2', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false);
			lstCals.add(calendar1);
			lstCals.add(calendar2);
			insert lstCals;
		}
		
		public void prepareCalendarList(){
			Date tmpDate = date.today();
			tmpDate = tmpDate.addMonths(1);
			nextMonthBase = tmpDate.year()+'-'+tmpDate.month();
			tmpDate = tmpDate.addMonths(-2);
			prevMonthBase = tmpDate.year()+'-'+tmpDate.month();
			
			calendars = new Calendar__c[]{
				Test_Helper.createCalendar('calendar1', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar2', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar3', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar4', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar5', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar6', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false)
			};
			insert calendars;
			
			brand1 = Test_Helper.testInsertBrand('brand1');
			Test_Helper.testInsertAccountBrand(account.id, brand1.id);
			
			List<CalendarBrand__c> lstCalBrands = new List<CalendarBrand__c>();
			for(Calendar__c cal : calendars){
				lstCalBrands.add(Test_Helper.testCreateCalendarBrand(cal.id, brand1.id, false));
			}
			insert lstCalBrands;
		}
		
		public void prepareCalendarListQ(){
			Service_Calendar sc = new Service_Calendar(3);
			Date tmpDate = sc.startDate;
			prevMonthBase = tmpDate.year()+'-'+tmpDate.month();
			tmpDate = tmpDate.addMonths(1);
			baseDate = tmpDate.year()+'-'+tmpDate.month();
			tmpDate = tmpDate.addMonths(1);
			nextMonthBase = tmpDate.year()+'-'+tmpDate.month();
			
			calendars = new Calendar__c[]{
				Test_Helper.createCalendar('calendar1', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar2', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar3', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar4', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar5', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar6', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false)
			};
			insert calendars;
			
			brand1 = Test_Helper.testInsertBrand('brand1');
			Test_Helper.testInsertAccountBrand(account.id, brand1.id);
			
			List<CalendarBrand__c> lstCalBrands = new List<CalendarBrand__c>();
			for(Calendar__c cal : calendars){
				lstCalBrands.add(Test_Helper.testCreateCalendarBrand(cal.id, brand1.id, false));
			}
			insert lstCalBrands;
		}
		
		public void prepareCalendarList2(){
			calendars = new Calendar__c[]{
				Test_Helper.createCalendar('calendar1', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar2', 'On Premise', 'Casual Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar3', 'On Premise', 'Fine Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar4', 'On Premise', 'Fine Dining', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar5', 'Off Premise', 'Drug', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar6', 'Off Premise', 'Drug', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar7', 'Off Premise', 'Drug', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false),
				Test_Helper.createCalendar('calendar7', 'Off Premise', 'Drug', 'National', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), String.valueOf((date.valueOf(baseDate+'-1')).Year()), 'Spirits', 'description1', 'callOnAction1', Constant.NATIONAL_ACCOUNTS, false)
			};
			insert calendars;
			
			brand1 = Test_Helper.testInsertBrand('brand1');
			Test_Helper.testInsertAccountBrand(account.id, brand1.id);
			
			List<CalendarBrand__c> lstCalBrands = new List<CalendarBrand__c>();
			for(Calendar__c cal : calendars){
				lstCalBrands.add(Test_Helper.testCreateCalendarBrand(cal.id, brand1.id, false));
			}
			insert lstCalBrands;
		}
	}
	
	static testmethod void testConstructor(){
		PageReference pageRef = Page.NationalAccountCal;
		Test.setCurrentPage(pageRef);
		TestSettings ts = new  TestSettings();
		ts.insertTwoBrands();
		ts.insertTwoCalendars();
		Test_Helper.testInsertAccountBrand(ts.account.id, ts.brand1.id);
		Test_Helper.testInsertCalendarBrand(ts.calendar1.id, ts.brand1.id);
		Test_Helper.testInsertCalendarBrand(ts.calendar2.id, ts.brand1.id);
        
    List<contentCategory__c> lstCategories = new List<contentCategory__c>();
	 	lstCategories.add(Test_Helper.createContentCategory('NAC1', 'Spirits;Wine;Beer', 'Casual Dining', Constant.NATIONAL_ACCOUNTS,3));
  	lstCategories.add(Test_Helper.createContentCategory('NAC2', 'Spirits;Wine;Beer', 'Fine Dining', Constant.NATIONAL_ACCOUNTS,2));
    insert lstCategories;
        
    Test.StartTest();
    	System.RunAs(ts.user){
            Controller_NationalAccountCal c = new Controller_NationalAccountCal();
            Date d = Date.today();
            System.assertEquals(d.year()+'-'+d.month()+'-01', c.startFromDate);
            System.assertEquals(1, c.timePeriod);
            System.assertEquals('All', c.salesDriver);
            System.assertEquals(false, c.isExport);
    	}
    Test.StopTest();
	}
	
	static testmethod void testConstructorGetParameters(){
		PageReference pageRef = Page.NationalAccountCal;
		Test.setCurrentPage(pageRef);
		
		TestSettings ts = new  TestSettings();
		ts.insertTwoBrands();
		ts.insertTwoCalendars();
		Test_Helper.testInsertAccountBrand(ts.account.id, ts.brand1.id);
		Test_Helper.testInsertCalendarBrand(ts.calendar1.id, ts.brand1.id);
		Test_Helper.testInsertCalendarBrand(ts.calendar2.id, ts.brand1.id);
        
		List<contentCategory__c> lstCategories = new List<contentCategory__c>();
	 	lstCategories.add(Test_Helper.createContentCategory('NAC1', 'Spirits;Wine;Beer', 'Casual Dining', Constant.NATIONAL_ACCOUNTS,3));
  	lstCategories.add(Test_Helper.createContentCategory('NAC2', 'Spirits;Wine;Beer', 'Fine Dining', Constant.NATIONAL_ACCOUNTS,2));
		insert lstCategories;
        
    Test.StartTest();
    	System.RunAs(ts.user){
    		String baseDate = date.today().year()+'-'+date.today().month()+'-1';
		    ApexPages.currentPage().getParameters().put('date', baseDate);
		    ApexPages.currentPage().getParameters().put('time', '3');
		    ApexPages.currentPage().getParameters().put('section', 'On-Premise Programs');
		    ApexPages.currentPage().getParameters().put('driver', 'Casual Dining');
		    ApexPages.currentPage().getParameters().put('export', 'true');
		    
		    Controller_NationalAccountCal c = new Controller_NationalAccountCal();
		    //System.assertEquals(baseDate, c.startFromDate);
		    System.assertEquals(3, c.timePeriod);
		    System.assertEquals('Casual Dining', c.salesDriver);
		    System.assertEquals(true, c.isExport);
		    c.getSalesDrivers();
		    c.setStartDateValue();
			}
		Test.StopTest();
	}
}