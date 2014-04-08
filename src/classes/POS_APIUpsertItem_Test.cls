@IsTest(SeeAllData=true)
public class POS_APIUpsertItem_Test{

    static testmethod void testUpsertItem () {
        
        //Get the current time
        Datetime now = System.now();
        
        Profile p = [select id from profile where name='POS - API User Agency'];
        
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id,
                          timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
                          Available_Themes__c='Spirits');
        
        RecordType posAgencyRecordType = [select Id from RecordType where Name='POS Production Agency' and sObjectType='Account'];
        
        
        System.runAs(u) {
            POSAPIConfiguration__c settings = POSAPIConfiguration__c.getOrgDefaults();
            
            //Now test queries for other filters
            Order_Window__c window = POS_TestDataUtil.createOrderWindow();
            window.Status__c='In Review';
            window.Magento_Id__c = '12345';
            update window;
            
            Program__c program = POS_TestDataUtil.createProgram();
            Account account = POS_TestDataUtil.createAccount();
            account.RecordTypeId = posAgencyRecordType.Id;
            update account;
            
            
            //Test if this user isn't associated with an agency account
            Item__c item = POS_TestDataUtil.populateItem(program,account);
            item.Agency_Item_Id__c = 'AGENCYID';
            
            RestResponse restResponse = new RestResponse();
            POS_APIUpsertItem.UpsertResponse response = POS_APIUpsertItem.doPost(item, restResponse);
            System.assert(restResponse.StatusCode==400);  //We get 400 because it's not permitted
            
            //Now associate them then try again
            POS_TestDataUtil.createAccountMember(account, u);
            
            restResponse = new RestResponse();
            response = POS_APIUpsertItem.doPost(item, restResponse);
            System.debug('POS_APIUpsertItem.cls Response: '+restResponse);
            
            //Make sure item got added
            String itemId = response.Id;
            List<Item__c> loadedItems = [select Id, Agency_Item_Id__c from Item__c where Id=:itemId];
            
            System.assert(loadedItems.size()==1);
            
            //Test an update
            restResponse = new RestResponse();
            response = POS_APIUpsertItem.doPost(item, new RestResponse());
            String agencyId = response.AgencyItemId;
            
            //If it reinserted the same record we'd have two results here
            loadedItems = [select Id, Agency_Item_Id__c from Item__c where Agency_Item_Id__c=:agencyId];
            System.assert(loadedItems.size()==1);
            
            
            //Test that it's rejected if the agency ID isn't there
            item = new Item__c();
            item.Program__c = program.Id;
            
            restResponse = new RestResponse();
            response = POS_APIUpsertItem.doPost(item, restResponse);
            System.assert(restResponse.StatusCode==400);  //We get 400 because it's not permitted
            
            //Test if no program is associated
            
            item = new Item__c();
            item.Program__c = null;
            restResponse = new RestResponse();
            response = POS_APIUpsertItem.doPost(item, restResponse);
            System.assert(restResponse.StatusCode==400);  //We get 400 because it's not permitted
            
        }
    }
        
     
}