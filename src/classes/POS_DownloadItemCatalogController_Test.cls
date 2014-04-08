@isTest(SeeAllData=false)
public class POS_DownloadItemCatalogController_Test{
    
    static testmethod void testDownloadItemCatalog () {
        
        Profile p = [select id from profile where name='POS - CM Administrator'];
        
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id,
                          timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
                          Available_Themes__c='Spirits');
        
        System.runAs(u) {
            //Create some test data
            Account account = new Account();
            account.Name='POS Unit Test Account';
            insert account;
            
            Account_Member__c am = new Account_Member__c();
            am.Account__c = account.Id;
            am.User__c = u.Id;
            insert am;
            
            //START : Insert Portfolio Brand : Basant Verma(Appirio JDC for Non-NAC Release 2) : 12/16/2013
            Brand__c brdProtfolio = new Brand__c(Name = 'Portfolio', Classification__c='Spirits', Diageo_Direct_Visible__c=true, Brand_Type__c='Individual Variant');
            insert brdProtfolio;
            //END : Insert Portfolio Brand : Basant Verma(Appirio JDC for Non-NAC Release 2) : 12/16/2013
            
            Account agency = POS_TestDataUtil.createProductionAgency();
            
            Order_Window__c ow = POS_TestDataUtil.createOrderWindow();
            ow.Magento_Id__c = '1';
            update ow;
            
            Program__c program = POS_TestDataUtil.createProgram(ow.Id);
            Item__c item = POS_TestDataUtil.populateItem(program, agency);
            item.Status__c='Approved w/Est Price';
            insert item;
            
            Legal_Disclaimer__c ld = new Legal_Disclaimer__c(Message__c='Test DL Message', Alternative_Message__c='Test Alt Message');
            insert ld;
            
            String owId = program.Order_Window__c;
            Test.setCurrentPageReference(new PageReference('Page.POS_DownloadItemCatalog'));
            System.currentPagereference().getParameters().put('owId',ow.Magento_Id__c);		    
            
            POS_DownloadItemCatalogController ctrl = new POS_DownloadItemCatalogController();	
            
            System.assertEquals(1, ctrl.orderwindowData.size());
        }
    }     
    
}