@isTest
public class POS_MagentoCategory_Test{
    
    static testmethod void testMagentoCategorySyncOW() {
        POS_Magento_Configuration__c settings = Test_Helper.createPOSMagentoConfigSettings();
        
        // OrderWindow Sync Test
        Date cDate = Date.today();
        Order_Window__c ow = new Order_Window__c(name='categoryName',Status__c='New', Fiscal_Year__c='2012', 
                                Order_Start_Date__c=cDate, Order_Close_Date__c=cDate+1, Order_Delivery_Date__c=cDate+2);
        
        Test.startTest();
        insert ow;
        Test.stopTest();
        
        // placing Assert check after Test.stopTest() as triggers here have @future callouts run asynchronously
        
        Dom.Document resp = POS_MagentoCategory.getMagentoCategoryInfo(ow.Magento_Id__c);
        String status = POS_MagentoIntegrationUtil.getMagentoResponseElement(resp, 'status');
        system.assertEquals( 'success', status );
         
        ow.Status__c='New';
        ow.Magento_Id__c='50'; // set some dummy value to be able simulate delete from magento
        update ow;
        delete ow;
    }
    
    static testmethod void testMagentoCategorySyncBD() {    
        POS_Magento_Configuration__c settings = Test_Helper.createPOSMagentoConfigSettings();
        // Brand Sync Test
        Brand__c bd = new Brand__c(name='categoryName');
        
        Test.startTest();
        insert bd;
        Test.stopTest();
        
        // placing Assert check after Test.stopTest() as triggers here have @future callouts run asynchronously
        Dom.Document resp = POS_MagentoCategory.getMagentoCategoryInfo(bd.Magento_Id__c);
        String status = POS_MagentoIntegrationUtil.getMagentoResponseElement(resp, 'status');
        system.assertEquals( 'success', status );
         
        bd.Name='Baileys';
        update bd;
        bd.Magento_Id__c='50'; // set some dummy value to be able simulate delete from magento
        update bd;
        
        bd.Name='Baileys - SP';
        update bd;
        delete bd; 
        
        // test mass sync
        Brand__c bd1 = new Brand__c(name='categoryName1');
        Brand__c bd2 = new Brand__c(name='categoryName2');
        List<Brand__c> brandList = new List<Brand__c>();
        brandList.add(bd1); brandList.add(bd2);
        POS_MagentoCategory.massSyncMagentoCategoryBrand(brandList);
        
        
    }
    
    static testmethod void testMagentoCategorySyncPg() {        
        POS_Magento_Configuration__c settings = Test_Helper.createPOSMagentoConfigSettings();
        Date cDate = Date.today();
        Order_Window__c ow = new Order_Window__c(name='categoryName',Status__c='New', Fiscal_Year__c='2012', 
                                Order_Start_Date__c=cDate, Order_Close_Date__c=cDate+1, Order_Delivery_Date__c=cDate+2);
        Brand__c bd = new Brand__c(name='categoryName',diageo_direct_visible__c=true);
        insert ow; 
        insert bd;
        // Program Sync Test
        
        Program__c pg = new Program__c(name='categoryName', Order_Window__c=ow.id, Brand__c=bd.id, 
                            Sales_Driver__c='Sustainovation', Sales_Channel_Group__c='Execution Plan;Flow Visibility;Multicultural;VAP');
        
        Test.startTest();
        insert pg;
        Test.stopTest();
        
        // placing Assert check after Test.stopTest() as triggers here have @future callouts run asynchronously
        Dom.Document resp = POS_MagentoCategory.getMagentoCategoryInfo(pg.Magento_Id__c);
        String status = POS_MagentoIntegrationUtil.getMagentoResponseElement(resp, 'status');
        system.assertEquals( 'success', status );
         
        pg.Name='Cinco De Mayo';
        update pg;
        
        pg.Magento_Id__c='50'; // set some dummy value to be able simulate delete from magento
        update pg;
        
        Brand__c bdNew = new Brand__c(name='categoryNameNew',diageo_direct_visible__c=true);
        insert bdNew;
        pg.Brand__c = bdNew.Id;
        update pg;
        
        delete pg;          
    }
    
    static testmethod void testMagentoCategory() {        
        POS_Magento_Configuration__c settings = Test_Helper.createPOSMagentoConfigSettings();
        Date cDate = Date.today();
        Brand__c bd = new Brand__c(name='categoryName',diageo_direct_visible__c=true);
        insert bd;
        
        Order_Window__c ow = new Order_Window__c(name='categoryName',Status__c='New', Fiscal_Year__c='2012', 
                                Order_Start_Date__c=cDate, Order_Close_Date__c=cDate+1, Order_Delivery_Date__c=cDate+2);        
        insert ow; 
        
        // Program Sync Test
        
        Program__c pg = new Program__c(name='categoryName', Order_Window__c=ow.id, Brand__c=bd.id, 
                            Sales_Driver__c='Sustainovation', Sales_Channel_Group__c='Execution Plan;Flow Visibility;Multicultural;VAP');
        
        Test.startTest();
        insert pg;
        Test.stopTest();
        
        POS_MagentoCategory.createMagentoCategoryWindow(ow.id, ow.Name, '0');
        POS_MagentoCategory.createMagentoCategoryBrand(bd.id, bd.Parent_Brand__c, bd.Name, '1');
        POS_MagentoCategory.updateMagentoCategory(ow.Magento_Id__c, ow.Name, '0', ow.Id, 'Order_Window__c');
        POS_MagentoCategory.createMagentoCategoryProgram(pg.id, pg.Name, pg.Sales_Channel_Group__c, pg.Sales_Driver__c, '1');
        POS_MagentoCategory.updateMagentoCategoryProgram(pg.Magento_Id__c, pg.Name, pg.Sales_Channel_Group__c, pg.Sales_Driver__c, '1', pg.Id);
        POS_MagentoCategory.deleteMagentoCategory(ow.Magento_Id__c, 'Order_Window__c');
        
        // placing Assert check after Test.stopTest() as triggers here have @future callouts run asynchronously
        Dom.Document resp = POS_MagentoCategory.getMagentoCategoryInfo(pg.Magento_Id__c);
        String status = POS_MagentoIntegrationUtil.getMagentoResponseElement(resp, 'status');
        system.assertEquals( 'success', status );
                    
    }

}