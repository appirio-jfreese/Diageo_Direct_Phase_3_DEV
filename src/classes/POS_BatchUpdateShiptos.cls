/*
This class updates the various shipto records when a specific shipto is edited or removed
*/
global class POS_BatchUpdateShiptos implements Database.Batchable<sObject> {
    private integer operation;
    private Ship_To__c originalShipTo;
    private Ship_To__c replacementShipTo;
    
    
    public static String query = 'select Id, Ship_To__c, Item__c from Cart_Item__c ';
    
    public POS_BatchUpdateShiptos (Ship_To__c originalShipTo, Ship_To__c replacementShipTo) {
        this.originalShipTo=originalShipTo;
        this.replacementShipTo = replacementShipTo;
    }
    
    global database.queryLocator start(Database.BatchableContext BC) 
    {
        String filteredQuery = query+' where Ship_To__c=\''+originalShipTo.Id+'\'';
        
        System.debug('QUERY: '+query);
        return database.getQueryLocator(filteredQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<Cart_Item__c> cartItems){
        System.debug('Updating: '+cartItems);
        for (Cart_Item__c cartItem:cartItems) {
            cartItem.Ship_To__c = replacementShipTo.Id;
        }
        
        update cartItems;
    }

    global void finish(Database.BatchableContext BC) {
        
    }

}