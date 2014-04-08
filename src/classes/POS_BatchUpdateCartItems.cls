/**
Batch that periodically updates any missing or invalid WBS numbers

*/
global class POS_BatchUpdateCartItems implements Database.Batchable<sObject> {


    String query = 'select Id, Ship_To__c, Item__c, Ship_To__r.Account__c, WBS__c, Company_Code__c, Cart__c, Cart__r.Shopper__c '+
     ' from Cart_Item__c where Ship_To__c != null and '+
     ' '+
     ' Item__r.Program__r.Order_Window__r.Status__c not in (\'Archived\',\'In Review\',\'Budgeting\') ';
    // (WBS__c=null or WBS__c like \'%?%\') and
    
    List<String> orderWindowId= new List<String>();
    Boolean isFull=false;

    /*public POS_BatchUpdateCartItems (String orderWindowId) {
        this.orderWindowId=orderWindowId;
    }*/
    
    /*
       since the trigger needs to be bulkified we will make order window id as list
    */
    public POS_BatchUpdateCartItems (Boolean isFull,List<String> orderWindowId) {
            
            this.orderWindowId=orderWindowId;
            this.isFull=isFull;
    }
    
    global database.queryLocator start(Database.BatchableContext BC) 
    {
        if(!isFull){
            query = query +' and (WBS__c=null or WBS__c like \'%?%\') AND Is_Manual_WBS__c=false';
        }
        
        if(isFull){
            query = query +' and Is_Manual_WBS__c=false';
        }
        
        if (orderWindowId!=null && orderWindowId.size()>0) {
            //query = query +' and Item__r.Program__r.Order_Window__c = \''+orderWindowId+'\'';
            query = query +' and Item__r.Program__r.Order_Window__c IN: orderWindowId';
        }
        
        if (Test.isRunningTest()) {
            query=query+' LIMIT 100';
        }
        return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Cart_Item__c> cartItems){
        
        System.debug('Cart Items: '+cartItems);
        POS_WBSUtil util = new POS_WBSUtil(cartItems);
        cartItems = util.populateWBSData(); 
        System.debug('Cart Items with WBS: '+cartItems);
        update cartItems;
        
        
            
    }

    global void finish(Database.BatchableContext BC) {
        
    }

}