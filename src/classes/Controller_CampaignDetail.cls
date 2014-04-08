/**
*Created By  : Siddharth Varshneya (Appirio JDC)   
*Date        : 27/11/13
*Story/Task  : US923/TA1668 : override campaign edit button for Communication Template Drop down
*
*Updated By  : Basant Verma (Appirio JDC)   
*Date        : 12/03/13
*
*Updated By  : Basant Verma (Appirio JDC)   
*Date        : 12/05/13
*Story/Task  : US923/DE867
*
*Updated By  : Siddharth Varshneya (Appirio JDC)   
*Date        : 12/07/13
*Story/Task  : NA (Code Modified to handle "List has no rows for assignment to SObject " exception)
*
*Updated By  : Basant Verma (Appirio JDC)   
*Date        : 12/09/13
*Story/Task  : NA (Code Modified to remove unwanted SOQL)
*
*Updated By  : Basant Verma (Appirio JDC)   
*Date        : 12/12/13
*Story/Task  : US923/DE883
*/
public with sharing class Controller_CampaignDetail {

    public Campaign campaign {get;set;}
    public List<SelectOption> options {
        get{
            if(options == null){
                options = new List<SelectOption>();   
            List<SelectOption> tempOptions = new List<SelectOption>();
            for(EmailTemplate eTemp:[Select Name, Id From EmailTemplate WHERE isActive = true]){
                tempOptions.add(new SelectOption(eTemp.Name,eTemp.Id));
            }
            tempOptions.sort();
            options.add(new SelectOption('','--- Select Email Template ---'));
            for(SelectOption s: tempOptions){
                options.add(new SelectOption(s.getLabel(),s.getValue()));
            }
            }
            return options;
        }
        set;
    }
    public string baseUrl {get;set;}
     
    public Controller_CampaignDetail (ApexPages.StandardController standardController) {
         baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
         if(ApexPages.currentPage().getParameters().containsKey('Id')){
             campaign = [Select Status, Scheduled_Send_Date__c, Program__c, Program_Start_Date__c,
                 Program_Local_Action_Req__c, Program_End_Date__c, Name, Id, Contact_Name__c, Contact_Email__c,
                 Communication_Template__c From Campaign Where id=: ApexPages.currentPage().getParameters().get('Id')];
         } 
           
         if(campaign  == null){
              campaign = new Campaign();
              setCommunicationTemplate();
         }
         
         Standard_Button_Ovverride__c settings = Standard_Button_Ovverride__c.getInstance(); 
         String fieldsToSearch = settings.CampaignProgram__c;
         if(fieldsToSearch != null && !fieldsToSearch.trim().equals('')){
            if(ApexPages.currentPage().getParameters().containsKey(fieldsToSearch+'_lkid')){
                campaign.Program__c = ApexPages.currentPage().getParameters().get(fieldsToSearch+'_lkid');
                    }
            if(ApexPages.currentPage().getParameters().containsKey(fieldsToSearch)){
                campaign.Name = ApexPages.currentPage().getParameters().get(fieldsToSearch);
            }
        }
        if(campaign.Communication_Template__c == null){
            setCommunicationTemplate();
        }
    }
    
    public Pagereference doSave(){
        Pagereference pg = null;
        try{
            upsert campaign;
            pg = new PageReference('/'+campaign.id);
            pg.setRedirect(true);
        }catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
        }
        return pg;
    }
    
    public void setCommunicationTemplate() {
    	// Start : Changed for US923/DE883
    	if(Settings__c.getValues('DefaultNACCommunication') != null){
    		String s = Settings__c.getValues('DefaultNACCommunication').value__c;
				if(s != null) { 
            campaign.Communication_Template__c = s; 
        } else {
            campaign.Communication_Template__c = '';
        }
    	}
    	// End : Changed for US923/DE883
    }
}