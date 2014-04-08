/*******************************************************************************
(c) 2013 Appirio, Inc.
Created By  : Vikash Goyal (Appirio JDC) 
Story/Task  : 
Description : Test Class for CampaignEmailScheduler

*******************************************************************************/
@isTest(SeeAllData=false)
private class Test_CampaignEmailScheduler {
      //Create test data
    static testmethod void createTestData(){
        RecordType rType = [select id from RecordType where name = 'National Accounts'];
        Calendar__c cal = new Calendar__c(RecordTypeId = rType.id);
        insert cal;
        Campaign cmp = new Campaign(name='test campaign', Scheduled_Send_Date__c = Date.today().addDays(-1),
                                       Status = 'Scheduled', Program__c = cal.id);
        insert cmp;
        Contact cont = new Contact (firstname='first',
                                    lastname='last',
                                    email='email@email.com',
                                    phone='1234567890');
        insert cont;
        CampaignMember cm = new CampaignMember (CampaignId = cmp.Id, ContactId = cont.Id);      
        insert cm;
        
        EmailTemplate eTemp = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'National_Accounts_Email'];
        if(eTemp != null){
            cmp.Communication_Template__c = eTemp.Id;
            update cmp;
        }
        Campaign cmp1 = new Campaign(name='test campaign1', Scheduled_Send_Date__c = Date.today().addDays(-1),
                                       Status = 'Scheduled');
        insert cmp1;
        Contact cont1 = new Contact (firstname='first1',
                                    lastname='last1',
                                    email='email1@email.com',
                                    phone='1234567891');
        insert cont1;
        CampaignMember cm1 = new CampaignMember (CampaignId = cmp1.Id, ContactId = cont1.Id);       
        insert cm1;
        EmailTemplate eTemp1 = [SELECT Id,name,developername FROM EmailTemplate where name = 'NAC - Existing Recipients'];
        if(eTemp1 != null){
            cmp1.Communication_Template__c = eTemp1.Id;
            update cmp1;
            
        }
        NoReplyEmailTemplate__c nrTemp  = new NoReplyEmailTemplate__c();
        
        nrTemp.Name = 'Test';
        insert nrTemp;
    }

    static testMethod void testScheduler() {
        createTestData();
        Test.startTest();
        CampaignEmailScheduler sch = new CampaignEmailScheduler();
        Database.executeBatch(sch, 2);
        Test.stopTest();        
    }
}