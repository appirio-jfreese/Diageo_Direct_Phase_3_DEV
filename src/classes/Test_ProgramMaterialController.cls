/*******************************************************************************
    (c) 2013 Appirio, Inc.
Created By  : Vikash Goyal    (Appirio JDC) 
Story/Task  : 
Description : Test Class for ProgramMaterialController
*******************************************************************************/
@isTest
private class Test_ProgramMaterialController {

  static testMethod void testProgramMaterial() {
    Organizational_Unit__c division = new Organizational_Unit__c(Label__c = 'Division', Name = 'divisionName', Type__c = 'Spirits');
    insert division;
        
    Calendar__c calendar = Test_Helper.testInsertCalendar('calendarMep', 'Distribution', 'GLBT', '1', 'description1', date.valueOf('2011-11-1'), date.valueOf('2011-11-10'), false, true);               
    
    Id recordId = [select Id from RecordType where Name = 'National Accounts' and sObjectType = 'Calendar__c'].Id;
    calendar.recordTypeId = recordId;    
    update calendar;
        
    Brand__c brand = Test_Helper.testInsertBrand('Test Brand 1');       
    CalendarBrand__c CalBrand  = Test_Helper.testInsertCalendarBrand(calendar.Id, brand.Id);
        
    Brand__c brand2 = Test_Helper.testInsertBrand('Test Brand 2');
    CalendarBrand__c CalBrand2 = Test_Helper.testInsertCalendarBrand(calendar.Id, brand2.Id);
                            
    Content_Description__c contentDescription = Test_Helper.testInsertContentDescription();                     
    Content_Property__c contentProperty = Test_Helper.testInsertContentProperty('Test 1', calendar.Id, contentDescription.id, 'Selling materials', 'Final Launch Deck' , '', '');
    contentProperty.Category__c = CONSTANT.NATIONAL_ACCOUNTS; 
    contentProperty.Sub_Category__c = CONSTANT.NATIONAL_ACCOUNTS_CALENDAR;
    update contentProperty;
    
    PageReference pageRef = Page.ProgramMaterial;
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('Id', calendar.Id);
    
    ProgramMaterialController pgmMat = new ProgramMaterialController();  
  }
}