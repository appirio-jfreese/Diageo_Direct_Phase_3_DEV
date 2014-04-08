/***************************************************************************************************************************************************
POS_APIUpsertItem.cls

Updated By  : Jonathan Freese   
Date        : 11/1/13
Story/Task  : DE759
Changes     : Modified existing system.debug calls to include reference to this class and added new system.debug calls for Magento sync tracking

***************************************************************************************************************************************************/

@RestResource(urlMapping='/UpsertItem/*')
global with sharing class POS_APIUpsertItem {
    
    public static String STATUS_SUCCESS='success';
    public static String STATUS_FAIL='fail';
    
    @HttpPost
    global static UpsertResponse doPost (Item__c item, RestResponse res) {
        
        String userId = UserInfo.getUserId();
        
        POSAPIConfiguration__c settings = POSAPIConfiguration__c.getOrgDefaults();
        String PROFILE_NAME = settings.POS_Agency_Profile_Name__c;
        
        List<Account_Member__c> accountMembers = [select a.Account__c from Account_Member__c a where a.User__c= :userId
            and a.Account__r.RecordType.Name = :PROFILE_NAME];
            
        //There should be one and only one agency associated with this account
        if (accountMembers == null || accountMembers.size()!=1) {
            res.StatusCode = 400;
            res.addHeader('Error','Misconfiguration: account not configured for a single POS agency');
            return new UpsertResponse();
            
        }
        
        //They must provide an agency item Id
        if (item.Agency_Item_Id__c==null) {
            res.StatusCode = 400;
            res.addHeader('Error','Agency Item ID is a required field');
            return new UpsertResponse();
        }
        
        //They must set the program if it's a new item
        if (item.Id==null && item.Program__c==null) {
            res.StatusCode = 400;
            res.addHeader('Error','Items must be associated with a valid Program');
            return new UpsertResponse();
        }
        
        Id agency = accountMembers.get(0).Account__c;
        
        UpsertResponse upsertResponse = new UpsertResponse();
        try {
            
            upsertResponse.AgencyItemId=item.Agency_Item_Id__c;
            //Check to see if this is an update
            if (item.Id!=null) {
                //It's an update
                //Get Magento ID from the current version of the item (API should not allow change of Magento ID)
                Id itemId = item.Id;
                Item__c currentItem = [select Magento_Id__c from Item__c where Id=:itemId];
                item.Magento_ID__c=currentItem.Magento_ID__c;
                upsertResponse.Id=item.Id;
                update item;
                upsertResponse.status=STATUS_SUCCESS;
                System.debug('DE759 POS_APIUpsertItem.cls Item after update: Item Name - ' + item.name + ', Item_ID - ' + item.Item_ID__c + ', Agency_Item_ID - ' + item.Agency_Item_ID__c + ', Magento_ID - ' + item.Magento_ID__c);
            }
            else {
                item.Agency__c=agency;
                insert item;
                upsertResponse.Id=item.Id;
                upsertResponse.status=STATUS_SUCCESS;
                System.debug('DE759 POS_APIUpsertItem.cls Item after insert: Item Name - ' + item.name + ', Item_ID - ' + item.Item_ID__c + ', Agency_Item_ID - ' + item.Agency_Item_ID__c + ', Magento_ID - ' + item.Magento_ID__c);
            }
        }
        catch (Exception e) {
            upsertResponse.status=STATUS_FAIL;
            upsertResponse.statusDetail=e.getMessage();
        }
        return upsertResponse;
        
    }
    
    global class UpsertResponse {
        public String Id {get;set;}
        public String AgencyItemId {get;set;}
        public String status {get;set;}
        public String statusDetail {get;set;}
        
    }

}