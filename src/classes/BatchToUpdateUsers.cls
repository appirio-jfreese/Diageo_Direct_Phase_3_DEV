global class BatchToUpdateUsers implements Database.batchable<sObject>{ 
    global String Query, Field;
    global boolean Value;
    global BatchToUpdateUsers(String q){
             Query=q; 
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<User> scope){
	  list<User> batchRecords = new list<User>();		                       	
      for(User s : scope){
      	s.Access_dd_latest_news__c = true;
      	batchRecords.add(s);
      	 
      }
      if(batchRecords.size() > 0){     
       update batchRecords;
      }
   }

   global void finish(Database.BatchableContext BC){

   }
}