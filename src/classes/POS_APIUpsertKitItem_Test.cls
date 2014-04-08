@IsTest(SeeAllData=true)
public class POS_APIUpsertKitItem_Test{

    static testmethod void testUpsertItem () {
        
        //Get the current time
        Datetime now = System.now();
        
        Profile p = [select id from profile where name='POS - API User Agency'];
        
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id,
                          timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
                          Available_Themes__c='Spirits');
        
        RecordType kitRecordType = [select Id from RecordType where Name='Kit' and sObjectType='Item__c'];
        RecordType standardRecordType = [select Id from RecordType where Name='Standard' and sObjectType='Item__c'];
        RecordType posAgencyRecordType = [select Id from RecordType where Name='POS Production Agency' and sObjectType='Account'];
        
        
        System.runAs(u) {
            
            //Create Agency
            
            Account agency = POS_TestDataUtil.createProductionAgency();
            
            
            Program__c program = POS_TestDataUtil.createProgram();
            
            
            //Create the kit
            Item__c kit = POS_TestDataUtil.createKit(program,agency);
            
            Test.startTest();
            //Create an item to add to the kit
            Item__c item = POS_TestDataUtil.populateItem(program, agency);
            item.RecordType=standardRecordType;
            insert item; 
            
            Kit_Item__c kitItem = new Kit_Item__c();
            kitItem.Kit__c = kit.Id;
            kitItem.Item__c = item.Id;
            kitItem.Packout_Quantity__c = 5;
            
            System.debug('KIT ITEM:'+kitItem);
            
            //Upsert will fail here because we aren't associated to an agency
            POS_APIUpsertKitItem.UpsertResponse response = POS_APIUpsertKitItem.doPost(kitItem, new RestResponse());
            System.assert(response==null);
            
            Account_Member__c member = new Account_Member__c();
            member.Account__c = agency.Id;
            member.User__c = u.Id;
            insert member;
            
            //Now it should work
            response = POS_APIUpsertKitItem.doPost(kitItem, new RestResponse());
            
            System.debug('Response: '+response.statusDetail);
            
            //Make sure item got added
            String kitItemId = response.Id;
            List<Kit_Item__c> loadedKitItems = [select Id from Kit_Item__c where Id=:kitItemId];
            System.assert(loadedKitItems.size()==1);
            
            //Test an update
            response = POS_APIUpsertKitItem.doPost(kitItem, new RestResponse());
            String secondItemId = response.Id;
            
            //If it reinserted the same record we'd have different results here
            System.assert(kitItemId==secondItemId);
            
            
            //Test that it's rejected if the item had the wrong agency isn't there
            //Create Agency
            Account agency2 = POS_TestDataUtil.createProductionAgency();
            
            item = POS_TestDataUtil.populateItem(program, agency2);
            item.RecordType=standardRecordType;
            insert item;
            kitItem.Item__c = item.Id;
            
            try {
                response = POS_APIUpsertKitItem.doPost(kitItem, new RestResponse());
                System.assert(response==null); //Should be null because it's invalid request
            }
            catch (Exception e) {
                //Expected
            }
            
            Test.stopTest();
        }
        
        
    }
    
    
}