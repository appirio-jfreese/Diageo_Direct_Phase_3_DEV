/*******************************************************************************
    (c) 2013 Appirio, Inc.
Created By  : Vikash Goyal    (Appirio JDC) 
Story/Task  : 
Description : Test Class for Controller_SignUp

Upadted By  : Basant Verma    (Appirio JDC) 
Story/Task  : NA
Description : TO Improve test coverage

Upadted By  : Vikash Goyal    (Appirio JDC) 
Story/Task  : NA
Description : To fix test method

Upadted By  : Basant Verma    (Appirio JDC) 
Story/Task  : NA  - 9th Jan, 2014
Description : TO Improve test coverage

Upadted By  : Basant Verma    (Appirio JDC) 
Story/Task  : US1198  - 19th Mar, 2014
Description : TO Improve test coverage
*******************************************************************************/
@isTest
private class Test_Controller_SignUp {
    
    static testMethod void testSubscriberRequest() {
    	
      SignupController controller = new SignupController();
      controller.distribuorCon.FirstName = 'Test';
      controller.distribuorCon.LastName = 'New Subscriber';
      controller.distribuorCon.Email = 'testsubscriber@test.com';
      controller.distribuorCon.Subscribe_Interested_In__c = 'Beer';
      controller.subscribe();
      
      ProcessInstance processInstance = null;
      ProcessInstanceWorkitem processStep = null;
      Approval.ProcessWorkitemRequest workItemReq = null;
      Approval.ProcessResult result =  null;
      for(ProcessInstance p : [SELECT Id, TargetObjectId, CreatedDate FROM ProcessInstance WHERE Status = 'Pending' AND TargetObjectId = :controller.distribuorCon.Id limit 1]){
      	processInstance = p;
      }
      if(processInstance != null){
	      processStep = [SELECT ProcessInstanceId, Id, ActorId, CreatedDate FROM ProcessInstanceWorkitem 
	       																							WHERE ProcessInstanceId = :processInstance.Id limit 1];																											
	      
	      workItemReq = new Approval.ProcessWorkitemRequest();
		  	workItemReq.setWorkitemId(processStep.Id);
	      workItemReq.setAction('Approve');
		  	result =  Approval.process(workItemReq);
      }
      
      Test.setCurrentPageReference(Page.SignUp);
      Apexpages.currentPage().getParameters().put('ContId', controller.distribuorCon.Id);
      
      String encryptedText = Utility.encryptText(controller.distribuorCon.Id+'_'+Date.today().addDays(10));
      Apexpages.currentPage().getParameters().put('Key', encryptedText);
      
      SignupController controller2 = new SignupController();
      controller2.distribuorConDummy.Subscribe_Interested_In__c = 'Wine';
      controller2.save();
      
      if(controller2 != null && controller2.distribuorCon != null && controller2.distribuorCon.Id != null){
	      for(ProcessInstance p : [SELECT Id, TargetObjectId, CreatedDate FROM ProcessInstance WHERE Status = 'Pending' AND TargetObjectId = :controller2.distribuorCon.Id limit 1]){
	      	processInstance = p;
	      }
	      if(processInstance != null){
	      	processStep = [SELECT ProcessInstanceId, Id, ActorId, CreatedDate FROM ProcessInstanceWorkitem 
	       																							WHERE ProcessInstanceId = :processInstance.Id limit 1];																											
	      
	      	workItemReq = new Approval.ProcessWorkitemRequest();
		  		workItemReq.setWorkitemId(processStep.Id);
		  		workItemReq.setAction('Approve');
		  		result =  Approval.process(workItemReq);
		  		//controller2.save();
	      }
      }
      
      // START - Added Code to provide coverage for Utility.sendQuarterlyRequestEmail - Basant 11/21/13
      List<String> contactIds = new List<String>();
      contactIds.add(controller.distribuorCon.Id);
      String status = Utility.sendQuarterlyRequestEmail(contactIds);
      //System.assertEquals(status, 'success');
      // END - Added Code to provide coverage for Utility.sendQuarterlyRequestEmail - Basant 11/21/13
      
      Apexpages.currentPage().getParameters().put('Key', controller.distribuorCon.Id);
      Apexpages.currentPage().getParameters().put('Method', 'Unsubscribe');
      Apexpages.currentPage().getParameters().put('isEncrypted', 'false');
      SignupController controller3 = new SignupController();
      controller3.processEmailLink();
      
      //START : Changed for US1198
      Apexpages.currentPage().getParameters().remove('Key');
      Apexpages.currentPage().getParameters().remove('Method');
      Apexpages.currentPage().getParameters().remove('isEncrypted');
      controller3 = new SignupController();
      controller3.processEmailLink();
      controller3.addMessage(Apexpages.Severity.ERROR, 'RECORD IS LOCKED', false);
      //END : Changed for US1198
    }
}