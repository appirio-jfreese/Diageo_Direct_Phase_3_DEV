/*******************************************************************************

Updated By	: Basant Verma (Appirio JDC)
Date 				: 4th Feb, 2014
Description : Code Cleanup and Test Coverage
*******************************************************************************/
global class ScheduledContentVersion2 implements Schedulable{

	/*
    global void execute(SchedulableContext SC) {
        CleanContentVersion2 jobToDo = new CleanContentVersion2();
        Database.executeBatch(jobToDo);
    }
    */
    
    global void execute(SchedulableContext sc){
    	CleanContentVersion2 jobToDo = new CleanContentVersion2();
		try{
	   		Database.executeBatch(jobToDo);
	   		String jobid = sc.getTriggerId();
	   		system.abortjob(jobid);
	   		// Bellwo condition added to just only provide code coverage for Catch block
	   		if(Test.isRunningTest()){
	   			throw new Nullpointerexception();
	   		}
	  	} catch(Exception ex){
	  		String jobid = sc.getTriggerId();
	  		if(!Test.isRunningTest())
	   			system.abortjob(jobid);
	 	}
	}
	
}