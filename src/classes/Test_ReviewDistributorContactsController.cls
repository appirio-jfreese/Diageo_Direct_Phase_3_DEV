@isTest
private class Test_ReviewDistributorContactsController {

  static testMethod void testReviewController() {
    Account acc = TestUtil.createAccount(true);
    List<Contact> lstContact = new List<Contact>();
    lstContact.add(TestUtil.createContact(acc.Id, false));
    lstContact.add(TestUtil.createContact(acc.Id, false));
    lstContact.add(TestUtil.createContact(acc.Id, false));
    lstContact.add(TestUtil.createContact(acc.Id, false));
    lstContact[0].Subscribe_Interested_In__c = 'Wine';
    lstContact[0].Subscribe_Status__c = 'Submitted';
    lstContact[1].Subscribe_Status__c = 'Submitted';
    lstContact[2].Subscribe_Status__c = 'Submitted';
    lstContact[3].Subscribe_Status__c = 'Submitted';
    insert lstContact;
    
    List<Approval.ProcessSubmitRequest> lstApp = new List<Approval.ProcessSubmitRequest>();
    for(Integer index = 0; index < 4; index++){
    	Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
   		app.setObjectId(lstContact[index].id);
   		lstApp.add(app);
    }
   	List<Approval.ProcessResult> result = Approval.process(lstApp);
    
    Apexpages.Standardcontroller ctrl = new Apexpages.Standardcontroller(lstContact[0]);
    ReviewDistributorContactsController controller = new ReviewDistributorContactsController(ctrl);
    
    Apexpages.Standardsetcontroller setCtrl = new Apexpages.Standardsetcontroller(lstContact);
    ReviewDistributorContactsController setController = new ReviewDistributorContactsController(setCtrl);
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