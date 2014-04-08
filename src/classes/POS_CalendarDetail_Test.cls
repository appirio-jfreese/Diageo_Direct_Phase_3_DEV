@IsTest(SeeAllData=false)
public class POS_CalendarDetail_Test{
	
    static testmethod void testCalendarDetail () {
    	Program__c program = POS_TestDataUtil.createProgram();
    	
    	Calendar__c calendar = new Calendar__c();
    	calendar.RecordTypeId=([select Id,Name from RecordType where Name='Innovation, Sustainovation & VAP']).Id;
    	insert calendar;
    	
    	System.debug('Rec Type: '+calendar.RecordType.Name);
    	
    	program.Calendar__c=calendar.Id;
    	update program;
    	
    	ApexPages.currentPage().getHeaders().put('Referer','test');
		ApexPages.currentPage().getParameters().put('program',program.Id);
    	POS_CalendarDetail detail = new POS_CalendarDetail();
    	System.debug('Detail: '+detail);
    	System.assert(detail.destination.indexOf('IVAPDetails')>=0);
    	
    	calendar.RecordTypeId=([select Id,Name from RecordType where Name='Monthly Execution Plan']).Id;
    	update calendar;
    	
    	detail = new POS_CalendarDetail();
    	System.debug('Detail: '+detail);
    	System.assert(detail.destination.indexOf('MEPDetails')>=0);
    	
    	calendar.RecordTypeId=([select Id,Name from RecordType where Name='Multicultural']).Id;
    	update calendar;
    	detail = new POS_CalendarDetail();
    	//No assertion here because Multicultural isn't implemented yet
    	
    	program.Calendar__c = null;
    	update program;
    	
    	detail = new POS_CalendarDetail();
    	System.debug('Detail: '+detail);
    	System.assert(detail.destination=='test');
    	
    }    
}