/*************************************************************
Name        : APPIRIO_WSCallMultiImages_JSON_Test
Updated By  : Appirio Offshore(Rishi Khirbat)
Date        : 28th Dec, 2014
Purpose     : Test Class for
				- APPIRIO_GenerateXMLRecipeIinfoDemoCon
*************************************************************/
@isTest(SeeAllData=false)
private class APPIRIO_WSCallMultiImages_JSON_Test {

	//variable declaration
	static ContentVersion contentVersion;
	static Publishing_API_User_Setting__c setting;

	static {
		if(Publishing_API_User_Setting__c.getAll().size() > 0) {
	      	setting = Publishing_API_User_Setting__c.getAll().values()[0];
	    } else {
	    	setting = new Publishing_API_User_Setting__c();
	      	setting.Name = 'publishingapiuser';
	      	setting.API_Header_Value__c = 'verified';
	      	setting.Message__c = 'Access denied. Not a verified user.';
	      	insert setting;
	    }

		contentVersion = TestUtil.testInsertDrinkImageContent('Google.com');
		contentVersion = [Select Id, Title, FileType,  ContentDocumentId, VersionData From ContentVersion Where Id =: contentVersion.Id];
	}

	//Test Web Service Call multiple content images
    public static TestMethod void WebServiceCallMultipleImagesTest() {

    	Test.startTest();
	    	// set up the request object
	        System.RestContext.request = new RestRequest();
	        RestContext.request.requestURI = '/CallMultipleContentImagesJSON/';

	        // Invoke the method directly
	        //APPIRIO_WrapperUtility_JSON.Images responseResult
	        APPIRIO_WebServiceCallMultiImages_JSON.WebServiceCallMultipleImages();

	      	//System.assert(responseResult.Error != null);
		    //System.assert(responseResult.Error.ErrorMessage.contains(setting.Message__c));

		    //Added to check the publishingapiuser header in request
			System.RestContext.request.headers.put(setting.Name, setting.API_Header_Value__c);

	        // Invoke the method directly
	        APPIRIO_WebServiceCallMultiImages_JSON.WebServiceCallMultipleImages();
	        //System.assert(responseResult.Error.ErrorMessage.contains('ContentDisplayIDs cannot be blank.'));

	        RestContext.request.addParameter('ContentDisplayIDs',contentVersion.ContentDocumentId);
	    	APPIRIO_WebServiceCallMultiImages_JSON.WebServiceCallMultipleImages();

	    	/*System.assert(responseResult.Images.size() > 0);
	    	System.assertEquals(responseResult.Images[0].ContentDisplayID, contentVersion.ContentDocumentId);
	    	System.assertEquals(responseResult.Images[0].fileName, contentVersion.Title+'.'+contentVersion.FileType.toLowerCase());
	    	System.assertEquals(responseResult.Images[0].VersionData, EncodingUtil.base64Encode(contentVersion.VersionData));*/

        Test.stopTest();
	}
}