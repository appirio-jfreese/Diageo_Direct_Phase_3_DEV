@IsTest(SeeAllData=false)
public class POS_APIGetOrderWindows_Test{
    
    static testmethod void testGetWindows () {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
        
        //Try query with no populated data first
        POS_APIGetOrderWindows.APIWindowResponse response = POS_APIGetOrderWindows.doGet();
        List<Order_Window__c> windows = response.Windows;
        System.assert(windows.size()==0);
        
        //Now add data and test again
        Order_Window__c window = POS_TestDataUtil.createOrderWindow();
        window.Status__c='New';
        window.Magento_Id__c = '12345';
        update window;
        
        response = POS_APIGetOrderWindows.doGet();
        windows = response.Windows;
        
        //Should have no records because it's a new window
        System.assert(windows.size()==0);
        
        window.Status__c = 'In Review';
        update window;
        
        //Now should get one since it's not "new"
        response = POS_APIGetOrderWindows.doGet();
        windows = response.Windows;
        System.assert(windows.size()==1);
        
        //Now try using a more recent update time and see if we get no results again
        req=new RestRequest();
        Datetime now = System.now();
        now=now.addDays(2);
        
        String dateString = now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        req.addParameter('UpdateTime',dateString);
        RestContext.request=req;
        
        response = POS_APIGetOrderWindows.doGet();
        windows = response.Windows;
        System.assert(windows.size()==0);
    }
}