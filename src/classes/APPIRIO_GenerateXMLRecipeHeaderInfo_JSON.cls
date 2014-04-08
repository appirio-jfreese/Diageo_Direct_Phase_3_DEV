/*****************************************************************************
Name        : APPIRIO_GenerateXMLRecipeHeaderInfo_JSON
Updated By  : Appirio Offshore(Rahul Mittal)
Date        : 27th Jan, 2014
Purpose     : Convert response into JSON format
******************************************************************************/
public class APPIRIO_GenerateXMLRecipeHeaderInfo_JSON {

	//public variable declaration
	public transient Boolean endOfResponse;
    public transient Integer resumePoint;
	public List<Id> recipeIds{get;set;}
	public string xmlString {get;set;}

	//private variable declaration
	private transient Integer RecipesReturned;
	private map<String, String> mapOZTo5Mils;
	private map<String, String> mapMLToOZ;
	private transient map<String, Convert_Measurements__c> mapConvertMeasurements;
	private transient map<String, ContentVersion> mapContentDisplayIDContentVersion;

    //Constructor of calss APPIRIO_GenerateXMLRecipeHeaderInfo_JSON
	public APPIRIO_GenerateXMLRecipeHeaderInfo_JSON() {
		xmlString = '';
		RecipesReturned = 0;
		recipeIds = new List<Id>();

		mapContentDisplayIDContentVersion = new map<String, ContentVersion>();
        //Query all ContentVersion records where ContentDocumentId = input parameter
        for(ContentVersion contentVersion :[Select FileType, Title, ContentDocumentId From ContentVersion]) {
        	mapContentDisplayIDContentVersion.put(contentVersion.ContentDocumentId, contentVersion);
        }

        mapOZTo5Mils = new map<String, String>();
		mapMLToOZ = new map<String, String>();
		mapConvertMeasurements = Convert_Measurements__c.getAll();

		//getting Convert Measurements values.
		for(String name :mapConvertMeasurements.keySet()) {
      		Convert_Measurements__c convertMeasurements = mapConvertMeasurements.get(name);
      		if(convertMeasurements != null) {
      			mapOZTo5Mils.put(convertMeasurements.fl_Oz__c.trim(),convertMeasurements.X5Mils__c.trim());
				mapMLToOZ.put(convertMeasurements.mL__c.trim(),convertMeasurements.fl_Oz__c.trim());
      		}
      	}
	}

