@IsTest(SeeAllData=false)
public class POS_APIGetCartItems_Test{


    static testmethod void testGetCartItems () {
        
        //Get the current time
        Datetime now = System.now();
        
        Profile p = [select id from profile where name='System Administrator'];
        
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id,
                          timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
                          Available_Themes__c='Spirits');
        
        System.runAs(u) {
            
            POS_TestDataUtil.initializeTestData();
            
            //Create Agency
            Account agency = POS_TestDataUtil.createProductionAgency();
            
            Program__c program = POS_TestDataUtil.createProgram();
            Item__c item = POS_TestDataUtil.populateItem(program, agency);
            insert item;
            
            Order_Window__c ow = POS_TestDataUtil.createOrderWindow();
            Cart__c crt = POS_TestDataUtil.createCart(u, ow);
            
            Cart_Item__c ci = POS_TestDataUtil.populateCartItem(item, crt);
            insert ci;
            
            //APICartResponse response1 = POS_APIGetCartItems.doPost(null, null);
            //System.assertEquals(null, response1);
            
            POS_APIGetCartItems.APICartResponse response = POS_APIGetCartItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''), null, null);
            
            //Should only see the one record
            System.assert(response.carts.size()==1);
            System.assert(response.lastRowIndex==1);
            System.assert(response.moreResults==false);
            
            // add another cart Item
            Cart_Item__c ci2 = POS_TestDataUtil.populateCartItem(item, crt);
            insert ci2;	 
            
            response = POS_APIGetCartItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''), null, null);
            
            //Should see 2 CartItem records under the same Cart
            System.assert(response.carts[0].Carts__r.size()==2);
            System.assertEquals(1, response.lastRowIndex);
            System.assert(response.moreResults==false);	    	   	
            
            //Update the time and try again so that record doesn't appear
            now=now.addDays(1);
            response = POS_APIGetCartItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),0, null);
            System.assert(response.carts.size()==0);
            System.assert(response.lastRowIndex==0);
            System.assert(response.moreResults==false);
            
            //Now test queries for offset filter, set the offset so we get one again
            response = POS_APIGetCartItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),1, null);
            System.assert(response.carts.size()==0);
            System.assert(response.lastRowIndex==1);
            System.assert(response.moreResults==false);
            
            //Now create enough items to hit row limit and make sure that the pagination works
            Cart__c crt2 = POS_TestDataUtil.createCart(u, ow);
            
            List<Cart_Item__c> testCItems = new List<Cart_Item__c>();
            integer citemCount=0;
            integer ROW_LIMIT=25;
            while (true) {
                if (citemCount==ROW_LIMIT) {
                    break;
                }
                citemCount++;
                
                Cart_Item__c citem = POS_TestDataUtil.populateCartItem(item, crt2);
                
                testCItems.add(citem);
            }
            
            
            insert testCItems;
            
            now = System.now();
            response = POS_APIGetCartItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''), 0, null);
            System.assertEquals(ROW_LIMIT, response.carts[1].Carts__r.size());
            System.assert(response.lastRowIndex==2);
            System.assert(response.moreResults==false);
            
            //Now test for the order window
            response = POS_APIGetCartItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''), 0, ow.Id);
            System.assertEquals(ROW_LIMIT, response.carts[1].Carts__r.size());
            System.assert(response.lastRowIndex==2);
            System.assert(response.moreResults==false);
            
            //Make sure a bad window id gets no results
            Order_Window__c ow2 = POS_TestDataUtil.createOrderWindow();
            response = POS_APIGetCartItems.doPost(now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''), 0, ow2.Id);
            System.assert(response.carts.size()==0);
        }
    } 	
}