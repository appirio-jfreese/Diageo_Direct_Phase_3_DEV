/********************************************************************************************************************
Name        : APPIRIO_GenerateXMLRecipeIinfo_JSON
Updated By  : Appirio India(Rahul Mittal)
Date        : 23rd Jan, 2014
Purpose     : Convert into JSON web service result for APPIRIO_GenerateXMLRecipeIinfo
********************************************************************************************************************/
public class APPIRIO_GenerateXMLRecipeIinfo_JSON {

    //public variable declaration
    public transient Boolean endOfResponse;
    public transient Integer resumePoint;
    public transient List<Id> recipeIds;
    public transient set<String> digitalPublishedAssetIds;

    //private variable declaration
    private transient Integer RecipesReturned;
    private transient set<string> setAttributes;
    private transient set<string> setDynamicAttributes;
    private transient map<String, String> mapOZTo5Mils;
    private transient map<String, String> mapMLToOZ;
    private transient map<String, Convert_Measurements__c> mapConvertMeasurements;
    private transient map<String, ContentVersion> mapContentDisplayIDContentVersion;

    //Constructor of calss APPIRIO_GenerateXMLRecipeIinfo
    public APPIRIO_GenerateXMLRecipeIinfo_JSON() {
        RecipesReturned = 0;
        recipeIds = new List<Id>();
        digitalPublishedAssetIds = new set<String>();

        mapContentDisplayIDContentVersion = new map<String, ContentVersion>();
        //Query all ContentVersion records where ContentDocumentId = input parameter
        for(ContentVersion contentVersion :[Select FileType, Title, ContentDocumentId
                              						From ContentVersion]) {
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

        setAttributes = new set<string>();
        setDynamicAttributes = new set<string>();
        for(Attribute__c attribute :[Select Attribute_Type__c, Dynamic__c From Attribute__c]){
            if(attribute.Dynamic__c)
                setDynamicAttributes.add(attribute.Attribute_Type__c);
            else
                setAttributes.add(attribute.Attribute_Type__c);
        }
    }

    //Generating an JSON with Recipe info.
    public APPIRIO_WrapperUtility_JSON.Recipes generateJSONRecipeIinfo() {
        set<Id> occasionIds = new set<Id>();

        if(digitalPublishedAssetIds.size() > 0){
          for(Published_Occasion__c publishedOccasion :[Select Occasion__c From Published_Occasion__c
                                    Where Status__c='Published' And Digital_Published_Asset__r.API_External_ID__c IN :digitalPublishedAssetIds]){
		        occasionIds.add(publishedOccasion.Occasion__c);
		      }
        } else {
          for(Occasion__c occasion :[Select Id From Occasion__c]){
		        occasionIds.add(occasion.Id);
		      }
        }

        //recipes
        APPIRIO_WrapperUtility_JSON.Recipes recipes = new APPIRIO_WrapperUtility_JSON.Recipes();
        recipes.Recipe = new List<APPIRIO_WrapperUtility_JSON.Recipe>();

        for(Recipe__c recipeElem : [SELECT API_External_ID__c, LastModifiedDate, NEO_Recipe_Id__c, Recipe_Tag__c, Name, Id, Recipe_Title__c, Locale__c,
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
                                      ,(select id, Attribute__r.Attribute_Type__c,Attribute__r.Attribute_Value__c, Dynamic_Value__c, Attribute__r.Locale__c, Attribute__r.API_External_ID__c from Recipe_Attributes__r)
                                      ,(select id, Occasion__r.API_External_ID__c,Occasion__r.Name_Of_The_Occasion__c, Occasion__r.Locale__c, Occasion__r.Occasion_Tags__c from Recipe_Occasions__r where Occasion__c IN:occasionIds)
                                      ,(select id, API_External_ID__c,Ingredient_Number__c, Quantity__c,Ingredient_Unit__c,Featured_Brand__c,
                                        Recipe_Brand__c,Recipe_Brand__r.Name,Recipe_Brand__r.API_External_ID__c,Recipe_Brand__r.Locale__c,
                                        Recipe_Diageo_Product__r.Name, Recipe_Diageo_Product__r.API_External_ID__c, Recipe_Diageo_Product__r.Locale__c,
                                        Recipe_Non_Diageo_Product__r.Name, Recipe_Non_Diageo_Product__r.Locale__c, Recipe_Non_Diageo_Product__r.API_External_ID__c
                                        from Diageo_Ingredients__r order by Ingredient_Number__c)
                                      ,(select Step_Number__c,Description__c from Preparation_Steps__r order by Step_Number__c)
                                      FROM Recipe__c WHERE Id IN :recipeIds  And recordSaved__c = true order by API_External_ID__c]) {

			RecipesReturned +=1;
          	string str;
            map<string,List<string>> mapAttributeTypeValues = new map<string,List<string>>();
            map<string,string> mapAttributeTypeDynamicValues = new map<string,string>();
            map<string,Recipe_Attribute__c> mapAttributeTypeValueRecipeAttribute = new map<string,Recipe_Attribute__c>();

            for(Recipe_Attribute__c recipeAttribute :recipeElem.Recipe_Attributes__r) {
                if(!mapAttributeTypeValues.containsKey(recipeAttribute.Attribute__r.Attribute_Type__c)) {
                    mapAttributeTypeValues.put(recipeAttribute.Attribute__r.Attribute_Type__c, new List<string>());
                }
                mapAttributeTypeValues.get(recipeAttribute.Attribute__r.Attribute_Type__c).add(recipeAttribute.Attribute__r.Attribute_Value__c);

                String key = recipeAttribute.Attribute__r.Attribute_Type__c.trim();
                key += recipeAttribute.Attribute__r.Attribute_Value__c != null ? recipeAttribute.Attribute__r.Attribute_Value__c.trim() : '';
                mapAttributeTypeValueRecipeAttribute.put(key,recipeAttribute);

                if(recipeAttribute.Dynamic_Value__c != null && recipeAttribute.Attribute__r.Attribute_Type__c != null)
                    mapAttributeTypeDynamicValues.put(recipeAttribute.Attribute__r.Attribute_Type__c, recipeAttribute.Dynamic_Value__c);
            }

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

			for(Diageo_Ingredient__c diageoIngredient: recipeElem.Diageo_Ingredients__r) {
				if(diageoIngredient.Featured_Brand__c) {
					APPIRIO_WrapperUtility_JSON.FeaturedBrand featuredBrand = new APPIRIO_WrapperUtility_JSON.FeaturedBrand();
                  	APPIRIO_WrapperUtility_JSON.FeaturedProduct featuredProduct = new APPIRIO_WrapperUtility_JSON.FeaturedProduct();

					featuredBrand.Id = diageoIngredient.Recipe_Brand__r.API_External_ID__c != null ? diageoIngredient.Recipe_Brand__r.API_External_ID__c : '';
					featuredBrand.Locale = diageoIngredient.Recipe_Brand__r.Locale__c != null ? diageoIngredient.Recipe_Brand__r.Locale__c : '';
					featuredBrand.Name = diageoIngredient.Recipe_Brand__r.Name != null ? diageoIngredient.Recipe_Brand__r.Name : '';

					featuredProduct.Id = diageoIngredient.Recipe_Diageo_Product__r.API_External_ID__c != null ? diageoIngredient.Recipe_Diageo_Product__r.API_External_ID__c : '';
					featuredProduct.Locale = diageoIngredient.Recipe_Diageo_Product__r.Locale__c != null ? diageoIngredient.Recipe_Diageo_Product__r.Locale__c : '';
					featuredProduct.Name = diageoIngredient.Recipe_Diageo_Product__r.Name != null ? diageoIngredient.Recipe_Diageo_Product__r.Name : '';

					featuredBrands.add(featuredBrand);
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
            //end of featuredIngredient

            //attributes
            APPIRIO_WrapperUtility_JSON.Attributes attributes = new APPIRIO_WrapperUtility_JSON.Attributes();
            List<APPIRIO_WrapperUtility_JSON.Attribute> attributeElems = new List<APPIRIO_WrapperUtility_JSON.Attribute>();
            List<APPIRIO_WrapperUtility_JSON.AttributeElement> dynamicAttributes = new List<APPIRIO_WrapperUtility_JSON.AttributeElement>();
            //attributes.Attribute = new List<APPIRIO_WrapperUtility_JSON.Attribute>();
            //attributes.DynamicAttribute = new List<APPIRIO_WrapperUtility_JSON.AttributeElement>();

            for(string attribute :setAttributes) {
                //Attribute Types
                str = attribute.replaceAll(' ', '');
                str = str.replaceAll('/', '');

                APPIRIO_WrapperUtility_JSON.Attribute attributeElem = new APPIRIO_WrapperUtility_JSON.Attribute();
                attributeElem.AttributeElement = new List<APPIRIO_WrapperUtility_JSON.AttributeElement>();
                attributeElem.Name = str+'s';

                if(mapAttributeTypeValues.get(attribute) != null) {
					for(string dc: mapAttributeTypeValues.get(attribute)) {
                  		APPIRIO_WrapperUtility_JSON.AttributeElement attrElem = new APPIRIO_WrapperUtility_JSON.AttributeElement();
                    	Recipe_Attribute__c recipeAttribute = mapAttributeTypeValueRecipeAttribute.get(attribute.trim()+dc.trim());
                        //attribute
                        attrElem.Name = str;
                        attrElem.Id = recipeAttribute != null ? recipeAttribute.Attribute__r.API_External_ID__c : '';
                        attrElem.Locale = recipeAttribute != null ? recipeAttribute.Attribute__r.Locale__c : '';
                        attrElem.value = dc;
                        attributeElem.AttributeElement.add(attrElem);
                        //end of attribute
					}
                } else {
                    //attribute
                    APPIRIO_WrapperUtility_JSON.AttributeElement attrElem = new APPIRIO_WrapperUtility_JSON.AttributeElement();
                    attrElem.Name = str;
                    attrElem.Id = '';
                    attrElem.Locale = '';
                    attributeElem.AttributeElement.add(attrElem);
                    //end of attribute
                }
                //end of Attribute Types
                attributeElems.add(attributeElem);
            }
            if(attributeElems !=null && attributeElems.size() > 0) {
            	attributes.Attribute = attributeElems;
            }

            for(string dynamicAttribute : setDynamicAttributes) {
                str = dynamicAttribute.replaceAll(' ', '');
                str = str.replaceAll('/', '');
                Recipe_Attribute__c recipeAttribute = mapAttributeTypeValueRecipeAttribute.get(str.trim());

                //dynamicAttribute
                APPIRIO_WrapperUtility_JSON.AttributeElement dynAttrElem = new APPIRIO_WrapperUtility_JSON.AttributeElement();
                dynAttrElem.Name = str;
                dynAttrElem.Id = recipeAttribute != null ? recipeAttribute.Attribute__r.API_External_ID__c : '';
                dynAttrElem.Locale = recipeAttribute != null ? recipeAttribute.Attribute__r.Locale__c : '';
                if(mapAttributeTypeDynamicValues.get(dynamicAttribute) != null) {
                	dynAttrElem.value = mapAttributeTypeDynamicValues.get(dynamicAttribute);
                }
                dynamicAttributes.add(dynAttrElem);
                //end of dynamicAttribute
            }
            if(dynamicAttributes != null && dynamicAttributes.size() > 0) {
            	attributes.DynamicAttribute = dynamicAttributes;
            }
            //tags
            attributes.RecipeTag = recipeElem.Recipe_Tag__c != null ? recipeElem.Recipe_Tag__c : '';
            recipe.Attributes = attributes;
            //end of tags
            //end of attributes

            //occasions
            APPIRIO_WrapperUtility_JSON.Occasions occasions = new APPIRIO_WrapperUtility_JSON.Occasions();
            List<APPIRIO_WrapperUtility_JSON.Occasion> occasionElems = new List<APPIRIO_WrapperUtility_JSON.Occasion>();
            List<APPIRIO_WrapperUtility_JSON.Tags> tagElems = new List<APPIRIO_WrapperUtility_JSON.Tags>();

            for(Recipe_Occasion__c recipeOccasion: recipeElem.Recipe_Occasions__r){
                //occasion
                APPIRIO_WrapperUtility_JSON.Occasion occasion = new APPIRIO_WrapperUtility_JSON.Occasion();
                occasion.Id = ''+recipeOccasion.Occasion__r.API_External_ID__c;
                occasion.Locale = ''+recipeOccasion.Occasion__r.Locale__c;
                occasion.Name = recipeOccasion.Occasion__r.Name_Of_The_Occasion__c;
                //end of occasion
				occasionElems.add(occasion);

                //tags
                APPIRIO_WrapperUtility_JSON.Tags tag;
              	if(recipeOccasion.Occasion__r.Occasion_Tags__c != null) {
              		tag = new APPIRIO_WrapperUtility_JSON.Tags();
              		tag.occasion_tag = recipeOccasion.Occasion__r.Occasion_Tags__c;
              		tagElems.add(tag);
              	}
              	//end of tags
            }
            if(occasionElems.size() > 0) {
            	occasions.Occasion = occasionElems;
            }
            if(tagElems.size() > 0) {
            	occasions.Tags = tagElems;
            }
            if(occasionElems.size() > 0 || tagElems.size() > 0) {
            	recipe.occasions = occasions;
            }
            //end of occasions

            //images
            APPIRIO_WrapperUtility_JSON.Images images = new APPIRIO_WrapperUtility_JSON.Images();
            //images.Images = new List<APPIRIO_WrapperUtility_JSON.Image>();
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
              image.fileName = contentVersion != null && contentVersion.Title != null ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';
              imageElems.add(image);
            }
            //end of image-Additional5

			 if(imageElems != null && imageElems.size() > 0) {
			 	images.Name = 'Images';
			 	images.Images = imageElems;
			 	recipe.Images = images;
			 }
            //end of images

            //diageoIngredients
            List<APPIRIO_WrapperUtility_JSON.DiageoIngredient> diageoIngredients = new List<APPIRIO_WrapperUtility_JSON.DiageoIngredient>();

            //w.writeStartElement(null,'diageoIngredients',null);
            for(Diageo_Ingredient__c diageoIngredient: recipeElem.Diageo_Ingredients__r){
                if(diageoIngredient.Recipe_Diageo_Product__r.Name != null) {
                    //diageoIngredient
                    APPIRIO_WrapperUtility_JSON.DiageoIngredient diageoIngredientElem = new APPIRIO_WrapperUtility_JSON.DiageoIngredient();
                    diageoIngredientElem.Id = ''+diageoIngredient.Recipe_Diageo_Product__r.API_External_ID__c;
                    diageoIngredientElem.Locale = diageoIngredient.Recipe_Diageo_Product__r.Locale__c != null ? diageoIngredient.Recipe_Diageo_Product__r.Locale__c : '';
                    diageoIngredientElem.name = diageoIngredient.Recipe_Diageo_Product__r.Name;
                    diageoIngredientElem.quantity = diageoIngredient.Quantity__c != null ? diageoIngredient.Quantity__c : '';
                    diageoIngredientElem.units = diageoIngredient.Ingredient_Unit__c != null ? diageoIngredient.Ingredient_Unit__c : '';
                    if(diageoIngredient.Ingredient_Unit__c != null && diageoIngredient.Ingredient_Unit__c.equals('oz.')) {
                        //ozquantity
                        diageoIngredientElem.ozquantity = diageoIngredient.Quantity__c != null ? diageoIngredient.Quantity__c : '';
                        //end of ozquantity
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
                    brand.Id = diageoIngredient.Recipe_Brand__r.API_External_ID__c != null ? diageoIngredient.Recipe_Brand__r.API_External_ID__c : '';
                    brand.Locale = diageoIngredient.Recipe_Brand__r.Locale__c != null ? diageoIngredient.Recipe_Brand__r.Locale__c : '';
                    brand.Name = diageoIngredient.Recipe_Brand__r.Name != null ? diageoIngredient.Recipe_Brand__r.Name : '';
					diageoIngredientElem.brand = brand;
                    //Add DiageoIngredient element in list
                    diageoIngredients.add(diageoIngredientElem);
                }
            }
            if(diageoIngredients != null && diageoIngredients.size() > 0) {
            	recipe.diageoIngredients = diageoIngredients;
            }
            //end of diageoIngredients

            //ingredients
            List<APPIRIO_WrapperUtility_JSON.Ingredient> ingredients = new List<APPIRIO_WrapperUtility_JSON.Ingredient>();
            for(Diageo_Ingredient__c diageoIngredient: recipeElem.Diageo_Ingredients__r) {
                if(diageoIngredient.Recipe_Non_Diageo_Product__r.Name != null) {
                    //ingredient
                    APPIRIO_WrapperUtility_JSON.Ingredient ingredient = new APPIRIO_WrapperUtility_JSON.Ingredient();
                    ingredient.id = ''+diageoIngredient.Recipe_Non_Diageo_Product__r.API_External_ID__c;
                    ingredient.Locale = ''+diageoIngredient.Recipe_Non_Diageo_Product__r.Locale__c;
                    ingredient.name = diageoIngredient.Recipe_Non_Diageo_Product__r.Name;
                    ingredient.quantity = diageoIngredient.Quantity__c != null ? diageoIngredient.Quantity__c : '';
                    ingredient.units = diageoIngredient.Ingredient_Unit__c != null ? diageoIngredient.Ingredient_Unit__c : '';
                    if(diageoIngredient.Ingredient_Unit__c != null && diageoIngredient.Ingredient_Unit__c.equals('oz.')) {
                        //ozquantity
                        ingredient.ozquantity = diageoIngredient.Quantity__c != null ? diageoIngredient.Quantity__c : '';
                        //mlquantity
                        ingredient.mlquantity = mapOZTo5Mils.get(diageoIngredient.Quantity__c) != null ? mapOZTo5Mils.get(diageoIngredient.Quantity__c) : '';
                        //end of mlquantity
                    } else if(diageoIngredient.Ingredient_Unit__c != null && diageoIngredient.Ingredient_Unit__c.equals('ml.')) {
                        //mlquantity
                        ingredient.mlquantity = diageoIngredient.Quantity__c != null ? diageoIngredient.Quantity__c : '';
                        //ozquantity
                        ingredient.mlquantity = mapMLToOZ.get(diageoIngredient.Quantity__c) != null ? mapMLToOZ.get(diageoIngredient.Quantity__c) : '';
                    } else {
                        //ozquantity
                        ingredient.ozquantity = null;
                        //end of ozquantity
                        //mlquantity
                        ingredient.mlquantity = null;
                        //end of mlquantity
                    }
                    //w.writeEndElement();
                    //end of ingredient
                    ingredients.add(ingredient);
                }
            }
            if(ingredients != null && ingredients.size() > 0) {
            	recipe.ingredients = ingredients;
            }
            //end of ingredients

            //prepSteps
            List<APPIRIO_WrapperUtility_JSON.PrepStep> prepSteps = new List<APPIRIO_WrapperUtility_JSON.PrepStep>();
            for(Preparation_Step__c preparationStep: recipeElem.Preparation_Steps__r) {
                //prepStep
                APPIRIO_WrapperUtility_JSON.PrepStep prepStep = new APPIRIO_WrapperUtility_JSON.PrepStep();
                prepStep.stepNo = ''+preparationStep.Step_Number__c;
                prepStep.instruction = preparationStep.Description__c != null ? preparationStep.Description__c : '';
				prepSteps.add(prepStep);
                //end of prepStep
            }
            if(prepSteps != null && prepSteps.size() > 0) {
            	recipe.prepSteps = prepSteps;
            }
            //end of prepSteps

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