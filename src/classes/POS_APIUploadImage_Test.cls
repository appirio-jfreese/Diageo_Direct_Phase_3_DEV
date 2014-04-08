@IsTest(SeeAllData=true)
public class POS_APIUploadImage_Test{
    static testmethod void testUploadItemImage () {	
    	
    	RestContext.response = new RestResponse(); // Important to set this for testMethod
    	Program__c pg1 = POS_TestDataUtil.createProgram();
    	Item__c itm = POS_TestDataUtil.createItem(pg1);
		
    	Item_Image__c itemImage = new Item_Image__c();
    	//System.debug('********** testUploadItemImage - itemImage.Item__c ' + itemImage.Item__c);
	    Item_Image__c rtnImage = POS_APIUploadImage.doPost(itemImage);
	    system.assertEquals( null, rtnImage );     	

	    itemImage.Item__c = itm.id;
	    rtnImage = POS_APIUploadImage.doPost(itemImage);
	    system.assertEquals( null, rtnImage ); 
	        
	    itemImage.File_Name__c = 'CaptainMorgan-Jersey-Sm.jpg';
	    rtnImage = POS_APIUploadImage.doPost(itemImage);
	    system.assertEquals( null, rtnImage ); 

    	itemImage.Mime_Type__c = 'image/jpeg';
    	itemImage.ImgBase64String__c = '/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBhISERUSExIUEBUUFBAUFBUVEBQUEBUUFBQVFBUU'; // dummy base64 string
    	itemImage.Label__c = 'Captain Morgan Basketball Jersey';
    	itemImage.Position__c = 1;
    	itemImage.Exclude__c = 0;
    	itemImage.Image_Types__c = 'image;thumbnail;small_image';	
    	
    	rtnImage = POS_APIUploadImage.doPost(itemImage);
    	system.assertNotEquals( null, rtnImage );	

    }

}