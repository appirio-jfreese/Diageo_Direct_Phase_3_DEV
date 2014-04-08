/*******************************************************************
// (c) 2013 Appirio, Inc.
// 
// Trigger that *should be* invoked for all contexts that
// delegates control to LeadTriggerHandler. 
//
// Sep 12, 2013    Randy Wandell    Original
//
********************************************************************/
trigger LeadTrigger on Lead (before insert, after insert, 
                             before delete, after delete,  
                             before update, after update,
                             after undelete) {

    if(TriggerState.isActive('LeadTrigger')) {
        LeadTriggerHandler handler = new LeadTriggerHandler(Trigger.isExecuting, Trigger.size);

        if(Trigger.isInsert && Trigger.isBefore){     
            //Handler for before insert
            handler.OnBeforeInsert(Trigger.new);     
        } else if(Trigger.isInsert && Trigger.isAfter){
            //Handler for after insert
            handler.OnAfterInsert(Trigger.new);       
        } else if(Trigger.isUpdate && Trigger.isBefore){    
            //Handler for before update trigger
            handler.OnBeforeUpdate(Trigger.oldMap, Trigger.newMap);       
        } else if(Trigger.isUpdate && Trigger.isAfter){   
            //Handler for after update trigger
            handler.OnAfterUpdate(Trigger.oldMap, Trigger.newMap);    
        } else if (Trigger.isDelete && Trigger.isBefore) {     
            //Handler for before Delete trigger
            handler.OnBeforeDelete(Trigger.oldMap);    
        } else if (Trigger.isDelete && Trigger.isAfter) {     
            //Handler for before Delete trigger
            handler.OnAfterDelete(Trigger.oldMap);    
        }
    }                             

}