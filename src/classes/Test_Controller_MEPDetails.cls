/*******************************************************************************

Updated By	: Vikash Goyal (Appirio JDC)
Date        : 02/03/2014
Story/Task  : Code Coverage and Data Cleanup
*******************************************************************************/
@isTest
private class Test_Controller_MEPDetails {
	
	 class TestSettings {
	  	 Contact contact;
         Account account;
         User user;
         Brand__c brand;
         Calendar__c calendar;
         Content_Description__c[] contentDescriptionList;
         Content_Property__c[] contentPropertyList;
         
         String baseDate;
         
         public TestSettings(){
         		account = Test_Helper.testInsertAccount('test_account1');
         		contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
         		        
        		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];   
        		System.runAs (thisUser) {
         			user = Test_Helper.testInsertDistributorPortalUser(contact.id);
        		}
         		brand = Test_Helper.testInsertBrand('brand1');
         		
         		calendar = Test_Helper.testInsertCalendar('calendar1', 'Distribution', 'GLBT', '1', 'description1', date.valueOf('2011-11-1'), date.valueOf('2011-11-10'), false, true);        		
         		
         		Test_Helper.testInsertAccountBrand(account.id, brand.id);
 				Test_Helper.testInsertCalendarBrand(calendar.id, brand.id);
 				
 				/*contentDescriptionList = new Content_Description__c[]{
 					Test_Helper.testInsertContentDescriptionExtended('title1'),
 					Test_Helper.testInsertContentDescriptionExtended('title2'),
 					Test_Helper.testInsertContentDescriptionExtended('title3'),
 					Test_Helper.testInsertContentDescriptionExtended('title4'),
 					Test_Helper.testInsertContentDescriptionExtended('title5'),
 					Test_Helper.testInsertContentDescriptionExtended('title6'),
 					Test_Helper.testInsertContentDescriptionExtended('title7')
 				};*/
 				
 				contentDescriptionList = Test_Helper.testInsertContentDescriptionExtended(new List<String>
 										{'title1','title2','title3','title4','title5','title6','title7'});				
 				
 				contentPropertyList = new Content_Property__c[]{
 					Test_Helper.testCreateContentProperty('property1', calendar.id, contentDescriptionList[0].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.VIDEOS_AND_MEDIA, 'PR', null),
 					Test_Helper.testCreateContentProperty('property2', calendar.id, contentDescriptionList[1].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.VIDEOS_AND_MEDIA, 'PR', null),
 					Test_Helper.testCreateContentProperty('property3', calendar.id, contentDescriptionList[2].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.SELL_SHEETS, 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property4', calendar.id, contentDescriptionList[3].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.SELL_SHEETS, 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property5', calendar.id, contentDescriptionList[4].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.SELL_SHEETS, 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property6', calendar.id, contentDescriptionList[5].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.OTHERS, 'PR', null),
 					Test_Helper.testCreateContentProperty('property7', calendar.id, contentDescriptionList[6].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.OTHERS, 'PR', null),
 					Test_Helper.testCreateContentProperty('property8', calendar.id, contentDescriptionList[1].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.OTHERS, 'PR', null),
 					Test_Helper.testCreateContentProperty('property9', calendar.id, contentDescriptionList[2].Id, Constant.MONTHLY_EXECUTION_PLAN, Constant.OTHERS, 'PR', null)
 				};
 				insert contentPropertyList;
         }
         
         public void insertContentBrands(){
         	List<ContentBrand__c> lstContentBrands = new List<ContentBrand__c>();
         	for(Content_Description__c cont : contentDescriptionList){
 				lstContentBrands.add(Test_Helper.testCreateContentBrand(cont.id, brand.id));
 			}
 			insert lstContentBrands;
         }
	 }
	 
