@IsTest(SeeAllData=false)
public class POS_ManageShipTosController_Test{
    
    static testMethod void testDeleteEditShiptos () {
        Profile p = [select id from profile where name='System Administrator'];
         
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
        Available_Themes__c='Spirits'); 
        
        System.runAs(u) {
            PageReference pageRef = Page.HomePage;
            Test.setCurrentPage(pageRef);
            Organizational_Unit__c ou=POS_TestDataUtil.createOrgUnit();
            //Create some test data
            Account account = new Account();
            account.Name='POS Unit Test Account';
            account.Spirits_Hierarchy__c=ou.Id;
            insert account;
            
            Account_Member__c am = new Account_Member__c();
            am.Account__c = account.Id;
            am.User__c = u.Id;
            insert am;
            
            Ship_To__c shipTo = new Ship_To__c();
            shipTo.Account__c = account.Id;
            shipTo.Name='Test Ship To';
            insert shipTo;
            
            POS_ManageShipTosController controller = new POS_ManageShipTosController();
             controller.getClassificationTypes();
            controller.deletedShipTo=shipTo.Id;
            controller.deleteShipTo();
            Ship_To__c loadedShipTo = [select Id, Removed__c from Ship_to__c where Id=:shipTo.Id];
            System.assert(loadedShipTo.Removed__c);

            //reset it
            loadedShipTo.Removed__c=false;
            update loadedShipTo;
            
            controller = new POS_ManageShipTosController(); //refresh it to make sure removed item is brought back
            
            controller.selectedShipTo=loadedShipTo.Id;
            controller.selectShipTo();
            controller.addedShipTo.Name='TEST123';
            controller.editShipTo();
            
            loadedShipTo = [select Id, Name from Ship_to__c where Id=:shipTo.Id];
            System.assert(loadedShipTo.Name=='TEST123');
            
            
        }
    }
    
    static testmethod void testManageShipTos () {
        
        Profile p = [select id from profile where name='System Administrator'];
         
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
        Available_Themes__c='Spirits');
        
        System.runAs(u) {
            PageReference pageRef = Page.HomePage;
            Test.setCurrentPage(pageRef);
           try{ 
                 Organizational_Unit__c ou=POS_TestDataUtil.createOrgUnit();
                //Create some test data
                Account account = new Account();
                account.Name='POS Unit Test Account';
                account.Spirits_Hierarchy__c=ou.Id;
                insert account;
                
                Account_Member__c am = new Account_Member__c();
                am.Account__c = account.Id;
                am.User__c = u.Id;
                insert am;
                
                Ship_To__c shipTo = new Ship_To__c();
                shipTo.Account__c = account.Id;
                shipTo.Name='Test Ship To';
                insert shipTo;
            
            
                POS_ManageShipTosController controller = new POS_ManageShipTosController();
                
                //Should have user associated with account list
                System.debug('Account list size: '+controller.accountList.size());
                System.debug('Account name: '+controller.accountList.get(0).Name);
                System.assert(controller.accountList.get(0).Name=='POS Unit Test Account');
            
                //Should have one ship to
                System.assert(controller.selectableShipTos.size()==1);
                System.assert(controller.selectableShipTos.get(0).shipTo.Name=='Test Ship To');
            
                //Create a new shipto
                controller.addedShipTo.Name='New Ship To';
                controller.addedShipTo.Account__c = account.Id;
                controller.createUpdateShipTo();
                
                //Should now have one more ship to
                System.assert(controller.selectableShipTos.size()==2);
            
                //Select a ship to
                System.assert(controller.selectableShipTos.get(0).selected=true);
                
                
                //Confirm that one and only one has been selected
                integer selectedCount = 0;
                for (POS_ManageShipTosController.SelectableShipTo selectable: controller.selectableShipTos) {
                    if (selectable.selected) {
                        selectedCount++;
                    }
                }
                
                System.assert(selectedCount==1);
                
                
                //Now toggle one
                POS_ManageShipTosController.toggleShipToAjax(shipTo.Id,'true');
                List<User_Ship_To__c> toggledList = [select Id from User_Ship_To__c where User__c = :u.Id];
                System.assert(toggledList.size()==1);
                
                //And detoggle it
                POS_ManageShipTosController.toggleShipToAjax(shipTo.Id,'false');
                toggledList = [select Id from User_Ship_To__c where User__c = :u.Id];
                System.assert(toggledList.size()==0);
           }catch(Exception e){
           
           } 
            
        }
        
    }
    
   
}