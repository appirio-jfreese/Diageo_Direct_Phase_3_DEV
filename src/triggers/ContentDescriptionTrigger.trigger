trigger ContentDescriptionTrigger on Content_Description__c (before update ,after insert) {
	
	 if(Trigger.isAfter && Trigger.isInsert){
        TriggerContentDescription.onAfterInsert(Trigger.newMap);
    }
    else{
    	TriggerContentDescription.onBeforeUpdate(Trigger.isUpdate, Trigger.newMap, Trigger.oldMap);
    }
}