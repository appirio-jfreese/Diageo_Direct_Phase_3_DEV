@isTest 
private class TestBatchToUpdate {
    static testMethod void testBatchtoUpdateMethod() {
    	String query = 'Select Id , Access_dd_latest_news__c from User limit 1';
    	Test.startTest();
    	ID batchprocessid = Database.executeBatch(new BatchToUpdateUsers(query));    	
    	Test.stopTest();
   }
}