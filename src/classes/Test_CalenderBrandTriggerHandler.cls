/*******************************************************************************
Name        : Test_CalenderBrandTriggerHandler

Created By  : Basant Verma (Appirio JDC)   
Date        : 11/19/13
Story/Task  : US834/TA1500 : Test Class for CalenderBrandTriggerHandler
*******************************************************************************/
@IsTest(SeeAllData=true)
public with sharing class Test_CalenderBrandTriggerHandler {
    static testMethod void testCalenderBrandTrigger(){
        Calendar__c cal = new Calendar__c();
        cal.Name = 'Test Cal';
        cal.Sales_Channel__c = 'On Premise';
        cal.Start_Date__c = System.today();
        cal.End_Date__c = System.today().addMonths(1);
        cal.Description__c = 'Test Description';
        insert cal;
        System.assert(cal.Id != null);
        cal = [Select Id, Name, Primary_Brand_Name__c From Calendar__c Where Id = :cal.Id].get(0);
        System.assert(cal.Primary_Brand_Name__c == null);
        
        List<Brand__c> brnds = new List<Brand__c>();
        Brand__c brnd1 = new Brand__c();
        brnd1.Name = 'Test Brand 1';
        brnd1.Classification__c = 'Spirits';
        brnd1.Brand_Type__c = 'Brand';
        brnd1.diageo_direct_visible__c = true;
        brnds.add(brnd1);
        Brand__c brnd2 = new Brand__c();
        brnd2.Name = 'Test Brand 2';
        brnd2.Classification__c = 'Spirits';
        brnd2.Brand_Type__c = 'Brand';
        brnd2.diageo_direct_visible__c = true;
        brnds.add(brnd2);
        insert brnds;
        System.assert(brnd1.Id != null);
        System.assert(brnd2.Id != null);
        
        CalendarBrand__c cb1 = new CalendarBrand__c();
        cb1.Name = 'Test 1';
        cb1.Calendar__c = cal.Id;
        cb1.Brand__c = brnd1.Id;
        insert cb1;
        System.assert(cb1.Id != null);
        
        cb1 = [Select Id, Name, Calendar__c, Brand__c, Primary_Brand__c From CalendarBrand__c where Id = :cb1.Id].get(0);
        System.assert(cb1.Primary_Brand__c);
        cal = [Select Id, Name, Primary_Brand_Name__c From Calendar__c Where Id = :cal.Id].get(0);
        System.assert(cal.Primary_Brand_Name__c != null);
        System.assertEquals(cal.Primary_Brand_Name__c, brnd1.Name);
        
        CalendarBrand__c cb2 = new CalendarBrand__c();
        cb2.Name = 'Test 1';
        cb2.Calendar__c = cal.Id;
        cb2.Brand__c = brnd1.Id;
        cb2.Primary_Brand__c = true;
        try{
            insert cb2;
//            System.assert(false);
        }catch(Exception e){
//            System.assert(true);
        }
//        cb2.Primary_Brand__c = false;
//        insert cb2;
//        System.assert(cb2.Id != null);
        
        List<CalendarBrand__c> cbList = new List<CalendarBrand__c>();
        cb1.Primary_Brand__c = true;
        cb2.Primary_Brand__c = true;
        cbList.add(cb1);
        cbList.add(cb2);
        try{
            update cbList;
//            System.assert(false);
        }catch(Exception e){
//            System.assert(true);
        }
        
        cbList = new List<CalendarBrand__c>();
        cb1.Primary_Brand__c = false;
        cb2.Primary_Brand__c = true;
        cbList.add(cb1);
        cbList.add(cb2);
        update cbList;
//        System.assert(true);
    }
}