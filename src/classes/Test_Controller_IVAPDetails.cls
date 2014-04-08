/*******************************************************************************

Updated By	: Vikash Goyal (Appirio JDC)
Date        : 02/02/2014
Story/Task  : Code Coverage and Data Cleanup

Updated By	: Vikash Goyal (Appirio JDC)
Date        : 02/03/2014
Story/Task  : Code Coverage and Data Cleanup
*******************************************************************************/
@isTest
private class Test_Controller_IVAPDetails {
	
	 class TestSettings {
	  	 Contact contact;
         Account account;
         User user;
         Brand__c brand;
         Calendar__c calendarInnov;
         Calendar__c calendarSust;
         Calendar__c calendarVap;
         Calendar__c calendarPack;
         Content_Description__c[] contentDescriptionList;
         Content_Property__c[] contentPropertyList;
         
         String baseDate;
         
         public TestSettings(){
         		account = Test_Helper.testInsertAccount('test_account1');
         		contact = Test_Helper.testInsertContact('firstName', 'lastName', account.id);
         		user = Test_Helper.testInsertDistributorPortalUser(contact.id);
         		brand = Test_Helper.testInsertBrand('brand1');
         		
         		List<Calendar__c> lstCals = new List<Calendar__c>();
         		calendarInnov = Test_Helper.testCreateCalendar('calendar1', 'Innovation', 'GLBT', '1', 'description1', date.valueOf('2011-11-1'), date.valueOf('2011-11-10'), false, false);        		
         		calendarSust = Test_Helper.testCreateCalendar('calendar2', 'Sustainovation', 'GLBT', '1', 'description1', date.valueOf('2011-11-1'), date.valueOf('2011-11-10'), false, false);        		
         		calendarVap = Test_Helper.testCreateCalendar('calendar3', 'VAP', 'GLBT', '1', 'description1', date.valueOf('2011-11-1'), date.valueOf('2011-11-10'), false, false);        		
         		calendarPack = Test_Helper.testCreateCalendar('calendar4', 'Pack & Label Changes', 'GLBT', '1', 'description1', date.valueOf('2011-11-1'), date.valueOf('2011-11-10'), false, false);        		
         		lstCals.add(calendarInnov);
         		lstCals.add(calendarSust);
         		lstCals.add(calendarVap);
         		lstCals.add(calendarPack);
         		insert lstCals;
         		
         		Test_Helper.testInsertAccountBrand(account.id, brand.id);
         		
         		List<CalendarBrand__c> lstCalBrands = new List<CalendarBrand__c>();
 				lstCalBrands.add(Test_Helper.testCreateCalendarBrand(calendarInnov.id, brand.id, false));
 				lstCalBrands.add(Test_Helper.testCreateCalendarBrand(calendarSust.id, brand.id, false));
 				lstCalBrands.add(Test_Helper.testCreateCalendarBrand(calendarVap.id, brand.id, false));
 				lstCalBrands.add(Test_Helper.testCreateCalendarBrand(calendarPack.id, brand.id, false));
 				insert lstCalBrands;
 				
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
 					//innovation
 					Test_Helper.testCreateContentProperty('property1', calendarInnov.id, contentDescriptionList[0].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SELLING_MATERILAS, 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property2', calendarInnov.id, contentDescriptionList[1].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SELLING_MATERILAS, 'Preliminary Long Lead Deck', null),
 					Test_Helper.testCreateContentProperty('property3', calendarInnov.id, contentDescriptionList[2].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SELLING_MATERILAS, 'Launch Sell Sheet', null),
 					Test_Helper.testCreateContentProperty('property4', calendarInnov.id, contentDescriptionList[3].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SELLING_MATERILAS, 'Brand Fact Sheets', null),
 					Test_Helper.testCreateContentProperty('property1', calendarInnov.id, contentDescriptionList[4].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SELLING_MATERILAS, 'Business Card / Hot Sheet', null),
 					Test_Helper.testCreateContentProperty('property2', calendarInnov.id, contentDescriptionList[0].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.MARKETING_INFORMATION, 'Media', null),
 					Test_Helper.testCreateContentProperty('property3', calendarInnov.id, contentDescriptionList[1].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.MARKETING_INFORMATION, 'Marketing Deck', null),
 					Test_Helper.testCreateContentProperty('property3', calendarInnov.id, contentDescriptionList[2].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.MARKETING_INFORMATION, 'Retail Mailers', null),
 					Test_Helper.testCreateContentProperty('property3', calendarInnov.id, contentDescriptionList[3].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.MARKETING_INFORMATION, 'Trade Ads', null),
 					Test_Helper.testCreateContentProperty('property4', calendarInnov.id, contentDescriptionList[3].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.IMAGES, 'Drink Shots', null),
 					Test_Helper.testCreateContentProperty('property5', calendarInnov.id, contentDescriptionList[4].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.IMAGES, 'Logo Shots', null),
 					Test_Helper.testCreateContentProperty('property6', calendarInnov.id, contentDescriptionList[5].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.IMAGES, 'Product Shots', null),
 					Test_Helper.testCreateContentProperty('property6', calendarInnov.id, contentDescriptionList[5].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.IMAGES, 'Scannable UPC', null),
 					Test_Helper.testCreateContentProperty('property7', calendarInnov.id, contentDescriptionList[6].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SHIPPING_DETAILS, 'Samples', null),
 					Test_Helper.testCreateContentProperty('property8', calendarInnov.id, contentDescriptionList[1].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.FORECASTING, null, null),
 					Test_Helper.testCreateContentProperty('property9', calendarInnov.id, contentDescriptionList[2].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.FORECASTING, null, null),
 					Test_Helper.testCreateContentProperty('property10', calendarInnov.id, contentDescriptionList[3].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SUCCESS_STORIES, null, null),
 					Test_Helper.testCreateContentProperty('property11', calendarInnov.id, contentDescriptionList[4].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SUCCESS_STORIES, null, null),
 					Test_Helper.testCreateContentProperty('property12', calendarInnov.id, contentDescriptionList[5].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SUCCESS_STORIES, null, null),
 					Test_Helper.testCreateContentProperty('property13', calendarInnov.id, contentDescriptionList[6].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SUCCESS_STORIES, null, null),
 					//sustainovation
 					Test_Helper.testCreateContentProperty('property14', calendarSust.id, contentDescriptionList[0].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SELLING_MATERILAS, 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property15', calendarSust.id, contentDescriptionList[1].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.IMAGES, 'Drink Shots', null),
 					Test_Helper.testCreateContentProperty('property16', calendarSust.id, contentDescriptionList[2].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.IMAGES, 'Drink Shots', null),
 					//vap
 					Test_Helper.testCreateContentProperty('property17', calendarVap.id, contentDescriptionList[3].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SELLING_MATERILAS, 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property18', calendarVap.id, contentDescriptionList[4].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.IMAGES, 'Drink Shots', null),
 					Test_Helper.testCreateContentProperty('property19', calendarVap.id, contentDescriptionList[5].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.IMAGES, 'Drink Shots', null),
 					Test_Helper.testCreateContentProperty('property20', calendarVap.id, contentDescriptionList[6].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SHIPPING_DETAILS, 'Samples', null),
 					Test_Helper.testCreateContentProperty('property21', calendarVap.id, contentDescriptionList[0].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.FORECASTING, null, null),
 					Test_Helper.testCreateContentProperty('property22', calendarVap.id, contentDescriptionList[2].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.FORECASTING, null, null),
 					//pack
 					Test_Helper.testCreateContentProperty('property14', calendarPack.id, contentDescriptionList[2].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.SELLING_MATERILAS, 'Final Launch Deck', null),
 					Test_Helper.testCreateContentProperty('property15', calendarPack.id, contentDescriptionList[3].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.IMAGES, 'Drink Shots', null),
 					Test_Helper.testCreateContentProperty('property16', calendarPack.id, contentDescriptionList[4].Id, Constant.INNOVATION_AND_SUSTAINOVATION, Constant.IMAGES, 'Drink Shots', null)
 					
 				};
 				
 				insert contentPropertyList;
         }
         
         public void insertContentBrands(){
         	List<ContentBrand__c> lstContentBrand = new List<ContentBrand__c>();
         	for(Content_Description__c cont : contentDescriptionList){
 				Test_Helper.testCreateContentBrand(cont.id, brand.id);
 			}
 			insert lstContentBrand;
         }
	 }
	 
	 static testmethod void testInnovation(){
	 	User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( thisUser ) {
		 	PageReference pageRef = Page.IVAPDetails;
	        Test.setCurrentPage(pageRef);
	        
		 	TestSettings ts = new  TestSettings();
		 	Test.StartTest();
		 	ts.insertContentBrands();
		 	
		 	
		 	List<Sections__c> lstSections = new List<Sections__c>();
		 	lstSections.add(Test_Helper.createSectionTab('IVAP1', 'Spirits;Wine;Beer', null, 'Innovation',
	    											'Innovation, Sustainovation & Vintage Transition', 'Selling Materials', 1));
	  		lstSections.add(Test_Helper.createSectionTab('IVAP2', 'Spirits;Wine;Beer', null, 'Innovation',
	    											'Innovation, Sustainovation & VAP', 'Selling Materials', 1));
	        insert lstSections;
	        
	        ts.calendarInnov.Logo_Image_Large__c = ts.contentDescriptionList[0].Id;
            update ts.calendarInnov;
		 	
		 	ApexPages.currentPage().getParameters().put('date', '2011-11-1');
		 	ApexPages.currentPage().getParameters().put('time', '2');
			ApexPages.currentPage().getParameters().put('driver', 'Innovation');
		 	ApexPages.currentPage().getParameters().put('id', ts.calendarInnov.id);
		 	ApexPages.currentPage().getParameters().put('themetype1', 'Spirits');
		 	
		 	System.RunAs(ts.user){
		 		Controller_IVAPDetails c = new Controller_IVAPDetails();
		 		System.assertEquals(ts.calendarInnov.id, c.ivapItem.id );
		 		System.assertEquals('11/1/2011 - 11/10/2011', c.dateDescription );
				System.assertEquals('Innovation', c.salesDriverDescription );
				System.assertEquals('description1', c.description );
				System.assertEquals('calendar1', c.breadCrumbLinks[1].linkName );
				c.initTheme();
				System.assertEquals(c.detailsHolderMap !=null,true);
				c.renderAsListSlider();
				c.renderAsBoxSlider();
		 	}
		 	Test.stopTest();
		}
	 }
	 
	 static testmethod void testSustainovation(){
	 	User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( thisUser ) {
		 	PageReference pageRef = Page.IVAPDetails;
	        Test.setCurrentPage(pageRef);
	        
		 	TestSettings ts = new  TestSettings();
		 	Test.StartTest();
		 	ts.insertContentBrands();
		 	ApexPages.currentPage().getParameters().put('id', ts.calendarSust.id);
		 	ApexPages.currentPage().getParameters().put('themetype1', 'Spirits');
		 	
		 	System.RunAs(ts.user){
		 		Controller_IVAPDetails c = new Controller_IVAPDetails();
		 		System.assertEquals(ts.calendarSust.id, c.ivapItem.id );
		 		System.assertEquals('11/1/2011 - 11/10/2011', c.dateDescription );
				System.assertEquals('Sustainovation', c.salesDriverDescription );
				System.assertEquals('description1', c.description );
				System.assertEquals('calendar2', c.breadCrumbLinks[1].linkName );
				
		 	}
		 	Test.stopTest();
		}
	 }
	 
	  static testmethod void testVap(){
	  	User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( thisUser ) {
		  	PageReference pageRef = Page.IVAPDetails;
	        Test.setCurrentPage(pageRef);
	        
		 	TestSettings ts = new  TestSettings();
		 	Test.StartTest();
		 	ts.insertContentBrands();
		 	ApexPages.currentPage().getParameters().put('id', ts.calendarVap.id);
		 	ApexPages.currentPage().getParameters().put('date', '11/1/2011');
		 	ApexPages.currentPage().getParameters().put('themetype1', 'Spirits');
		 	
		 	System.RunAs(ts.user){
		 		Controller_IVAPDetails c = new Controller_IVAPDetails();
		 		System.assertEquals(ts.calendarVap.id, c.ivapItem.id );
		 		System.assertEquals('11/1/2011 - 11/10/2011', c.dateDescription );
				System.assertEquals('VAP', c.salesDriverDescription );
				System.assertEquals('description1', c.description );
				System.assertEquals('calendar3', c.breadCrumbLinks[1].linkName );
				//System.assertEquals(true,c.detailsHolderMap.size()>0);
		 	}
		 	Test.stopTest();
		}
	 }
	 
	 
	 static testmethod void testPack(){
	 	User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( thisUser ) {
		 	PageReference pageRef = Page.IVAPDetails;
	        Test.setCurrentPage(pageRef);
		 	TestSettings ts = new  TestSettings();
		 	Test.StartTest();
		 	ts.insertContentBrands();
		 			 	
		 	ApexPages.currentPage().getParameters().put('id', ts.calendarPack.id);
		 	ApexPages.currentPage().getParameters().put('themetype1', 'Spirits');
		 	
		 	System.RunAs(ts.user){
		 		Controller_IVAPDetails c = new Controller_IVAPDetails();
		 		System.assertEquals(ts.calendarPack.id, c.ivapItem.id );
		 		System.assertEquals('11/1/2011 - 11/10/2011', c.dateDescription );
				System.assertEquals('Pack & Label Changes', c.salesDriverDescription );
				System.assertEquals('description1', c.description );
				System.assertEquals('calendar4', c.breadCrumbLinks[1].linkName );
				
		 	}
		 	Test.stopTest();
		}
	 }
	 
	 static testmethod void testResponsive(){
	 	User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( thisUser ) {
		 	PageReference pageRef = Page.R_IVAPDetails;
	        Test.setCurrentPage(pageRef);
		 	TestSettings ts = new  TestSettings();
		 	Test.StartTest();
		 	ts.insertContentBrands();
		 	
		 	ts.calendarPack.Logo_Image_Large__c = ts.contentDescriptionList[0].Id;
            update ts.calendarPack;
		 	
		 	ApexPages.currentPage().getParameters().put('id', ts.calendarPack.id);
		 	ApexPages.currentPage().getParameters().put('themetype1', 'Spirits');
		 	
		 	System.RunAs(ts.user){
		 		Controller_IVAPDetails c = new Controller_IVAPDetails();
		 		System.assertEquals(ts.calendarPack.id, c.ivapItem.id );
		 		System.assertEquals('11/1/2011 - 11/10/2011', c.dateDescription );
				System.assertEquals('Pack & Label Changes', c.salesDriverDescription );
				System.assertEquals('description1', c.description );
				System.assertEquals('calendar4', c.breadCrumbLinks[1].linkName );
				
		 	}
		 	Test.stopTest();
		}
	 }
	 

}