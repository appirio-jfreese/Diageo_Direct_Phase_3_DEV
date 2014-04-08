@IsTest(SeeAllData=false)
public class POS_APIGetKitItems_Test{
    
    static testmethod void testGetKitItems () {
        
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
        
        System.runAs(u) {
            
            POS_TestDataUtil.initializeTestData();
            
            //Create Agency
            Account agency = POS_TestDataUtil.createProductionAgency(); 
            
            Account_Member__c member = new Account_Member__c();
            member.Account__c = agency.Id;
            member.User__c = u.Id;
            insert member;
            
            System.debug('Pre-test 1');
            
            
            Program__c program = POS_TestDataUtil.createProgram();
            
            
            //Create the kit
            Item__c kit = POS_TestDataUtil.createKit(program);
            
            System.debug('Pre-test 2');
            
            Test.startTest();
            
            //Create an item to add to the kit
            Item__c item = POS_TestDataUtil.populateItem(program, agency);
            item.RecordType=standardRecordType;
            insert item; 
            
            
            System.debug('Pre-test 3');
            
            
            Kit_Item__c kitItem = new Kit_Item__c();
            kitItem.Kit__c = kit.Id;
            kitItem.Item__c = item.Id;
            kitItem.Packout_Quantity__c = 5;
            insert kitItem;
            
            
            //create enough items to hit row limit and make sure that the pagination works
            
            
            List<Item__c> testItems = new List<Item__c>();
            List<Kit_Item__c> testKitItems = new List<Kit_Item__c>();
            integer itemCount=0;
            Integer ROW_LIMIT = 10;
            
            while (true) {
                System.debug('Loop count: '+itemCount);
                if (itemCount==ROW_LIMIT) {
                    break;
                }
                itemCount++;
                item = POS_TestDataUtil.populateItem(program, agency);
                kitItem = new Kit_Item__c();
                kitItem.Kit__c = kit.Id;
                kitItem.Item__c = item.Id;
                kitItem.Packout_Quantity__c = 5;
                
                testItems.add(item);
                testKitItems.add(kitItem);
            }
            
            
            insert testItems;
            insert testKitItems;
            
            List<String> itemsIds = new List<String>();
            for(Kit_Item__c kitem : testKitItems){
                itemsIds.add(kitem.Id);
            }
            
            System.debug('Run test 7');
            POS_APIGetKitItems.APIKitItemResponse response = POS_APIGetKitItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),null,null);
            System.assert(response.kitItems.size()==ROW_LIMIT);
            System.assert(response.lastRowIndex==ROW_LIMIT);
            System.assert(response.moreResults==true);
            
            POS_APIGetKitItems.APIKitItemResponse response2 = POS_APIGetKitItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),itemsIds,null);
            System.assert(response2.kitItems.size()==ROW_LIMIT);
            System.assert(response2.lastRowIndex==ROW_LIMIT);
            
            Test.stopTest();
            
        }

    }
  	
}