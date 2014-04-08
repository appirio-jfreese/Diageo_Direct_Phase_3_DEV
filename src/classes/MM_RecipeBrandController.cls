/*-----------------------------------------------------------------------------------------------------------------
Name        : MM_MasterRecipeController

Created By  : Rahul Mittal (Appirio India)
Date        : 13th Feb. 2014
Task  		: Controller class for MM_RecipeBrand page
-------------------------------------------------------------------------------------------------------------------*/
public class MM_RecipeBrandController extends MM_RecipeBase{
	public String brandId {get; set;}
	public String locale {get; set;}
	public Diageo_Brand__c recipeBrand {get; set;}
    public Boolean isClone {get; set;}
	public Boolean editMode {get; set;}
	public Boolean isCreateNew {get; set;}
	public String cssStatus {get; set;}
	public string errorMessage{get;set;}
	public List<Diageo_Product__c> recipeBrandProducts {get; set;}
	public BrandImageWrapper brandImageWrapper {get; set; }
	public Id swapId {get; set;}
	public boolean showManageImages{get;set;}

	//Constructor
	public MM_RecipeBrandController(ApexPages.StandardController controller) {

		brandId = (String)controller.getId();

		editMode = ApexPages.currentPage().getParameters().get('editMode') == 'true' ? true : false;
		isClone = ApexPages.currentPage().getParameters().get('isClone') == 'true' ? true : false;
		locale = ApexPages.currentPage().getParameters().get('Locale');

		swapId = null;
		showManageImages = false;
		recipeBrandProducts = new List<Diageo_Product__c>();
		init();

		if(isClone) {
			cssStatus = 'draft';
			editMode = true;
			isCreateNew = true;
			recipeBrand = cloneRecipeBrand();
			recipeBrandProducts = new List<Diageo_Product__c>();
		}
	}

	public Diageo_Brand__c cloneRecipeBrand() {
		Diageo_Brand__c cloneBrand = new Diageo_Brand__c();
		cloneBrand = recipeBrand.clone();
		return cloneBrand;
	}

	/*public MM_RecipeBrandController() {
		brandId = ApexPages.currentPage().getParameters().get('brandId');
	}*/

	//Method to inilialize the all attributes
	private void init() {
		if(brandId != null && brandId != '') {
			recipeBrand = [Select Id, Name, Category__c, Brand_Image__c, Brand_Image__r.Content_Id__c, Generic_Brand__c, Locale__c,
							SAP_Level_3_Code__c, SAP_Level_3_Descr__c, Diageo_Brand_Tags__c, Short_Description__c,
							Long_Description__c
							From Diageo_Brand__c
							Where Id = :brandId ];

			recipeBrandProducts = [Select Id, Name, Diageo_Brand_Id__c, Diageo_Brand_Id__r.Name, Available__c, Units__c, Locale__c,
									Category__c, Diageo_Product_Image__c, Alcoholic__c, SAP_Level_5_Code__c,Diageo_Brand_Id__r.Locale__c,
									SAP_Level_5_Descr__c, Diageo_Product_Tags__c, Short_Description__c, Long_Description__c
									From Diageo_Product__c
									Where Diageo_Brand_Id__c = :brandId];

			cssStatus = 'draft';
			isCreateNew = false;
			if(recipeBrand.Brand_Image__c != null) {
				brandImageWrapper = new BrandImageWrapper('Brand Image', recipeBrand.Brand_Image__r.Content_Id__c);
				swapId = brandImageWrapper.contentId;
			}

		} else {
			recipeBrand = new Diageo_Brand__c();
			cssStatus = 'draft';
			editMode = true;
			isCreateNew = true;
			showManageImages = false;
			recipeBrand.Locale__c = locale != null ? locale : 'EN-US';
		}

		if(brandId != null && brandId != '' && editMode) {
			showManageImages = true;
		}
	}

	public String getUserAgent() {
	 	return ApexPages.currentPage().getHeaders().get('User-Agent');
	}

	//Method to open brand page on edit mode
	public PageReference editBrand() {
      editMode = true;
      PageReference pageRef = new PageReference('/apex/MM_RecipeBrand?Id=' + brandId + '&editMode=true');
      pageRef.setRedirect(true);
      return pageRef;
   }

	//Method to add error in string and display on page
	public void addError(String msg) {
		if(errorMessage == null) {
           errorMessage = 'Error: ';
           errorMessage += msg;
        } else  {
           errorMessage +='; ';
           errorMessage+= msg;
       }
	}

	//Method to redirect the page in ready only mode if cancel is clicked
	public PageReference cancelEdit() {
		PageReference pageRef;
		if(brandId != null && brandId != '') {
			pageRef = new PageReference('/apex/MM_RecipeBrand?id=' + brandId);
		}else {
			pageRef = new PageReference('/apex/MM_RecipeBrand');
		}

		pageRef.setRedirect(true);
        return pageRef;
	}

	//Method to save the Recipe_Brand record and redirect to the detail page
    public PageReference saveBrand() {
        errorMessage=null;
        if(recipeBrand.Name == null || recipeBrand.Name == '') {
            addError('Recipe Brand Name required');
            return null;
        } else {
            try {
			    upsert recipeBrand;
			    editMode = false;
				//if (brandId == null)
				brandId = recipeBrand.Id;
			    PageReference pageRef1 = new PageReference('/apex/MM_RecipeBrand?id=' + brandId);
			    pageRef1.setRedirect(true);
			    return pageRef1;
            } catch(Exception e) {
                String message = e.getMessage();
            }
        }
        return null;
    }

	//Method to open a Recipe_Product page to add a new product
    public PageReference addAProduct() {
    	PageReference pageRef;
		pageRef = new PageReference('/apex/MM_RecipeBrandProduct?brandId=' + brandId);
		pageRef.setRedirect(true);
        return pageRef;
    }

	//Method to check whether the recipeBrand has already image or not
    public Boolean getHasImages() {
        if (brandImageWrapper != null)
         return true;
      return false;
    }

	//Method to save the Recipe_Brand record on loading image page
    public PageReference upsertTempRecipeBrand() {
        try{
            upsert recipeBrand;
        } catch(DMLException e) {
            String message = e.getMessage();
            system.debug('===========message===============' + message);
      }
      return null;
    }

    //Brand Image Wrapper
	public class BrandImageWrapper{
	    public string imageType{get;set;}
	    public id contentId{get;set;}
	    public BrandImageWrapper(String iType, Id CId) {
	        this.imageType = iType;
	        this.contentId = cId;
	    }
	}
}