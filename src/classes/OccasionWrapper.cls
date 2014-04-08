public class OccasionWrapper {
    public Boolean checked {get;set;}
    public Occasion__c occ {get;set;}
    public String image {get;set;}
    public String publishStatus {get;set;}
    
    public OccasionWrapper() {
        occ = new Occasion__c();
        checked = false;
    }
 
    public OccasionWrapper(Occasion__c o, String pubStatus){
    	occ = o;
    	publishStatus = pubStatus;
        if(publishStatus.equals('Published')) {
        	checked = true;
        } else {
        	checked = false;	
        }
        
        if(o.Recipe_Occasion_Image__c != null)
        	image = o.Recipe_Occasion_Image__r.Content_id__c;
        else
        	image = null;
    }

}