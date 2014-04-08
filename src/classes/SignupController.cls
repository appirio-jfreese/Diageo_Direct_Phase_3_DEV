/*******************************************************************************
	(c) 2013 Appirio, Inc.
Created By 	:	Basant Kr. Verma	(Appirio JDC) 
Story/Task	: US848/TA1539
Description	: Controller class for SignupController

Upadted By  : Basant Verma    (Appirio JDC) 
Story/Task  : US1198  - 19th Mar, 2014
Description : TO Improve test coverage
*******************************************************************************/
public without sharing class SignupController{
	public Contact distribuorCon {get;set;}
	public Contact distribuorConDummy {get;set;}
	private String contId;
	private static final String DistributorSubmitedState = 'Submitted';
	public Boolean isSuccess {get; set;}
	public Boolean isSubscribe {get; set;}
	public Boolean isValidKey {get; set;}
	public Boolean isUnsubscribeLink {get; set;}
	
	private static String PRIVATE_KEY = 'mRMjHmlC1C+1L/Dkz8EJuw==';
	private static String ENCRYPTION_ALGO = 'AES128';
	public SignupController(){
		isSuccess = false;
		isSubscribe = true ;
		isValidKey = false;
		isUnsubscribeLink = false;
		distribuorConDummy = new Contact();
		
		if(Apexpages.currentPage().getParameters().containsKey('contId')){
	  	contId = Apexpages.currentPage().getParameters().get('contId');
  	}
  	
  	if(Apexpages.currentPage().getParameters().containsKey('key')){
  		String key = Apexpages.currentPage().getParameters().get('key');
  		String isEncryptd = Apexpages.currentPage().getParameters().get('isEncrypted');
	  	isSubscribe = false;
	  	if(isEncryptd != null && isEncryptd == 'false'){
	  		contId = key;
	  		if(Apexpages.currentPage().getParameters().get('method') == 'Unsubscribe'){
	  			isUnsubscribeLink = true;
	  		}
	  		isValidKey = true;
	  	}else{
	  	  isValidKey = decryptKey(key);
	  	}
	  	if(!isValidKey){
	  		//START : Changed for US1198
			  addMessage(Apexpages.Severity.ERROR, Label.DistributorContactExpireMsg, false);
			  //END : Changed for US1198
	  	}  	
		}
  		
  	if(contId != null && !contId.trim().equals('')){
			distribuorCon = [Select Id, Name, AccountId, Account.Name, FirstName, 
				LastName, Title, Email, Phone, 
				Distributor_Name__c, Distributor_City__c, Distributor_State__c, 
				Distributor_Postal_Code__c, Subscribe_Interested_In__c, 
				Subscribe_Premise__c, Subscribe_Status__c,Distributor_Address__c,
				First_Name_copy__c, Last_Name_copy__c, Title_copy__c, Email_copy__c, 
				Phone_copy__c, Distributor_Name_copy__c, Distributor_City_copy__c, 
				Distributor_State_copy__c, Distributor_Postal_Code_copy__c, 
				Subscribe_Interested_In_copy__c,Subscribe_Premise_copy__c, 
				Update_Request_Status__c,Distributor_Address_copy__c,Unsubscribe__c,
				Is_Update_Link_Used__c, Select_Managed_States__c, Select_Managed_States_Copy__c
				From Contact Where Id = :contId Limit 1].get(0);
				
				if(distribuorCon.Unsubscribe__c && distribuorCon.Is_Update_Link_Used__c){
	  		  //START : Changed for US1198
			    addMessage(Apexpages.Severity.INFO, Label.DistributorContactUnsubscribeMsg, true);
			    addMessage(Apexpages.Severity.INFO, Label.DistributorContactNoteMsg, true);
			    //END : Changed for US1198
	  	  }
	  	  if(distribuorCon.Update_Request_Status__c == 'Submitted' && distribuorCon.Is_Update_Link_Used__c && !isUnsubscribeLink){
	  		  //START : Changed for US1198
			    addMessage(Apexpages.Severity.INFO, Label.DistributorContactExpireMsg, true);
			    //END : Changed for US1198
	  	  }
		}else{
			distribuorCon = new Contact(AccountId = Label.DistributorPlaceHolderAccount);
			distribuorCon.Subscribe_Status__c = DistributorSubmitedState;			
		}
		
		if(!isSubscribe){
			populateContactInfoDummy();
		}		
	}
	
	private boolean decryptKey(String decryptText){
		boolean isValid = true;
		if(decryptText == null || decryptText.trim() == ''){
		  return false;
		}
		Blob decryptKey = EncodingUtil.base64Decode(PRIVATE_KEY);
		Blob cypherText = Crypto.decryptWithManagedIV(ENCRYPTION_ALGO, decryptKey, EncodingUtil.base64Decode(decryptText));
		String plainText = cypherText.toString();				
		List<String> str = plainText.split('_');
		if(str.size() < 2){
			return false;
		}
		contId = str[0].trim();
		String dateString = str[1].trim();
		if(contId.length() < 15 || contId.substring(0, 3) != '003' || Date.valueOf(dateString) < Date.today()){
			isValid = false;
		}
		if(str.size() == 3 && str[2].trim() == 'Unsubscribe'){
			isUnsubscribeLink = true;
		}
		return isValid;
	}
	
	public Pagereference save(){
		isSuccess = false;
		try{
			// Create Distributor Contact Record
			distribuorConDummy.Id= distribuorCon.Id;
			distribuorConDummy.Update_Request_Status__c = DistributorSubmitedState;
			distribuorConDummy.Is_Update_Link_Used__c = true;			 
			update distribuorConDummy;
			// Submit that record for Approval
			Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
   		app.setObjectId(distribuorConDummy.id);
   		Approval.ProcessResult result = Approval.process(app);
   		   		
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, Label.DistributorContactSubmitSuccessMessage));
   			isSuccess = true;
		}catch(Exception e){
			//START : Changed for US1198
	    addMessage(Apexpages.Severity.ERROR, e.getMessage(), false);
	    //END : Changed for US1198
		}
		return null;
	}
	
	public void processEmailLink(){
		if(isUnsubscribeLink){
			unSubscribe();
		}
	}
	
	
	public Pagereference unSubscribe(){
		isSuccess = false;
		try{
			// Unsubscribe Distributor Contact  
			distribuorCon.Unsubscribe__c = true;
			distribuorCon.Is_Update_Link_Used__c = true;
			update distribuorCon;
			EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Confirmation_Email_Unsubscribe'];
			List<OrgWideEmailAddress> orgWideAddr = new List<OrgWideEmailAddress>([SELECT Id, DisplayName, Address FROM OrgWideEmailAddress 
			                                         WHERE Address = 'nac.admin@diageo.com' LIMIT 1]);
			Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
	  	mail.setTemplateId(template.Id);
	  	mail.setTargetObjectId(distribuorCon.Id);
	  	if(orgWideAddr.size() > 0){
	  		mail.setOrgWideEmailAddressId(orgWideAddr[0].Id);
	  	}
	  	Messaging.sendEmail(new List<Messaging.Singleemailmessage>{mail});
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, Label.DistributorContactUnsubscribeMsg));
	    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, Label.DistributorContactNoteMsg));
   		isSuccess = true;
		}catch(Exception e){
			//START : Changed for US1198
	    addMessage(Apexpages.Severity.ERROR, e.getMessage(), false);
	    //END : Changed for US1198
		}
		return null;
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
			//START : Changed for US1198
	    return addMessage(Apexpages.Severity.ERROR, e.getMessage(), false);
	    //END : Changed for US1198
		}
		return null;
	}
	
	
	private void populateContactInfoDummy(){
		distribuorConDummy.First_Name_copy__c = distribuorCon.FirstName;
		distribuorConDummy.Last_Name_copy__c = distribuorCon.LastName;
		distribuorConDummy.Title_copy__c = distribuorCon.Title;
		distribuorConDummy.Email_copy__c = distribuorCon.Email;
		distribuorConDummy.Phone_copy__c = distribuorCon.Phone;
		distribuorConDummy.Distributor_Name_copy__c = distribuorCon.Distributor_Name__c;
		distribuorConDummy.Distributor_City_copy__c = distribuorCon.Distributor_City__c;
		distribuorConDummy.Distributor_State_copy__c = distribuorCon.Distributor_State__c;
		distribuorConDummy.Distributor_Postal_Code_copy__c = distribuorCon.Distributor_Postal_Code__c;
		distribuorConDummy.Subscribe_Interested_In_copy__c = distribuorCon.Subscribe_Interested_In__c;
		distribuorConDummy.Subscribe_Premise_copy__c = distribuorCon.Subscribe_Premise__c;
		distribuorConDummy.Distributor_Address_copy__c = distribuorCon.Distributor_Address__c;
		distribuorConDummy.Select_Managed_States_Copy__c = distribuorCon.Select_Managed_States__c;
	} 
	//START : Changed for US1198
	public Pagereference addMessage(Apexpages.Severity severity, String msg, Boolean flag){
		if(msg.contains('LOCK')){
			msg = Label.DistributorContactRecordLocked;
		}
		Apexpages.addMessage(new Apexpages.Message(severity, msg));
	  isSuccess = flag;
	  return null;
	} 
	//END : Changed for US1198
}