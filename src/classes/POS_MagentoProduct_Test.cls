@IsTest(SeeAllData=true)
public class POS_MagentoProduct_Test{
    
    static testmethod void testMagentoProductSync() {
        Profile p = [select id from profile where name='POS - API User Agency'];
         
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
        Available_Themes__c='Spirits');
        
        System.runAs(u) {       
            // test working of POS_Product_Brand Magento Sync part
            Test.startTest();
            Program__c pg = POS_TestDataUtil.createProgram();
            Id brandId = pg.Brand__c;
            
            Item__c o = POS_TestDataUtil.createItem(pg);
            
            // no need to create Item Brand as it's created bu the trigger on Item creation
            /*Item_Brand__c ib = new Item_Brand__c(Item__c=o.id, Brand__c=brandId);
            insert ib;
            ib.Primary__c=true;
            update ib;
            delete ib;*/
            o.Current_Price__c=18.99;        
            o.Estimated_Price__c=18.99;
            update o;
            Test.stopTest();
            
            // placing Assert check after Test.stopTest() as triggers here have @future callouts run asynchronously
            Dom.Document resp = POS_MagentoProduct.getMagentoProductInfo(o.Id);
            String status = POS_MagentoIntegrationUtil.getMagentoResponseElement(resp, 'status');
            system.assertEquals( 'success', status );
            
            // following status change and delete both should cause budget total re-calculation batch to execute
            Order_Window__c ow = POS_TestDataUtil.createOrderWindow();
            Cart__c crt = POS_TestDataUtil.createCart(u, ow);           
            Cart_Item__c ci = POS_TestDataUtil.populateCartItem(o, crt);
            insert ci;          
            o.Status__c = 'Cancelled';
            update o;
            
            delete o;
        }
    }       
    
    static testmethod void testItemBrandAssociation() {
        Profile p = [select id from profile where name='POS - API User Agency'];
         
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
        Available_Themes__c='Spirits');
        
        System.runAs(u) {       
            // test working of POS_Product_Brand ItemBrand creation part
            Program__c pg1 = POS_TestDataUtil.createProgram();
            Id brandId1 = pg1.Brand__c;
            
            
            Item__c i1 = POS_TestDataUtil.createItem(pg1);
            Item_Brand__c ib1 = [Select id, Brand__c from Item_Brand__c where Item__c = :i1.id][0];
            system.assertEquals( brandId1, ib1.Brand__c );
            
            Test.startTest();
            Program__c pg2 = POS_TestDataUtil.createProgram();
            Id brandId2 = pg2.Brand__c;
            i1.Program__c = pg2.id;
            update i1;
            
            Item_Brand__c ib2 = [Select id, Brand__c from Item_Brand__c where Item__c = :i1.id][0];
            system.assertEquals( brandId2, ib2.Brand__c );  
            
            Test.stopTest(); 
        }       
    }
    
    static testmethod void testKitItemTriggerValidations() {
        
        Id kitRecTypeId = [select id from RecordType where DeveloperName = 'Kit'].id;
        Profile p = [select id from profile where name='POS - API User Agency'];
         
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
        Available_Themes__c='Spirits');
        
        System.runAs(u) {       
        
            // test working of POS_Product_Brand ItemBrand creation part
            Program__c pg1 = POS_TestDataUtil.createProgram();
            
            Item__c k1 = POS_TestDataUtil.createKit(pg1);
            
            
            Test.startTest();
            Item__c i1 = POS_TestDataUtil.createItem(pg1);
            
            
            Kit_Item__c ki1 = new Kit_Item__c(Kit__c=k1.id, Item__c=i1.id, Packout_Quantity__c=5);
            insert ki1;
            
            // 1: move the Kit status to Approved and make sure the validation stops the update as kit has only one Item
            k1.Status__c='Approved w/Est Price';
            
            try {
                update k1;
            } catch(System.DMLException e) {
                System.assert(e.getMessage().contains('Kit must contain at least two different items while in status Approved or Accepted'));
            } 
            
            Test.stopTest();
        }
    }

    static testmethod void testKitItemTriggerValidations2() {
        
        Id kitRecTypeId = [select id from RecordType where DeveloperName = 'Kit'].id;
        Profile p = [select id from profile where name='POS - API User Agency'];
         
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
        Available_Themes__c='Spirits');
        
        System.runAs(u) {       
        
            // test working of POS_Product_Brand ItemBrand creation part
            Program__c pg1 = POS_TestDataUtil.createProgram();
    
            Test.startTest();
            
            Item__c k1 = POS_TestDataUtil.createKit(pg1);
            
            Item__c i1 = POS_TestDataUtil.createItem(pg1);
            
            Kit_Item__c ki1 = new Kit_Item__c(Kit__c=k1.id, Item__c=i1.id, Packout_Quantity__c=5);
            insert ki1;
            
            // 2: add another Kit Item with the same Item reference to the Kit k1, trigger validation should stop this addition     
            Kit_Item__c ki2 = new Kit_Item__c(Kit__c=k1.id, Item__c=i1.id, Packout_Quantity__c=5);
            try {
                insert ki2;
            } catch(System.DMLException e) {
                System.assert(e.getMessage().contains('This kit-item already exists on the Kit. Cannot add duplicate.'));
            } 
            
        }
    }
    
    static testmethod void testKitItemTriggerValidations3() {
        
        Id kitRecTypeId = [select id from RecordType where DeveloperName = 'Kit'].id;
        Profile p = [select id from profile where name='POS - API User Agency'];
         
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
        Available_Themes__c='Spirits');
        
        System.runAs(u) {       
        
            // test working of POS_Product_Brand ItemBrand creation part
            Program__c pg1 = POS_TestDataUtil.createProgram();
    
            Test.startTest();
            
            Item__c k1 = POS_TestDataUtil.createKit(pg1);
            
            Item__c i1 = POS_TestDataUtil.createItem(pg1);
            
            Kit_Item__c ki1 = new Kit_Item__c(Kit__c=k1.id, Item__c=i1.id, Packout_Quantity__c=5);
            insert ki1;
            
            /*
            // 3: Add a separate Item to the Kit and then it should allow moving the Kit to Aprroved status
            Item__c i2 = POS_TestDataUtil.createItem(pg1);  
            Kit_Item__c ki2  = new Kit_Item__c(Kit__c=k1.id, Item__c=i2.id, Packout_Quantity__c=5);
            insert ki2;         
            update k1;
            
            system.assertEquals( 'Approved w/Est Price', k1.Status__c );  
            */  
            
            // 4: Delete a Kit Item from the already Approved Kit, trigger validation should stop it
            try {
                delete ki1;
            } catch(System.DMLException e) {
                System.assert(e.getMessage().contains('Kit must contain at least two different items while in status Approved or Accepted'));
            }    
            /*      
            
            // 5: Now add an additional item and see if we can delete it
            
            Item__c i3 = POS_TestDataUtil.createItem(pg1);  
            Kit_Item__c ki3 = new Kit_Item__c(Kit__c=k1.id, Item__c=i3.id, Packout_Quantity__c=5);
            insert ki3;         
            update k1;
            
            try {
                delete ki3;
            }
            catch (System.DMLException e) {
                System.assert(false); //Shouldn't get here
            }*/
            Test.stopTest();
        }
    }    
}