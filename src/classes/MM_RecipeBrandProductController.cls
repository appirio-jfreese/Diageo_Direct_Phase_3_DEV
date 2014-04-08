/*-----------------------------------------------------------------------------------------------------------------
Name        : MM_RecipeBrandProductController

Created By  : Rahul Mittal (Appirio India)
Date        : 13th Feb. 2014
Task  		: Controller class for MM_RecipeBrandProduct page
-------------------------------------------------------------------------------------------------------------------*/
public class MM_RecipeBrandProductController extends MM_RecipeBase{
	public String productId {get; set;}
	public String brandId {get; set;}
	public Diageo_Brand__c recipeBrand {get; set;}
    public Diageo_Product__c brandProduct {get; set;}
	public Boolean editMode {get; set;}
	public Boolean isCreateNew {get; set;}
	public String cssStatus {get; set;}
	public string errorMessage{get;set;}
	public String brandName {get; set;}
	public ProductImageWrapper productImageWrapper {get; set; }
	public Id swapId {get; set;}
	public boolean showManageImages{get;set;}

	public MM_RecipeBrandProductController(ApexPages.StandardController controller) {
		productId = (String)controller.getId();
		brandId = ApexPages.currentPage().getParameters().get('brandId');
		if(ApexPages.currentPage().getParameters().get('editMode') != null && ApexPages.currentPage().getParameters().get('editMode') != '') {
			editMode = ApexPages.currentPage().getParameters().get('editMode') == 'true' ? true : false;
		}else {
			editMode = false;
		}
		swapId = null;
		showManageImages = false;
		init();
	}

	private void init() {
		if(brandId != null && brandId != '') {
			recipeBrand = [Select Id, Name, Category__c, Brand_Image__c, Generic_Brand__c, Locale__c
							From Diageo_Brand__c
							Where Id = :brandId ];
		}

		if(productId != null && productId != '') {
			brandProduct = [Select Id, Name, Diageo_Brand_Id__c, Diageo_Brand_Id__r.Name, Available__c, Units__c, Locale__c,
							Category__c, Diageo_Product_Image__c, Alcoholic__c, SAP_Level_5_Code__c,Diageo_Brand_Id__r.Locale__c,
							SAP_Level_5_Descr__c, Diageo_Product_Tags__c, Short_Description__c, Long_Description__c,
							Diageo_Product_Image__r.Content_Id__c
							From Diageo_Product__c
							Where Id = :productId ];

			cssStatus = 'draft';
			brandProduct.Locale__c = brandProduct.Diageo_Brand_Id__r.Locale__c;
			brandName = brandProduct.Diageo_Brand_Id__r.Name;
			isCreateNew = false;
			brandId = brandProduct.Diageo_Brand_Id__c;

			if(brandProduct.Diageo_Product_Image__c != null) {
				productImageWrapper = new ProductImageWrapper('Brand Image', brandProduct.Diageo_Product_Image__r.Content_Id__c);
				swapId = productImageWrapper.contentId;
			}

		}else {
			brandProduct = new Diageo_Product__c();
			cssStatus = 'draft';
			if(recipeBrand != null) {
				brandProduct.Diageo_Brand_Id__c = recipeBrand.Id;
				brandName = recipeBrand.Name;
				brandProduct.Locale__c = recipeBrand.Locale__c;
			}else {
				brandName = '';
				brandProduct.Locale__c = 'EN-US';
			}
			editMode = true;
			isCreateNew = true;
		}

		if(productId != null && productId != '' && editMode) {
			showManageImages = true;
		}
	}

	public String getUserAgent() {
	 	return ApexPages.currentPage().getHeaders().get('User-Agent');
	}

	//Method to open recipe brand product page on edit mode
	public PageReference editRecipeProduct() {
      editMode = true;
      String pagRefStr = '/apex/MM_RecipeBrandProduct?Id=' + productId + '&editMode=true';
      if(brandId != null && brandId != '') {
      	pagRefStr += '&brandId=' + brandId;
      }
      PageReference pageRef = new PageReference(pagRefStr);
      pageRef.setRedirect(true);
      return pageRef;
   }

	public void addError(String msg) {
		if(errorMessage == null) {
           errorMessage = 'Error: ';
           errorMessage += msg;
        } else  {
           errorMessage +='; ';
           errorMessage+= msg;
       }
	}

	public PageReference cancelEdit() {
		PageReference pageRef;
		if(productId != null && productId != '') {
			pageRef = new PageReference('/apex/MM_RecipeBrandProduct?Id=' + productId);
		}else {
			pageRef = new PageReference('/apex/MM_RecipeBrandProduct');
		}
		pageRef.setRedirect(true);
        return pageRef;
	}

    public PageReference saveRecipeProduct() {
        errorMessage=null;
        if(brandProduct.Name == null || brandProduct.Name == '') {
            addError('Product Name required');
            return null;
        } else {
            try {
			    upsert brandProduct;
			    editMode = false;
				if (productId == null)
				    productId = brandProduct.Id;

			    PageReference pageRef1 = new PageReference('/apex/MM_RecipeBrandProduct?Id=' + productId);
			    pageRef1.setRedirect(true);
			    return pageRef1;
            } catch(Exception e) {
                String message = e.getMessage();
            }
        }
        return null;
    }

	public Boolean getHasImages() {
        if (productImageWrapper != null)
			return true;
		return false;
    }

    public PageReference upsertTempRecipeProduct() {
		try{
		    upsert brandProduct;
		} catch(DMLException e) {
            String message = e.getMessage();
            system.debug('===========message===============' + message);
		}
		return null;
    }

    //Brand Image Wrapper
	public class ProductImageWrapper{
	    public string imageType{get;set;}
	    public id contentId{get;set;}
	    public ProductImageWrapper(String iType, Id CId) {
	        this.imageType = iType;
	        this.contentId = cId;
	    }
	}
}