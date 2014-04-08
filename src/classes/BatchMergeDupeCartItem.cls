global class BatchMergeDupeCartItem implements Database.Batchable<sObject>{
    global final String Query;
    global BatchMergeDupeCartItem(String q){
        Query=q; 
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext BC,List<Recipe__c> scope){
        List<Cart_Item__c> allCartItems = new List<Cart_Item__c>([SELECT Cart__c,Item__c,Ship_To__c,Cart__r.Order_Window__c from Cart_Item__c]);
        Map<String,List<Cart_Item__c>> DupeRecords = new Map<String,List<Cart_Item__c>>();
        list<Cart_Item__c> dupeCartItems = new list<Cart_Item__c>();
        for(Cart_Item__c cItem : allCartItems) {
            string key = cItem.Cart__c+':'+cItem.Item__c+':'+cItem.Ship_To__c+':'+cItem.Cart__r.Order_Window__c;
            if(DupeRecords.containsKey(key)) {
                DupeRecords.get(Key).add(cItem);
                dupeCartItems.add(cItem);
            } else {
                DupeRecords.put(key,new list<Cart_Item__c>{cItem});
            }
        }
        system.debug('======dupeCartItems====='+dupeCartItems.size());
    }

    global void finish(Database.BatchableContext BC){
    }
}