	//Generating an JSON with Recipe info.
	public APPIRIO_WrapperUtility_JSON.Recipes generateJSONRecipeIinfo() {
		//recipes
		APPIRIO_WrapperUtility_JSON.Recipes recipes = new APPIRIO_WrapperUtility_JSON.Recipes();
        recipes.Recipe = new List<APPIRIO_WrapperUtility_JSON.Recipe>();

		//Grabbing/getting all the details of the recipes that is already created.
		for(Recipe__c recipeElem :[SELECT API_External_ID__c, LastModifiedDate, NEO_Recipe_Id__c, Recipe_Tag__c, Name, Id, Recipe_Title__c, Locale__c,
                                      Additional_Image_1__c, Additional_Image_1__r.Content_Display_ID__c,
                                      Additional_Image_2__c, Additional_Image_2__r.Content_Display_ID__c,
                                      Additional_Image_3__c, Additional_Image_3__r.Content_Display_ID__c,
                                      Additional_Image_4__c, Additional_Image_4__r.Content_Display_ID__c,
                                      Additional_Image_5__c, Additional_Image_5__r.Content_Display_ID__c,
                                      Background_Image__c, Background_Image__r.Content_Display_ID__c,
                                      Brand_Recipe_Image__c, Brand_Recipe_Image__r.Content_Display_ID__c,
                                      Main_Drink_Image__c, Main_Drink_Image__r.Content_Display_ID__c,
                                      Main_Ingredient_Image__c, Main_Ingredient_Image__r.Content_Display_ID__c,
                                      Mobile_Selected_Image__c, Mobile_Selected_Image__r.Content_Display_ID__c,
                                      Mobile_Unselected_Image__c, Mobile_Unselected_Image__r.Content_Display_ID__c,
                                      Mobile_Drink_Image__c, Mobile_Drink_Image__r.Content_Display_ID__c,
                                      Search_Recipe_Image__c, Search_Recipe_Image__r.Content_Display_ID__c,
                                      Thumbnail_Drink_Image__c, Thumbnail_Drink_Image__r.Content_Display_ID__c, Language__c
                                      ,(select id, API_External_ID__c,Ingredient_Number__c, Quantity__c,Ingredient_Unit__c,Featured_Brand__c,
                                      Recipe_Brand__c,Recipe_Brand__r.Name,Recipe_Brand__r.API_External_ID__c,Recipe_Brand__r.Locale__c,
                                      Recipe_Diageo_Product__r.Name, Recipe_Diageo_Product__r.API_External_ID__c,Recipe_Diageo_Product__r.Locale__c
                                      from Diageo_Ingredients__r order by Ingredient_Number__c)
                                      FROM Recipe__c WHERE Id IN :recipeIds  And recordSaved__c = true order by API_External_ID__c]) {

			RecipesReturned +=1;
			string str;

			//recipe
			APPIRIO_WrapperUtility_JSON.Recipe recipe = new APPIRIO_WrapperUtility_JSON.Recipe();
            recipe.sfRecipeId = recipeElem.API_External_ID__c != null ? recipeElem.API_External_ID__c : '';
            recipe.neoRecipeId = recipeElem.NEO_Recipe_Id__c != null ? recipeElem.NEO_Recipe_Id__c : '';
            recipe.Locale = recipeElem.Locale__c != null ? recipeElem.Locale__c : '';
            recipe.Language = recipeElem.Language__c != null ? recipeElem.Language__c : '';
            recipe.lastModified = string.valueOf(recipeElem.LastModifiedDate);
            recipe.recipeTitle = recipeElem.Recipe_Title__c != null ? recipeElem.Recipe_Title__c : '';

		  	//featuredIngredient
		  	APPIRIO_WrapperUtility_JSON.FeaturedIngredient featuredIngredient = new APPIRIO_WrapperUtility_JSON.FeaturedIngredient();
            List<APPIRIO_WrapperUtility_JSON.FeaturedBrand> featuredBrands = new List<APPIRIO_WrapperUtility_JSON.FeaturedBrand>();
            List<APPIRIO_WrapperUtility_JSON.FeaturedProduct> featuredProducts = new List<APPIRIO_WrapperUtility_JSON.FeaturedProduct>();

	  		for(Diageo_Ingredient__c diageoIngredient: recipeElem.Diageo_Ingredients__r){
	  			if(diageoIngredient.Featured_Brand__c) {
	  				APPIRIO_WrapperUtility_JSON.FeaturedBrand featuredBrand = new APPIRIO_WrapperUtility_JSON.FeaturedBrand();
					APPIRIO_WrapperUtility_JSON.FeaturedProduct featuredProduct = new APPIRIO_WrapperUtility_JSON.FeaturedProduct();

					featuredBrand.Id = diageoIngredient.Recipe_Brand__r.API_External_ID__c != null ? diageoIngredient.Recipe_Brand__r.API_External_ID__c : '';
					featuredBrand.Locale = diageoIngredient.Recipe_Brand__r.Locale__c != null ? diageoIngredient.Recipe_Brand__r.Locale__c : '';
					featuredBrand.Name = diageoIngredient.Recipe_Brand__r.Name != null ? diageoIngredient.Recipe_Brand__r.Name : '';
					featuredBrands.add(featuredBrand);

					featuredProduct.Id = diageoIngredient.Recipe_Diageo_Product__r.API_External_ID__c != null ? diageoIngredient.Recipe_Diageo_Product__r.API_External_ID__c : '';
					featuredProduct.Locale = diageoIngredient.Recipe_Diageo_Product__r.Locale__c != null ? diageoIngredient.Recipe_Diageo_Product__r.Locale__c : '';
					featuredProduct.Name = diageoIngredient.Recipe_Diageo_Product__r.Name != null ? diageoIngredient.Recipe_Diageo_Product__r.Name : '';
					featuredProducts.add(featuredProduct);
	  			}
		  	}
		  	if(featuredBrands.size() > 0)
        		featuredIngredient.featuredBrands = featuredBrands;
            if(featuredProducts.size() > 0)
        		featuredIngredient.featuredProducts = featuredProducts;

        	if(featuredBrands.size() > 0 || featuredProducts.size() > 0) {
        		recipe.featuredIngredient = featuredIngredient;
        	}

		  	/*featuredIngredient.featuredBrands = featuredBrands;
            featuredIngredient.featuredProducts = featuredProducts;
            recipe.featuredIngredient = featuredIngredient;*/
		  	//end of featuredIngredient

		  	//Recipe Main Drink Image
		  	APPIRIO_WrapperUtility_JSON.Images images = new APPIRIO_WrapperUtility_JSON.Images();
            //images.Images = new List<APPIRIO_WrapperUtility_JSON.Image>();
			//images.Name = 'RecipeMainDrinkImage';
			List<APPIRIO_WrapperUtility_JSON.Image> imageElems = new List<APPIRIO_WrapperUtility_JSON.Image>();

	  		ContentVersion contentVersion;
            //image-MainDrink
            if(recipeElem.Main_Drink_Image__c != null && recipeElem.Main_Drink_Image__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Main_Drink_Image__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'MainDrink';
				image.sfImageAssetId = recipeElem.Main_Drink_Image__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-MainDrink

            //image-Thumbnail
            if(recipeElem.Thumbnail_Drink_Image__c != null && recipeElem.Thumbnail_Drink_Image__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Thumbnail_Drink_Image__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'Thumbnail';
				image.sfImageAssetId = recipeElem.Thumbnail_Drink_Image__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-Thumbnail

            //image-SearchImage
            if(recipeElem.Search_Recipe_Image__c != null && recipeElem.Search_Recipe_Image__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Search_Recipe_Image__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'SearchImage';
				image.sfImageAssetId = recipeElem.Search_Recipe_Image__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-SearchImage

            //image-MobileDrink
            if(recipeElem.Mobile_Drink_Image__c != null && recipeElem.Mobile_Drink_Image__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Mobile_Drink_Image__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'MobileDrink';
				image.sfImageAssetId = recipeElem.Mobile_Drink_Image__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-MobileDrink

            //image-MobileSelected
            if(recipeElem.Mobile_Selected_Image__c != null && recipeElem.Mobile_Selected_Image__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Mobile_Selected_Image__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'MobileSelected';
				image.sfImageAssetId = recipeElem.Mobile_Selected_Image__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-MobileSelected

            //image-MobileUnselected
            if(recipeElem.Mobile_Unselected_Image__c != null && recipeElem.Mobile_Unselected_Image__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Mobile_Unselected_Image__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'MobileUnselected';
				image.sfImageAssetId = recipeElem.Mobile_Unselected_Image__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-MobileUnselected

            //image-MainIngredient
            if(recipeElem.Main_Ingredient_Image__c != null && recipeElem.Main_Ingredient_Image__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Main_Ingredient_Image__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'MainIngredient';
				image.sfImageAssetId = recipeElem.Main_Ingredient_Image__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-MainIngredient

            //image-BrandRecipe
            if(recipeElem.Brand_Recipe_Image__c != null && recipeElem.Brand_Recipe_Image__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Brand_Recipe_Image__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'BrandRecipe';
				image.sfImageAssetId = recipeElem.Brand_Recipe_Image__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-BrandRecipe

            //image-BackgroundImage
            if(recipeElem.Background_Image__c != null && recipeElem.Background_Image__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Background_Image__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'BackgroundImage';
				image.sfImageAssetId = recipeElem.Background_Image__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-BackgroundImage

	        //image-Additional1
	        if(recipeElem.Additional_Image_1__c != null && recipeElem.Additional_Image_1__r.Content_Display_ID__c != null) {
	        	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Additional_Image_1__r.Content_Display_ID__c);
	            APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'Additional1';
				image.sfImageAssetId = recipeElem.Additional_Image_1__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-Additional1

            //image-Additional2
            if(recipeElem.Additional_Image_2__c != null && recipeElem.Additional_Image_2__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Additional_Image_2__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'Additional2';
				image.sfImageAssetId = recipeElem.Additional_Image_2__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-Additional2

            //image-Additional3
            if(recipeElem.Additional_Image_3__c != null && recipeElem.Additional_Image_3__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Additional_Image_3__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'Additional3';
				image.sfImageAssetId = recipeElem.Additional_Image_3__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
						                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-Additional3

            //image-Additional4
            if(recipeElem.Additional_Image_4__c != null && recipeElem.Additional_Image_4__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Additional_Image_4__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'Additional4';
				image.sfImageAssetId = recipeElem.Additional_Image_4__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-Additional4

            //image-Additional5
            if(recipeElem.Additional_Image_5__c != null && recipeElem.Additional_Image_5__r.Content_Display_ID__c != null) {
            	contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Additional_Image_5__r.Content_Display_ID__c);
                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
				image.imageType = 'Additional5';
				image.sfImageAssetId = recipeElem.Additional_Image_5__r.Content_Display_ID__c;
				image.fileName = contentVersion != null && contentVersion.Title != null
				                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';

				imageElems.add(image);
            }
            //end of image-Additional5
			if(imageElems != null && imageElems.size() > 0) {
			 	images.Name = 'RecipeMainDrinkImage';
			 	images.Images = imageElems;
			 	recipe.Images = images;
			 }

			//recipe.Images = images;
		  	//w.writeEndElement();
		  	//end of Recipe Main Drink Image

		  	//diageoIngredients
		  	List<APPIRIO_WrapperUtility_JSON.DiageoIngredient> diageoIngredients = new List<APPIRIO_WrapperUtility_JSON.DiageoIngredient>();

	  		for(Diageo_Ingredient__c diageoIngredient: recipeElem.Diageo_Ingredients__r){
	  			if(diageoIngredient.Recipe_Diageo_Product__r.Name != null) {
	  				//diageoIngredient
	  				APPIRIO_WrapperUtility_JSON.DiageoIngredient diageoIngredientElem = new APPIRIO_WrapperUtility_JSON.DiageoIngredient();
                    diageoIngredientElem.Id = ''+diageoIngredient.Recipe_Diageo_Product__r.API_External_ID__c;
                    diageoIngredientElem.Locale = diageoIngredient.Recipe_Diageo_Product__r.Locale__c != null
                                                ? diageoIngredient.Recipe_Diageo_Product__r.Locale__c : '';
                    diageoIngredientElem.name = diageoIngredient.Recipe_Diageo_Product__r.Name;
                    diageoIngredientElem.quantity = diageoIngredient.Quantity__c != null ? diageoIngredient.Quantity__c : '';
                    diageoIngredientElem.units = diageoIngredient.Ingredient_Unit__c != null ? diageoIngredient.Ingredient_Unit__c : '';

		  			if(diageoIngredient.Ingredient_Unit__c != null && diageoIngredient.Ingredient_Unit__c.equals('oz.')) {
		  				//ozquantity
		  				diageoIngredientElem.ozquantity = diageoIngredient.Quantity__c != null ? diageoIngredient.Quantity__c : '';
			  			//mlquantity
			  			diageoIngredientElem.mlquantity = mapOZTo5Mils.get(diageoIngredient.Quantity__c) != null ? mapOZTo5Mils.get(diageoIngredient.Quantity__c) : '';
			  			//end of mlquantity
		  			} else if(diageoIngredient.Ingredient_Unit__c != null && diageoIngredient.Ingredient_Unit__c.equals('ml.')) {
		  				//mlquantity
		  				diageoIngredientElem.mlquantity = diageoIngredient.Quantity__c != null ? diageoIngredient.Quantity__c : '';
			  			//end of mlquantity

		  				//ozquantity
		  				diageoIngredientElem.ozquantity = mapMLToOZ.get(diageoIngredient.Quantity__c) != null ? mapMLToOZ.get(diageoIngredient.Quantity__c) : '';
			  			//end of ozquantity
		  			} else {
		  				//ozquantity
		  				diageoIngredientElem.ozquantity = null;
			  			//end of ozquantity

		  				//mlquantity
		  				diageoIngredientElem.mlquantity = null;
			  			//end of mlquantity
		  			}

		  			//featured
		  			diageoIngredientElem.featured = diageoIngredient.Featured_Brand__c != null ? diageoIngredient.Featured_Brand__c+'' : '';
		  			//end of featured

		  			//brand
		  			APPIRIO_WrapperUtility_JSON.Brand brand = new APPIRIO_WrapperUtility_JSON.Brand();
                    brand.Id = diageoIngredient.Recipe_Brand__r.API_External_ID__c != null
                                ? diageoIngredient.Recipe_Brand__r.API_External_ID__c : '';
                    brand.Locale = diageoIngredient.Recipe_Brand__r.Locale__c != null ? diageoIngredient.Recipe_Brand__r.Locale__c : '';
                    brand.Name = diageoIngredient.Recipe_Brand__r.Name != null ? diageoIngredient.Recipe_Brand__r.Name : '';
					diageoIngredientElem.brand = brand;
			  		//end of diageoIngredient
			  		diageoIngredients.add(diageoIngredientElem);
	  			}
		  	}
		  	if(diageoIngredients != null && diageoIngredients.size() > 0) {
            	recipe.diageoIngredients = diageoIngredients;
            }
		  	//recipe.diageoIngredients = diageoIngredients;
		  	//end of diageoIngredients

			recipes.Recipe.add(recipe);
		  	//end of recipe
		}

		//endOfResponse
		recipes.endOfResponse = endOfResponse != null && endOfResponse ? 'TRUE' : 'FALSE';
		//end of endOfResponse

		//RecipesReturned
		recipes.RecipesReturned = RecipesReturned +'';
		//end of RecipesReturned

		//resumePoint
		recipes.resumePoint = resumePoint != null ? resumePoint + '' : 'False';
		//end of resumePoint
		return recipes;
	}
}