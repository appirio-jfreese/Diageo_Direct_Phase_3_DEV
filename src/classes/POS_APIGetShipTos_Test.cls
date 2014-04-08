@IsTest(SeeAllData=false)
public class POS_APIGetShipTos_Test{

    static testmethod void testGetShipTos () {
    	
    	//Get the current time
    	Datetime now = System.now();
    	now=now.addMinutes(-1);
		POS_TestDataUtil.initializeTestData();
	
		//Create ShipTo
		Account act = POS_TestDataUtil.createAccount();
    	Ship_To__c st = POS_TestDataUtil.createShipTo(act);
    	
    	
	    POS_APIGetShipTos.APIShipToResponse response = POS_APIGetShipTos.doPost(now.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''), null);
	    	
    	//Should only see the one record
    	System.assert(response.shipTos.size()==1);
    	System.assert(response.lastRowIndex==1);
    	System.assert(response.moreResults==false);
	    	
	    Ship_To__c st2 = POS_TestDataUtil.createShipTo(act); 
	    response = POS_APIGetShipTos.doPost(now.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''), null);
	    	
    	//Should see 2 records
    	System.assert(response.shipTos.size()==2);
    	System.assertEquals(2, response.lastRowIndex);
    	System.assert(response.moreResults==false);	    	   	
	    	
    	//Update the time and try again so that record doesn't appear
    	now=now.addDays(1);
    	response = POS_APIGetShipTos.doPost(now.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),0);
    	System.assert(response.shipTos.size()==0);
    	System.assert(response.lastRowIndex==0);
    	System.assert(response.moreResults==false);
    	
    	//Now test queries for offset filter, set the offset so we get one again
    	now = System.now();
    	now=now.addMinutes(-1);
    	Account act2 = POS_TestDataUtil.createAccount();
    	st2 = POS_TestDataUtil.createShipTo(act2);
    	response = POS_APIGetShipTos.doPost(now.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),1);
    	System.assert(response.shipTos.size()==2);
    	System.assert(response.lastRowIndex==3);
    	System.assert(response.moreResults==false);
    	
	}     

}