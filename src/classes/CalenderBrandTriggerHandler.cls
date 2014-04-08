/*******************************************************************************
Name        : CalenderBrandTriggerHandler

Created By  : Basant Verma (Appirio JDC)   
Date        : 10/11/13
Story/Task  : US834/TA1500 : Only one Calendar Brand can marked as primary for an Calender

Updated By  : Basant Verma (Appirio JDC)   
Date        : 2/5/13
Story/Task  : DE1021

Updated By  : Basant Verma (Appirio JDC)   
Date        : 3/4/14
Story/Task  : DE1102
*******************************************************************************/
public with sharing class CalenderBrandTriggerHandler {
	public static Boolean isAlreadyProcessed = false;
	
	public static void onBeforeInsert(List<CalendarBrand__c> newList){
    checkForPrimaryBrandBeforeInsert(newList);
	}
	
	public static void onAfterInsert(List<CalendarBrand__c> newList){
    checkForPrimaryBrand(newList, null);
	}

	public static void onAfterUpdate(List<CalendarBrand__c> newList,
                                 Map<Id,CalendarBrand__c> oldMap){
    checkForPrimaryBrand(newList, oldMap);
	}
	
	private static void checkForPrimaryBrandBeforeInsert(List<CalendarBrand__c> newList){
		Map<String, List<CalendarBrand__c>> calBrandMap = new Map<String, List<CalendarBrand__c>>();
		for(CalendarBrand__c cb : newList){
			if(!calBrandMap.containsKey(cb.Calendar__c))
				calBrandMap.put(cb.Calendar__c, new List<CalendarBrand__c>());
			calBrandMap.get(cb.Calendar__c).add(cb);
		}
		
		for(CalendarBrand__c cb : [Select Id, Name, Primary_Brand__c, Calendar__c
			From CalendarBrand__c Where Calendar__c IN :calBrandMap.keySet() AND Primary_Brand__c = true]){
			calBrandMap.remove(cb.Calendar__c);
		}
		
		// START : Changed for DE1021 : by Basant Verma (Apirio India) : 2/5/2013
		for(CalendarBrand__c cb : newList){
			if(calBrandMap.containsKey(cb.Calendar__c) && cb.Primary_Brand__c)
				calBrandMap.remove(cb.Calendar__c);
		}
		// END : Changed for DE1021 : by Basant Verma (Apirio India) : 2/5/2013
		
		for(String key : calBrandMap.keySet()){
			calBrandMap.get(key).get(0).Primary_Brand__c = true;
		}
	}
	
	//START : Changed for DE1102 , By Basant Verma on 4th March, 2014
	private static void checkForPrimaryBrand(List<CalendarBrand__c> newList, 
			Map<Id,CalendarBrand__c> oldMap){
		if(!isAlreadyProcessed){
			isAlreadyProcessed = true;
			Map<String, CalendarBrand__c> calBrandMap = new Map<String, CalendarBrand__c>();
			Set<String> newPrimaryCals = new Set<String>();
			List<Calendar__c> calToBeUpdate = new List<Calendar__c>();
			// We are doing SOQL here because we need to access CalendarBrand__c.Brand__r.Name
			for(CalendarBrand__c cb : [Select Id, Name, Primary_Brand__c, Calendar__c, Brand__c, Brand__r.Name 
				From CalendarBrand__c Where ID IN :newList]){
				if(!calBrandMap.containsKey(cb.Calendar__c)){
					calBrandMap.put(cb.Calendar__c, null);
				}
				
				// Only One Record Can have Primary Brand Checked
				if(cb.Primary_Brand__c){
					if(calBrandMap.get(cb.Calendar__c) == null){
						calBrandMap.put(cb.Calendar__c, cb);
						newPrimaryCals.add(cb.Calendar__c);
					}else{
						newList.get(0).Primary_Brand__c.addError(Label.PrimaryCalendarBrandError);
					}
				}
			}
			
			//Remove Existing Primary Cal Brand for New Cal Brand
			List<CalendarBrand__c> cbToUpdate = new List<CalendarBrand__c>();
			for(CalendarBrand__c cb : [Select Id, Name, Primary_Brand__c From CalendarBrand__c 
							Where Calendar__c IN :newPrimaryCals AND Primary_Brand__c = true AND ID NOT IN :newList]){
				cb.Primary_Brand__c = false;
				cbToUpdate.add(cb);
			}
			update cbToUpdate;
			
			// Update Primary_Brand_Name__c on Calender
			String brandName = '';
			for(Calendar__c cal : [Select Id, Name, RecordType.Name, 
				Sales_Channel__c, Start_Date__c, Primary_Brand_Name__c
				From Calendar__c Where Id IN :calBrandMap.keySet()]){
				brandName = '';
				if(calBrandMap.get(cal.Id) != null){
					//brandName = ' - ' + calBrandMap.get(cal.Id).Brand__r.Name;
					brandName = calBrandMap.get(cal.Id).Brand__r.Name;
				}else{
					newList.get(0).Primary_Brand__c.addError(Label.PrimaryCalendarBrandMustError);
				}
				/*cal.Program_Name__c = cal.RecordType.Name + ' - ' + cal.Sales_Channel__c 
						+ brandName + ' - ' + String.valueOf(cal.Start_Date__c);*/
				cal.Primary_Brand_Name__c = brandName;
				calToBeUpdate.add(cal);
			}
			if(calToBeUpdate.size() > 0){
				update calToBeUpdate;
			}
		}
	}
	//END : Changed for DE1102 , By Basant Verma on 4th March, 2014
}