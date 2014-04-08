@IsTest(SeeAllData=true)
public class POS_APIDeleteImage_Test{
    
    static testmethod void testDeleteItemImage () {	
    	
    	RestContext.response = new RestResponse(); // Important to set this for testMethod
    	POS_TestDataUtil.initializeTestData();   
    	Program__c pg1 = POS_TestDataUtil.createProgram();
    	Item__c itm = POS_TestDataUtil.createItem(pg1);
		
    	Item_Image__c itemImage = new Item_Image__c();
	    itemImage.Item__c = itm.id;
	    insert itemImage;
	        
	    itemImage.File_Name__c = 'CaptainMorgan-Jersey-Sm.jpg';
	    String rtnValue = POS_APIDeleteImage.doDelete(itemImage);
	    system.assertEquals( null, rtnValue ); 

    	itemImage.Magento_File_Name__c = '/C/a/CaptainMorgan-Jersey-Sm.jpg';
    	rtnValue = POS_APIDeleteImage.doDelete(itemImage);
    	system.assertEquals( 'success', rtnValue );	

    }    

}