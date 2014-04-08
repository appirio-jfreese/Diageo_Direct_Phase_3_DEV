/*******************************************************************************
Name        : Test_Controller_Folder
Created By  : Vikash Goyal (Appirio JDC)
Date        : 19th Mar, 2014
Reason      : For Code Coverage of Controller_Folder 
*******************************************************************************/
@isTest
private class Test_Controller_Folder {

    static testMethod void testControllerFolder() {
    	  CollaborationSectionRole__c setting = new CollaborationSectionRole__c(RoleName__c = 'Marketing Directors');
        insert setting;
        
        User mdUser = Test_Helper.generateTestMDUser('12345', false, [SELECT Name FROM Profile Limit 1].Name);
        Organizational_Unit__c orgUnit = Test_Helper.createOrgUnit('SWS', 'Division', 'Spirits');
        insert orgUnit;        
        Account a = Test_Helper.testInsertAccount('Diageo', orgUnit.Id);
        Contact c = Test_Helper.testInsertContact('TestFirst', 'TestLast', a.ID);
        User u = Test_Helper.testInsertDiageoPortalUser(c.ID);
        
        List<Folder__c> lstFolders = new List<Folder__c>();        
        Folder__c folderParentP = Test_Helper.testCreateFolder(false, false, orgUnit.Id, false, false, CONSTANT.PLANNING, null, null);
        Folder__c folderChildP = Test_Helper.testCreateFolder(false, false, orgUnit.Id, false, false, CONSTANT.PLANNING, folderParentP.ID, null);

        Folder__c folderParentPM = Test_Helper.testCreateFolder(false, false, orgUnit.Id, false, false, CONSTANT.PERFORMANCE_MANAGMENT, null, null);
        Folder__c folderChildPM = Test_Helper.testCreateFolder(false, false, orgUnit.Id, false, false, CONSTANT.PERFORMANCE_MANAGMENT, folderParentPM.ID, null);

        Folder__c folderParentC = Test_Helper.testCreateFolder(false, false, orgUnit.Id, false, false, CONSTANT.COLLABORATION, null, null);
        Folder__c folderChildC = Test_Helper.testCreateFolder(false, false, orgUnit.Id, false, false, CONSTANT.COLLABORATION, folderParentC.ID, null);
        lstFolders.add(folderParentP);
        lstFolders.add(folderChildP);
        lstFolders.add(folderParentPM);
        lstFolders.add(folderChildPM);
        lstFolders.add(folderParentC);
        lstFolders.add(folderChildC);
        
        System.runAs(mdUser){
          insert lstFolders;
        }  
        
        System.runAs(u){
            ApexPages.StandardController sc = new ApexPages.standardController(folderParentP);
            Controller_Folder cf= new Controller_Folder(sc);
            
            sc = new ApexPages.standardController(folderParentPM);
            cf= new Controller_Folder(sc);
            cf.SelectedDivisions = orgUnit.Id;
            cf.SelectedDistributorIds = a.id;
            cf.updateDistributors();
            cf.updateOrganizationUnits();
            cf.getThemes();
            cf.changeTheme();

            sc = new ApexPages.standardController(folderParentC);
            cf= new Controller_Folder(sc);
            cf.SelectedDivisions = orgUnit.Id;
            cf.SelectedDistributorIds = a.id;
            cf.SelectedOrganizationUnits = orgUnit.id;
            cf.updateDistributors();
            cf.updateOrganizationUnits();
            cf.save();
    		}
    }
}