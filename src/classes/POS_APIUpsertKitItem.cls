@RestResource(urlMapping='/UpsertKitItem/*')
global with sharing class POS_APIUpsertKitItem {
	
	public static String STATUS_SUCCESS='success';
    public static String STATUS_FAIL='fail';
	
	@HttpPost 
        global static UpsertResponse doPost (Kit_Item__c kitItem, RestResponse res) {
            
            String userId = UserInfo.getUserId();
            
            POSAPIConfiguration__c settings = POSAPIConfiguration__c.getOrgDefaults();
            String PROFILE_NAME = settings.POS_Agency_Profile_Name__c;
            
            List<Account_Member__c> accountMembers = [select a.Account__c from Account_Member__c a where a.User__c= :userId
                                                      and a.Account__r.RecordType.Name = :PROFILE_NAME];
            
            //There should be one and only one agency associated with this account
            if (accountMembers == null || accountMembers.size()!=1) {
                res.StatusCode = 400;
                res.addHeader('Error','Misconfiguration: account not configured for a single POS agency');
                return null;
                
            }
            
            Id agency = accountMembers.get(0).Account__c;
            
            //They must own the items that are associated with the kit item
            List<String> itemIds = new List<String>();
            itemIds.add(kitItem.Kit__c);
            itemIds.add(kitItem.Item__c);
            List<Item__c> items = [select Id, Agency__c from Item__c where Id in :itemIds];
            
            //Make sure that the items they are referencing actually exist
            if (items==null || items.size()!=2) {
                res.StatusCode = 500;
                res.addHeader('Error','The Kit or Item you specified does not exist');
                return null;
            }
            else {
                for (Item__c item:items) {
                    System.debug('Agency comparison: '+item.Agency__c+'->'+agency);
                    System.debug('They dont match: '+(item.Agency__c!=agency));
                    if (item.Agency__c!=agency) {
                        res.StatusCode = 500;
                        res.addHeader('Error','The Kit or Item you specified does not belong to your agency');
                        return null;
                    }
                }
            }
            
            
            
            
            UpsertResponse upsertResponse = new UpsertResponse();
            try {
                upsert kitItem;
                upsertResponse.status=STATUS_SUCCESS;
                upsertResponse.Id=kitItem.Id;
            }
            catch (Exception e) {
                upsertResponse.status=STATUS_FAIL;
                upsertResponse.statusDetail=e.getMessage();
            }
            return upsertResponse;
            
        }
    
    global class UpsertResponse {
        public String Id {get;set;}
        public String status {get;set;}
        public String statusDetail {get;set;}
        
    }

}