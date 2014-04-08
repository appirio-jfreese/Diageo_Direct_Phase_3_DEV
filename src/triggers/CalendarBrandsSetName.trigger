/*******************************************************************************
Name        : CalendarBrandsSetName

Updated By  : Basant Verma (Appirio JDC)   
Date        : 10/11/13
Story/Task  : US834/TA1500 : Only one Calendar Brand can marked as primary for an Calender

Updated By  : Siddharth varshneya (Appirio JDC)   
Date        : 29/11/13
Story/Task  : US922/TA1670
*******************************************************************************/
trigger CalendarBrandsSetName on CalendarBrand__c (before insert, before update) {
    Id[] BrandIds = new Id[]{};
    Id[] CalendarIds = new Id[]{};
    for(CalendarBrand__c calBr : trigger.new){
        BrandIds.add(calBr.Brand__c);
        CalendarIds.add(calBr.Calendar__c);
    }
    
    Map <Id,Brand__c> brands = new Map<Id,Brand__c>([select id, name from Brand__c where  id in :BrandIds]);
    Map <Id,Calendar__c> calendars = new Map<Id,Calendar__c>([select id, name from Calendar__c where  id in :CalendarIds]);
    
    for(CalendarBrand__c calBr : trigger.new){
        String name = calendars.get(calBr.Calendar__c).Name+'_'+brands.get(calBr.Brand__c).Name;
        if(name.length() > 80){
            name = name.substring(0, 79);
        }
        calBr.Name = name;
    }
    
    // Start : Changed for US834/TA1500 - Basant
    if(Trigger.isBefore && Trigger.isInsert){
        CalenderBrandTriggerHandler.onBeforeInsert(Trigger.new);
    }
    // End : Changed for US834/TA1500 - Basant
}