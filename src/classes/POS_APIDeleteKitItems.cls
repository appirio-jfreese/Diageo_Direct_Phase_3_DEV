/******************************************************************
Class  - POS_APIDeleteKitItems
Created By -  Rahul Chitkara(Appirio Jaipur)
Created Date - 25th March 2013
Uses - To delete the Kit items while giving Kit Master Id
****************************************************************/


@RestResource(urlMapping='/DeleteKitItems/*')
global with sharing class POS_APIDeleteKitItems{
    @HttpPost
    global static String DeleteKitItems(Id KitMasterId) {
        System.debug('----parameter'+KitMasterId);
        Id kitRecTypeId = [select id from RecordType where DeveloperName = 'Kit'].id;
        
        list<Kit_Item__c> KitItems = [select Id,Item__c from Kit_Item__c where Kit__c =:KitMasterId and Kit__r.RecordTypeId= :kitRecTypeId];
        System.debug('----listKitItem'+KitItems );
       try{ 
            if(KitItems.size() > 0){
                delete KitItems;
                return 'Status - Succes'+KitMasterId+'';    
            }
        return 'No Kit Item to Delete.';
        }
        catch(Exception e){
            System.debug('Exception '+e);
            return 'Status - Failed: ' + e;
        }
    }   
}