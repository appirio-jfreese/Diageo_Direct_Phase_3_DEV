@IsTest(SeeAllData=true)
public class POS_APIUpdateImage_Test{

    static testmethod void testUpdateItemImage () {	
    	
    	RestContext.response = new RestResponse(); // Important to set this for testMethod
    	Program__c pg1 = POS_TestDataUtil.createProgram();
    	Item__c itm = POS_TestDataUtil.createItem(pg1);
		
    	Item_Image__c itemImage = new Item_Image__c();
	    itemImage.Item__c = itm.id;
	    insert itemImage;
	        
	    itemImage.File_Name__c = 'CaptainMorgan-Jersey-Sm.jpg';
	    Item_Image__c rtnImage = POS_APIUpdateImage.doUpdate(itemImage);
	    system.assertEquals( null, rtnImage ); 

    	itemImage.Magento_File_Name__c = '/C/a/CaptainMorgan-Jersey-Sm.jpg';
    	itemImage.Image_Types__c='TEST';
    	rtnImage = POS_APIUpdateImage.doUpdate(itemImage);
    	system.assertNotEquals( null, rtnImage );	
    	
    	//Test error scenarios
	    rtnImage = POS_APIUpdateImage.doUpdate(null);
	    System.assert(rtnImage==null);
	    
	    itemImage.Magento_File_Name__c = null;
	    rtnImage = POS_APIUpdateImage.doUpdate(itemImage);
    	System.assert(rtnImage==null);
    }      

}