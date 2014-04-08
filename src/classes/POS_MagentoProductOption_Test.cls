@isTest(SeeAllData=true)
public class POS_MagentoProductOption_Test{

    static testmethod void testMagentoProductOptionSync() {
        
        Account agency = POS_TestDataUtil.createProductionAgency();
        
        Program__c program1 = POS_TestDataUtil.createProgram();
        Item__c item11 = POS_TestDataUtil.populateItem(program1, agency);
        item11.RecordTypeId = [select Id, Name, DeveloperName from RecordType where DeveloperName='Customizable' limit 1].id;
        insert item11;
        
        Item_Customization__c iCust = new Item_Customization__c(Name='Personalization Label 1', Custom_Attribute_Length__c=120, Item__c=item11.Id);
        insert iCust;
        // this being a sync CallOut test UnitTest doesn't support the assertion in a meaningful way.
        
        Profile p = [select id from profile where name='POS - API User Agency'];
        
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id,
                          timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
                          Available_Themes__c='Spirits');
        
        System.runAs(u) {  
            Test.startTest();
            Account agency2 = POS_TestDataUtil.createProductionAgency();
            
            Program__c program2 = POS_TestDataUtil.createProgram();
            Item__c item12 = POS_TestDataUtil.populateItem(program2, agency2);
            item12.RecordTypeId = [select Id, Name, DeveloperName from RecordType where DeveloperName='Customizable' limit 1].id;
            insert item12;
            
            Item_Customization__c iCust2 = new Item_Customization__c(Name='Personalization Label 1', Custom_Attribute_Length__c=120, Item__c=item12.Id);
            insert iCust2;
            
            iCust2.Name = 'Personalization Label 2';
            update iCust2;
            
            delete iCUst2;  
            Test.stopTest();          
        }   
        
        
    }       
    

}