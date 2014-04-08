/*******************************************************************************
    (c) 2013 Appirio, Inc.
Created By  :   Basant Kr. Verma    (Appirio JDC) 
Story/Task  : US913/TA1679, US912/TA1678
Description : Controller class for NAC Subscription
ability to save changes or unsubscribe
*******************************************************************************/
public without sharing class NACommunications {
    
    private static final String DistributorSubmitedState = 'Submitted';
    public Contact distribuorCon {get;set;}
    public Contact distribuorConDummy {get;set;}
    private String contId;
    public Boolean isSuccess {get; set;}
    public Boolean isUnsubscribeLink {get; set;}
    public Boolean isPortalUser {get; set;}
    
    public NACommunications(){
        isSuccess = false;
        isPortalUser = false;
        isUnsubscribeLink = false;
        
        if(Apexpages.currentPage().getParameters().containsKey('contId')){
        contId = Apexpages.currentPage().getParameters().get('contId');
    }
    
    if(contId != null && !contId.trim().equals('')){
        distribuorCon = null;
            for(Contact c : [Select Id, Name, AccountId, Account.Name, FirstName, 
                LastName, Title, Email, Phone, Division__c, Select_Managed_States__c, 
                Subscribe_Interested_In__c, Subscribe_Premise__c,  
                NAC_Update_Request_Status__c, NAC_Unsubscribe__c,
                Is_Update_Link_Used__c
                From Contact Where Id = :contId Limit 1]){
                distribuorCon = c;
            }
            
            if(distribuorCon == null){
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, Label.DistributorContactNotFound));
                isSuccess = false;
                return;
            }   
            
            if(distribuorCon.NAC_Unsubscribe__c){
          Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, Label.DistributorContactUnsubscribeMsg));
          Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, Label.DistributorContactNoteMsg));
            isSuccess = true;
            return;
      }
        
      for(User u : [Select Id From User Where ContactId = :distribuorCon.Id]){
        isPortalUser = true;
      }
          
        }else{
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, Label.DistributorContactNotFound));
            isSuccess = false;
            return;
        }
        distribuorConDummy = new Contact();
        populateContactInfoDummy(distribuorCon, distribuorConDummy);
    }
    
    public Pagereference save(){
        isSuccess = false;
        try{
            populateContactInfoDummy(distribuorConDummy, distribuorCon);
            // Create Distributor Contact Record
            distribuorCon.NAC_Update_Request_Status__c = DistributorSubmitedState;   
            update distribuorCon;
            
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, Label.NACSaveSuccessMessage));
        isSuccess = true;
        }catch(Exception e){
            String errMsg = e.getMessage();
            if(errMsg.contains('LOCK')){
                errMsg = Label.DistributorContactRecordLocked;
            }
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, errMsg));
            isSuccess = false;
        }
        return null;
    }
    
    public Pagereference unSubscribe(){
        isSuccess = false;
        try{
            // Unsubscribe Distributor Contact  
            distribuorCon.NAC_Unsubscribe__c = true;
            update distribuorCon;
            /*EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Confirmation_Email_Unsubscribe'];
            Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        mail.setTemplateId(template.Id);
        mail.setTargetObjectId(distribuorCon.Id);
        Messaging.sendEmail(new List<Messaging.Singleemailmessage>{mail});*/
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, Label.DistributorContactUnsubscribeMsg));
        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, Label.DistributorContactNoteMsg));
        isSuccess = true;
        }catch(Exception e){
            String errMsg = e.getMessage();
            if(errMsg.contains('LOCK')){
                errMsg = Label.DistributorContactRecordLocked;
            }
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, errMsg));
            isSuccess = false;
        }
        return null;
    }
    
    private void populateContactInfoDummy(Contact src, Contact trg){
        
        trg.FirstName = src.FirstName;
        trg.LastName = src.LastName;
        trg.Title = src.Title;
        trg.Email = src.Email;
        trg.Phone = src.Phone;
        trg.Division__c = src.Division__c;
        trg.Select_Managed_States__c = src.Select_Managed_States__c;
        trg.Subscribe_Interested_In__c = src.Subscribe_Interested_In__c;
        trg.Subscribe_Premise__c = src.Subscribe_Premise__c;
        trg.NAC_Update_Request_Status__c = src.NAC_Update_Request_Status__c;
        trg.NAC_Unsubscribe__c = src.NAC_Unsubscribe__c;
        trg.Is_Update_Link_Used__c = src.Is_Update_Link_Used__c;
    } 
}