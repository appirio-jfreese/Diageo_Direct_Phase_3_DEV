@IsTest(SeeAllData=true)
public class POS_APIUpdateCartItems_Test{

    static testmethod void testUpdateCartItem () {
        
        //Get the current time
        Datetime now = System.now();
        
        Profile p = [select id from profile where name='POS - API User Agency'];
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id,
                          timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
                          Available_Themes__c='Spirits'
                         );
        RecordType posAgencyRecordType = [select Id from RecordType where Name='POS Production Agency' and sObjectType='Account'];

        System.runAs(u) {
            POSAPIConfiguration__c settings = POSAPIConfiguration__c.getOrgDefaults();
            
            Order_Window__c window = POS_TestDataUtil.createOrderWindow();
            window.Status__c='Open';
            window.Magento_Id__c = '12345';
            update window;
            
            Program__c program = POS_TestDataUtil.createProgram();
            Account account = POS_TestDataUtil.createAccount();
            account.RecordTypeId = posAgencyRecordType.Id;
            update account;
            
            Item__c item = POS_TestDataUtil.createItem(program);
            Cart__c cart = POS_TestDataUtil.createCart(u, window);
            Cart_Item__c cartItem = POS_TestDataUtil.populateCartItem(item, cart);
            insert cartItem;
            
            //Flag item as shipped so there's a change
            cartItem.Status__c = 'Shipped';
            cartItem.Carrier__c = 'Fedex';
            cartItem.Tracking_Code__c = 'TESTING123';
            
            List<Cart_Item__c> cartItems = new List<Cart_Item__c>();
            cartItems.add(cartItem);
            
            
            POS_APIUpdateCartItems.doPost(cartItems);
            
            Id cartItemId=cartItem.Id;
            
            //Now load the item and see if it changed
            Cart_Item__c loaded = [select Id, Status__C from Cart_Item__c where Id=:cartItemId];
            System.assert(loaded.Status__c == 'Shipped');
            
        }
    }

}