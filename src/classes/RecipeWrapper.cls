public class RecipeWrapper {

 
    public Boolean checked{ get; set; }
    public Recipe__c rec { get; set;}
    public String image { get; set;}
    public String publishStatus { get; set;}
    
    public RecipeWrapper() {
        rec = new Recipe__c();
        checked = false;
    }
 
    public RecipeWrapper(Recipe__c r){
        rec = r;
        checked = false;
        if(r.Main_Drink_Image__c!=null)
        	image=r.Main_Drink_Image__r.Content_id__c;
        else if(r.Mobile_Drink_Image__c!=null)
        	image=r.Mobile_Drink_Image__r.Content_id__c;
        else if(r.Mobile_Selected_Image__c!=null)
        	image=r.Mobile_Selected_Image__r.Content_id__c;
        else if(r.Mobile_Unselected_Image__c!=null)
        	image=r.Mobile_Unselected_Image__r.Content_id__c;
        else if(r.Background_Image__c!=null)
        	image=r.Background_Image__r.Content_id__c;
        else if(r.Brand_Recipe_Image__c!=null)
        	image=r.Brand_Recipe_Image__r.Content_id__c;
        else if(r.Search_Recipe_Image__c != null)
        	image = r.Search_Recipe_Image__r.Content_id__c;
        else if(r.Additional_Image_1__c!=null)
        	image=r.Additional_Image_1__r.Content_id__c;
        else if(r.Additional_Image_2__c!=null)
        	image=r.Additional_Image_2__r.Content_id__c;
        else
        	image=null;
    }
    
    public RecipeWrapper(Recipe__c r, String pubStatus){
    	rec = r;
    	publishStatus = pubStatus;
        if(publishStatus.equals('Published')) {
        	checked = true;
        } else {
        	checked = false;	
        }
        
        if(r.Main_Drink_Image__c!=null)
        	image=r.Main_Drink_Image__r.Content_id__c;
        else if(r.Mobile_Drink_Image__c!=null)
        	image=r.Mobile_Drink_Image__r.Content_id__c;
        else if(r.Mobile_Selected_Image__c!=null)
        	image=r.Mobile_Selected_Image__r.Content_id__c;
        else if(r.Mobile_Unselected_Image__c!=null)
        	image=r.Mobile_Unselected_Image__r.Content_id__c;
        else if(r.Background_Image__c!=null)
        	image=r.Background_Image__r.Content_id__c;
        else if(r.Brand_Recipe_Image__c!=null)
        	image=r.Brand_Recipe_Image__r.Content_id__c;
        else if(r.Search_Recipe_Image__c != null)
        	image = r.Search_Recipe_Image__r.Content_id__c;
        else if(r.Additional_Image_1__c!=null)
        	image=r.Additional_Image_1__r.Content_id__c;
        else if(r.Additional_Image_2__c!=null)
        	image=r.Additional_Image_2__r.Content_id__c;
        else
        	image=null;
    }

}