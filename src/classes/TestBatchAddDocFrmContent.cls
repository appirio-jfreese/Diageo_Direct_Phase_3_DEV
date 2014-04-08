@isTest(SeeAllData=false) 
private class TestBatchAddDocFrmContent {
    static testMethod void testBatchAddDocFrmContentMethod() {
    	
    	
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
		
		
		
		System.debug('test11'+[SELECT Id,Name,filetype__c,Content_Version_Id__c FROM Content_Description__c]);
        String query = 'Select c.share_link_low__c, c.share_link__c, c.filetype__c, c.filesize_low__c, c.filesize__c, c.Video_Id__c, c.Uploaded_date__c,'+
   	   'c.Title__c, c.Title_Display__c, c.Tags__c, c.TBA__c, c.TBA_Display__c, c.SystemModstamp, c.RTS__c, c.RTS_Display__c, c.Preview_Id__c,'+ 
   	   'c.Preview_Available__c, c.Portfolio__c, c.Portfolio_Display__c, c.OwnerId, c.Name, c.Matrix_type__c, c.Matrix_Type_Display__c, '+
   	   'c.LastModifiedDate, c.LastModifiedById, c.LastActivityDate, c.Is_Video__c, c.IsDeleted, c.Innovation__c, c.Image_Resolution__c,'+
   	   'c.Image_Resolution_Display__c, c.Id, c.Document_Id__c, c.Description__c, c.Description_Display__c, c.CreatedDate, c.CreatedById,'+
   	   'c.Content_Version_Id__c, c.Content_Version_Id_Low__c, c.Content_ID__c, c.Content_ID_Low__c, c.ConnectionSentId, c.ConnectionReceivedId,'+
   	   'c.Classification__c, c.Classification_Display__c From Content_Description__c c where c.Content_Version_Id__c != null ' +
		'and Content_Version_Id__c != \'\' and (name like \'%LOGO CAL-lg%\' or name like \'%LOGO CAL-sm%\' )';
        Test.startTest();
        
        //System.debug('query'+ Database.query(query));
        ID batchprocessid = Database.executeBatch(new BatchAddDocFrmContent(query));       
        System.assertEquals(batchprocessid,batchprocessid);
        Test.stopTest();
   }
}