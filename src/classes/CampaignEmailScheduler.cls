/*****************************************************************************
  Name              : CampaignEmailScheduler
  Created On        : Nov 12, 2013
  Created By        : Vikash Goyal(JDC)
  Task Number       : US871/TA1590
  Implementation    : Batch job to send emails to campaign members
 
  Updated By        : Basant Verma (JDC)
  Updated Date      : 05 Dec, 2013
  Story/Task        : US923/DE868
  
  Updated By        : Siddharth Varshneya (JDC)
  Updated Date      : 26 Dec, 2013
  Story/Task        : US940/DE907
  
  Updated By        : Basant Verma (Appirio JDC)
  Updated Date      : 17 Jan, 2014
  Story/Task        : US1047/TA1866
  
  Updated By        : Basant Verma (Appirio JDC)
  Updated Date      : 5 Feb, 2014
  Story/Task        : DE1023
  
  Updated By        : Siddharth Varshneya (JDC)
  Updated Date      : 14 Feb, 2014
  Story/Task        : TA2094
  
  Updated By        : Basant Verma (Appirio JDC)
  Updated Date      : 19 Feb, 2014
  Story/Task        : DE1045, and code optimization
******************************************************************************/
global class CampaignEmailScheduler implements Database.Batchable<sObject>, Schedulable, Database.Stateful{
  
  // Holds the query string.
  public String queryStr;
  //START : Changed for DE1023
  public String queryStr1;
  String previousCamp;
  //END : Changed for DE1023
  global Set<String> campaignIds;
  global Integer totalBatches;
  global Integer currentBatchNumber;
  map<Id,String> mapCCEmail;
  String statusMessage = '';
  
  public CampaignEmailScheduler(){
  		//START : Changed for DE1023
  		queryStr1 = 'Select Id,Program__c From Campaign Where Scheduled_Send_Date__c <= :dt AND Communication_Template__c != null AND Status = \'Scheduled\'';
  		//END : Changed for DE1023
  		queryStr = 'SELECT Id, Processed__c, LeadId, ContactId, Campaign.Weekly_Date__c, Campaign.Weekly__c, Campaign.Monthly_Date__c, '+
                 'Campaign.Monthly__c, Campaign.Manual_Date__c, Campaign.Manual__c, Campaign.EndDate, Campaign.StartDate, CampaignId, '+
                 'Campaign.Communication_Template__c, Campaign.Program__c, Campaign.Scheduled_Send_Date__c '+
                 'FROM CampaignMember '+
                 'WHERE Campaign.Scheduled_Send_Date__c <= :dt AND Processed__c = false AND Campaign.Communication_Template__c != null AND Campaign.Status = \'Scheduled\''+
                 'ORDER BY campaignId';
      previousCamp = '';
  }
  // Initializes the query with QueryLocator.
  
  global Database.QueryLocator start(Database.BatchableContext BC){
    campaignIds = new Set<String>();
    Set<String> calIds = new Set<String>();
    Date dt = Date.today();
    //START : Changed for DE1023
    for(Campaign cm : (List<Campaign>)Database.query(queryStr1)){
  		campaignIds.add(cm.Id);
  		calIds.add(cm.Program__c);
  	}
  	
  	//END : Changed for DE1023
  	
  	
	//START : Changed for TA2094
  	mapCCEmail = new map<Id,String>();
  	
  	for(Calendar__c cal : [SELECT Id,OwnerId, Owner.Email from Calendar__c where Id in : calIds]){
			mapCCEmail.put(cal.Id,cal.Owner.Email);
  	}
  	//END : Changed for TA2094
    return Database.getQueryLocator(queryStr);
  }
  
  // Processes the list of objects.
  global void execute(Database.BatchableContext BC, List<sObject> scope) {
    List<CampaignMember> lstCampaignMember = new List<CampaignMember>();
    if(totalBatches == null){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, 
                          TotalJobItems, CreatedBy.Email 
                          from AsyncApexJob 
                          where Id = :BC.getJobId()];
      totalBatches = a.TotalJobItems;
      currentBatchNumber = 0;                    
    }
    //start changes for US940/DE907
		string NACEXISTING = '';
		string NACEMAIL = '';
		string NACNONEXISTING = '';
		string FROMEMAILID = '';
		List<NoReplyEmailTemplate__c> noReplyEmails = [SELECT FromEmailID__c,NAC_Existing_Recipients_Name__c,NAC_Non_Existing_Recipients_Name__c,NACEmailTemplateName__c FROM NoReplyEmailTemplate__c];
    for(NoReplyEmailTemplate__c obj: noReplyEmails){ 
        NACEXISTING = obj.NAC_Existing_Recipients_Name__c ;
        NACNONEXISTING = obj.NAC_Non_Existing_Recipients_Name__c;
        NACEMAIL = obj.NACEmailTemplateName__c;
        FROMEMAILID = obj.FromEmailID__c;
    }
    
    map<Id,EmailTemplate> mapET = new map<Id,EmailTemplate>([Select e.Name, e.Id From EmailTemplate e where name =:NACEXISTING or name =:NACNONEXISTING or name =:NACEMAIL]);
    OrgWideEmailAddress sender;
    for(OrgWideEmailAddress owea : [select Id from OrgWideEmailAddress where Address =: FROMEMAILID]){
        sender = owea;
    }
    //end changes for US940/DE907
    // START : Changed for US1047/TA1866 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
    if(sender != null){
	    try{
	      currentBatchNumber++;
	      for(CampaignMember mem : (List<CampaignMember>)scope){
	        	if(!CheckEmail.isOverLimit(1, Service_API.getReserveEmails())){
	            if(mem.Campaign.Communication_Template__c.startsWith('00X')){
		            List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
		            String receiverId;
		            if(mem.ContactId != null){
		                receiverId = mem.ContactId;
		            }
		            else{
		                receiverId = mem.LeadId;
		            }
		            //Messaging.reserveSingleEmailCapacity(1);
		            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		            mail.setTemplateId(mem.Campaign.Communication_Template__c);
		            //start changes for US940/DE907
		            if(mapET.containsKey(mem.Campaign.Communication_Template__c)){
		            	mail.setOrgWideEmailAddressId(sender.id);
		            	//START : Changed for TA2094
		            	System.debug('======================== Previous Campaign '+previousCamp);
		            	System.debug('======================== Current Campaign '+mem.CampaignId);
		            	if(previousCamp != String.valueOf(mem.CampaignId)){
		            		previousCamp = mem.Campaign.Id;
		                	if(mapCCEmail.containsKey(mem.Campaign.Program__c)){
		                		mail.setCcAddresses(new String[]{Label.NAC_Admin_CC_Address,mapCCEmail.get(mem.Campaign.Program__c)}) ;
		                	}
		                	else{
		                		mail.setCcAddresses(new String[]{Label.NAC_Admin_CC_Address}) ;
		                	}
		            	}
		            	//END : Changed for TA2094
		            }
		            if(mem.Campaign.Program__c != null){
		            	 mail.setWhatId(mem.Campaign.Program__c);
		            }
		            //end changes for US940/DE907
		            mail.setTargetObjectId(receiverId);
	              mail.setSaveAsActivity(false);
	              emailMessages.add(mail);
	              System.debug('============================= MAIL TO SEND '+emailMessages);
	              Messaging.sendEmail(emailMessages);
	              
	              mem.Processed__c = true;
	              lstCampaignMember.add(mem);
	              //START : Changed for DE1023
	              //campaignIds.add(mem.CampaignId);
	              //END : Changed for DE1023
	            }
	        	}          
	      }
	      
	      if(lstCampaignMember != null && lstCampaignMember.size() > 0){     
	      	update lstCampaignMember;
	      }
	      // END : Changed for US1047/TA1866 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
	    }
	    catch(Exception e){
	        //System.abortJob(BC.getJobId());     
	        System.debug('============================= EXCPETION OCCURED '+e.getStackTraceString()+' :: '+e.getMessage());
	        statusMessage += '\nEXCPETION OCCURED : '+e.getStackTraceString()+' :: '+e.getMessage();
	    }
  	}else{
  		statusMessage += Label.OWA_NOT_FOUND;
  	}
    System.debug('============================= ENDED EXECUTE');
  }
  
  // Completes the batch process.
  global void finish(Database.BatchableContext BC) {
  	// START : Changed for US1047/TA1866 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
  	if(campaignIds != null && campaignIds.size() > 0){
	    Set<String> pendingCampaignIds = new Set<String>();
	    for(CampaignMember campMem : [SELECT campaignId FROM CampaignMember WHERE Processed__c = false AND campaignId IN : campaignIds]){
	        pendingCampaignIds.add(campMem.campaignId);
	    }
	    
	    List<Campaign> lstCampaignsCompleted = new List<Campaign>();
	    for(String campId : campaignIds){
	        if(!pendingCampaignIds.contains(campId)){
	            Campaign camp = new Campaign(Id = campId, Status = 'Completed');
	            lstCampaignsCompleted.add(camp);
	        }
	    }
	    
	    if(lstCampaignsCompleted.size() > 0){
	        update lstCampaignsCompleted;
	    }
    }
    sendSchedulerStatusEmail(BC);
    // END : Changed for US1047/TA1866 : By Basant Verma (Appirio JDC) : 17th Jan, 2014
  }
  
  // Execute method for schedulable context.
  global void execute(SchedulableContext SC) {
    ID batchprocessid = Database.executeBatch(this, 1);
  }
  
  // Changed By Basant, New Method created to email campaign Email schedle status : 02/19/2014
  global void sendSchedulerStatusEmail(Database.BatchableContext BC){
  	if(statusMessage == null || statusMessage.trim().equals('')){
  		statusMessage = 'SUCCESS!';
  	}
  	if(!CheckEmail.isOverLimit(1, Service_API.getReserveEmails())){
	    AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, 
	                          TotalJobItems, CreatedBy.Email 
	                          from AsyncApexJob 
	                          where Id = :BC.getJobId()];
	        
	    // Send an email to the Apex job's submitter notifying of job completion.
	    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	    String[] toAddresses = new String[] {a.CreatedBy.Email};
	    mail.setToAddresses(toAddresses);
	    mail.setSubject('CampaignEmailScheduler status :: ' + a.Status);
	    mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '
	            + a.NumberOfErrors + ' failures.'+'\n\n\n Status Message : '+statusMessage);
	    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
  }
}