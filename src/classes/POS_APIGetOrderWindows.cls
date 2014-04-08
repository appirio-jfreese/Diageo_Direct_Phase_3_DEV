@RestResource(urlMapping='/GetWindows/*')
global with sharing class POS_APIGetOrderWindows {
    
    private static String fieldList = 'Order_Close_Date__c, Order_Delivery_Date__c, Order_Start_Date__c, '+
      'Name, Status__c, Type__c, Fiscal_Year__c from Order_Window__c where Status__c!=\'New\'';
      
    @HttpGet
    global static APIWindowResponse doGet () {
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        
        String UpdateTime = req.params.get('UpdateTime');   
        
        String soql = 'select '+fieldList;
        if (UpdateTime!=null) {
            UpdateTime = String.escapeSingleQuotes(UpdateTime);
            soql = soql +' and SystemModstamp > '+UpdateTime;
        }
        
        System.debug('Query: '+soql);
        
        List<Order_Window__c> windows = (List<Order_Window__c>)Database.query(soql);
        
        APIWindowResponse response = new APIWindowResponse();
        response.Windows=windows;
        return response;
    
    }
    
    global class APIWindowResponse {
        public List<Order_Window__c> Windows;
    }
   
}