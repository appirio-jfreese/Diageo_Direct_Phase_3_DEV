@IsTest(SeeAllData=false)
public class POS_APIListCarts_Test{

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
            
            
            //Now test the query
            POS_APIListCarts.APICartResponse response = POS_APIListCarts.doPost(ow.Id);
            System.assert(response.carts.size()==1);
            
            
            //Make sure a bad window id gets no results
            Order_Window__c ow2 = POS_TestDataUtil.createOrderWindow();
            response = POS_APIListCarts.doPost(ow2.Id);
            System.assert(response.carts.size()==0);
        }

    } 
}