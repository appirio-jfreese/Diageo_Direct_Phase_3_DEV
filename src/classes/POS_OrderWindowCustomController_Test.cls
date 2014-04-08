@IsTest(SeeAllData=false)
public class POS_OrderWindowCustomController_Test{
    
    public static testMethod void testManageOrderWindowCustomer () {
        User u =createCMAdminUser();
        List<Order_Window_Customer__c> owcList;
        List<POS_OrderWindowCustomerController.CustomerWrapper> cwList = new List<POS_OrderWindowCustomerController.CustomerWrapper>();
        
        System.runAs(u) {
            Order_Window__c ow = createOrderWindow();
            User usr0 = createStdUser();
            
            Order_Window_Customer__c owc11 = new Order_Window_Customer__c(Order_Window__c = ow.Id, Customer__c=usr0.id);
            insert owc11;
            
            owcList = [select id from Order_Window_Customer__c where Order_Window__c=:ow.Id];
            System.debug(' owcList - ' + owcList);
            system.assertEquals(1, owcList.size());
            
            ApexPages.currentPage().getParameters().put('owId', ow.Id+'');
            POS_OrderWindowCustomerController ctr = new POS_OrderWindowCustomerController(new ApexPages.StandardController(ow));
            
            Profile p = [select id from profile where name='Standard User' limit 1]; 
            User usr1 = new User(alias = 'posmmtst1', email='posmmunittest1@diageo.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = p.Id,
                                 timezonesidkey='America/Chicago', username='posmmunittest1@diageo.com');
            User usr2 = new User(alias = 'posmmtst2', email='posmmunittest2@diageo.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = p.Id,
                                 timezonesidkey='America/Chicago', username='posmmunittest2@diageo.com');
            
            /* add a new cw */
            POS_OrderWindowCustomerController.CustomerWrapper cw0 = new POS_OrderWindowCustomerController.CustomerWrapper(usr0); // retain the existing user as checked
            cw0.checked = true;
            
            POS_OrderWindowCustomerController.CustomerWrapper cw1 = new POS_OrderWindowCustomerController.CustomerWrapper(usr1);
            cw1.checked = true;
            
            POS_OrderWindowCustomerController.CustomerWrapper cw2 = new POS_OrderWindowCustomerController.CustomerWrapper(usr2); // not checked
            cw2.checked = false;
            
            cwList.add(cw0);    cwList.add(cw1);    cwList.add(cw2);
            ctr.availableCustomers = cwList;
            ctr.saveOWCAssignments();
            
            owcList = [select id from Order_Window_Customer__c where Order_Window__c=:ow.Id];
            system.assertEquals(2, owcList.size());     // Original cw0 + new cw1 but not cw2   
            
            /* search user by name */
            ctr.name = 'pos';
            ctr.searchUsers();
            system.assert(ctr.availableCustomers.size() > 0);
            
            ctr.accountName = 'MM';
            ctr.selectedProfile = 'Diageo';
            ctr.searchUsers();
            ctr.getItems();
            ctr.back();
            
            /* delete a existing cw and adding new one */
            ApexPages.currentPage().getParameters().put('owId', ow.Id+'');
            POS_OrderWindowCustomerController ctr1 = new POS_OrderWindowCustomerController(new ApexPages.StandardController(ow));           
            cw0.checked = false;
            cw2.checked = true;
            cwList = new List<POS_OrderWindowCustomerController.CustomerWrapper>();
            cwList.add(cw0);    cwList.add(cw1);    cwList.add(cw2);
            ctr1.availableCustomers = cwList;
            ctr1.saveOWCAssignments();
            
            owcList = [select id from Order_Window_Customer__c where Order_Window__c=:ow.Id];
            System.debug(' owcList - ' + owcList);
            system.assertEquals(1, owcList.size());  
            
            /* test on a OW in New status */
            Order_Window__c owNew = createOrderWindow();
            owNew.status__c = 'New';
            owNew.Magento_Id__c = '12345';
            update owNew;
            
            ApexPages.currentPage().getParameters().put('owId', owNew.Id+'');
            POS_OrderWindowCustomerController ctrNew = new POS_OrderWindowCustomerController(new ApexPages.StandardController(owNew));
            
            cwList = new List<POS_OrderWindowCustomerController.CustomerWrapper>();           
            cwList.add(cw0);    cwList.add(cw1);    cwList.add(cw2);
            ctrNew.availableCustomers = cwList;
            ctrNew.saveOWCAssignments();
            
            system.assert(Apexpages.hasMessages());
            system.assertEquals(1, Apexpages.getMessages().size());
            system.assert(Apexpages.getMessages()[0].getDetail().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            
            Test.startTest();
            customEmailAuthorController testController = new customEmailAuthorController();
            testController.getTemplates();
            testController.toAddress = 'test@gmail.com;\n';
            testController.newEmailTemplate.Name = 'Temaplate Name';
            testController.createNewTemplate();
            testController.newEmailTemplate.DeveloperName = 'TemaplateName';
            testController.sendEmail();
            testController.selectTemplate();
            testController.createNewTemplate();
            testController.createNewTemplate();
            testController.cancelNewTemplate();
            Test.stopTest();
            
        }
    }
    
    public static User createCMAdminUser() {
        Profile p = [select id from profile where name='POS - CM Administrator' limit 1]; 
        User testUser = new User(alias = 'cmadmin', email='cmadminuser@modelmetrics.pos.com', 
                                 emailencodingkey='UTF-8', lastname='Admin', languagelocalekey='en_US', 
                                 localesidkey='en_US', profileid = p.Id, firstname='CM',
                                 timezonesidkey='America/Los_Angeles', username='cmadminuser41231@modelmetrics.pos.com',
            					 Available_Themes__c='Spirits');
        insert testUser; 
        return testUser;     
    }  
    public static Order_Window__c createOrderWindow(){
        Order_Window__c o = new Order_Window__c(Name = 'Test OW', Type__c='Monthly', Status__c='Open');
        o.Fiscal_Year__c = '2012';
        DateTime now = System.now();
        Date nowDate = date.newinstance(now.year(), now.month(), now.day());
        Date later = nowDate.addDays(90);
        Date muchLater = later.addDays(90);
        o.Order_Close_Date__c=later;
        o.Order_Delivery_Date__c=muchLater;
        o.Order_Start_Date__c=nowDate;
        o.Magento_Id__c = '12345'+System.now();
        insert o; 
        return o;                        
    } 
    public static User createStdUser() {
        Profile p = [select id from profile where name='Standard User' limit 1]; 
        User testUser = new User(alias = 'standt', email='standarduser@modelmetrics.pos.com', 
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US', profileid = p.Id, firstname='phil',
                                 timezonesidkey='America/Los_Angeles', username='standarduser231242@modelmetrics.pos.com',
                                 Available_Themes__c='Spirits');
        insert testUser; 
        return testUser;     
    } 
    
}