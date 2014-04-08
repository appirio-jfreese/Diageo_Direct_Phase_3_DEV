@isTest(SeeAllData=true)
public class POS_MagentoCartRESTResource_Test{
    private static RestRequest req;
    private static RestResponse res;
    
    static testmethod void testDoGet() {
        
        // setup test data
        User u = createStdUser();
        u.Magento_Id__c = '12345';
        update u;
        
        //Create Agency
        Account agency = POS_TestDataUtil.createProductionAgency();
        
        //Create Distributor Account
        Account dist = POS_TestDataUtil.createDistributorAccount();         
        
        Program__c program = POS_TestDataUtil.createProgram();
        Item__c item = POS_TestDataUtil.populateItem(program, agency);
        item.RecordTypeId = [select Id, Name, DeveloperName from RecordType where DeveloperName='Customizable' limit 1].id;
        insert item;
        
        Item_Customization__c iCust = new Item_Customization__c(Name='Personalization Label 1', Custom_Attribute_Length__c=120, Item__c=item.Id, Magento_Id__c='60');
        insert iCust;
        
        Order_Window__c ow = POS_TestDataUtil.createOrderWindow();
        Cart__c crt = POS_TestDataUtil.createCart(u, ow);
        crt.Magento_ID__c='12345';
        crt.Status__c = 'Open';
        update crt;
        
        Order_Window_Customer__c cust = new Order_Window_Customer__c();
        cust.Order_Window__c = ow.Id;
        cust.Customer__c=u.Id;
        cust.Magento_Id__c='12345';
        insert cust;
        
        
        Cart_Item__c ci0 = POS_TestDataUtil.populateCartItem(item, crt);
        insert ci0;
        delete ci0;
        
        Cart_Item__c ci = POS_TestDataUtil.populateCartItem(item, crt);
        insert ci;
        
        req = new RestRequest();
        res = new RestResponse();
        
        req.addParameter('sfdcid', u.id);
        req.addParameter('magentoid', u.Magento_Id__c);
        req.addParameter('cart_id','12345');
        
        req.requestURI =  POS_Magento_Configuration__c.getOrgDefaults().Salesforce_apexrest_uri__c +'syncmagentocart';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        String result = POS_MagentoCartRESTResource.doGet();
        System.debug('results -' + result);
    }
    
    static testmethod void testBudgetValidation() {
        User u = createStdUser();
        u.Magento_Id__c = '12345';
        update u;     
        
        //Create Agency
        Account agency = POS_TestDataUtil.createProductionAgency();
        
        //Create Distributor Account
        Account dist = POS_TestDataUtil.createDistributorAccount();   
        
        Order_Window__c ow = POS_TestDataUtil.createOrderWindow();        
        Brand__c brand = POS_TestDataUtil.createBrand();
        //Brand__c brand = new Brand__c(Name = 'Test Brand', Classification__c='Spirits', diageo_direct_visible__c=true, Brand_Type__c='Individual Variant');
        //insert brand;      
        
        Program__c program = POS_TestDataUtil.createProgram(brand.Id, ow.Id);
        Item__c item = POS_TestDataUtil.populateItem(program, agency);
        item.RecordTypeId = [select Id, Name, DeveloperName from RecordType where DeveloperName='Customizable' limit 1].id;
        insert item;    
        
        Item_Customization__c iCust = new Item_Customization__c(Name='Personalization Label 1', Custom_Attribute_Length__c=120, Item__c=item.Id, Magento_Id__c='60');
        insert iCust;            
        
        Cart__c crt = POS_TestDataUtil.createCart(u, ow);
        crt.Magento_ID__c='12345'; 
        crt.Status__c = 'Open';
        update crt;
        
        Order_Window_Customer__c cust = new Order_Window_Customer__c();
        cust.Order_Window__c = ow.Id;
        cust.Customer__c=u.Id;
        cust.Magento_Id__c='12345';
        insert cust;   
        
        Ship_To__c shipTo = new Ship_To__c();
        shipTo.Account__c = dist.Id;
        shipTo.Name='Test Ship To';
        insert shipTo;
        
        User_Ship_To__c uShipTo = new User_Ship_To__c(Ship_To__c=shipTo.id, User__c=u.id, Magento_Ship_To_ID__c='12345');
        insert uShipTo;             
        
        Cart_Item__c ci = POS_TestDataUtil.populateCartItem(item, crt);
        insert ci;
        
        String xmlString = '<?xml version="1.0" encoding="UTF-8"?><Mage_Api_Model_Server_Handler generator="zend" version="1.0"><call><cartItems><key_0><product_id>460</product_id><sku>' + ci.Item__c + '</sku><quote_id>160</quote_id><qty>10000</qty><shipto_id>' + shipto.id +'</shipto_id><customer_id>12345</customer_id><cart_id>12345</cart_id><order_window_id>12345</order_window_id><options><key_0><code>option_60</code><value>John Doe</value></key_0></options></key_0></cartItems><status>success</status></call></Mage_Api_Model_Server_Handler>';
        Dom.Document doc = new Dom.Document();
        
        Test.startTest();
        doc.load(xmlString);    
        List<POS_MagentoCartRESTResource.CartItemWrapper> cartItems = POS_MagentoCartRESTResource.parseResponseXML(doc);
        POS_MagentoCartRESTResource.saveCartItems(cartItems);
        Test.stopTest();
        
        System.assertEquals(1, cartItems.size());
        
        POS_MagentoCartRESTResource.validateBudget(cartItems); //Validate without budget
        
        // Associate Brand with Item
        Item_Brand__c ib = new Item_Brand__c(Brand__c = brand.Id, Item__c=item.id);
        insert ib;
        
        //Associate a brand with the account so we can budget on that brand
        AccountBrand__c ab = new AccountBrand__c();
        ab.Account__c = dist.Id;
        ab.Brand__c = program.Brand__c;
        insert ab; 
        
        Account_Member__c member = new Account_Member__c();
        member.Account__c = dist.Id;
        member.User__c = u.Id;
        insert member;
        
        //Create a budget and try again
        Budget__c budget = new Budget__c();
        budget.Shopper__c = u.Id;
        //budget.Brand__c = program.Brand__c;
        System.debug('budget.Brand__c' + budget.Brand__c);
        budget.Amount__c = 1;
        budget.Order_Window__c = ow.Id;
        insert budget;
        
        POS_MagentoCartRESTResource.validateBudget(cartItems); //Validate with budget          
        
    }
    
