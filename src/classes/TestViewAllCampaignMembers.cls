/*******************************************************************************
    (c) 2013 Appirio, Inc.
Created By  : Vikash Goyal    (Appirio JDC) 
Story/Task  : US765/TA1462
Description : Class contains the utility methods

Upadted By  : Basant Verma    (Appirio JDC) 
Story/Task  : NA
Description : TO Improve test coverage
*******************************************************************************/
@isTest
private class TestViewAllCampaignMembers {
	static testMethod void unitTest() {
		//Create test data
		Campaign cmp = new Campaign(name='test campaign');
		insert cmp;
		Contact cont = new Contact (firstname='first',
    	                            lastname='last',
    	                            email='email@email.com',
    	                            phone='1234567890');
		insert cont;
		CampaignMember cm = new CampaignMember (CampaignId=cmp.Id,
    	                                        ContactId=cont.Id);    	
		insert cm;                                        
		PageReference pageRef = Page.ViewAllCampaignMembers;
		Test.setCurrentPageReference(pageRef);
		ViewAllCampaignMembers con = new ViewAllCampaignMembers (new ApexPages.Standardcontroller (cmp));
		System.assert(con.campMembers.size() == 1);
		
		// Start - Code Added to improve code coverage - Basant - 11/21/13
		Apexpages.currentPage().getParameters().put('method','CreateMember');
		con = new ViewAllCampaignMembers (new ApexPages.Standardcontroller (cmp));
		System.assert(con.campMembers.size() == 1);
		con.lead.FirstName = 'FName';
		con.lead.LastName = 'LName';
		con.lead.Email = 'test@test.com';
		// This try will fail due to required field and will add error
		con.createCampaignMember();
		System.assert(Apexpages.getMessages().size() > 0);
		
		// This time it will success
		con.lead.Company = 'Test Company';
		con.createCampaignMember();
		System.assert(con.campMembers.size() == 2);
		// End - Code Added to improve code coverage - Basant - 11/21/13
	}
}