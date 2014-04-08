@IsTest(SeeAllData=true)
public class POS_APIDeleteKitItems_Test{
    
    // Method for success status for deleting the kit item. 
    static testmethod void testDeleteKitItems1() {        
        Program__c pg = POS_TestDataUtil.createProgram();
        // Creation of Item record, as each Kit item shuould be associated to different Item 
        Item__c item = createItem(pg);
        Item__c item1 = createItem(pg);
        Item__c item2 = createItem(pg);
        
        // Kit record creation(Kit Master record)
        Item__c kit = createKit(pg,'Development','Kit');
        // Creation of Kit item records
        list<Kit_item__c> kititemList = new list<Kit_item__c>(); 
        Kit_Item__c kititem1 = getKitItem(kit, item);
        kititemList.add(kititem1);
        
        Kit_Item__c kitItem2 = getKitItem(kit, item1);
        kititemList.add(kitItem2);
        
        Kit_Item__c kitItem3 = getKitItem(kit, item2);
        kititemList.add(kitItem3);
        insert kititemList;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        // Extracting the reuestURL  
        req.requestURI =  POS_Magento_Configuration__c.getOrgDefaults().Salesforce_apexrest_uri__c +'DeleteKitItems';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        // Calling of rest APi method for deleting the kit item records.
        String result = POS_APIDeleteKitItems.DeleteKitItems(kit.Id);
        system.assertEquals(result,'Status - Succes'+kit.Id);
        
        
    }
    
    static testmethod void testDeleteKitItems2() {        
        Program__c pg = POS_TestDataUtil.createProgram();
        // Creation of Item record, as each Kit item shuould be associated to different Item 
        
        
        // Kit record creation(Kit Master record)
        Item__c kit = createKit(pg,'Development','Roll_Up');
        // Creation of Kit item records
        
        // No kit items are associated to Kit master record. Kit item obly creates when Kit Master records keeps Kit record type       
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        // Extracting the reuestURL  
        req.requestURI =  POS_Magento_Configuration__c.getOrgDefaults().Salesforce_apexrest_uri__c +'DeleteKitItems';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        // Calling of rest APi method for deleting the kit item records.
        String result = POS_APIDeleteKitItems.DeleteKitItems(kit.Id);
        system.assertEquals(result,'No Kit Item to Delete.');
        
        
    }
    
    public static Item__c createItem(Program__c pg){
        
        RecordType productionAgency1 = [select Id, Name from RecordType where Name='POS Production Agency'];
        Account agency = new Account(Name='POS TEST AGENCY', RecordTypeId = productionAgency1.Id);
        insert agency;      
        
        Item__c o = populateItem(pg, agency,'Development');
        insert o;
        return o; 
    }
    public static Item__c populateItem(Program__c pg, Account ag, String status){
        RecordType standard = [select Id, Name from RecordType where SobjectType = 'Item__c' and Name='Standard'];
        // create ItemCategory records which is required while creating Item
        Item_Category__c ic = createItemCategory();
        
        Item__c o = new Item__c(name='itemName',Description__c='Uit Test Item Description', Current_Price__c=19.99, Estimated_Price__c=17.99, 
                                Estimated_Shipping_Tax__c=7.65, Category__c='Regular', Minimum_Quantity__c=10,  Packout_Quantity__c = 10,
                                Program__c=pg.id, Item_Category__c=ic.id, agency__c=ag.id,RecordTypeId=standard.Id,Status__c = status);
        // START : Changed to avoid test class failure : by Basant Verma (Appirio JDC) : 26 Dec, 2013 
        o.Agency_Item_ID__c = POS_TestDataUtil.getTimeStamp();
        // END : Changed to avoid test class failure : by Basant Verma (Appirio JDC) : 26 Dec, 2013
        return o;                        
    }
    public static Item_Category__c createItemCategory(){
        Item_Category__c o = new Item_Category__c(Name='Test Item Category', Customer_Marketing_Category__c='Bar', Material_Code__c='55B.91', 
                                                  Primary_Group__c='Display', Primary_Type__c='PRINT');
        insert o;
        return o;                        
    } 
    public static Item__c createKit(Program__c pg, Account agency,String status, String recordType){
        Id kitRecTypeId;
        if(recordType=='kit'){
            kitRecTypeId = [select id from RecordType where DeveloperName = 'Kit'].id;
        }
        else
            kitRecTypeId = [select id from RecordType where DeveloperName = 'Roll_Up'].id;
        
        Item__c o = populateItem(pg, agency, status);
        o.recordTypeId=kitRecTypeId;
        // START : Added by Basant To fix the Test Class Falure : 12/20/13
        if (recordType != 'kit'){
            o.Current_Price__c = 0;
            o.Estimated_Price__c = 0;
        }
        // END : Added by Basant To fix the Test Class Falure : 12/20/13
        insert o;
        return o; 
    }
    
    public static Kit_Item__c getKitItem(Item__c kit, Item__c item){
        Kit_Item__c kitItem = new Kit_Item__c();
        kitItem.Kit__c = kit.Id;
        kitItem.Item__c = item.Id;     
        kitItem.Packout_Quantity__c = 1; 
        return kitItem;    
    }
    public static Item__c createKit(Program__c pg, String status,String recordType){
        RecordType productionAgency = [select Id, Name from RecordType where Name='POS Production Agency'];   
        Id kitRecTypeId;
        if(recordType=='kit'){
            kitRecTypeId = [select id from RecordType where DeveloperName = 'Kit'].id;
        }
        else
            kitRecTypeId = [select id from RecordType where DeveloperName = 'Roll_Up'].id;   
        Account agency = new Account(Name='POS TEST AGENCY', RecordTypeId = productionAgency.Id);
        insert agency;      
        
        return createKit(pg,agency,status,recordType);
    } 
}