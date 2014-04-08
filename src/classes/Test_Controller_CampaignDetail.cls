/*******************************************************************************
Name 				: Test_Controller_CampaignDetail
Created By	: Vikash Goyal (Appirio JDC)
Date				: 18th Mar, 2014
Reason 			: For Code Coverage of Controller_CampaignDetail
*******************************************************************************/
@isTest
private class Test_Controller_CampaignDetail {

    static testMethod void testCampaignDetails() {
        RecordType rType = [SELECT Id FROM RecordType WHERE Name = 'National Accounts'];
        
        Calendar__c cal = new Calendar__c(RecordTypeId = rType.id, Name = 'Test Cal');
        insert cal;
        
        Campaign cmp = new Campaign(name='test campaign', Scheduled_Send_Date__c = Date.today().addDays(-1),
                                       Status = 'Scheduled', Program__c = cal.id);
        insert cmp;
        
        Contact cont = new Contact (firstname='first', lastname='last', email='email@email.com', phone='1234567890');
        insert cont;
        
        CampaignMember cm = new CampaignMember (CampaignId = cmp.Id, ContactId = cont.Id);      
        insert cm;
        
        EmailTemplate eTemp = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'National_Accounts_Email'];
        
        settings__c customSetting = new settings__c(Name = 'DefaultNACCommunication', Value__c = eTemp.Id);
        insert customSetting;
        
        Standard_Button_Ovverride__c customSetting2 = new Standard_Button_Ovverride__c(CalendarBrandName__c = 'calBrand',
        																					ContentPropertyName__c = 'contentProp', CampaignProgram__c = 'cmpProgram');
        insert customSetting2;
               
        Apexpages.currentPage().getParameters().put('Id', cmp.Id);
        Apexpages.currentPage().getParameters().put('cmpProgram_lkid', cal.Id);
        Apexpages.currentPage().getParameters().put('cmpProgram', cal.Name);
        ApexPages.Standardcontroller sc = new Apexpages.Standardcontroller(cmp);
        Controller_CampaignDetail cmpDetail = new Controller_CampaignDetail(sc);
        List<SelectOption> options = cmpDetail.options;
        cmpDetail.doSave();
    }
}