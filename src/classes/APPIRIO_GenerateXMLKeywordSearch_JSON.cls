/*****************************************************************************
Name        : APPIRIO_GenerateXMLKeywordSearch_JSON
Updated By  : Appirio India(Rahul Mittal)
Date        : 27th Jan, 2014
Ref         : T-240639
******************************************************************************/
public class APPIRIO_GenerateXMLKeywordSearch_JSON   {
    //public variable declaration
    public transient Boolean endOfResponse;
    public transient Integer resumePoint;
    public transient List<Id> recipeIds;
    public transient string xmlString;

    //private variable declaration
    private transient Integer RecipesReturned;
    private transient map<String, String> mapOZTo5Mils;
    private transient map<String, String> mapMLToOZ;
    private transient map<String, Convert_Measurements__c> mapConvertMeasurements;
    private transient map<String, ContentVersion> mapContentDisplayIDContentVersion;

    //Constructor of calss APPIRIO_GenerateXMLRecipeHeaderInfo
    public APPIRIO_GenerateXMLKeywordSearch_JSON() {
        xmlString = '';
        RecipesReturned = 0;
        recipeIds = new List<Id>();
    }

    //Grabbing/getting all the details of the recipes that is already created.
    private void grabbingRecipesInfo() {
        set<Id> contentIds = new set<Id>();
        //3.26.2012-LSLEVIN-Case4405-START//

        //Added Main_Drink__Image__r.Content_Display_ID__c to query below
        //Grabbing/getting all the details of the recipes that is already created.
        for(Recipe__c recipe :[SELECT Main_Drink_Image__r.Content_Display_ID__c
                                      FROM Recipe__c WHERE Id IN :recipeIds And recordSaved__c = true
                                      order by API_External_ID__c]) {
            contentIds.add(recipe.Main_Drink_Image__r.Content_Display_ID__c);
        }

        mapContentDisplayIDContentVersion = new map<String, ContentVersion>();
        //Query all ContentVersion records where ContentDocumentId = input parameter
        for(ContentVersion contentVersion :[Select FileType, VersionData, Title, ContentDocumentId
                                                    From ContentVersion
                                                    Where contentVersion.ContentDocumentId IN :contentIds]) {
            mapContentDisplayIDContentVersion.put(contentVersion.ContentDocumentId, contentVersion);
        }
        contentIds = null;

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

    // Pass in the endpoint to be used using the string url
    public String getContent(String url) {

        // Instantiate a new http object
        Http h = new Http();

        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        req.setMethod('GET');

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        return res.getBody();
    }

    //Generating an JSON with Recipe info.
    public APPIRIO_WrapperUtility_JSON.Recipes generateJSONRecipeIinfo() {
        grabbingRecipesInfo();

        //XmlStreamWriter w = new XmlStreamWriter();
        //w.writeStartDocument(null,'1.0');

        //recipes
        APPIRIO_WrapperUtility_JSON.Recipes recipes = new APPIRIO_WrapperUtility_JSON.Recipes();
        recipes.Recipe = new List<APPIRIO_WrapperUtility_JSON.Recipe>();

        //w.writeStartElement(null,'recipes',null);
        //Added Main_Drink__Image__r.Content_Display_ID__c and Main_Drink_Image__c to query below
        //Removed Thumbnail_Drink_Image__c, Thumbnail_Drink_Image__r.Content_Display_ID__c
        //Limit the Recipe query to only return 10 recipes so that we do not hit the Call Out Limit
        for(Recipe__c recipeElem :[SELECT API_External_ID__c, LastModifiedDate, NEO_Recipe_Id__c, Name, Id, Recipe_Title__c, Locale__c,
                                      Main_Drink_Image__c, Main_Drink_Image__r.Content_Display_ID__c, Language__c
                                      ,(select id, API_External_ID__c,Ingredient_Number__c, Quantity__c,Ingredient_Unit__c,Featured_Brand__c,
                                      Recipe_Brand__c,Recipe_Brand__r.Name,Recipe_Brand__r.API_External_ID__c,Recipe_Brand__r.Locale__c,
                                      Recipe_Diageo_Product__r.Name,Recipe_Diageo_Product__r.API_External_ID__c,Recipe_Diageo_Product__r.Locale__c
                                      from Diageo_Ingredients__r order by Ingredient_Number__c)
                                      FROM Recipe__c WHERE Id IN :recipeIds And recordSaved__c = true order by API_External_ID__c limit 10]) {

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

                //w.writeStartElement(null,'featuredIngredient',null);
                    for(Diageo_Ingredient__c diageoIngredient: recipeElem.Diageo_Ingredients__r){
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
                    /*featuredIngredient.featuredBrands = featuredBrands;
                    featuredIngredient.featuredProducts = featuredProducts;
                    recipe.featuredIngredient = featuredIngredient;*/

                //end of featuredIngredient

                //Recipe Thumbnail Drink Image
                APPIRIO_WrapperUtility_JSON.Images images = new APPIRIO_WrapperUtility_JSON.Images();
                List<APPIRIO_WrapperUtility_JSON.Image> imageElems = new List<APPIRIO_WrapperUtility_JSON.Image>();
                //images.Images = new List<APPIRIO_WrapperUtility_JSON.Image>();


                //w.writeStartElement(null,'RecipeThumbnailDrinkImage',null);

                    //image-ThumbnailDrink
                   // if(recipeElem.Thumbnail_Drink_Image__c != null && recipeElem.Thumbnail_Drink_Image__r.Content_Display_ID__c != null) {
                    if(recipeElem.Main_Drink_Image__c != null && recipeElem.Main_Drink_Image__r.Content_Display_ID__c != null) {

                       // ContentVersion contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Thumbnail_Drink_Image__r.Content_Display_ID__c);
                        ContentVersion contentVersion = mapContentDisplayIDContentVersion.get(recipeElem.Main_Drink_Image__r.Content_Display_ID__c);
                        //Added by LSLEVIN
                        if(URL.getSalesforceBaseUrl().toExternalForm()!=null && contentVersion!=null){ // Added by Rahul on 11th April
                            String thumbNailUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v24.0/chatter/files/'+ contentVersion.ContentDocumentId + '/rendition?type=THUMB120BY90';
                            String renditionUrl = '';
                            renditionUrl = getContent(thumbNailUrl);
                            Blob thumbNailRendition = blob.valueOf(renditionUrl);
                            if(contentVersion != null) {
                                //image
                                APPIRIO_WrapperUtility_JSON.Image image = new APPIRIO_WrapperUtility_JSON.Image();
                                //image.imageType = 'MainDrink';
                                image.ContentDisplayID = contentVersion.ContentDocumentId;
                                image.fileName = contentVersion != null && contentVersion.Title != null
                                                  ? contentVersion.Title+'.'+contentVersion.FileType.toLowerCase() : '';
                                image.VersionData = contentVersion.VersionData != null ? EncodingUtil.base64Encode(thumbNailRendition) : '';
                                imageElems.add(image);
                                //end of image
                            }
                        }
                    }

                    if(imageElems != null && imageElems.size() > 0) {
                        images.Name = 'RecipeThumbnailDrinkImage';
                        images.Images = imageElems;
                        recipe.Images = images;
                     }
                    //end of image-ThumbnailDrink

                    //recipe.Images = images;
                //w.writeEndElement();
                //end of Recipe Thumbnail Drink Image

                //diageoIngredients
                List<APPIRIO_WrapperUtility_JSON.DiageoIngredient> diageoIngredients = new List<APPIRIO_WrapperUtility_JSON.DiageoIngredient>();

                //w.writeStartElement(null,'diageoIngredients',null);
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
                                brand.Id = diageoIngredient.Recipe_Brand__r.API_External_ID__c != null
                                            ? diageoIngredient.Recipe_Brand__r.API_External_ID__c : '';
                                brand.Locale = diageoIngredient.Recipe_Brand__r.Locale__c != null ? diageoIngredient.Recipe_Brand__r.Locale__c : '';
                                brand.Name = diageoIngredient.Recipe_Brand__r.Name != null ? diageoIngredient.Recipe_Brand__r.Name : '';
                                diageoIngredientElem.brand = brand;
                                //end of brand

                            //w.writeEndElement();
                            //end of diageoIngredient
                            diageoIngredients.add(diageoIngredientElem);
                        }
                    }
                    if(diageoIngredients != null && diageoIngredients.size() > 0) {
                        recipe.diageoIngredients = diageoIngredients;
                    }
                    //recipe.diageoIngredients = diageoIngredients;

                //w.writeEndElement();
                //end of diageoIngredients

            recipes.Recipe.add(recipe);
            //w.writeEndElement();
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

        mapContentDisplayIDContentVersion = null;
        mapOZTo5Mils = null;
        mapMLToOZ = null;

        return recipes;
    }
}