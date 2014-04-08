@IsTest(SeeAllData=false)
public class OcasionWrapper_Test{
    
    public static testMethod void testMe() {
 
      	OccasionWrapper re = new OccasionWrapper();
      	System.assertEquals(re.checked,false);
 
 	  	Occasion__c occasion = new Occasion__c(Name_Of_The_Occasion__c='Test1');
 	  
 	  	ContentVersion myImage = new ContentVersion();
 	  	myImage.title='TITLE';
 		myImage.contentUrl='http://www.salesforce.com';
        insert myImage;
       
        Recipe_Media__c media = new Recipe_Media__c();
        media.Content_id__c=myImage.Id;
        insert media;
      
        
        occasion.Recipe_Occasion_Image__c = media.Id;        
        OccasionWrapper oc2 = new OccasionWrapper(occasion,'Published');
        System.assertEquals(oc2.checked,true);
        
        occasion.Recipe_Occasion_Image__c = null;
        oc2 = new OccasionWrapper(occasion,'Suppressed');
        	  
      	System.assertEquals(oc2.occ.Name_Of_The_Occasion__c,'Test1');
      	System.assertEquals(oc2.checked,false);
    }
}