/*-----------------------------------------------------------------------------------------------------------------
Name        : MM_BrandMediaController

Created By  : Rahul Mittal (Appirio India)
Date        : 18th Feb. 2014
Task  		: Controller class for MM_BrandMedia page
-------------------------------------------------------------------------------------------------------------------*/
public class MM_BrandMediaController extends MM_RecipeBase {

    public ContentVersion myImage {get;set;}
    public String imageName {get; set; }
    public Diageo_Brand__c recipeBrand {get; set;}
    public Diageo_Product__c recipeProduct {get; set;}
    public List<Recipe_Media__c> mediaList {get; set;}
    public String redirect {get; set;}
    public PageReference pageRef {get; set;}
    public Boolean uploadMediaMode{get;set;}
    public Boolean selectMediaMode{get;set;}
    public String currentImageId {get;set;}
    public String imageNameFilter {get;set;}

    public String currentImageName {get;set;}
    public string selectedAlphabet{get;set;}
    public string currentAlpha{get;set;}

    transient map<Id,Recipe_Media__c> mediaMap {get;set;}

    //Maintains the status of edit mode
    public String editMode {get;set;}
    //Maintains the already present image
    String alreadyPresentImage;

    public MM_BrandMediaController(String brandId, String productId) {
        selectedAlphabet = 'A';
        processMediaController(brandId, productId);
    }

    public MM_BrandMediaController(){
        selectedAlphabet = 'A';
        String brandId = ApexPages.currentPage().getParameters().get('brandId');
        String productId = ApexPages.currentPage().getParameters().get('productId');
        editMode = ApexPages.currentPage().getParameters().get('editMode');
        processMediaController(brandId, productId);
    }

    private void processMediaController (String brandId, String productId) {
        myImage = new ContentVersion();
        try {
        	if(brandId != null && brandId != '') {
        		recipeBrand = [Select Id, Name, Category__c, Brand_Image__c, Brand_Image__r.Content_Id__c, Generic_Brand__c, Locale__c,
								SAP_Level_3_Code__c, SAP_Level_3_Descr__c, Diageo_Brand_Tags__c, Short_Description__c,
								Long_Description__c
								From Diageo_Brand__c
								Where Id = :brandId ];

        		pageRef = new PageReference('/apex/MM_RecipeBrand?editMode='+editMode+'&id=' + recipeBrand.Id);
	        	redirect = '/apex/MM_RecipeBrand?id=' + recipeBrand.Id;
        	}else if(productId != null && productId != '' ) {
        		recipeProduct = [Select Id, Name, Diageo_Brand_Id__c, Diageo_Brand_Id__r.Name,
								Category__c, Diageo_Product_Image__c, Diageo_Brand_Id__r.Locale__c,
								SAP_Level_5_Descr__c, Diageo_Product_Tags__c, Short_Description__c, Long_Description__c
								From Diageo_Product__c
								Where Id = :productId ];

        		pageRef = new PageReference('/apex/MM_RecipeBrandProduct?editMode='+editMode+'&id=' + recipeProduct.Id);
	        	redirect = '/apex/MM_RecipeBrandProduct?id=' + recipeProduct.Id;
        	}

	        //Set up the already present Images
	    	alreadyPresentImage = 'brandImage';

	        loadMediaMap();
	        if (recipeBrand != null && recipeBrand.Brand_Image__c != null) {
	            currentImageId = mediaMap.get(recipeBrand.Brand_Image__c).Content_Id__c;
	        }else if(recipeProduct != null && recipeProduct.Diageo_Product_Image__c != null) {
	            currentImageId = mediaMap.get(recipeProduct.Diageo_Product_Image__c).Content_Id__c;
	        }

        } catch (exception e) {
            System.debug(e);
        }

        myImage = new ContentVersion();
    }

    public PageReference loadAllImages () {
        mediaList = [Select Version_Number__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Image__c, Id,
                    File_Type__c, CreatedDate, CreatedById, Content_id__c, Content_URL__c, Content_Display_ID__c, Available__c
               From Recipe_Media__c where Name like 'A%' order by Name ASC limit 999];

        loadMediaMap();

        return null;
    }

