/********************************************************************************************************************
Name        : APPIRIO_WebServiceCallMultiImages_JSON
Updated By  : Appirio Offshore(Rishi Khirbat)
Date        : 28th Dec, 2012
Purpose     : Create Web Service Call for return of multiple content images
Ref         :
********************************************************************************************************************/
@RestResource(urlMapping='/CallMultipleContentImagesJSON/*')
global with sharing class APPIRIO_WebServiceCallMultiImages_JSON {
    //Creating Web Service Call for return of multiple content images
    @HttpGet
    webservice static void WebServiceCallMultipleImages() {
        APPIRIO_WrapperUtility_JSON.Images responseResult = new APPIRIO_WrapperUtility_JSON.Images();
        APPIRIO_WrapperUtility_JSON.Error error;
        RestRequest req = RestContext.request;

        Publishing_API_User_Setting__c setting;
        if(Publishing_API_User_Setting__c.getAll().size() > 0) {
          setting = Publishing_API_User_Setting__c.getAll().values()[0];
        } else {
            error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('Publishing API User Setting is not defined', '');
            responseResult.Error = error;
            APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifierForImages(responseResult));
            return;
        }

        String publishingapiuser = req.headers.get(setting.Name);
        if(String.isNotBlank(publishingapiuser) && publishingapiuser.equalsIgnoreCase(setting.API_Header_Value__c)) {

            map<String,String> paramMap = req.params;
            //input parameter
            String ContentDisplayIDs = paramMap.get('ContentDisplayIDs');
            if(ContentDisplayIDs == null || ContentDisplayIDs.trim() == '') {
                error = APPIRIO_WrapperUtility_JSON.generateErrorResponse('ContentDisplayIDs cannot be blank.', '');
                responseResult.Error = error;
                APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifierForImages(responseResult));
                return;
            }

            set<String> ContentIDs = new set<String>();
            for(String str :ContentDisplayIDs.split(';')) {
                ContentIDs.add(str.trim());
            }

            //system.debug('========================ContentIDs: '+ContentIDs);
            List<ContentVersion> contentVersions = new List<ContentVersion>();
            //Query all ContentVersion records where ContentDocumentId = input parameter
            for(ContentVersion contentVersion :[Select FileType, VersionData, Title, ContentDocumentId From ContentVersion
                                                        Where ContentDocumentId IN :ContentIDs]) {
                contentVersions.add(contentVersion);
            }

            //images
            //APPIRIO_WrapperUtility_JSON.Images images = new APPIRIO_WrapperUtility_JSON.Images();
            //responseResult.Images = new List<APPIRIO_WrapperUtility_JSON.Image>();
            List<APPIRIO_WrapperUtility_JSON.Image> imageElems = new List<APPIRIO_WrapperUtility_JSON.Image>();

            for(ContentVersion contentVersion :contentVersions) {
                if(contentVersion.ContentDocumentId != null) {
                    //image
                    APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
                    image.ContentDisplayID = contentVersion.ContentDocumentId;
                    image.fileName = contentVersion != null && contentVersion.Title != null
                                                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';
                    image.VersionData = EncodingUtil.base64Encode(contentVersion.VersionData);
                    imageElems.add(image);
                    //end of image
                }
            }
            if(imageElems != null && imageElems.size() > 0) {
                responseResult.Images = imageElems;
            }

            //Return the JSON output.
            APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifierForImages(responseResult));
            return;
        } else {
            error = APPIRIO_WrapperUtility_JSON.generateErrorResponse(setting.Message__c, '');
            responseResult.Error = error;
            APPIRIO_WrapperUtility_JSON.validatedFormatterJSON(APPIRIO_WrapperUtility_JSON.getJSONStringifierForImages(responseResult));
            return;
        }
    }
}