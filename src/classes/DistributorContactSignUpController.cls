/*******************************************************************************
	(c) 2013 Appirio, Inc.
Created By 	:	Basant Kr. Verma	(Appirio JDC) 
Story/Task	: US848/TA1539
Description	: Controller class for DistributorContactSignUpController
*******************************************************************************/
public with sharing class DistributorContactSignUpController{
	public Contact distribuorCon {get;set;}
	private String contId;
	private static final String DistributorSubmitedState = 'Submitted';
	public Boolean isSuccess {get; set;}
	  
	public DistributorContactSignUpController(){
		isSuccess = false;
  	if(Apexpages.currentPage().getParameters().containsKey('contId'))
	  	contId = Apexpages.currentPage().getParameters().get('contId');
		
		if(contId != null && !contId.trim().equals('')){
			distribuorCon = [Select Id, Name, AccountId, Account.Name, FirstName, 
				LastName, Title, Email, Phone, 
				Distributor_Name__c, Distributor_City__c, Distributor_State__c, 
				Distributor_Postal_Code__c, Subscribe_Interested_In__c, 
				Subscribe_Premise__c, Subscribe_Status__c 
				From Contact Where Id = :contId Limit 1].get(0);
		}else{
			distribuorCon = new Contact(AccountId = Label.DistributorPlaceHolderAccount);
			distribuorCon.Subscribe_Status__c = DistributorSubmitedState;
		}
	}
	
	public Pagereference subscribe(){
		isSuccess = false;
		try{
			// Create Distributor Contact Record 
			insert distribuorCon;
			// Submit that record for Approval
			Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
   		app.setObjectId(distribuorCon.id);
   		Approval.ProcessResult result = Approval.process(app);
   		
   		Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, Label.DistributorContactSubmitSuccessMessage));
   		isSuccess = true;
		}catch(Exception e){
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
			isSuccess = false;
		}
		return null;
	}
}