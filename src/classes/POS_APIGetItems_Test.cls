@IsTest(SeeAllData=false)
public class POS_APIGetItems_Test{

    static testmethod void testGetItems () {
      
      //Get the current time
      Datetime now = System.now();
      
      Profile p = [select id from profile where name='POS - API User Agency'];
         
    User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
    localesidkey='en_US', profileid = p.Id,
    timezonesidkey='America/Chicago', username='posmmunittest@diageo.com', Available_Themes__c='Spirits');
    
    System.runAs(u) {
      
      POS_TestDataUtil.initializeTestData();
      
        //Create Agency
        Account agency = POS_TestDataUtil.createProductionAgency();
        
        Account_Member__c member = new Account_Member__c();
        member.Account__c = agency.Id;
        member.User__c = u.Id;
        insert member;
        
        
        Program__c program = POS_TestDataUtil.createProgram();
        Item__c item = POS_TestDataUtil.populateItem(program, agency);
        insert item;
        
        POS_APIGetItems.APIItemResponse response = POS_APIGetItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),null,null,null);
        
        //Should only see the one record
        System.assert(response.items.size()==1);
        System.assert(response.lastRowIndex==1);
        System.assert(response.moreResults==false);
        
        //Update the time and try again so that record doesn't appear
        now=now.addDays(1);
        response = POS_APIGetItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),null,null,null);
        System.assert(response.items.size()==0);
        System.assert(response.lastRowIndex==0);
        System.assert(response.moreResults==false);
        
        //Now test queries for other filters
        now=System.now();
        update item;
        
        //now test with the window ID added to the filter
        response = POS_APIGetItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),program.Order_Window__c,null,null);
        System.assert(response.items.size()==1);
        System.assert(response.lastRowIndex==1);
        System.assert(response.moreResults==false);
        
        
        Test.startTest();
        //Now give a different ID and make sure no result comes back
        response = POS_APIGetItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),'000000000000000',null,null);
        System.assert(response.items.size()==0);
        System.assert(response.lastRowIndex==0);
        System.assert(response.moreResults==false);
        
        //Test ID pass through
        List<String> itemList = new List<String>();
        itemList.add(item.Id);
        
        response = POS_APIGetItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),program.Order_Window__c,itemList,null);
        System.assert(response.items.size()==1);
        System.assert(response.lastRowIndex==1);
        System.assert(response.moreResults==false);
        
        //Add one more item, shouldn't see it
      
        item = POS_TestDataUtil.populateItem(program, agency);
        insert item;
        
        response = POS_APIGetItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),null,itemList,null);
        System.assert(response.items.size()==1);
        System.assert(response.lastRowIndex==1);
        System.assert(response.moreResults==false);
        
        //But should have two if we turn off the filter
        response = POS_APIGetItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),null,null,null);
        System.assert(response.items.size()==2);
        System.assert(response.lastRowIndex==2);
        System.assert(response.moreResults==false);
        
        //Set the offset so we get one again
        response = POS_APIGetItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),null,null,1);
        System.assert(response.items.size()==1);
        System.assert(response.lastRowIndex==2);
        System.assert(response.moreResults==false);
        Test.stopTest();
        //Now create enough items to hit row limit and make sure that the pagination works
        
    }
    
    }
    
    static testmethod void testPaginate () {
      
      //Get the current time
      Datetime now = System.now();
      
      Profile p = [select id from profile where name='POS - API User Agency'];
         
    User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
    localesidkey='en_US', profileid = p.Id,
    timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',Available_Themes__c='Spirits');
    
    System.runAs(u) {
      
      POS_TestDataUtil.initializeTestData();
      
        //Create Agency
        Account agency = POS_TestDataUtil.createProductionAgency();
        
        Account_Member__c member = new Account_Member__c();
        member.Account__c = agency.Id;
        member.User__c = u.Id;
        insert member;
        
        Program__c program = POS_TestDataUtil.createProgram();
        Item__c item = POS_TestDataUtil.populateItem(program, agency);
        insert item;
        
        Test.startTest();
        List<Item__c> testItems = new List<Item__c>();
        integer itemCount=0;
        integer ROW_LIMIT=10;
        while (true) {
          if (itemCount==ROW_LIMIT) {
            break;
          }
          itemCount++;
          
          item = POS_TestDataUtil.populateItem(program, agency);
          
          testItems.add(item);
        }
   
         
        insert testItems; 
         
        POS_APIGetItems.APIItemResponse response = POS_APIGetItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),null,null,null);
        System.debug('Row count: '+response.items.size());
        System.assert(response.items.size()==ROW_LIMIT);
        System.assert(response.lastRowIndex==ROW_LIMIT);
        System.assert(response.moreResults==true);
        
       Test.stopTest();
        
        
        
          
    }
    
    
      
    }
}