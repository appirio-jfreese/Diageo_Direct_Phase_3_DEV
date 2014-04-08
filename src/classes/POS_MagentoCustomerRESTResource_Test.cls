@isTest(SeeAllData=true) // required as the End-Point required for getting Magento session is stored as Custom Setting
public class POS_MagentoCustomerRESTResource_Test{

    static testmethod void testDoGet() {
        
        // setup test data
        User u = POS_TestDataUtil.createStdUser();
        u.Magento_Id__c = '212';
        update u;
        
        Account a =  POS_TestDataUtil.createAccount();
        Account_Member__c am = POS_TestDataUtil.createAccountMember(a, u);
        Brand__c b = POS_TestDataUtil.createBrand();
        b.Magento_Id__c = '213';
        update b;
        AccountBrand__c ab = POS_TestDataUtil.createAccountBrand(a, b);
        System.debug('DBG2 static void testDoGet() { -' + u.id);
        
        Order_Window__c o = POS_TestDataUtil.createOrderWindow();
        Program__c p = POS_TestDataUtil.createProgram(b.id, o.id);
        Item__c i = POS_TestDataUtil.createStandardItem(p);
        Item_Brand__c ib = POS_TestDataUtil.createItemBrand(i.id, b.id);
        ib.primary__c=TRUE;
        update ib;
        i.status__c='Approved w/Est Price';
        update i;

        System.debug('DBG1 Test Data Summary: User ID = ' + u.id + ', User Magento_id__c = ' + u.Magento_Id__c +
                     ', Account ID = ' + a.id + ', AccountMember ID = ' + am.id +
                     ', AccountMember Account__c = ' + am.account__c + ', AccountMember User__c = ' + am.user__c +
                     ', Brand ID  =  ' + b.id + ', Brand Magento_id__c = ' + b.Magento_Id__c + ', AccountBrand ID  =  ' + ab.id + 
                     ', AccountBrand Account__c = ' + ab.account__c + ', AccountBrand Brand__c = ' + ab.Brand__c +
                     ', Order_Window ID = ' + o.id + ', Program ID = ' + p.id + ', Item ID = ' + i.id +
                     ', Item Status__c = ' + i.status__c + ', Item_Brand ID = ' + ib.id + ', Item_Brand Item__c = ' + ib.item__c + 
                     ', Item_Brand brand__c = ' + ib.brand__c + ', Item_Brand Primary__c = ' + ib.primary__c);
  
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('sfdcid', u.id);
        req.addParameter('magentoid', u.Magento_Id__c);
    
        req.requestURI =  POS_Magento_Configuration__c.getOrgDefaults().Salesforce_apexrest_uri__c +'getmagentocustomer';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
    
        POS_MagentoCustomerRESTResource.MagentoUserAccess result = POS_MagentoCustomerRESTResource.doGet();
        System.debug('DBG1 results.size() -' + result);
        System.debug('DBG1 results.size() -' + result.user_brands.size());
        
        System.assertEquals(1, result.user_brands.size());
 
   }
  

}