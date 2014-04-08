@IsTest(SeeAllData=false)
public class POS_ShipTosMigrateToAccount_Test{
    
    static testmethod void testMigration(){
        Account newAccount = new Account(Name='test1');    
        insert newAccount;
        // Start : Changing for US682/TA1267 - CC9/30: Note #2 - By Siddharth
        Brand__c brd = new Brand__c(Name = 'Portfolio', Classification__c='Spirits', Diageo_Direct_Visible__c=true, Brand_Type__c='Individual Variant');
        // End : Changing for US682/TA1267 - CC9/30: Note #2 - By Siddharth
        insert brd;
        
        //let us create a ship to
        Order_Window__c ow = POS_TestDataUtil.createOrderWindow();
        Program__c program = POS_TestDataUtil.createProgram(ow.Id);
        Item__c item = POS_TestDataUtil.createItem(program);
        User shopper = [Select Id,Name FROM User WHERE Id=:UserInfo.getUserId()];
        Cart__c cart = POS_TestDataUtil.createCart(shopper, ow);
        
        
        
        Ship_To__c shipTo = POS_TestDataUtil.createShipTo();
        
        Cart_Item__c cartItem = new Cart_Item__c();
        cartItem.Item__c=item.Id;
        cartItem.Cart__c=cart.Id;
        cartItem.Quantity__c=item.Packout_Quantity__c;
        cartItem.Ship_To__c=shipTo.Id;
        insert cartItem;
        
        //create user ship to
        User_Ship_To__c us = new User_Ship_To__c();
        us.User__c =shopper .Id;
        us.ship_to__c=shipTo.Id;
        insert us;
        
        
        Test.startTest();
        POS_ShipTosMigrateToAccount job= new POS_ShipTosMigrateToAccount();
        job.doTransfer(shipTo, newAccount);
        Test.StopTest();
        
    } 
}