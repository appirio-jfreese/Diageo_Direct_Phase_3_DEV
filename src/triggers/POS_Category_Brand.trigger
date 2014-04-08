/***************************************************************************************************************************************************
 * @author      Model Metrics {Venkatesh Kamat}
 * @date        05/01/2012
 * @description Takes care of synching updates to Magento.

Updated By  : Jonathan Freese   
Date        : 11/18/13
Story/Task  : US278/TA1627

***************************************************************************************************************************************************/

 
trigger POS_Category_Brand on Brand__c (after delete, after insert, after update) {
	   
    //Start: changes for US278/TA1627 jfreese
    if(TriggerState.isActive('POS_Category_Brand')) { //de-activate/activate this entire trigger via custom_settings TriggerSettings
    //End: changes for US278/TA1627 jfreese

	   if (trigger.isDelete) {
		   for(Brand__c o : trigger.old) {
				if(o.Portfolio_Brand__c) {
					o.addError('Cannot delete "Portfolio" brand.');
				}
				
                //Start: changes for US278/TA1627 jfreese - add sObjTypeName to set batch queue priority
                POS_MagentoCategory.deleteMagentoCategory(o.Magento_Id__c, 'Brand__c');
                //End: changes for US278/TA1627 jfreese
				System.debug('o.Magento_Id__c -' +o.Magento_Id__c);
				
			}		   	
	   	
	   } else if (trigger.isInsert) {
	   	
		   for(Brand__c n : trigger.new) {
				
				String isActive = '1'; //Magento has 2 status - Active, Inactive for category, but Inactive doesn't applie to Brand.
				if (!Test.isRunningTest()) {
					POS_MagentoCategory.createMagentoCategoryBrand(n.id, n.Parent_Brand__c, n.Name, isActive);
				}
				System.debug('n.Parent_Brand__c -' +n.Parent_Brand__c);
				
			}	
			   
		} else if (trigger.isUpdate) {
	   		
		   for(Brand__c n : trigger.new) {
		   		
		   		Brand__c o = trigger.oldMap.get(n.id);
		   		if (o.Magento_Id__c == null && n.Magento_Id__c==null && !Test.isRunningTest()) {
		   			String isActive = '1'; //Magento has 2 status - Active, Inactive for category, but Inactive doesn't applie to Brand.
		   			if(!Test.isRunningTest()) { // avoid futureCallouts
						POS_MagentoCategory.createMagentoCategoryBrand(n.id, n.Parent_Brand__c, n.Name, isActive);
		   			}
					System.debug('n.Parent_Brand__c -' +n.Parent_Brand__c);
		   		}
		   		else {
					System.debug('n.Name -' +n.Name + ' o.Name -' + o.Name);
					if(o.Magento_Id__c != null && n.Name != o.Name) { // update only if Name is updated
						
						String isActive = '1'; //Magento has 2 status - Active, Inactive for category, but Inactive doesn't applie to Brand.
						if(!Test.isRunningTest()) { // avoid futureCallouts
                            //Start: changes for US278/TA1627 jfreese - add sObjId and sObjTypeName
							POS_MagentoCategory.updateMagentoCategory(n.Magento_Id__c, n.Name, isActive, n.Id, 'Brand__c');
                            //End: changes for US278/TA1627 jfreese
						}
					}
					System.debug('n.Name -' +n.Name);
		   		}
			}	
			   
		}

    //Start: changes for US278/TA1627 jfreese
    } //de-activate/activate this entire trigger via custom_settings TriggerSettings
    //End: changes for US278/TA1627 jfreese
}