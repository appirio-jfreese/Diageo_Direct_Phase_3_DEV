/*******************************************************************************

Updated By	: Basant Verma (Appirio JDC)
Date 				: 4th Feb, 2014
Description : Code Cleanup and Test Coverage
*******************************************************************************/
//Here we are using see all data true becuase we can not create workspace object in test class
@isTest(seeAllData = true)
private class Test_CleanContentVersion2 {
	List<File__c> contentDescriptionList;
	class TestSettings {
		List<File__c> contentDescriptionList = new List<File__c>();
	 	public TestSettings(){
	 		File__c[] cd = [select Id from File__c];
			delete cd;
			ContentWorkspace cw = new ContentWorkspace();
					contentDescriptionList = new File__c[]{
 					Test_Helper.testInsertFile(),
 					Test_Helper.testInsertFile(),
 					Test_Helper.testInsertFile(),
 					Test_Helper.testInsertFile(),
 					Test_Helper.testInsertFile(),
 					Test_Helper.testInsertFile(),
 					Test_Helper.testInsertFile()
 				};
	 	}
	}
	static testmethod void testCleanContentVersion1(){
		TestSettings ts = new TestSettings();
 		
 		Test.StartTest();
 		Integer iCount = 0;
 		List<File__c> allFiles = new List<File__c>();
 		List<Id> cvIds = new List<Id>();
 		for(File__c  f : ts.contentDescriptionList){
 			if(iCount > 2){
	 			//f.Content_Version_Id__c = '';
	 			allFiles.add(f);
 			}else{
 				cvIds.add(f.Content_Version_Id__c);
 			}
 			iCount++;
 		}
 		update allFiles;
 		try{
 			List<ID> docIds = new List<ID>();
 			for(ContentVersion cv : [Select Id, ContentDocumentId From ContentVersion Where Id IN:cvIds]){
 				docIds.add(cv.ContentDocumentId);
 			}
 			delete [Select Id from ContentDocument Where Id IN :docIds ];
 		}catch(Exception e){
 		}
 		
 		
 		CleanContentVersion2 jobToDo = new CleanContentVersion2();
		Database.executeBatch(jobToDo);
 		
		Test.StopTest();
		
		System.AssertNotEquals(
           database.countquery('SELECT COUNT()'
              +' from File__c'),
           7);  
          
    /*    Set<Id> tsSet = new Set<Id>();
        tsSet.add(ts.contentDescriptionList[0].Id); 
        tsSet.add(ts.contentDescriptionList[1].Id); 
        tsSet.add(ts.contentDescriptionList[2].Id); 
        tsSet.add(ts.contentDescriptionList[3].Id); 
        tsSet.add(ts.contentDescriptionList[4].Id);
        tsSet.add(ts.contentDescriptionList[5].Id); 
        tsSet.add(ts.contentDescriptionList[6].Id);  
        
        File__c[] cds = [select Id from File__c Where Id In :tsSet];
		delete cds;*/
	}
}