	 static testmethod void testConstructor(){	 	
	 	PageReference pageRef = Page.MEPDetails;
        Test.setCurrentPage(pageRef);
        
        TestSettings ts = new  TestSettings();
	 	ts.insertContentBrands();
	 	
	 	List<Sections__c> lstSections = new List<Sections__c>();
	 	lstSections.add(Test_Helper.createSectionTab('MEP1', 'Spirits;Wine;Beer', null, 'Distribution',
    											'Monthly Execution Plan', 'General', 3));
  		lstSections.add(Test_Helper.createSectionTab('MEP2', 'Spirits;Wine;Beer', null, 'Distribution',
    											'Monthly Execution Plan', 'Media', 2));
        insert lstSections;
        
        ts.calendar.Logo_Image_Large__c = ts.contentDescriptionList[0].Id;
        update ts.calendar;
	 	
	 	ApexPages.currentPage().getParameters().put('date', '2011-10-1');
		ApexPages.currentPage().getParameters().put('time', '2');
		ApexPages.currentPage().getParameters().put('driver', 'Innovation');
		ApexPages.currentPage().getParameters().put('id', ts.calendar.id);
	 	
	 	Test.StartTest();
	 	System.RunAs(ts.user){
			Controller_MEPDetails c = new Controller_MEPDetails();
			System.assertEquals(ts.calendar.id, c.mepItem.id );
			System.assertEquals('11/1/2011 - 11/10/2011', c.dateDescription );
			System.assertEquals('Distribution', c.salesDriverDescription );
			System.assertEquals('description1', c.description );
			c.initTheme();
			System.assertEquals(c.contentHolderMap !=null,true);
			String folderID = c.goalsFolderId;
	 	}
	 	Test.StopTest();
		
		
	 }
	 
	 static testmethod void testResponsiveSite(){
	   PageReference pgRef = Page.R_MEPDetails;
	   Test.setCurrentPage(pgRef);
	   
	   TestSettings ts = new  TestSettings();
	 	ts.insertContentBrands();
	 	
	 	List<Sections__c> lstSections = new List<Sections__c>();
	 	lstSections.add(Test_Helper.createSectionTab('MEP1', 'Spirits;Wine;Beer', null, 'Distribution',
    											'Monthly Execution Plan', 'General', 3));
  		lstSections.add(Test_Helper.createSectionTab('MEP2', 'Spirits;Wine;Beer', null, 'Distribution',
    											'Monthly Execution Plan', 'Media', 2));
        insert lstSections;
        
        ts.calendar.Logo_Image_Large__c = ts.contentDescriptionList[0].Id;
        update ts.calendar;
                
	 	ApexPages.currentPage().getParameters().put('date', '2011-10-1');
		ApexPages.currentPage().getParameters().put('time', '2');
		ApexPages.currentPage().getParameters().put('driver', 'Innovation');
		ApexPages.currentPage().getParameters().put('id', ts.calendar.id);
	 	
	 	Test.StartTest();
	 	System.RunAs(ts.user){
			Controller_MEPDetails c = new Controller_MEPDetails();
			System.assertEquals(ts.calendar.id, c.mepItem.id );
			System.assertEquals('11/1/2011 - 11/10/2011', c.dateDescription );
			System.assertEquals('Distribution', c.salesDriverDescription );
			System.assertEquals('description1', c.description );
			c.initTheme();
			System.assertEquals(c.contentHolderMap !=null,true);
			c.renderAsListSlider();
				c.renderAsBoxSlider();
	 	}
	 	Test.StopTest();	 	
	 	
	 }
	 
	 static testmethod void testExceptions(){
	   PageReference pgRef = Page.R_MEPDetails;
	   Test.setCurrentPage(pgRef);
	   
	   TestSettings ts = new  TestSettings();
	 	ts.insertContentBrands();
	 	
	 	List<Sections__c> lstSections = new List<Sections__c>();
	 	lstSections.add(Test_Helper.createSectionTab('MEP1', 'Spirits;Wine;Beer', null, 'Distribution',
    											'Monthly Execution Plan', 'General', 3));
  		lstSections.add(Test_Helper.createSectionTab('MEP2', 'Spirits;Wine;Beer', null, 'Distribution',
    											'Monthly Execution Plan', 'Media', 2));
        insert lstSections;
        
        try{
          Controller_MEPDetails ctrl = new Controller_MEPDetails();
        }
        catch(Exception e){
          
        }	 	
	 }

}