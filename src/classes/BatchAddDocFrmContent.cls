global class BatchAddDocFrmContent implements Database.Batchable<sObject> {
   public String query;
	
   global BatchAddDocFrmContent(String q){
             query=q; 
   }
   
   global BatchAddDocFrmContent(){
       query = 'Select c.share_link_low__c, c.share_link__c, c.filetype__c, c.filesize_low__c, c.filesize__c, c.Video_Id__c, c.Uploaded_date__c,'+
   	   'c.Title__c, c.Title_Display__c, c.Tags__c, c.TBA__c, c.TBA_Display__c, c.SystemModstamp, c.RTS__c, c.RTS_Display__c, c.Preview_Id__c,'+ 
   	   'c.Preview_Available__c, c.Portfolio__c, c.Portfolio_Display__c, c.OwnerId, c.Name, c.Matrix_type__c, c.Matrix_Type_Display__c, '+
   	   'c.LastModifiedDate, c.LastModifiedById, c.LastActivityDate, c.Is_Video__c, c.IsDeleted, c.Innovation__c, c.Image_Resolution__c,'+
   	   'c.Image_Resolution_Display__c, c.Id, c.Document_Id__c, c.Description__c, c.Description_Display__c, c.CreatedDate, c.CreatedById,'+
   	   'c.Content_Version_Id__c, c.Content_Version_Id_Low__c, c.Content_ID__c, c.Content_ID_Low__c, c.ConnectionSentId, c.ConnectionReceivedId,'+
   	   'c.Classification__c, c.Classification_Display__c From Content_Description__c c where c.Content_Version_Id__c != null ' +
		'and Content_Version_Id__c != \'\' and (c.filetype__c = \'PNG\' or c.filetype__c = \'JPG\' or c.filetype__c = \'GIF\' or c.filetype__c = \'JPEG\')  and name like \'%LOGO%\''; 
   }
   
   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   		Map<ID, Content_Description__c> mapCD = new Map<ID, Content_Description__c>();
		for(Sobject s : scope){
			mapCD.put(s.Id,(Content_Description__c)s); 
        }     
        TriggerContentDescription.onAfterInsert(mapCD);
   }

   global void finish(Database.BatchableContext BC){
   }
}