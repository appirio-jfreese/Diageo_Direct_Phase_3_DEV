@isTest
private class TestMiscellaneous_serviceAPI {
    
    static testMethod void testGetAccBrandIdsForUser1() {
//        POS_ServiceAPI.getAccBrandIdsForUser(userInfo.getUserID()); 
    }
    static testMethod void testGetAccBrandIdsWithParentForUser() {
        RecordType rType = [select id from RecordType where name = 'Distributor'];
        Account acc = new Account();
        acc.name = 'DIAGEO';
        //acc.RecordType.Name = 'Distributor';
        acc.RecordTypeId = rType.id;
        insert acc;
        Account_Member__c acm = new Account_Member__c();
        acm.Account__c = acc.id;
        acm.User__c = userInfo.getUserId();
        acm.Default__c = true;
        insert acm;
        Brand__c brn = new Brand__c();
        brn.diageo_direct_visible__c = true;
        insert brn;
        AccountBrand__c accBrn = new AccountBrand__c();
        accBrn.Account__c = acc.id;
        accBrn.Brand__c = brn.id ;
        
        insert accBrn;
        POS_ServiceAPI.getAccBrandIdsWithParentForUser(userInfo.getUserID());
    }
    static testMethod void testGetAccBrandIdsForUser() {
        RecordType rType = [select id from RecordType where name = 'Distributor'];
        Account acc = new Account();
        acc.name = 'DIAGEO';
        //acc.RecordType.Name = 'Distributor';
        acc.RecordTypeId = rType.id;
        insert acc;
        Account_Member__c acm = new Account_Member__c();
        acm.Account__c = acc.id;
        acm.User__c = userInfo.getUserId();
        acm.Default__c = true;
        insert acm;
        Brand__c brn = new Brand__c();
        brn.diageo_direct_visible__c = true;
        brn.Classification__c = 'abc';
        insert brn;
        AccountBrand__c accBrn = new AccountBrand__c();
        accBrn.Account__c = acc.id;
        accBrn.Brand__c = brn.id ;
        
        
        insert accBrn;
        POS_ServiceAPI.getAccBrandIdsForUser(userInfo.getUserID(),'abc'); 
    }
    
   


}