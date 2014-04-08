@IsTest(SeeAllData=false)
public class POS_OrderWindowViewController_Test{

    static testmethod void testOrderWindow () {
        Profile p = [select id from profile where name='System Administrator'];
         
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
        Available_Themes__c='Spirits');
        
        System.runAs(u) {
            Test.startTest();
            PageReference pageRef = Page.HomePage;
            Test.setCurrentPage(pageRef);
            
            Order_Window__c ow = POS_TestDataUtil.createOrderWindow();
            
            Order_Window_Customer__c owc = new Order_Window_Customer__c();
            owc.Customer__c = u.Id;
            owc.Order_Window__c = ow.Id;
            insert owc;
            
            POS_OrderWindowViewController controller = new POS_OrderWindowViewController();
            
            //Should have zero right now because window was in wrong state
            System.assert(controller.orderWindowCustomers.size()==0);
            
            ow.Status__c='Open';
            update ow;
            owc.Open_For_Shopping__c = true;
            update owc;
            
            
            controller = new POS_OrderWindowViewController();
            //Should have one right now because window is in open state
            System.assert(controller.orderWindowCustomers.size()==1);
            
            ow.Status__c='Closed';
            update ow;
            owc.Open_For_Shopping__c = false;
            update owc;
            
            controller = new POS_OrderWindowViewController();
            //Should have none right now because window is closed and not open for shopping
            System.assert(controller.orderWindowCustomers.size()==0);
            
            ow.Status__c='Budgeting';
            update ow;
            owc.Open_For_Shopping__c = false;
            update owc;
            
            controller = new POS_OrderWindowViewController();
            
            Test.stopTest();
            
        }
    }
        
}