    static testmethod void testBadAddressData () {
        User u = createStdUser();
        u.Magento_Id__c = '12345';
        update u;     
        
        //Create Agency
        Account agency = POS_TestDataUtil.createProductionAgency();
        
        //Create Distributor Account
        Account dist = POS_TestDataUtil.createDistributorAccount();   
        
        Order_Window__c ow = POS_TestDataUtil.createOrderWindow();        
        Brand__c brand = POS_TestDataUtil.createBrand();
        //Brand__c brand = new Brand__c(Name = 'Test Brand', Classification__c='Spirits', diageo_direct_visible__c=true, Brand_Type__c='Individual Variant');
        //insert brand;      
        
        Program__c program = POS_TestDataUtil.createProgram(brand.Id, ow.Id);
        Item__c item = POS_TestDataUtil.populateItem(program, agency);
        item.RecordTypeId = [select Id, Name, DeveloperName from RecordType where DeveloperName='Customizable' limit 1].id;
        insert item;    
        
        Item_Customization__c iCust = new Item_Customization__c(Name='Personalization Label 1', Custom_Attribute_Length__c=120, Item__c=item.Id, Magento_Id__c='60');
        insert iCust;            
        
        Cart__c crt = POS_TestDataUtil.createCart(u, ow);
        crt.Magento_ID__c='12345'; 
        crt.Status__c = 'Open';
        update crt;
        
        Order_Window_Customer__c cust = new Order_Window_Customer__c();
        cust.Order_Window__c = ow.Id;
        cust.Customer__c=u.Id;
        cust.Magento_Id__c='12345';
        insert cust;   
        
        Ship_To__c shipTo = new Ship_To__c();
        shipTo.Account__c = dist.Id;
        shipTo.Name='Test Ship To';
        insert shipTo;  
        
        User_Ship_To__c uShipTo = new User_Ship_To__c(Ship_To__c=shipTo.id, User__c=u.id, Magento_Ship_To_ID__c='12345');
        insert uShipTo;             
        
        Cart_Item__c ci = POS_TestDataUtil.populateCartItem(item, crt);
        insert ci;
        
        String xmlString = '<?xml version="1.0" encoding="UTF-8"?><Mage_Api_Model_Server_Handler generator="zend" version="1.0"><call><cartItems><key_0><product_id>460</product_id><sku>' + ci.Item__c + '</sku><quote_id>160</quote_id><qty>10000</qty><address_id>1</address_id><customer_id>12345</customer_id><cart_id>12345</cart_id><order_window_id>12345</order_window_id><options><key_0><code>option_60</code><value>John Doe</value></key_0></options></key_0></cartItems><status>success</status></call></Mage_Api_Model_Server_Handler>';
        Dom.Document doc = new Dom.Document();
        
        
        Test.startTest();
        try {
            doc.load(xmlString);    
            List<POS_MagentoCartRESTResource.CartItemWrapper> cartItems = POS_MagentoCartRESTResource.parseResponseXML(doc);
            POS_MagentoCartRESTResource.saveCartItems(cartItems);
            System.assert(false); //We shouldn't get here because it should have errored out
        }
        catch (Exception e) {
            //This is expected because we have a quantity.  Now try the same thing without
            xmlString = '<?xml version="1.0" encoding="UTF-8"?><Mage_Api_Model_Server_Handler generator="zend" version="1.0"><call><cartItems><key_0><product_id>460</product_id><sku>' + ci.Item__c + '</sku><quote_id>160</quote_id><qty>0</qty><address_id>1</address_id><customer_id>12345</customer_id><cart_id>12345</cart_id><order_window_id>12345</order_window_id><options><key_0><code>option_60</code><value>John Doe</value></key_0></options></key_0></cartItems><status>success</status></call></Mage_Api_Model_Server_Handler>';
            doc = new Dom.Document();
            doc.load(xmlString);
            List<POS_MagentoCartRESTResource.CartItemWrapper> cartItems = POS_MagentoCartRESTResource.parseResponseXML(doc);
            POS_MagentoCartRESTResource.saveCartItems(cartItems);
            //If we get here without failure then it's working properly
        }
        Test.stopTest();
    }
    // For case 00003802
    private static User createStdUser(){
        Profile p = [select id from profile where name='Standard User' limit 1]; 
        User testUser = new User(alias = 'standt', email='standarduser@modelmetrics.pos.com', 
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US', profileid = p.Id, firstname='phil',
                                 timezonesidkey='America/Los_Angeles', 
                                 username='standarduser'+system.now().getTime()+'@modelmetrics.pos.com',
                                 Available_Themes__c='Spirits');
        insert testUser;
        return testUser ;
    }    

}