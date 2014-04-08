/*******************************************************************************
    (c) 2013 Appirio, Inc.
Name				: Test_UpdateLeadOrContactEmails

Created By  : Basant Verma (Appirio JDC) 
Story/Task  : US1198
Description : Test Class for UpdateLeadOrContactEmails
*******************************************************************************/
@isTest(seeAllData = false)
public with sharing class Test_UpdateLeadOrContactEmails {
	public static testMethod void Test_UpdateLeadOrContactEmails(){
		Account a = TestUtil.createAccount(true);
		List<Contact> conList = new List<Contact>();
		for(Integer i=0; i<5; i++){
			Contact c = TestUtil.createContact(a.Id, false);
			c.Email = 'test'+i+'email@test.com';
			conList.add(c);
		}
		insert conList;
		for(Contact c : conList){
			System.assert(!String.valueOf(c.Email).endsWith('.sk2'));
		}
		String soql = 'Select Id, Email From Contact Where CreatedDate = TODAY';
		UpdateLeadOrContactEmails btch = new UpdateLeadOrContactEmails(soql);
		Database.executeBatch(btch);
	}
}