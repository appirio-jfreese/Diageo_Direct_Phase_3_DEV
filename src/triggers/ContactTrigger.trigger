trigger ContactTrigger on Contact ( after insert, after update, before insert, before update) {
	if(trigger.isBefore){
	 	if(trigger.isInsert){
		 	ContactActions.GenerateActivationCode(trigger.new);
		 } else if(trigger.isUpdate){
			 ContactActions.GenerateActivationCode(trigger.oldMap, trigger.new);
		 }
	 } else 
	 if(trigger.isAfter){
	 	
	}
 }