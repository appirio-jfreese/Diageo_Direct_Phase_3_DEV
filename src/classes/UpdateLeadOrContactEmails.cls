global class UpdateLeadOrContactEmails implements Database.Batchable<sObject>{
   global final String Query;
 
   global UpdateLeadOrContactEmails(String q){Query=q;}
 
   global Database.QueryLocator start(Database.BatchableContext BC){
     return Database.getQueryLocator(query);
   }
 
   global void execute(Database.BatchableContext BC, List<sObject> scope){
     List<sObject> sObjectListForUpdate = new List<sObject>();
     for(sObject s : scope){
       sObject newSObject = (sObject)s;
       string updatedEmail = String.valueOf(newSObject.get('Email')) + '.sk2';
       newSObject.put('Email', updatedEmail);
       sObjectListForUPdate.add(newSObject);
     } 
     database.update(sObjectListForUpdate, false);
   }
     
   global void finish(Database.BatchableContext BC){}
	
}