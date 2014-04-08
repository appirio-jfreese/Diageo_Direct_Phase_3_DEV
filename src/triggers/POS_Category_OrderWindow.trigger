/***************************************************************************************************************************************************
 * @author      Model Metrics {Venkatesh Kamat}
 * @date        05/01/2012
 * @description Takes care of synching updates to Magento.

Updated By  : Jonathan Freese   
Date        : 11/18/13
Story/Task  : US278/TA1627
Changes     : Disable updates if Magento_ID has not yet been obtained

***************************************************************************************************************************************************/
 
trigger POS_Category_OrderWindow on Order_Window__c (after delete, after insert, after update) {
	   
    //Start: changes for US278/TA1627 jfreese
    if(TriggerState.isActive('POS_Category_OrderWindow')) { //de-activate/activate this entire trigger via custom_settings TriggerSettings
    //End: changes for US278/TA1627 jfreese
	
	   if (trigger.isDelete) {
		   for(Order_Window__c o : trigger.old) {
		   	
		   		if(o.Status__c != 'New') {
					o.addError('Cannot delete Order Window once it leaves \'New\' status');
					
				} else {
				
                    //Start: changes for US278/TA1627 jfreese - add sObjTypeName to set batch queue priority
                    POS_MagentoCategory.deleteMagentoCategory(o.Magento_Id__c, 'Order_Window__c');
                    //End: changes for US278/TA1627 jfreese
					System.debug('o.Magento_Id__c -' +o.Magento_Id__c);
		   		}
				
			}		   	
	   	
	   } else if (trigger.isInsert) {
	   	
		   for(Order_Window__c n : trigger.new) {
				
				String isActive = (n.Status__c=='Open')?'1':'0'; //Magento has only 2 status - Active, Inactive
				if(!Test.isRunningTest()) { // avoid futureCallouts
					POS_MagentoCategory.createMagentoCategoryWindow(n.id, n.Name, isActive);
				}
				System.debug('n.Name -' +n.Name);
				
			}	
			   
		} else if (trigger.isUpdate) {
	   		
	   		Map<Id, Order_Window__c> owWithCustomers = new Map<Id, Order_Window__c>([Select o.Id, (Select Id, Name, Order_Window__c, Customer__c, Open_For_Shopping__c 
	   																From Order_Window_Customers__r) From Order_Window__c o where o.id in :trigger.new]);
		   List<Order_Window_Customer__c> owCustomerForUpdate =	new List<Order_Window_Customer__c>();
		   for(Order_Window__c n : trigger.new) {
		   	
				Order_Window__c o = trigger.oldMap.get(n.id);
				
				//System.debug('n.Status__c -' +n.Status__c + ' o.Status__c -' + o.Status__c + ' n.Name -' +n.Name + ' o.Name -' + o.Name);
				
                //Start: changes for US278/TA1627 jfreese
                if (o.Magento_Id__c == null && n.Magento_Id__c == null){
                	  n.addError('Cannot update order window until a Magento Category ID is obtained.  Please wait a few minutes and try again.');
                } else
                //End: changes for US278/TA1627 jfreese
				/* Manage OrderWindow status on Magento */
				if(n.Status__c != o.Status__c || n.Name != o.Name) { // update only if Status or Name is updated
					
					String isActive = (n.Status__c=='Open' || n.Status__c=='Closed')?'1':'0'; //Magento has only 2 status - Active, Inactive
					if(!Test.isRunningTest()) { // avoid futureCallouts
                        //Start: changes for US278/TA1627 jfreese - add sObjId and sObjTypeName
						POS_MagentoCategory.updateMagentoCategory(n.Magento_Id__c, n.Name, isActive, n.Id, 'Order_Window__c');
                        //End: changes for US278/TA1627 jfreese
					}
				}
				System.debug('n.Name -' +n.Name);
				
				
				/* set OrderWindowCustomer 'Open for Shopping' flag based on the OrderWindow status */
				List<Order_Window_Customer__c> owCustomers = owWithCustomers.get(n.id).Order_Window_Customers__r;
				if(n.Status__c != o.Status__c && owCustomers != null) {
					Boolean openForShopping = false;
					if(n.Status__c=='Open') {
						openForShopping = true;
					}
					
					for(Order_Window_Customer__c owc :owCustomers ) {
						if(owc.Open_For_Shopping__c != openForShopping) {
							owc.Open_For_Shopping__c = openForShopping;
							owCustomerForUpdate.add(owc);
						}
					}
					
				}
				
			}	
			
			System.debug('owCustomerForUpdate.size() -' + owCustomerForUpdate.size());
			update(owCustomerForUpdate);
			   
		}

    //Start: changes for US278/TA1627 jfreese
    } //de-activate/activate this entire trigger via custom_settings TriggerSettings
    //End: changes for US278/TA1627 jfreese

}