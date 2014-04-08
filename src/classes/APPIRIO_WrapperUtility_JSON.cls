/********************************************************************************************************************
Name        : APPIRIO_WrapperUtility_JSON
Updated By  : Appirio India(Rahul Mittal)
Date        : 23rd Jan, 2014
Purpose     : Wrapper utility class to create response in JSON format
********************************************************************************************************************/
global class APPIRIO_WrapperUtility_JSON {
  global class Recipes {
    public List<Recipe> Recipe {get; set;}
    public String endOfResponse {get; set;}
    public String RecipesReturned {get; set;}
    public String resumePoint {get; set;}
    public Error Error {get; set;}
  }

  public class Recipe {
    public String sfRecipeId {get; set;}
    public String neoRecipeId {get; set;}
    public String Locale {get; set;}
    public String Language {get; set;}
    public String lastModified {get; set;}
    public String recipeTitle {get; set;}
    public FeaturedIngredient featuredIngredient {get; set;}
    public Attributes Attributes {get; set;}
    public Occasions occasions {get; set;}
    public Images Images {get; set;}
    public String publishedStatus {get; set;}

    public List<DiageoIngredient> DiageoIngredients {get; set;}
    public List<Ingredient> Ingredients {get; set;}
    public List<PrepStep> PrepSteps {get; set;}
  }

  public class Error {
    public String ErrorMessage {get; set;}
    public String ErrorCode {get; set;}
  }

   public class Attributes {
    public List<Attribute> Attribute {get; set;}
    public List<AttributeElement> DynamicAttribute {get; set;}
    public String RecipeTag {get; set;}
  }

  public class Attribute {
    public List<AttributeElement> AttributeElement {get; set;}
    public String Name {get; set;}
  }

  public class AttributeElement {
    public String Id {get; set;}
    public String Locale {get; set;}
    public String Name {get; set;}
    public String value {get; set;}
  }

  public class Occasions {
    public List<Occasion> Occasion {get; set;}
    public List<Tags> Tags {get; set;}
  }

  public class Occasion {
    public String id {get; set;}
    public String Locale {get; set;}
    public String name {get; set;}
  }

  public class Tags {
    public String occasion_tag {get; set;}
  }

  global class Images {
    public List<Image> Images {get; set;}
    public String Name {get; set;}
    public Error Error {get; set;}
  }

  public class Image {
    public String imageType {get; set;}
    public String sfImageAssetId {get; set;}
    public String fileName {get; set;}
    public String VersionData {get; set;}
    public String ContentDisplayID {get; set;}
  }

  public class DiageoIngredients {
    public List<DiageoIngredient> DiageoIngredients {get; set;}
  }

  public class DiageoIngredient {
    public String id {get; set;}
    public String Locale {get; set;}
    public String name {get; set;}
    public String quantity {get; set;}
    public String units {get; set;}
    public String ozquantity {get; set;}
    public String mlquantity {get; set;}
    public String featured {get; set;}
    public Brand brand {get; set;}
  }

  public class Brand {
    public String id {get; set;}
    public String Locale {get; set;}
    public String Name {get; set;}
  }

  public class Ingredients {
    public List<Ingredient> Ingredients {get; set;}
  }

  public class Ingredient {
    public String id {get; set;}
    public String Locale {get; set;}
    public String name {get; set;}
    public String quantity {get; set;}
    public String units {get; set;}
    public String ozquantity {get; set;}
    public String mlquantity {get; set;}
  }

  public class OtherIngredients {
    public List<OtherIngredient> OtherIngredients {get; set;}
  }

  public class OtherIngredient {
    public String id {get; set;}
    public String Locale {get; set;}
    public String name {get; set;}
    public String quantity {get; set;}
    public String units {get; set;}
  }

  public class PrepSteps {
    public List<PrepStep> PrepSteps {get; set;}
  }

  public class PrepStep {
    public String stepNo {get; set;}
    public String instruction {get; set;}
  }

  public class RecipeTags {
    public String RecipeTag {get; set;}
  }

  public class FeaturedIngredient {
    public List<FeaturedBrand> featuredBrands {get; set;}
    public List<FeaturedProduct> featuredProducts {get; set;}
  }

  public class FeaturedBrand {
     public String Id {get; set;}
     public String Locale {get; set;}
     public String Name {get; set;}
  }

  public class FeaturedProduct {
     public String Id {get; set;}
     public String Locale {get; set;}
     public String Name {get; set;}
  }

  public class RecipeClassification {
    public String AttributeType {get; set;}
  }

  global class RecipeClassifications {
    public List<RecipeClassification> RecipeClassifications {get; set;}
    public Error Error {get; set;}
  }

  public class RecipeClassificationDtl {
    public String key {get; set;}
    public List<Value> Values {get; set;}
  }

  public class Value {
    public String Id {get; set;}
    public String Locale {get; set;}
    public String Name {get; set;}
    public String Type {get; set;}
    public String Category {get; set;}
    public String BrandId {get; set;}
    public String Tags {get; set;}
  }

  global class RecipeClassificationsDtl {
    public List<RecipeClassificationDtl> RecipeClassificationDetails {get; set;}
    public Error Error {get; set;}
  }

  global class ShoppingList {
    public List<DiageoIngredient> DiageoIngredients {get; set;}
    public List<OtherIngredient> OtherIngredients {get; set;}
    public Error Error {get; set;}
  }

  //-------------------------------------------------------------------------------------------------
  // Method to get error information if any of error is returning
  //-------------------------------------------------------------------------------------------------
  public static APPIRIO_WrapperUtility_JSON.Error generateErrorResponse(String errorMessage, String errorCode) {
      APPIRIO_WrapperUtility_JSON.Error error = new APPIRIO_WrapperUtility_JSON.Error();
      error.ErrorMessage = errorMessage;
      error.ErrorCode = errorCode;
      return error;
  }

  //-------------------------------------------------------------------------------------------------
  // Method to get error information if any of error is returning
  //-------------------------------------------------------------------------------------------------
  public static APPIRIO_WrapperUtility_JSON.Recipes getErrorMessage(String errorMessage) {
      APPIRIO_WrapperUtility_JSON.Recipes recipes = new APPIRIO_WrapperUtility_JSON.Recipes();
      APPIRIO_WrapperUtility_JSON.Error error = new APPIRIO_WrapperUtility_JSON.Error();
      error.ErrorMessage = errorMessage;
      recipes.Error = error;
      return recipes;
  }

  //-------------------------------------------------------------------------------------------------
  // Method to create JSON string using JOSN creator from response
  //-------------------------------------------------------------------------------------------------
  public static String getJSONStringifier(APPIRIO_WrapperUtility_JSON.Recipes recipes) {
    String tempStr = '';
    JSONGenerator gen = JSON.createGenerator(true);
    if(recipes != null){
        gen.writeStartObject();
        if(recipes.endOfResponse != null && recipes.endOfResponse.trim() != '') {
            gen.writeStringField('endOfResponse', recipes.endOfResponse);
        }
        if(recipes.RecipesReturned != null && recipes.RecipesReturned.trim() != '') {
            gen.writeStringField('RecipesReturned', recipes.RecipesReturned);
        }
        if(recipes.resumePoint != null && recipes.resumePoint.trim() != '') {
            gen.writeStringField('resumePoint', recipes.resumePoint);
        }

        if(recipes.Error != null) {
            gen.writeFieldName('Error');
            gen.writeStartObject();
            if(recipes.Error.ErrorMessage != null && recipes.Error.ErrorMessage.trim() != '') {
                gen.writeStringField('ErrorMessage', recipes.Error.ErrorMessage);
            }
            if(recipes.Error.ErrorCode != null && recipes.Error.ErrorCode.trim() != '') {
                gen.writeStringField('ErrorCode', recipes.Error.ErrorCode);
            }
            gen.writeEndObject();
        }else if(recipes.Recipe != null && recipes.Recipe.size() > 0) {
            gen.writeFieldName('Recipe');
            gen.writeStartArray();

            for(APPIRIO_WrapperUtility_JSON.Recipe recipe : recipes.Recipe) {
                gen.writeStartObject();
                if(recipe.sfRecipeId != null && recipe.sfRecipeId.trim() != '') {
                    gen.writeStringField('sfRecipeId', recipe.sfRecipeId);
                }
                if(recipe.neoRecipeId != null && recipe.neoRecipeId.trim() != '') {
                    gen.writeStringField('neoRecipeId', recipe.neoRecipeId);
                }
                if(recipe.Locale != null && recipe.Locale.trim() != '') {
                    gen.writeStringField('Locale', recipe.Locale);
                }
                if(recipe.Language != null && recipe.Language.trim() != '') {
                    gen.writeStringField('Language', recipe.Language);
                }
                if(recipe.lastModified != null && recipe.lastModified.trim() != '') {
                    gen.writeStringField('lastModified', recipe.lastModified);
                }
                if(recipe.recipeTitle != null && recipe.recipeTitle.trim() != '') {
                    gen.writeStringField('recipeTitle', recipe.recipeTitle);
                }
                if(recipe.publishedStatus != null && recipe.publishedStatus.trim() != '') {
                    gen.writeStringField('publishedStatus', recipe.publishedStatus);
                }

                if(recipe.featuredIngredient != null) {
                    gen.writeFieldName('featuredIngredient');
                    gen.writeStartObject();

                    if(recipe.featuredIngredient.featuredBrands != null && recipe.featuredIngredient.featuredBrands.size() > 0) {
                        gen.writeFieldName('featuredBrands');
                        gen.writeStartArray();
                        for(APPIRIO_WrapperUtility_JSON.FeaturedBrand featuredBrand : recipe.featuredIngredient.featuredBrands) {
                            gen.writeStartObject();

                            if(featuredBrand.Name != null && featuredBrand.Name.trim() != '') {
                                gen.writeStringField('Name', featuredBrand.Name);
                            }
                            if(featuredBrand.Locale != null && featuredBrand.Locale.trim() != '') {
                                gen.writeStringField('Locale', featuredBrand.Locale);
                            }
                            if(featuredBrand.Id != null && featuredBrand.Id.trim() != '') {
                                gen.writeStringField('Id', featuredBrand.Id);
                            }
                            gen.writeEndObject();
                        }
                        gen.writeEndArray();
                    }

                    if(recipe.featuredIngredient.featuredProducts != null && recipe.featuredIngredient.featuredProducts.size() > 0) {
                        gen.writeFieldName('featuredProducts');
                        gen.writeStartArray();
                        for(APPIRIO_WrapperUtility_JSON.FeaturedProduct featuredProduct : recipe.featuredIngredient.featuredProducts) {
                            gen.writeStartObject();

                            if(featuredProduct.Name != null && featuredProduct.Name.trim() != '') {
                                gen.writeStringField('Name', featuredProduct.Name);
                            }
                            if(featuredProduct.Locale != null && featuredProduct.Locale.trim() != '') {
                                gen.writeStringField('Locale', featuredProduct.Locale);
                            }
                            if(featuredProduct.Id != null && featuredProduct.Id.trim() != '') {
                                gen.writeStringField('Id', featuredProduct.Id);
                            }
                            gen.writeEndObject();
                        }
                        gen.writeEndArray();
                    }
                    gen.writeEndObject();
                }


                if(recipe.Attributes != null) {
                    gen.writeFieldName('Attributes');
                    gen.writeStartObject();

                    if(recipe.Attributes.Attribute != null && recipe.Attributes.Attribute.size() > 0) {
                        gen.writeFieldName('Attribute');
                        gen.writeStartArray();
                        for(APPIRIO_WrapperUtility_JSON.Attribute attribute : recipe.Attributes.Attribute) {
                            gen.writeStartObject();

                            if(attribute.Name != null && attribute.Name.trim() != '') {
                                gen.writeStringField('Name', attribute.Name);
                            }
                            if(attribute.AttributeElement != null && attribute.AttributeElement.size() > 0) {
                                gen.writeFieldName('AttributeElement');
                                gen.writeStartArray();
                                for(APPIRIO_WrapperUtility_JSON.AttributeElement attributeElement : attribute.AttributeElement) {
                                    gen.writeStartObject();

                                    if(attributeElement.Name != null && attributeElement.Name.trim() != '') {
                                        gen.writeStringField('Name', attributeElement.Name);
                                    }
                                    if(attributeElement.Value != null && attributeElement.Value.trim() != '') {
                                        gen.writeStringField('Value', attributeElement.Value);
                                    }
                                    if(attributeElement.Locale != null && attributeElement.Locale.trim() != '') {
                                        gen.writeStringField('Locale', attributeElement.Locale);
                                    }
                                    if(attributeElement.Id != null && attributeElement.Id.trim() != '') {
                                        gen.writeStringField('Id', attributeElement.Id);
                                    }
                                    gen.writeEndObject();
                                }
                                gen.writeEndArray();
                            }
                            gen.writeEndObject();
                        }
                        gen.writeEndArray();
                    }

                    if(recipe.Attributes.DynamicAttribute != null && recipe.Attributes.DynamicAttribute.size() > 0) {
                        gen.writeFieldName('DynamicAttribute');
                        gen.writeStartArray();
                            for(APPIRIO_WrapperUtility_JSON.AttributeElement attributeElement : recipe.Attributes.DynamicAttribute) {
                                gen.writeStartObject();

                                if(attributeElement.Name != null && attributeElement.Name.trim() != '') {
                                    gen.writeStringField('Name', attributeElement.Name);
                                }
                                if(attributeElement.Value != null && attributeElement.Value.trim() != '') {
                                    gen.writeStringField('Value', attributeElement.Value);
                                }
                                if(attributeElement.Locale != null && attributeElement.Locale.trim() != '') {
                                    gen.writeStringField('Locale', attributeElement.Locale);
                                }
                                if(attributeElement.Id != null && attributeElement.Id.trim() != '') {
                                    gen.writeStringField('Id', attributeElement.Id);
                                }
                                gen.writeEndObject();
                            }
                        gen.writeEndArray();
                    }

                    if(recipe.Attributes.RecipeTag != null && recipe.Attributes.RecipeTag.trim() != '') {
                        gen.writeStringField('RecipeTag', recipe.Attributes.RecipeTag);
                    }
                    gen.writeEndObject();
                }

                //Occassions
                if(recipe.Occasions != null && ((recipe.Occasions.Occasion != null && recipe.Occasions.Occasion.size() > 0)
                                                || (recipe.Occasions.Tags != null && recipe.Occasions.Tags.size() > 0))) {
                    gen.writeFieldName('Occasions');
                    gen.writeStartObject();

                    if(recipe.Occasions.Occasion != null && recipe.Occasions.Occasion.size() > 0) {
                        gen.writeFieldName('Occasion');
                        gen.writeStartArray();
                        for(APPIRIO_WrapperUtility_JSON.Occasion occasion : recipe.Occasions.Occasion) {
                            gen.writeStartObject();

                            if(occasion.Name != null && occasion.Name.trim() != '') {
                                gen.writeStringField('Name', occasion.Name);
                            }
                            if(occasion.Locale != null && occasion.Locale.trim() != '') {
                                gen.writeStringField('Locale', occasion.Locale);
                            }
                            if(occasion.Id != null && occasion.Id.trim() != '') {
                                gen.writeStringField('Id', occasion.Id);
                            }
                            gen.writeEndObject();
                        }
                        gen.writeEndArray();
                    }

                    if(recipe.Occasions.Tags != null && recipe.Occasions.Tags.size() > 0) {
                        gen.writeFieldName('Tags');
                        gen.writeStartArray();

                        for(APPIRIO_WrapperUtility_JSON.Tags tag : recipe.Occasions.Tags) {
                            gen.writeStartObject();
                            if(tag.occasion_tag != null && tag.occasion_tag.trim() != '') {
                                gen.writeStringField('RecipeTag', tag.occasion_tag);
                            }
                            gen.writeEndObject();
                        }

                        gen.writeEndArray();
                    }
                    gen.writeEndObject();
                }


                //Images
                if(recipe.Images != null) {
                    gen.writeFieldName('Images');
                    gen.writeStartObject();

                    if(recipe.Images.Name != null && recipe.Images.Name.trim() != '') {
                        gen.writeStringField('Name', recipe.Images.Name);
                    }

                    if(recipe.Images.Images != null && recipe.Images.Images.size() > 0) {
                        gen.writeFieldName('Images');
                        gen.writeStartArray();
                        for(APPIRIO_WrapperUtility_JSON.Image image : recipe.Images.Images) {
                            gen.writeStartObject();

                            if(image.imageType != null && image.imageType.trim() != '') {
                                gen.writeStringField('imageType', image.imageType);
                            }
                            if(image.sfImageAssetId != null && image.sfImageAssetId.trim() != '') {
                                gen.writeStringField('sfImageAssetId', image.sfImageAssetId);
                            }
                            if(image.fileName != null && image.fileName.trim() != '') {
                                gen.writeStringField('fileName', image.fileName);
                            }
                            if(image.VersionData != null && image.VersionData.trim() != '') {
                                gen.writeStringField('VersionData', image.VersionData);
                            }
                            if(image.ContentDisplayID != null && image.ContentDisplayID.trim() != '') {
                                gen.writeStringField('ContentDisplayID', image.ContentDisplayID);
                            }
                            gen.writeEndObject();
                        }
                        gen.writeEndArray();
                    }
                    gen.writeEndObject();
                }

                //DiageoIngredients
                if(recipe.DiageoIngredients != null && recipe.DiageoIngredients.size() > 0) {
                    gen.writeFieldName('DiageoIngredients');
                    gen.writeStartArray();
                    for(APPIRIO_WrapperUtility_JSON.DiageoIngredient diageoIngredient : recipe.DiageoIngredients) {
                        gen.writeStartObject();

                        if(diageoIngredient.units != null && diageoIngredient.units.trim() != '') {
                            gen.writeStringField('units', diageoIngredient.units);
                        }
                        if(diageoIngredient.quantity != null && diageoIngredient.quantity.trim() != '') {
                            gen.writeStringField('quantity', diageoIngredient.quantity);
                        }
                        if(diageoIngredient.ozquantity != null && diageoIngredient.ozquantity.trim() != '') {
                            gen.writeStringField('ozquantity', diageoIngredient.ozquantity);
                        }
                        if(diageoIngredient.name != null && diageoIngredient.name.trim() != '') {
                            gen.writeStringField('name', diageoIngredient.name);
                        }
                        if(diageoIngredient.mlquantity != null && diageoIngredient.mlquantity.trim() != '') {
                            gen.writeStringField('mlquantity', diageoIngredient.mlquantity);
                        }
                        if(diageoIngredient.Locale != null && diageoIngredient.Locale.trim() != '') {
                            gen.writeStringField('Locale', diageoIngredient.Locale);
                        }
                        if(diageoIngredient.id != null && diageoIngredient.id.trim() != '') {
                            gen.writeStringField('id', diageoIngredient.id);
                        }
                        if(diageoIngredient.featured != null && diageoIngredient.featured.trim() != '') {
                            gen.writeStringField('featured', diageoIngredient.featured);
                        }

                        if(diageoIngredient.brand != null) {
                            gen.writeFieldName('brand');
                            gen.writeStartObject();
                            if(diageoIngredient.brand.Name != null && diageoIngredient.brand.Name.trim() != '') {
                                gen.writeStringField('Name', diageoIngredient.brand.Name);
                            }
                            if(diageoIngredient.brand.Locale != null && diageoIngredient.brand.Locale.trim() != '') {
                                gen.writeStringField('Locale', diageoIngredient.brand.Locale);
                            }
                            if(diageoIngredient.brand.Id != null && diageoIngredient.brand.Id.trim() != '') {
                                gen.writeStringField('Id', diageoIngredient.brand.Id);
                            }
                            gen.writeEndObject();
                        }
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                }

                //Ingredients
                if(recipe.Ingredients != null && recipe.Ingredients.size() > 0) {
                    gen.writeFieldName('Ingredients');
                    gen.writeStartArray();
                    for(APPIRIO_WrapperUtility_JSON.Ingredient ingredient : recipe.Ingredients) {
                        gen.writeStartObject();

                        if(ingredient.units != null && ingredient.units.trim() != '') {
                            gen.writeStringField('units', ingredient.units);
                        }
                        if(ingredient.quantity != null && ingredient.quantity.trim() != '') {
                            gen.writeStringField('quantity', ingredient.quantity);
                        }
                        if(ingredient.ozquantity != null && ingredient.ozquantity.trim() != '') {
                            gen.writeStringField('ozquantity', ingredient.ozquantity);
                        }
                        if(ingredient.name != null && ingredient.name.trim() != '') {
                            gen.writeStringField('name', ingredient.name);
                        }
                        if(ingredient.mlquantity != null && ingredient.mlquantity.trim() != '') {
                            gen.writeStringField('mlquantity', ingredient.mlquantity);
                        }
                        if(ingredient.Locale != null && ingredient.Locale.trim() != '') {
                            gen.writeStringField('Locale', ingredient.Locale);
                        }
                        if(ingredient.id != null && ingredient.id.trim() != '') {
                            gen.writeStringField('id', ingredient.id);
                        }
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                }

                //PrepSteps
                if(recipe.PrepSteps != null && recipe.PrepSteps.size() > 0) {
                    gen.writeFieldName('PrepSteps');
                    gen.writeStartArray();
                    for(APPIRIO_WrapperUtility_JSON.PrepStep prepStep : recipe.PrepSteps) {
                        gen.writeStartObject();

                        if(prepStep.stepNo != null && prepStep.stepNo.trim() != '') {
                            gen.writeStringField('stepNo', prepStep.stepNo);
                        }
                        if(prepStep.instruction != null && prepStep.instruction.trim() != '') {
                            gen.writeStringField('instruction', prepStep.instruction);
                        }
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                }
                gen.writeEndObject();
            }

            gen.writeEndArray();
        }
        gen.writeEndObject();
    }
    tempStr = gen.getAsString();
    return tempStr;
  }

  //-------------------------------------------------------------------------------------------------
  // Method to create JSON string using JOSN creator from response for Images
  //-------------------------------------------------------------------------------------------------
  public static String getJSONStringifierForImages(APPIRIO_WrapperUtility_JSON.Images images) {
    String tempStr = '';
    JSONGenerator gen = JSON.createGenerator(true);
    if(images != null){
        gen.writeStartObject();
        if(images.Name != null && images.Name.trim() != '') {
            gen.writeStringField('Name', images.Name);
        }

        if(images.Error != null) {
            gen.writeFieldName('Error');
            gen.writeStartObject();
            if(images.Error.ErrorMessage != null && images.Error.ErrorMessage.trim() != '') {
                gen.writeStringField('ErrorMessage', images.Error.ErrorMessage);
            }
            if(images.Error.ErrorCode != null && images.Error.ErrorCode.trim() != '') {
                gen.writeStringField('ErrorCode', images.Error.ErrorCode);
            }
            gen.writeEndObject();
        }else if(images.Images != null && images.Images.size() > 0) {
            gen.writeFieldName('Images');
            gen.writeStartArray();

            for(APPIRIO_WrapperUtility_JSON.Image image : images.Images) {
                gen.writeStartObject();
                if(image.imageType != null && image.imageType.trim() != '') {
                    gen.writeStringField('imageType', image.imageType);
                }
                if(image.sfImageAssetId != null && image.sfImageAssetId.trim() != '') {
                    gen.writeStringField('sfImageAssetId', image.sfImageAssetId);
                }
                if(image.fileName != null && image.fileName.trim() != '') {
                    gen.writeStringField('fileName', image.fileName);
                }
                if(image.VersionData != null && image.VersionData.trim() != '') {
                    gen.writeStringField('VersionData', image.VersionData);
                }
                if(image.ContentDisplayID != null && image.ContentDisplayID.trim() != '') {
                    gen.writeStringField('ContentDisplayID', image.ContentDisplayID);
                }
                gen.writeEndObject();
            }
            gen.writeEndArray();
        }
        gen.writeEndObject();
    }
    tempStr = gen.getAsString();
    return tempStr;
  }

  //-------------------------------------------------------------------------------------------------
  // Method to create JSON string using JOSN creator from response for RecipeClassifications
  //-------------------------------------------------------------------------------------------------
  public static String getJSONStringForRecipeClassifications(APPIRIO_WrapperUtility_JSON.RecipeClassifications recipeClassifications) {
    String tempStr = '';
    JSONGenerator gen = JSON.createGenerator(true);
    if(recipeClassifications != null){
        gen.writeStartObject();

        if(recipeClassifications.Error != null) {
            gen.writeFieldName('Error');
            gen.writeStartObject();
            if(recipeClassifications.Error.ErrorMessage != null && recipeClassifications.Error.ErrorMessage.trim() != '') {
                gen.writeStringField('ErrorMessage', recipeClassifications.Error.ErrorMessage);
            }
            if(recipeClassifications.Error.ErrorCode != null && recipeClassifications.Error.ErrorCode.trim() != '') {
                gen.writeStringField('ErrorCode', recipeClassifications.Error.ErrorCode);
            }
            gen.writeEndObject();
        }else if(recipeClassifications.RecipeClassifications != null && recipeClassifications.RecipeClassifications.size() > 0) {
            gen.writeFieldName('RecipeClassifications');
            gen.writeStartArray();

            for(APPIRIO_WrapperUtility_JSON.RecipeClassification recipeClassification : recipeClassifications.RecipeClassifications) {
                gen.writeStartObject();
                if(recipeClassification.AttributeType != null && recipeClassification.AttributeType.trim() != '') {
                    gen.writeStringField('AttributeType', recipeClassification.AttributeType);
                }
                gen.writeEndObject();
            }
            gen.writeEndArray();
        }
        gen.writeEndObject();
    }
    tempStr = gen.getAsString();
    return tempStr;
  }

  //-------------------------------------------------------------------------------------------------
  // Method to create JSON string using JOSN creator from response for RecipeClassifications
  //-------------------------------------------------------------------------------------------------
  public static String getJSONStringForRecipeClassificationsDtl(APPIRIO_WrapperUtility_JSON.RecipeClassificationsDtl recipeClassificationsDtl) {
    String tempStr = '';
    JSONGenerator gen = JSON.createGenerator(true);
    if(recipeClassificationsDtl != null){
        gen.writeStartObject();

        if(recipeClassificationsDtl.Error != null) {
            gen.writeFieldName('Error');
            gen.writeStartObject();
            if(recipeClassificationsDtl.Error.ErrorMessage != null && recipeClassificationsDtl.Error.ErrorMessage.trim() != '') {
                gen.writeStringField('ErrorMessage', recipeClassificationsDtl.Error.ErrorMessage);
            }
            if(recipeClassificationsDtl.Error.ErrorCode != null && recipeClassificationsDtl.Error.ErrorCode.trim() != '') {
                gen.writeStringField('ErrorCode', recipeClassificationsDtl.Error.ErrorCode);
            }
            gen.writeEndObject();
        }else if(recipeClassificationsDtl.RecipeClassificationDetails != null && recipeClassificationsDtl.RecipeClassificationDetails.size() > 0) {
            gen.writeFieldName('RecipeClassificationDetails');
            gen.writeStartArray();

            for(APPIRIO_WrapperUtility_JSON.RecipeClassificationDtl recipeClassificationDtl : recipeClassificationsDtl.RecipeClassificationDetails) {
                gen.writeStartObject();
                //Key
                if(recipeClassificationDtl.key != null && recipeClassificationDtl.key.trim() != '') {
                    gen.writeStringField('key', recipeClassificationDtl.key);
                }
                //Values
                if(recipeClassificationDtl.Values != null && recipeClassificationDtl.Values.size() > 0) {
                    gen.writeFieldName('Values');
                    gen.writeStartArray();

                    for(APPIRIO_WrapperUtility_JSON.Value value : recipeClassificationDtl.Values) {
                        gen.writeStartObject();
                        if(value.Id != null && value.Id.trim() != '') {
                            gen.writeStringField('Id', value.Id);
                        }
                        if(value.Locale != null && value.Locale.trim() != '') {
                            gen.writeStringField('Locale', value.Locale);
                        }
                        if(value.Name != null && value.Name.trim() != '') {
                            gen.writeStringField('Name', value.Name);
                        }
                        if(value.Type != null && value.Type.trim() != '') {
                            gen.writeStringField('Type', value.Type);
                        }
                        if(value.Category != null && value.Category.trim() != '') {
                            gen.writeStringField('Category', value.Category);
                        }
                        if(value.BrandId != null && value.BrandId.trim() != '') {
                            gen.writeStringField('BrandId', value.BrandId);
                        }
                        if(value.Tags != null && value.Tags.trim() != '') {
                            gen.writeStringField('Tags', value.Tags);
                        }
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                }
                gen.writeEndObject();
            }
            gen.writeEndArray();
        }
        gen.writeEndObject();
    }
    tempStr = gen.getAsString();
    return tempStr;
  }


  //-------------------------------------------------------------------------------------------------
  // Method to create JSON string using JOSN creator from response for ShoppingList
  //-------------------------------------------------------------------------------------------------
  public static String getJSONStringForShoppingList(APPIRIO_WrapperUtility_JSON.ShoppingList shoppingList) {
    String tempStr = '';
    JSONGenerator gen = JSON.createGenerator(true);
    if(shoppingList != null){
        gen.writeStartObject();

        if(shoppingList.Error != null) {
            gen.writeFieldName('Error');
            gen.writeStartObject();
            if(shoppingList.Error.ErrorMessage != null && shoppingList.Error.ErrorMessage.trim() != '') {
                gen.writeStringField('ErrorMessage', shoppingList.Error.ErrorMessage);
            }
            if(shoppingList.Error.ErrorCode != null && shoppingList.Error.ErrorCode.trim() != '') {
                gen.writeStringField('ErrorCode', shoppingList.Error.ErrorCode);
            }
            gen.writeEndObject();
        }else {
            //diageoIngredients
            if(shoppingList.DiageoIngredients != null && shoppingList.DiageoIngredients.size() > 0) {
                gen.writeFieldName('DiageoIngredients');
                gen.writeStartArray();

                for(APPIRIO_WrapperUtility_JSON.DiageoIngredient diageoIngredient : shoppingList.DiageoIngredients) {
                    gen.writeStartObject();

                    if(diageoIngredient.units != null && diageoIngredient.units.trim() != '') {
                        gen.writeStringField('units', diageoIngredient.units);
                    }
                    if(diageoIngredient.quantity != null && diageoIngredient.quantity.trim() != '') {
                        gen.writeStringField('quantity', diageoIngredient.quantity);
                    }
                    if(diageoIngredient.ozquantity != null && diageoIngredient.ozquantity.trim() != '') {
                        gen.writeStringField('ozquantity', diageoIngredient.ozquantity);
                    }
                    if(diageoIngredient.name != null && diageoIngredient.name.trim() != '') {
                        gen.writeStringField('name', diageoIngredient.name);
                    }
                    if(diageoIngredient.mlquantity != null && diageoIngredient.mlquantity.trim() != '') {
                        gen.writeStringField('mlquantity', diageoIngredient.mlquantity);
                    }
                    if(diageoIngredient.Locale != null && diageoIngredient.Locale.trim() != '') {
                        gen.writeStringField('Locale', diageoIngredient.Locale);
                    }
                    if(diageoIngredient.id != null && diageoIngredient.id.trim() != '') {
                        gen.writeStringField('id', diageoIngredient.id);
                    }
                    if(diageoIngredient.featured != null && diageoIngredient.featured.trim() != '') {
                        gen.writeStringField('featured', diageoIngredient.featured);
                    }

                    if(diageoIngredient.brand != null) {
                        gen.writeFieldName('brand');
                        gen.writeStartObject();
                        if(diageoIngredient.brand.Name != null && diageoIngredient.brand.Name.trim() != '') {
                            gen.writeStringField('Name', diageoIngredient.brand.Name);
                        }
                        if(diageoIngredient.brand.Locale != null && diageoIngredient.brand.Locale.trim() != '') {
                            gen.writeStringField('Locale', diageoIngredient.brand.Locale);
                        }
                        if(diageoIngredient.brand.Id != null && diageoIngredient.brand.Id.trim() != '') {
                            gen.writeStringField('Id', diageoIngredient.brand.Id);
                        }
                        gen.writeEndObject();
                    }
                    gen.writeEndObject();
                }
                gen.writeEndArray();
            }

            if(shoppingList.OtherIngredients != null && shoppingList.OtherIngredients.size() > 0) {
                gen.writeFieldName('OtherIngredients');
                gen.writeStartArray();

                for(APPIRIO_WrapperUtility_JSON.OtherIngredient otherIngredient : shoppingList.OtherIngredients) {
                    gen.writeStartObject();

                    if(otherIngredient.units != null && otherIngredient.units.trim() != '') {
                        gen.writeStringField('units', otherIngredient.units);
                    }
                    if(otherIngredient.quantity != null && otherIngredient.quantity.trim() != '') {
                        gen.writeStringField('quantity', otherIngredient.quantity);
                    }
                    if(otherIngredient.name != null && otherIngredient.name.trim() != '') {
                        gen.writeStringField('name', otherIngredient.name);
                    }
                    if(otherIngredient.Locale != null && otherIngredient.Locale.trim() != '') {
                        gen.writeStringField('Locale', otherIngredient.Locale);
                    }
                    if(otherIngredient.id != null && otherIngredient.id.trim() != '') {
                        gen.writeStringField('id', otherIngredient.id);
                    }
                    gen.writeEndObject();
                }
                gen.writeEndArray();
            }
        }
        gen.writeEndObject();
    }
    tempStr = gen.getAsString();
    return tempStr;
  }

    //Method to get validated formatted JSON
    public static void validatedFormatterJSON(String jsonString) {
        if(!Test.isRunningTest()) {
            RestContext.response.addHeader('Content-Type', 'application/json; charset=utf-8');
            RestContext.response.responseBody = Blob.valueOf(jsonString);
        }
    }
}