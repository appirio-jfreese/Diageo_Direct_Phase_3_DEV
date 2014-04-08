@isTest(SeeAllData=false) 
private class TestController_NACcopyExistingProperties {
    static testMethod void testcpSearchMethod() {
    	
    	Master_Recipe__c master = new Master_Recipe__c();
	    insert master;
	    
		Recipe__c recipe = new Recipe__c();
		recipe.Master_Recipe__c=master.Id;
		recipe.Recipe_Title__c = 'TESTfdfdf Recipe PREP STEPS';
		recipe.Locale__c = 'EN-US';
		recipe.Preparation_Steps__c='TEST PREP STEPS';
		insert recipe;
		MM_MediaController controller = new MM_MediaController (recipe.Id);     
        controller.editMode = 'false';
	 
	   
		ContentVersion myImage = new ContentVersion();
	 	myImage.title='tt88LOGO CAL-lg.png'; 
	 	//myImage.contentUrl='http://www.salesforce.com'; 		
 		myImage.VersionData = Blob.valueOf('iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==');
	  	myImage.FirstPublishLocationId =UserInfo.getUserId();
 		myImage.PathOnClient = 'test88Ciroc - LOGO CAL-lg.png';
	    insert myImage;
	    
	    System.debug('test11'+[SELECT Id FROM Content_Description__c]);
		Content_Description__c cd = new Content_Description__c();
		cd.name = myImage.title;
        cd.Title__c              = myImage.title;
        cd.Description__c        = myImage.Description;
        cd.Content_Version_Id__c = myImage.Id;
        cd.Content_ID__c         = myImage.ContentDocumentId;
        cd.filetype__c           = 'PNG';
        //cd.Image_Resolution__c   = myImage.Image_Resolution__c;
        cd.Portfolio__c          = myImage.Portfolio__c;
        //cd.TBA__c                = myImage.TBA__c;
        //cd.Tags__c				  = myImage.TagCsv;
        //cd.RTS__c				  = myImage.RTS__c;
        //cd.Matrix_type__c		  = myImage.Matrix_type__c;
        //cd.Uploaded_date__c	  = myImage.LastModifiedDate;
		cd.Classification__c	  = myImage.Classification__c;
                    
                    
        insert cd;
	    
 		controller.myImage=myImage;
	    controller.upload();
    	Recipe_Media__c media = new Recipe_Media__c();
 	    media.Content_id__c=myImage.Id;
      	insert media;

		controller.loadAllImages();
		
    	
    	Calendar__c cal = new Calendar__c();
		cal.Name = 'Test NACcopyExisting Cal';
		cal.Sales_Channel__c = 'On Premise';
		cal.Start_Date__c = System.today();
		cal.End_Date__c = System.today().addMonths(1);
		cal.Description__c = 'Test Description';
		insert cal;
		
		Content_Property__c cp = Test_Helper.testInsertContentProperty('Test NACcopyExisting',cal.Id,cd.Id,'Selling Materials','Quarterly Selling Materials','Program Selling Materials','Selling Deck');
		
        Test.StartTest();
 		
 		PageReference pageRef = Page.NACcopyExistingProperties;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('calId', cal.Id);
        
        Controller_NACcopyExistingProperties obj = new Controller_NACcopyExistingProperties();
        obj.tempCp.Name = 'Test NACcopyExisting';
        obj.tempCp.Category__c = 'Selling Materials';
        obj.tempCp.Sub_Category__c = 'Quarterly Selling Materials';
        obj.tempCp.Sub_Sub_Category__c = 'Program Selling Materials';
        obj.tempCp.Sub_Sub_Sub_Category__c = 'Selling Deck';
        Controller_NACcopyExistingProperties.CPWrapper w = new Controller_NACcopyExistingProperties.CPWrapper(true,cp,cp);
        obj.cpSearch();
        obj.cpCopy();
        Test.stopTest();
   }
   
   static testMethod void testcpSearchMethod1() {
   		Calendar__c cal = new Calendar__c();
		cal.Name = 'Test NACcopyExisting Cal';
		cal.Sales_Channel__c = 'On Premise';
		cal.Start_Date__c = System.today();
		cal.End_Date__c = System.today().addMonths(1);
		cal.Description__c = 'Test Description';
		insert cal;
		 
        Test.StartTest();
 		
 		PageReference pageRef1 = Page.NACcopyExistingProperties;
        Test.setCurrentPage(pageRef1);
        Controller_NACcopyExistingProperties obj1 = new Controller_NACcopyExistingProperties();
        obj1.cpSearch();
        obj1.cpCopy();
        Test.stopTest();
   }
}