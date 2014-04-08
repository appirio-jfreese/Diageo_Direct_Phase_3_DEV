@isTest
private class Test_ReviewDistributorChangeRqstCtrl {

  static testMethod void testUpdateRequest() {
    Account acc = TestUtil.createAccount(true);
    List<Contact> lstContact = new List<Contact>();
    lstContact.add(TestUtil.createContact(acc.Id, false));
    lstContact.add(TestUtil.createContact(acc.Id, false));
    lstContact.add(TestUtil.createContact(acc.Id, false));
    lstContact.add(TestUtil.createContact(acc.Id, false));
    lstContact[0].Subscribe_Interested_In__c = 'Wine';
    lstContact[0].Update_Request_Status__c = 'Submitted';
    lstContact[1].Update_Request_Status__c = 'Submitted';
    lstContact[2].Update_Request_Status__c = 'Submitted';
    lstContact[3].Update_Request_Status__c = 'Submitted';
    insert lstContact;
    
    lstContact[0].Last_Name_copy__c = 'Updated';
    lstContact[1].Last_Name_copy__c = 'Updated';
    lstContact[2].Last_Name_copy__c = 'Updated';
    lstContact[3].Last_Name_copy__c = 'Updated';
    update lstContact;
    
    List<Approval.ProcessSubmitRequest> lstApp = new List<Approval.ProcessSubmitRequest>();
    for(Integer index = 0; index < 4; index++){
    	Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
   		app.setObjectId(lstContact[index].id);
   		lstApp.add(app);
    }
   	List<Approval.ProcessResult> result = Approval.process(lstApp);
    
    Apexpages.Standardcontroller ctrl = new Apexpages.Standardcontroller(lstContact[0]);
    ReviewDistributorChangeRqstCtrl controller = new ReviewDistributorChangeRqstCtrl(ctrl);
    
    Apexpages.Standardsetcontroller setCtrl = new Apexpages.Standardsetcontroller(lstContact);
    ReviewDistributorChangeRqstCtrl setController = new ReviewDistributorChangeRqstCtrl(setCtrl);
    setController.sortField = 'Subscribe_Interested_In__c';
    setController.doSort();
    setController.sortField = 'Date_Submitted';
    setController.doSort();
    setController.sortField = 'Name';
    setController.doSort();
    
    setController.lstContacts[0].isSelected = true;
    setController.populateSelected();
    setController.approveSelected();
    
    setController.selectedContactId = lstContact[0].Id;
   	setController.lstContacts[0].isSelected = true;
    setController.populateSelected();
    setController.approveRequest();
    
    setController.selectedContactId = lstContact[0].Id;
    setController.lstContacts[0].isSelected = true;
    setController.populateSelected();
    setController.rejectRequest();
    
    setController.lstContacts[0].isSelected = true;
    setController.populateSelected();
    setController.rejectSelected();
  }
}