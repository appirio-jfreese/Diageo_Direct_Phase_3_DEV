trigger ShipToTrigger on Ship_To__c (before insert) {
  
  for(Ship_To__c shipTo : Trigger.New){  	
  	shipTo.AddressOwnerID__c = Userinfo.getUserId();
  }
}