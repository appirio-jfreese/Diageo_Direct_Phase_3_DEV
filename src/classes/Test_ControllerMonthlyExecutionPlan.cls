/*******************************************************************************

Updated By	: Vikash Goyal (Appirio JDC)
Date        : 02/04/2014
Story/Task  : Code Coverage and Data Cleanup
*******************************************************************************/
@isTest
private class Test_ControllerMonthlyExecutionPlan {

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
            calendar1 = Test_Helper.testCreateCalendar('calendar1', 'Distribution', 'GLBT', '1', 'description1', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, true);               
            calendar2 = Test_Helper.testCreateCalendar('calendar2', 'Distribution', 'GLBT', '1', 'description2', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, true);               
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
                    Test_Helper.testCreateCalendar('calendar1', 'Distribution', 'GLBT', '1', 'description1', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar1', 'Distribution', 'GLBT', '1', 'description2', date.valueOf(nextMonthBase+'-1'), date.valueOf(nextMonthBase+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar3', 'Distribution', 'GLBT', '1', 'description3', date.valueOf(nextMonthBase+'-1'), date.valueOf(nextMonthBase+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar4', 'Distribution', 'GLBT', '1', 'description3', date.valueOf(prevMonthBase+'-1'), date.valueOf(prevMonthBase+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar5', 'Distribution', 'GLBT', '1', 'description5', date.valueOf(prevMonthBase+'-1'), date.valueOf(prevMonthBase+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar6', 'Distribution', 'GLBT', '1', 'description6', date.valueOf(prevMonthBase+'-1'), date.valueOf(prevMonthBase+'-10'), false, true)
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
                    Test_Helper.testCreateCalendar('calendar1', 'Distribution', 'GLBT', '1', 'description1', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar1', 'Distribution', 'GLBT', '1', 'description2', date.valueOf(nextMonthBase+'-1'), date.valueOf(nextMonthBase+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar3', 'Distribution', 'GLBT', '1', 'description3', date.valueOf(nextMonthBase+'-1'), date.valueOf(nextMonthBase+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar4', 'Distribution', 'GLBT', '1', 'description3', date.valueOf(prevMonthBase+'-1'), date.valueOf(prevMonthBase+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar5', 'Distribution', 'GLBT', '1', 'description5', date.valueOf(prevMonthBase+'-1'), date.valueOf(prevMonthBase+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar6', 'Distribution', 'GLBT', '1', 'description6', date.valueOf(prevMonthBase+'-1'), date.valueOf(prevMonthBase+'-10'), false, true)
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
                    Test_Helper.testCreateCalendar('calendar1', 'Distribution', 'GLBT', '1', 'description1', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar1', 'Innovation', 'GLBT', '1', 'description2', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar3', 'Innovation', 'GLBT', '1', 'description3', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar4', 'Integrated National Program', 'GLBT', '1', 'description3', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar5', 'Integrated National Program', 'GLBT', '1', 'description5', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, true),
                    Test_Helper.testCreateCalendar('calendar6', 'Integrated National Program', 'GLBT', '1', 'description6', date.valueOf(baseDate+'-1'), date.valueOf(baseDate+'-10'), false, true)
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
        PageReference pageRef = Page.MonthlyExecutionPlan;
        Test.setCurrentPage(pageRef);
        TestSettings ts = new  TestSettings();
        ts.insertTwoBrands();
        ts.insertTwoCalendars();
        Test_Helper.testInsertAccountBrand(ts.account.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar1.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar2.id, ts.brand1.id);
        
        List<contentCategory__c> lstCategories = new List<contentCategory__c>();
	 	lstCategories.add(Test_Helper.createContentCategory('MEP1', 'Spirits;Wine;Beer', 'Innovation', 'Monthly Execution Plan',
    											 3));
  		lstCategories.add(Test_Helper.createContentCategory('MEP2', 'Spirits;Wine;Beer', 'Distribution', 'Monthly Execution Plan',
    											 2));
        insert lstCategories;
        
        Test.StartTest();
        System.RunAs(ts.user){
            Controller_MonthlyExecutionPlan c = new Controller_MonthlyExecutionPlan();
            Date d = Date.today();
            System.assertEquals(d.year()+'-'+d.month()+'-01', c.startFromDate);
            System.assertEquals(1, c.timePeriod);
            System.assertEquals('All', c.salesDriver);
            System.assertEquals(false, c.isExport);
        }
        Test.StopTest();
    } 

    static testmethod void testConstructorGetParameters(){
        PageReference pageRef = Page.R_MonthlyExecutionPlan;
        Test.setCurrentPage(pageRef);
        
        TestSettings ts = new  TestSettings();
        ts.insertTwoBrands();
        ts.insertTwoCalendars();
        Test_Helper.testInsertAccountBrand(ts.account.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar1.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar2.id, ts.brand1.id);
        
        List<contentCategory__c> lstCategories = new List<contentCategory__c>();
	 	lstCategories.add(Test_Helper.createContentCategory('MEP1', 'Spirits;Wine;Beer', 'Innovation', 'Monthly Execution Plan',
    											 3));
  		lstCategories.add(Test_Helper.createContentCategory('MEP2', 'Spirits;Wine;Beer', 'Distribution', 'Monthly Execution Plan',
    											 2));
        insert lstCategories;
        
        Test.StartTest();
        System.RunAs(ts.user){
            ApexPages.currentPage().getParameters().put('date', '2011-10-1');
            ApexPages.currentPage().getParameters().put('time', '3');
            ApexPages.currentPage().getParameters().put('driver', 'Innovation');
            ApexPages.currentPage().getParameters().put('export', 'true');
            
            
            Controller_MonthlyExecutionPlan c = new Controller_MonthlyExecutionPlan();
            System.assertEquals('2011-10-01', c.startFromDate);
            System.assertEquals(3, c.timePeriod);
            System.assertEquals('Innovation', c.salesDriver);
            System.assertEquals(true, c.isExport);
            c.getSalesDrivers();
            c.setStartDateValue();
        }
        Test.StopTest();
    } 
    
    static testmethod void testGetDataForProperAccount(){
        PageReference pageRef = Page.MonthlyExecutionPlan;
        Test.setCurrentPage(pageRef);
        
        TestSettings ts = new  TestSettings();
        ts.insertTwoBrands();
        ts.insertTwoCalendars();
        Test_Helper.testInsertAccountBrand(ts.account.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar1.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar2.id, ts.brand1.id);
        
        List<contentCategory__c> lstCategories = new List<contentCategory__c>();
	 	lstCategories.add(Test_Helper.createContentCategory('MEP1', 'Spirits;Wine;Beer', 'Innovation', 'Monthly Execution Plan',
    											 3));
  		lstCategories.add(Test_Helper.createContentCategory('MEP2', 'Spirits;Wine;Beer', 'Distribution', 'Monthly Execution Plan',
    											 2));
        insert lstCategories;
        
        ApexPages.currentPage().getParameters().put('export', 'true');
        
        Controller_MonthlyExecutionPlan c;
        Test.StartTest();
        System.RunAs(ts.user){
            c = new Controller_MonthlyExecutionPlan();           
            System.assertEquals(2, c.calendarData.get(ts.baseDate).get('Distribution').size());
            
        }
        Test.StopTest();
            
    }
    
    static testmethod void testGetDataForProperAccount2(){
        PageReference pageRef = Page.MonthlyExecutionPlan;
        Test.setCurrentPage(pageRef);
        
        TestSettings ts = new  TestSettings();
        ts.insertTwoBrands();
        ts.insertTwoCalendars();
        Test_Helper.testInsertAccountBrand(ts.account.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar1.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar2.id, ts.brand2.id);
        
        List<contentCategory__c> lstCategories = new List<contentCategory__c>();
	 	lstCategories.add(Test_Helper.createContentCategory('MEP1', 'Spirits;Wine;Beer', 'Innovation', 'Monthly Execution Plan',
    											 3));
  		lstCategories.add(Test_Helper.createContentCategory('MEP2', 'Spirits;Wine;Beer', 'Distribution', 'Monthly Execution Plan',
    											 2));
        insert lstCategories;
        
        Controller_MonthlyExecutionPlan c;
        Test.StartTest();
        System.RunAs(ts.user){
            c = new Controller_MonthlyExecutionPlan();
            System.assertEquals(1, c.calendarData.get(ts.baseDate).get('Distribution').size());
            
        }
        Test.StopTest();
    }
    
    static testmethod void testGetDataForProperDates(){
        PageReference pageRef = Page.MonthlyExecutionPlan;
        Test.setCurrentPage(pageRef);
        
        TestSettings ts = new  TestSettings();
        ts.prepareCalendarList();
        
        List<contentCategory__c> lstCategories = new List<contentCategory__c>();
	 	lstCategories.add(Test_Helper.createContentCategory('MEP1', 'Spirits;Wine;Beer', 'Innovation', 'Monthly Execution Plan',
    											 3));
  		lstCategories.add(Test_Helper.createContentCategory('MEP2', 'Spirits;Wine;Beer', 'Distribution', 'Monthly Execution Plan',
    											 2));
        insert lstCategories;
        
        Controller_MonthlyExecutionPlan c;
        Test.StartTest();
        System.RunAs(ts.user){
            c = new Controller_MonthlyExecutionPlan();
            System.assertEquals(1, c.calendarData.get(ts.baseDate).get('Distribution').size());
            System.assertEquals(null, c.calendarData.get(ts.nextMonthBase));
            System.assertEquals(null, c.calendarData.get(ts.prevMonthBase));
            c.nextMonth();
            System.assertEquals(2, c.calendarData.get(ts.nextMonthBase).get('Distribution').size());
            System.assertEquals(null, c.calendarData.get(ts.baseDate));
            System.assertEquals(null, c.calendarData.get(ts.prevMonthBase));
            c.previousMonth();
            System.assertEquals(1, c.calendarData.get(ts.baseDate).get('Distribution').size());
            c.previousMonth();
            System.assertEquals(3, c.calendarData.get(ts.prevMonthBase).get('Distribution').size());
            System.assertEquals(null, c.calendarData.get(ts.baseDate));
            System.assertEquals(null, c.calendarData.get(ts.nextMonthBase));

        }
        Test.StopTest();
    }
    
    static testmethod void testGetDataForProperDatesQ(){
        PageReference pageRef = Page.MonthlyExecutionPlan;
        Test.setCurrentPage(pageRef);
        
        TestSettings ts = new  TestSettings();
        ts.prepareCalendarListQ();
        
        ts.calendars[0].background_color__c = 'FFFFFF';
        update ts.calendars[0];
        
        List<contentCategory__c> lstCategories = new List<contentCategory__c>();
	 	lstCategories.add(Test_Helper.createContentCategory('MEP1', 'Spirits;Wine;Beer', 'Innovation', 'Monthly Execution Plan',
    											 3));
  		lstCategories.add(Test_Helper.createContentCategory('MEP2', 'Spirits;Wine;Beer', 'Distribution', 'Monthly Execution Plan',
    											 2));
        insert lstCategories;
        
        Controller_MonthlyExecutionPlan c;
        Test.StartTest();
        System.RunAs(ts.user){
            c = new Controller_MonthlyExecutionPlan();
            c.timePeriod = 3;
            c.refreshContent();
            System.assertEquals(3, c.calendarData.get(ts.prevMonthBase).get('Distribution').size());
            System.assertEquals(1, c.calendarData.get(ts.baseDate).get('Distribution').size());
            System.assertEquals(2, c.calendarData.get(ts.nextMonthBase).get('Distribution').size());
            
        }
        Test.StopTest();
    }
    
    static testmethod void testGetDataForProperSalesChannel(){
    	Content_Description__c conDesc = Test_Helper.testInsertContentDescriptionExtended('title1');
        PageReference pageRef = Page.MonthlyExecutionPlan;
        Test.setCurrentPage(pageRef);
        
        TestSettings ts = new  TestSettings();
        ts.prepareCalendarList2();
        
        ts.calendars[0].background_color__c = 'FFFFFF';
        ts.calendars[0].background_color2__c = 'AAFFFF';
        ts.calendars[0].text_color__c = '000000';
        ts.calendars[0].Logo_Image_Small__c = conDesc.Id;
        
        update ts.calendars[0];
        
        List<contentCategory__c> lstCategories = new List<contentCategory__c>();
        lstCategories.add(Test_Helper.createContentCategory('MEP3', 'Spirits;Wine;Beer', 'Integrated National Program', 'Monthly Execution Plan',
    											 4));
	 	lstCategories.add(Test_Helper.createContentCategory('MEP1', 'Spirits;Wine;Beer', 'Innovation', 'Monthly Execution Plan',
    											 3));
  		lstCategories.add(Test_Helper.createContentCategory('MEP2', 'Spirits;Wine;Beer', 'Distribution', 'Monthly Execution Plan',
    											 2));
        insert lstCategories;
        
        Controller_MonthlyExecutionPlan c;
        Test.StartTest();
        System.RunAs(ts.user){
            c = new Controller_MonthlyExecutionPlan();
            System.assertEquals(1, c.calendarData.get(ts.baseDate).get('Distribution').size());
            System.assertEquals(2, c.calendarData.get(ts.baseDate).get('Innovation').size());
            System.assertEquals(3, c.calendarData.get(ts.baseDate).get('Integrated National Program').size());
            c.salesDriver = 'Innovation';
            c.selectSalesDriver();
            System.assertEquals(null, c.calendarData.get(ts.baseDate).get('Distribution'));
            System.assertEquals(2, c.calendarData.get(ts.baseDate).get('Innovation').size());
            System.assertEquals(null, c.calendarData.get(ts.baseDate).get('Integrated National Program'));
            c.salesDriver = 'Integrated National Program';
            c.selectSalesDriver();
            System.assertEquals(null, c.calendarData.get(ts.baseDate).get('Distribution'));
            System.assertEquals(null, c.calendarData.get(ts.baseDate).get('Innovation'));
            System.assertEquals(3, c.calendarData.get(ts.baseDate).get('Integrated National Program').size());
        }
        Test.StopTest();
    }
    
    static testmethod void testGetTimePerioda(){
        PageReference pageRef = Page.MonthlyExecutionPlan;
        Test.setCurrentPage(pageRef);
        
        List<contentCategory__c> lstCategories = new List<contentCategory__c>();
	 	lstCategories.add(Test_Helper.createContentCategory('MEP1', 'Spirits;Wine;Beer', 'Innovation', 'Monthly Execution Plan',
    											 3));
  		lstCategories.add(Test_Helper.createContentCategory('MEP2', 'Spirits;Wine;Beer', 'Distribution', 'Monthly Execution Plan',
    											 2));
        insert lstCategories;
        
        Controller_MonthlyExecutionPlan c;
        TestSettings ts = new  TestSettings();
        ts.insertTwoBrands();
        ts.insertTwoCalendars();
        Test_Helper.testInsertAccountBrand(ts.account.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar1.id, ts.brand1.id);
        Test_Helper.testInsertCalendarBrand(ts.calendar2.id, ts.brand1.id);
        Test.StartTest();
        System.RunAs(ts.user){
            c = new Controller_MonthlyExecutionPlan();
            List<SelectOption> options = c.getTimePeriods();
            System.assertEquals(4, options.size());
        }
        Test.StopTest();
    }
}