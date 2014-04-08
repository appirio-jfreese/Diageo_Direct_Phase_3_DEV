@IsTest(seeAllData=false)
public class POS_BatchNotifyOverageCascade_Test{

    static testmethod void testUpsertItem () {
        Brand__c brand1 = POS_TestDataUtil.createBrand();
        Brand__c brd = new Brand__c(Name = 'Test Brand', Classification__c='Spirits', Diageo_Direct_Visible__c=true, Brand_Type__c='Individual Variant');
        insert brd;
        Brand__c brand = new Brand__c(Name = 'Test Brand', Classification__c='Spirits', Diageo_Direct_Visible__c=true, Brand_Type__c='Individual Variant',Parent_Brand__c = brd.Id);
        insert brand;
        brand.Classification__c='Spirits';
        update brand;
        
        Brand__c brdProtfolio = new Brand__c(Name = 'Portfolio', Classification__c='Spirits', Diageo_Direct_Visible__c=true, Brand_Type__c='Individual Variant');
        insert brdProtfolio;
        
        Profile p = [select id from profile where name='Diageo Employee'];
        
        //Create Agency
        Account agency = POS_TestDataUtil.createProductionAgency();
        
        //Create Distributor Account
        Account dist = POS_TestDataUtil.createDistributorAccount(); 
        
        Order_Window__c ow = POS_TestDataUtil.createOrderWindow();
        
        Program__c program = POS_TestDataUtil.createProgram(brand.Id, ow.Id);
        Item__c item = POS_TestDataUtil.populateItem(program, agency);
        item.RecordTypeId = [select Id, Name, DeveloperName from RecordType where DeveloperName='Standard' limit 1].id;
        insert item;      	
        
        // Associate Brand with Item
        Item_Brand__c ib = new Item_Brand__c(Brand__c = brand.Id, Item__c=item.id);
        insert ib;    	
        
        AccountBrand__c ab = POS_TestDataUtil.createAccountBrand(dist, brand);
        
        
        User budgeter = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = p.Id,
                                 timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
                                 Available_Themes__c='Spirits');
        insert budgeter;
        
        Order_Window_Customer__c cust1 = new Order_Window_Customer__c();
        cust1.Order_Window__c = ow.Id;
        cust1.Customer__c=budgeter.Id;
        cust1.Open_For_Shopping__c=true;
        insert cust1; 		
        
        User shopper = new User(alias = 'posmmtt2', email='posmmunittest2@diageo.com',
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id,
                                timezonesidkey='America/Chicago', username='posmmunittest2@diageo.com',
                                Available_Themes__c='Spirits');
        insert shopper;
        
        Order_Window_Customer__c cust2 = new Order_Window_Customer__c();
        cust2.Order_Window__c = ow.Id;
        cust2.Customer__c=shopper.Id;
        cust2.Open_For_Shopping__c=true;
        insert cust2;
        
        POS_TestDataUtil.createAccountMember(dist, budgeter);
        POS_TestDataUtil.createAccountMember(dist, shopper);
        
        
        //System.debug('BRANDS: '+Service_API.getAccBrandIdsForUser(shopper.Id));
        
        Budget__c parentBudget = new Budget__c();
        parentBudget.Budget_Creator__c=budgeter.Id;
        parentBudget.Budgeter__c=budgeter.Id;
        parentBudget.Brand__c=brand.Id;
        parentBudget.Amount__c=100;
        parentBudget.Spent_Amount__c=10000;
        parentBudget.My_Spent_Amount__c=5000;
        parentBudget.Shopper__c=shopper.Id;
        //budget.Order_Window__r=ow;
        parentBudget.Order_Window__c = ow.Id;
        insert parentBudget;
        
        Budget__c budget = new Budget__c();
        budget.Budget_Creator__c=budgeter.Id;
        budget.Budgeter__c=budgeter.Id;
        budget.Brand__c=brand.Id;
        budget.Amount__c=100;
        budget.Spent_Amount__c=10000;
        budget.My_Spent_Amount__c=5000;
        budget.Shopper__c=shopper.Id;
        //budget.Order_Window__r=ow;
        budget.Order_Window__c = ow.Id;
        budget.Parent__c = parentBudget.Id;
        insert budget;

        List<Budget__c> overBudgets=new List<Budget__c>();
        overBudgets.add(budget);
        
        POS_BatchNotifyOverageCascade cascade = new POS_BatchNotifyOverageCascade(overBudgets);
        Test.startTest();
        database.executeBatch(cascade);
        Test.stopTest();

    }
}