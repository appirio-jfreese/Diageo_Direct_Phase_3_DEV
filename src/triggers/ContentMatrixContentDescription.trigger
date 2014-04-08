trigger ContentMatrixContentDescription on Content_Description__c (after insert, after update) {
    
	if((trigger.isInsert || trigger.isUpdate )){			
	  
	  list<Content_Property__c> contentPropertyToInsert = new list<Content_Property__c>();
	  
	  Map<String, List<Content_Matrix__c>> mapTypeToContentMatrix = new Map<String, List<Content_Matrix__c>>();
	  Map<Id, List<Content_Property__c>> mapDescToContentProperty = new Map<Id, List<Content_Property__c>>();
	  
	  for(Content_Description__c conDesc : Trigger.new){
		if(conDesc.Matrix_type__c != null && conDesc.Matrix_type__c != ''){
	      if(Trigger.isUpdate && trigger.oldmap.get(conDesc.Id).Matrix_type__c == conDesc.Matrix_type__c) {
	      	continue;
	      }
	      mapTypeToContentMatrix.put(conDesc.Matrix_type__c, new List<Content_Matrix__c>());
	      mapDescToContentProperty.put(conDesc.Id, new List<Content_Property__c>());
		}	
	  }
	  
	  if(mapDescToContentProperty.size() == 0){
	  	return;
	  }
	  
	  for(Content_Matrix__c matrix : [SELECT Id, Category__c, Sub_Category__c, Sub_Sub_Category__c, Sub_Sub_Sub_Category__c, Matrix_Type__c 
	                                       FROM Content_Matrix__c WHERE Matrix_Type__c IN :mapTypeToContentMatrix.keySet()]){
	  	mapTypeToContentMatrix.get(matrix.Matrix_Type__c).add(matrix);
	  }
	  
	  for(Content_Property__c contentProperty : [SELECT Id, Category__c, Sub_Category__c, Sub_Sub_Category__c, Sub_Sub_Sub_Category__c, Content_Description__c 
	  										FROM Content_Property__c where Content_Description__c IN :mapDescToContentProperty.keySet()]){
	  	mapDescToContentProperty.get(contentProperty.Content_Description__c).add(contentProperty);
	  }
	  
	  for(Content_Description__c conDesc : Trigger.new){
	  	if(mapDescToContentProperty.containsKey(conDesc.Id)){
	  	  for(Content_Matrix__c matrixItem : mapTypeToContentMatrix.get(conDesc.Matrix_type__c)) {
	        Boolean needToCreate = true;
			for(Content_Property__c property : mapDescToContentProperty.get(conDesc.Id)) {
			  if(
				  property.Category__c == matrixItem.Category__c &&
				  property.Sub_Category__c == matrixItem.Sub_Category__c &&
				  property.Sub_Sub_Category__c == matrixItem.Sub_Sub_Category__c &&
				  property.Sub_Sub_Sub_Category__c == matrixItem.Sub_Sub_Sub_Category__c 
				){
				 needToCreate = false;
				 break;
			  }
			}
			if(needToCreate){
			    Content_Property__c newCp = new Content_Property__c();
			    newCp.Content_Description__c = conDesc.id;
				newCp.Category__c = matrixItem.Category__c;
				newCp.Sub_Category__c = matrixItem.Sub_Category__c;
				newCp.Sub_Sub_Category__c = matrixItem.Sub_Sub_Category__c;
				newCp.Sub_Sub_Sub_Category__c = matrixItem.Sub_Sub_Sub_Category__c;
				newCp.Start_Date__c = date.today();
				newCp.End_Date__c = date.today();
				contentPropertyToInsert.add(newCp);
			}
		  }
	  	}
	  }
			
		    /*for(Content_Description__c c : Trigger.new){
	            if(c.Matrix_type__c != null && c.Matrix_type__c != ''){
	            	if(Trigger.isUpdate && trigger.oldmap.get(c.Id).Matrix_type__c == c.Matrix_type__c) {
	            		continue;
	            	}
	            	
	            	list<Content_Matrix__c> matrix = [Select Id, Category__c, Sub_Category__c, Sub_Sub_Category__c, Sub_Sub_Sub_Category__c FROM Content_Matrix__c WHERE Matrix_Type__c = :c.Matrix_type__c];
	            	list<Content_Property__c> currentProperty = [select Id, Category__c, Sub_Category__c, Sub_Sub_Category__c, Sub_Sub_Sub_Category__c FROM Content_Property__c where Content_Description__c = :c.id];
					if(matrix.size() != 0){
						for(Content_Matrix__c matrixItem : matrix) {
							Boolean needToCreate = true;
							for(Content_Property__c property : currentProperty) {
								if(
									property.Category__c == matrixItem.Category__c &&
									property.Sub_Category__c == matrixItem.Sub_Category__c &&
									property.Sub_Sub_Category__c == matrixItem.Sub_Sub_Category__c &&
									property.Sub_Sub_Sub_Category__c == matrixItem.Sub_Sub_Sub_Category__c 
								){
									needToCreate = false;
									break;
								}
							}
							if(needToCreate){
								Content_Property__c newCp = new Content_Property__c();
								newCp.Content_Description__c = c.id;
								newCp.Category__c = matrixItem.Category__c;
								newCp.Sub_Category__c = matrixItem.Sub_Category__c;
								newCp.Sub_Sub_Category__c = matrixItem.Sub_Sub_Category__c;
								newCp.Sub_Sub_Sub_Category__c = matrixItem.Sub_Sub_Sub_Category__c;
								newCp.Start_Date__c = date.today();
								newCp.End_Date__c = date.today();
								contentPropertyToInsert.add(newCp);
							}
						}				
					}            
	            }
		    }*/
		    
		    if(contentPropertyToInsert.size() != 0){
		    	insert contentPropertyToInsert;
		    }

	}
}