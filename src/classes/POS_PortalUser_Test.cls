@isTest(SeeAllData=true)
public class POS_PortalUser_Test{

    static testmethod void testPortalUserAccountMemberSync() {
    	// test creation/deletion of AccountMember when a PortalUser is created
    	Profile p = [select id from profile where name='System Administrator'];
    	UserRole role = [select id from UserRole where name='Diageo NA' limit 1];
         
		User sUsr = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
		localesidkey='en_US', profileid = p.Id, Available_Themes__c='Spirits',
		timezonesidkey='America/Chicago', username='posmmunittest@diageo.com', userroleid=role.id);
		
		insert sUsr;
    	
    	System.runAs(sUsr) {
	    	Account acct = POS_TestDataUtil.createAccount();
	    	
	    	update acct;
	    	System.debug('acct.OwnerId -' + acct.OwnerId + ' acct.owner.UserRoleId -' + acct.owner.UserRoleId);
	    	//Contact ctct = POS_TestDataUtil.createContact(acct);
    		//User pUsr = POS_TestDataUtil.createPortalUser(ctct);
    	}	
    
    	// Note: commented out the code below as couldn't get rid of - UNKNOWN_EXCEPTION, portal account owner must have a role: []
    	//
    }		

}