    private void loadMediaMap () {
         mediaMap = new Map<Id,Recipe_Media__c>([Select Version_Number__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Image__c, Id,
            File_Type__c, CreatedDate, CreatedById, Content_id__c, Content_URL__c, Content_Display_ID__c, Available__c
            From Recipe_Media__c order by Name ASC]);
    }

    public PageReference upload(){
        PageReference pageRef = null;

        try {
            System.debug('*** Upload Invoked*** myImage.PathOnClient' + myImage.PathOnClient);
            if (myImage.PathOnClient != null){
            	  //myImage.FirstPublishLocationID = '058Z000000006H3'; //workspace Id of Drink Image Workspace
                List<ContentWorkspace> lstCW = [SELECT DefaultRecordTypeId, Id, Name FROM ContentWorkspace WHERE Name = 'Drink Image Workspace']; //workspace Id of Drink Image Workspace
                //system.assert(lstCW.isEmpty(),'Entry missing for Drink Image Workspace in ContentWorkspace!!');
                if(!lstCW.isEmpty()) {
	                myImage.FirstPublishLocationID = lstCW.get(0).Id;
	                myImage.Title=currentImageName;
	                insert myImage;
	                ContentVersion c = [select id,contentDocumentId,Title,VersionNumber,FileType from ContentVersion where id=: myImage.Id];

	                Recipe_Media__c newMedia = new Recipe_Media__c();
	                newMedia.Content_Display_ID__c = c.ContentDocumentId;
	                newMedia.Content_id__c = c.Id;
	                newMedia.Name = c.Title;
	                newMedia.Available__c = 'TRUE';
	                newMedia.File_Type__c = c.FileType;
	                newMedia.Version_Number__c = c.VersionNumber;
	                insert newMedia;

	                System.debug('*** Image inserted');
	                String imageId=myImage.Id;


	                loadAllImages();
	                Recipe_Media__c media = [Select Id from Recipe_Media__c where Content_Id__c = :imageId];
	                System.debug('*** Associating with: '+media.Id);

	                mediaId = media.Id;
	                associateMedia();
              }
              else {
              	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'ContentWorkspace entry for \'Drink Image Workspace\' is missing!!'));
              }
            }
        } catch (Exception e){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        finally{
                myImage = new ContentVersion();
        }
        return pageRef;
    }

    public String mediaId {
        get;
        set {
            this.mediaId = value;
            System.debug('setting mediaId: ' + value);
        }
    }

    public PageReference associateMedia(){
    	if(recipeBrand != null) {
    		recipeBrand.Brand_Image__c = setImage(recipeBrand.Brand_Image__c, 'brandImage');
    	}else if(recipeProduct != null){
    		recipeProduct.Diageo_Product_Image__c = setImage(recipeProduct.Diageo_Product_Image__c, 'brandImage');
    	}

        Recipe_Media__c recipeMedia = this.getRecipeMedia(mediaId);
        currentImageId = recipeMedia.Content_id__c;

        return null;
    }

    public PageReference disassociateMedia () {
    	if(recipeBrand != null) {
    		recipeBrand.Brand_Image__c = removeImage(recipeBrand.Brand_Image__c, 'brandImage');
    	}else if(recipeProduct != null){
    		recipeProduct.Diageo_Product_Image__c = removeImage(recipeProduct.Diageo_Product_Image__c, 'brandImage');
    	}

        return null;
    }

    //For all image fields in which there is a value, lock the selection and do not allow the user to change it.
    //If the image field is blank, allow the user to add an image.
    private String setImage(String fieldValue, String fieldName) {
    	if(editMode.equals('false') && alreadyPresentImage == fieldName) {
    		return fieldValue;
    	}else{
    		return mediaId;
    	}
    }

    //For all image fields in which there is a value, lock the selection and do not allow the user to change/remove it.
    private String removeImage(String fieldValue, String fieldName) {
    	if(editMode.equals('false') && alreadyPresentImage == fieldName) {
    		return fieldValue;
    	}else{
    		currentImageId = '';
    		return null;
    	}
    }

    public Recipe_Media__c getRecipeMedia(String mediaId) {
        try {  return [Select Version_Number__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Image__c, Id, File_Type__c, CreatedDate, CreatedById, Content_id__c, Content_URL__c, Content_Display_ID__c, Available__c
             From Recipe_Media__c where Id = :mediaId];
        }
        Catch (Exception e) {
            return null;
        }

    }

    public PageReference saveImages () {
    	if(recipeBrand != null) {
    		recipeBrand.Brand_Image__c = mediaId;
        	upsert recipeBrand;
    	}else if(recipeProduct != null){
    		recipeProduct.Diageo_Product_Image__c = mediaId;
    		upsert recipeProduct;
    	}
        return null;
    }


    public PageReference close(){
    	PageReference pageRef = null;
    	if(recipeBrand != null) {
    		pageRef = new PageReference('/apex/MM_RecipeBrand?editMode='+editMode+'&id=' + recipeBrand.Id);
    	}else if(recipeProduct != null) {
    		pageRef = new PageReference('/apex/MM_RecipeBrandProduct?editMode='+editMode+'&id=' + recipeProduct.Id);
    	}
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference filterImages () {
        if(imageNameFilter != null && imageNameFilter.trim()!= ''){

        String filterClause = '%'+imageNameFilter+'%';
        mediaList = [Select Version_Number__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Image__c, Id,
                    File_Type__c, CreatedDate, CreatedById, Content_id__c, Content_URL__c, Content_Display_ID__c, Available__c
               From Recipe_Media__c where Name like :filterClause order by Name ASC limit 999];
        }
        else{

            system.debug('@@@@@@@@@@@@@@@@@306 Current Alphabet@@@@@@@@@@@@@@'+selectedAlphabet);
            string currentAlphabet;
            if(selectedAlphabet != null && selectedAlphabet.trim()!=''){
                system.debug('@@@@@@@@@@@@@@@@@309 Selected Alphabet@@@@@@@@@@@@@@'+selectedAlphabet);
                currentAlphabet = selectedAlphabet;
                currentAlpha = selectedAlphabet;
            }
            else{
                system.debug('@@@@@@@@@@@@@@@@@314 Else Loop Current Alphabet@@@@@@@@@@@@@@'+selectedAlphabet);
                currentAlphabet = 'A';
                currentAlpha = 'A';
            }

            currentAlphabet = ''+currentAlpha+'%';
            mediaList = [Select Version_Number__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Image__c, Id,
                    File_Type__c, CreatedDate, CreatedById, Content_id__c, Content_URL__c, Content_Display_ID__c, Available__c
                    From Recipe_Media__c where Name like:currentAlphabet order by Name ASC limit 999];

        }
        return null;
    }

    public String getUserAgent() {
        return ApexPages.currentPage().getHeaders().get('User-Agent');
    }

    //returns the list of alphabets to display on to the screen.
    private list<string> alphaSet = new list<string>();
    public list<string> getAlphabets(){
        alphaSet.clear();
            alphaSet.add('A');
            alphaSet.add('B');
            alphaSet.add('C');
            alphaSet.add('D');
            alphaSet.add('E');
            alphaSet.add('F');
            alphaSet.add('G');
            alphaSet.add('H');
            alphaSet.add('I');
            alphaSet.add('J');
            alphaSet.add('K');
            alphaSet.add('L');
            alphaSet.add('M');
            alphaSet.add('N');
            alphaSet.add('O');
            alphaSet.add('P');
            alphaSet.add('Q');
            alphaSet.add('R');
            alphaSet.add('S');
            alphaSet.add('T');
            alphaSet.add('U');
            alphaSet.add('V');
            alphaSet.add('W');
            alphaSet.add('X');
            alphaSet.add('Y');
            alphaSet.add('Z');

            return alphaSet;
    }
}