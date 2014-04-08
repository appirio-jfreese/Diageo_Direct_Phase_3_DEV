/*******************************************************************************
Name        : Test_Helper
 

Updated By  : Basant Verma (Appirio JDC)
Date        : 02/03/2014
Story/Task  : Code Coverage and Data Cleanup
*******************************************************************************/
@isTest
public class Test_Helper {

    public static User MDUser;
    /**
    * @author Denise Bacher
    * @date 09/08/2011
    * @description Insert a test Account
    * @return A test Account
    */
    public static Account testInsertAccount(String accountName){
        Organizational_Unit__c ou = new Organizational_Unit__c(Label__c = 'Division', Type__c = 'Spirits');
        insert ou;
        Account testAccount = new Account(name=accountName, Spirits_Hierarchy__c = ou.id);
        testAccount.BillingState = 'CT';
        insert testAccount;
        
        return testAccount;
    }
 
    /**
    * @author Bartosz Dudziak / modified by Maciej Krol
    * @date 15/11/2011 / 07/10/2012
    * @description Insert a test Account
    * @return A test Account
    */
    public static Account testInsertAccount(String accountName, Id OUId) {
        Account testAccount = new Account(name=accountName, Spirits_Hierarchy__c = OUId);
        testAccount.BillingState = 'CT';
        insert testAccount;
        
        return testAccount;
    }
    /**
    * @author Denise Bacher
    * @date 04/08/2011
    * @description Insert a test Contact
    * @return A test Contact
    */
    public static Contact testInsertContact(String firstName, String lastName, ID accountID){
        Contact testContact = new Contact(firstname=firstName, lastname=lastName, accountID = accountID);
        insert testContact;
        
        return testContact;
    }
    // START : Changed to avoid Test Class Failures and Improve test classes : Basant Verma (Appirio JDC) : 4th Feb, 2014
    /**
    * @author Denise Bacher
    * @date 09/08/2011
    * @description Insert a test Brand
    * @return A test Brand
    */
    public static Brand__c testInsertBrand(String brandName){
        return testCreateBrand(brandName, true);
    }
    
    public static Brand__c testCreateBrand(String brandName, Boolean isInsert){
        Brand__c testBrand = new Brand__c();
        testBrand.Name = brandName;
        testBrand.diageo_direct_visible__c = true;
        testBrand.Classification__c = 'Spirits';
        
        if(isInsert)
            insert testBrand;
        
        return testBrand;
    }
    // END : Changed to avoid Test Class Failures and Improve test classes : Basant Verma (Appirio JDC) : 4th Feb, 2014
    
    public static Brand__c testCreateBrand(String brandName, Id parentBrandId, String categoryName){
        Brand__c testBrand = new Brand__c();
        testBrand.Name = brandName;
        testBrand.Parent_Brand__c = parentBrandId;
        testBrand.Category__c = categoryName;
        testBrand.diageo_direct_visible__c = true;
        testBrand.Classification__c = 'Spirits';
        
        return testBrand;
    }
    
    /**
    * @author Denise Bacher
    * @date 09/08/2011
    * @description Insert a test child Brand (aka brand varient)
    * @return A test child Brand
    */
    public static Brand__c testInsertChildBrand(String brandName, ID brandID){
        Brand__c testBrand = new Brand__c();
        testBrand.Name = brandName;
        testBrand.Parent_Brand__c = brandID;
        testBrand.diageo_direct_visible__c = true;
        testBrand.Classification__c = 'Spirits';
        insert testBrand;
        
        return testBrand;
    }
    
    /**
    * @author Denise Bacher
    * @date 09/08/2011
    * @description Insert a test AccountBrand (links a brand to an account)
    * @return A test AccountBrand
    */
    public static AccountBrand__c testInsertAccountBrand(ID accountID, ID brandID){
        AccountBrand__c testActBrand = new AccountBrand__c();
        testActBrand.Name = 'Test AccountBrand';
        testActBrand.Account__c = accountID;
        testActBrand.Brand__c = brandID;
        insert testActBrand;
        
        return testActBrand;
    }
    
    /**
    * @author Basant Verma
    * @date 9th Jan, 2014
    * @description Create a test AccountBrand (links a brand to an account)
    * @return A test AccountBrand
    */
    public static AccountBrand__c testCreateAccountBrand(ID accountID, ID brandID){
        AccountBrand__c testActBrand = new AccountBrand__c();
        testActBrand.Name = 'Test AccountBrand';
        testActBrand.Account__c = accountID;
        testActBrand.Brand__c = brandID;
        
        return testActBrand;
    }
    
     public static void testInsertAccountBrand(ID accountID, List<Brand__c> brands){
        
        List<AccountBrand__c> ab = new AccountBrand__c[]{};
        for(Brand__c brand : brands){
            AccountBrand__c testActBrand = new AccountBrand__c();
            testActBrand.Name = 'Test AccountBrand';
            testActBrand.Account__c = accountID;
            testActBrand.Brand__c = brand.ID;
            
            ab.add(testActBrand);
        }
        insert ab;
    }
    
    public static List<AccountBrand__c> testCreateAccountBrand(ID accountID, List<Brand__c> brands){
        
        List<AccountBrand__c> ab = new AccountBrand__c[]{};
        for(Brand__c brand : brands){
            AccountBrand__c testActBrand = new AccountBrand__c();
            testActBrand.Name = 'Test AccountBrand';
            testActBrand.Account__c = accountID;
            testActBrand.Brand__c = brand.ID;
            
            ab.add(testActBrand);
        }
        return ab;
    }
    
    
    /**
    *   @used to get a basic test user.
    *   @Author     : Jeremy Mooer
    *   @Date       : 24 Jun 2012
    */
    public static User generateTestUser(String randomFiveDigitString, Boolean insertUser, String profileName)
    {
        User userToReturn = new User();
        userToReturn.Alias = randomFiveDigitString;
        userToReturn.Email = randomFiveDigitString + '@testorg.com';
        userToReturn.EmailEncodingKey = 'UTF-8';
        userToReturn.LastName = 'Test' + randomFiveDigitString;
        userToReturn.LanguageLocaleKey = 'en_US';
        userToReturn.LocaleSidKey = 'en_US';
        userToReturn.ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id;
        userToReturn.TimeZoneSidKey = 'America/Chicago';
        userToReturn.Username = randomFiveDigitString + '@test' + Math.round(Math.random() * 10000) + '.com';
        userToReturn.UserRoleId = null;
        userToReturn.Country = 'United States';
        userToReturn.Use_current_theme_as_default__c = 'Spirits';
        userToReturn.Diageo_Direct_Theme__c = 'Spirits';
        userToReturn.Available_Themes__c = 'Spirits; Wine; Beer'; 
        if(insertUser)
            insert userToReturn;
        
        return userToReturn;
    }
    
    
    /**
    * @author Denise Bacher
    * @date 09/08/2011
    * @description Insert a test distributor portal User
    * @return A test User
    */
    public static User testInsertDistributorPortalUser(ID contactID){
        double uniqueNum = Math.round(Math.random() * 10000);
        string uniqueKey = 'user' + uniqueNum;
        
        User testUser = new User();
        testUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Distributor Portal User'].Id;
        testUser.Alias = 'u'+uniqueNum;
        testUser.FirstName = 'Test' + uniqueKey;
        testUser.LastName = 'Test' + uniqueKey;
        testUser.Username = uniqueKey + '@test' + uniqueNum + '.com';
        testUser.Email = uniqueKey + '@testorg.com';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/Chicago';
        testUser.LocaleSidKey = 'en_US';
        testUser.Country = 'United States';
        testUser.IsActive = true;
        testUser.ContactId = contactID;
        testUser.UserPermissionsSFContentUser = true;
        testUser.Use_current_theme_as_default__c = 'Spirits';
        testUser.Diageo_Direct_Theme__c = 'Spirits'; 
        testUser.Available_Themes__c = 'Spirits; Wine; Beer';
        insert testUser;
        
        // Retrieve the roles for the user's account and assign one to the user
        
        Set<ID> aIDs = new Set<ID>();
        for(contact c: [select AccountID from Contact where id = :contactID]){
            aIDs.add(c.AccountID);
        }
        List<UserRole> roles = [select name, id, PortalRole from UserRole where PortalAccountId in :aIDs and name like '%Customer User%'];

        list<Account_Member__c> members = new list<Account_Member__c>();
        for(id amcid : aIDs){
            Account_Member__c am = new Account_Member__c();
            am.Account__c = amcid;
            am.User__c = testUser.id;
            am.Default__c = true;
            members.add(am);
        }
         
        if(members.size() != 0){
            insert members;
        }
        
        //Update the test user with the portal user role
        testUser.UserRoleId = roles[0].Id;
        testUser.loginDate__c = datetime.now();  
        update testUser;      
        
        return testUser;
    }

    /**
    * @author Denise Bacher
    * @date 09/08/2011
    * @description Insert a test distributor portal User
    * @return A test User
    */
    
    public static User testInsertDiageoPortalUser(ID contactID){
        double uniqueNum = Math.round(Math.random() * 10000);
        string uniqueKey = 'user' + uniqueNum;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        User testUser = new User();
        
        System.runAs ( thisUser ) {
            testUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Diageo Portal User'].Id;
            testUser.Alias = 'u'+uniqueNum;
            testUser.FirstName = 'Test' + uniqueKey;
            testUser.LastName = 'Test' + uniqueKey;
            testUser.Username = uniqueKey + '@test' + uniqueNum + '.com';
            testUser.Email = uniqueKey + '@testorg.com';
            testUser.EmailEncodingKey = 'UTF-8';
            testUser.LanguageLocaleKey = 'en_US';
            testUser.TimeZoneSidKey = 'America/Chicago';
            testUser.LocaleSidKey = 'en_US';
            testUser.Country = 'United States';
            testUser.IsActive = true;
            testUser.ContactId = contactID;
            testUser.UserPermissionsSFContentUser = true;
            testUser.Use_current_theme_as_default__c = 'Spirits';
            testUser.Diageo_Direct_Theme__c = 'Spirits'; 
            testUser.Available_Themes__c = 'Spirits; Wine; Beer'; 
            insert testUser;
            
            // Retrieve the roles for the user's account and assign one to the user
            Set<ID> aIDs = new Set<ID>();
            for(contact c: [select AccountID from Contact where id = :contactID]){
                aIDs.add(c.AccountID);
            }
            List<UserRole> roles = [select name, id, PortalRole from UserRole where PortalAccountId in :aIDs and name like '%Customer User%'];
    
            list<Account_Member__c> members = new list<Account_Member__c>();
            for(id amcid : aIDs){
                Account_Member__c am = new Account_Member__c();
                am.Account__c = amcid;
                am.User__c = testUser.id;
                am.Default__c = true;
                members.add(am);
            }
             
            if(members.size() != 0){
                insert members;
            }
            
            // Update the test user with the portal user role
            testUser.UserRoleId = roles[0].Id;
            testUser.loginDate__c = datetime.now();        
            update testUser;
        }
        
        return testUser;
    }

    /**
    * @author Jonathan Freese
    * @date 06/13/2013
    * @description Insert a test Diageo Employee
    * @return A test User
    */
    
    public static User testInsertDiageoEmployee(){
        double uniqueNum = Math.round(Math.random() * 10000);
        string uniqueKey = 'user' + uniqueNum;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        User testUser = new User();
        
        System.runAs ( thisUser ) {
            testUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Diageo Employee'].Id;
            testUser.Alias = 'u'+uniqueNum;
            testUser.FirstName = 'Test' + uniqueKey;
            testUser.LastName = 'Test' + uniqueKey;
            testUser.Username = uniqueKey + '@test' + uniqueNum + '.com';
            testUser.Email = uniqueKey + '@testorg.com';
            testUser.EmailEncodingKey = 'UTF-8';
            testUser.LanguageLocaleKey = 'en_US';
            testUser.TimeZoneSidKey = 'America/Chicago';
            testUser.LocaleSidKey = 'en_US';
            testUser.Country = 'United States';
            testUser.IsActive = true;
            //testUser.ContactId = contactID; - Not Applicable (Diageo Employee profile has no association tothe Contact object)
            testUser.UserPermissionsSFContentUser = true;
            testUser.Use_current_theme_as_default__c = 'Spirits';
            testUser.Diageo_Direct_Theme__c = 'Spirits';
            testUser.Available_Themes__c = 'Spirits; Wine; Beer'; 
            insert testUser;
            
            // Retrieve the roles for the user's account and assign one to the user
            Set<ID> aIDs = new Set<ID>();
            //for(contact c: [select AccountID from Contact where id = :contactID]){
            //    aIDs.add(c.AccountID);
            //}
            //List<UserRole> roles = [select name, id, PortalRole from UserRole where PortalAccountId in :aIDs and name like '%Customer User%'];
    
            list<Account_Member__c> members = new list<Account_Member__c>();
            for(id amcid : aIDs){
                Account_Member__c am = new Account_Member__c();
                am.Account__c = amcid;
                am.User__c = testUser.id;
                am.Default__c = true;
                members.add(am);
            }
             
            if(members.size() != 0){
                insert members;
            }
            
            // Update the test user with the portal user role
            //testUser.UserRoleId = roles[0].Id;
            testUser.loginDate__c = datetime.now();        
            update testUser;
        }
        
        return testUser;
    }

    public static Account testGetDiageoAccount(){
        return [select id, name from Account where name = 'Diageo' limit 1];
        
    }

    /**
    * @author Denise Bacher
    * @date 09/08/2011
    * @description Insert a test ContentVersion, it is added to the distributor library
    * @return A test ContentVersion
    */
    public static ContentVersion testInsertDistributorContent(String title, String fileURL, ID calendarID){        
        ContentWorkspace CW = [select id, defaultrecordTypeId from ContentWorkspace where name = 'Distributor Portal']; 
        ID contentWorkID = CW.Id;
        ContentVersion testContent = new ContentVersion();
        testContent.Title = title;
        testContent.ContentUrl = fileURL;
        testContent.Description = 'Test';
        testContent.RecordTypeId = CW.DefaultRecordTypeId;
        insert testContent;
        
        ID contentDocID = [select ContentDocumentId from ContentVersion where id = :testContent.id].ContentDocumentId;
        
       // System.debug('contentWorkID ' + contentWorkID);
       // System.debug('contentDocID ' + contentDocID);

       // System.debug('Record Types ' + [select id, name, SobjectType from RecordType]);
        
        ContentWorkspaceDoc contentWorkDoc = new ContentWorkspaceDoc();
        contentWorkDoc.ContentDocumentId = contentDocID;
        contentWorkDoc.ContentWorkspaceId = contentWorkID;
        insert contentWorkDoc;
        
        testContent.Content_Description__c = [select Content_Description__c from ContentVersion where ID = :testContent.ID][0].Content_Description__c;
        
        return testContent;
    }
    /**
    * @author Denise Bacher
    */    
    public static ContentBrand__c testInsertContentBrand(ID contentProxyID, ID brandID){
        ContentBrand__c testCB = new ContentBrand__c(name='test', Content_Description__c = contentProxyID, Brand__c = brandID);
        insert testCB;
        return testCB;
    }
    
    public static ContentBrand__c testCreateContentBrand(ID contentProxyID, ID brandID){
        ContentBrand__c testCB = new ContentBrand__c(name='test', Content_Description__c = contentProxyID, Brand__c = brandID);
        return testCB;
    }
    
    /**
    * @author Denise Bacher
    * @date 18/08/2011
    * @description Insert a test Calendar
    * @return A test Calendar
    */
    public static Calendar__c testInsertCalendar(String name, String salesChannel, String segment, 
        String priority, String description, Date startDate, Date endDate, Boolean archive, Boolean isMonthlyExecutionPlan){
            
        String recordName = isMonthlyExecutionPlan ? Constant.MONTHLY_EXECUTION_PLAN : Constant.INNOVATION_AND_SUSTAINOVATION;
        Id recordId = [select Id from RecordType where Name =: recordName and sObjectType = 'Calendar__c'].Id;
        Calendar__c testCalendar = new Calendar__c();
        testCalendar.Name = name;
        testCalendar.Sales_Channel__c = salesChannel;
        testCalendar.Segment__c = segment;
        testCalendar.Priority__c = priority;
        testCalendar.Description__c = description;
        testCalendar.Start_Date__c = startDate;
        testCalendar.End_Date__c = endDate;
        testCalendar.Archive__c = archive;
        testCalendar.recordTypeId = recordId;
        testCalendar.classification__c = 'Spirits';
        insert testCalendar;
        
        return testCalendar;
    }
    
    public static Calendar__c testInsertMCalendar(String name, String description, Date startDate, Date endDate){
            
        String recordName = Constant.MULTICULTURAL;
        Id recordId = [select Id from RecordType where Name =: recordName and sObjectType = 'Calendar__c'].Id;
        Calendar__c testCalendar = new Calendar__c();
        testCalendar.Name = name;
        testCalendar.Description__c = description;
        testCalendar.Start_Date__c = startDate;
        testCalendar.End_Date__c = endDate;
        testCalendar.recordTypeId = recordId;
        testCalendar.classification__c = 'Spirits';
        
        insert testCalendar;
        
        return testCalendar;
    }

    public static Calendar__c testInsertPCalendar(String name, String description, Date startDate, Date endDate){
            
        String recordName = Constant.PLANNING;
        Id recordId = [select Id from RecordType where Name =: recordName and sObjectType = 'Calendar__c'].Id;
        Calendar__c testCalendar = new Calendar__c();
        testCalendar.Name = name;
        testCalendar.Description__c = description;
        testCalendar.Start_Date__c = startDate;
        testCalendar.End_Date__c = endDate;
        testCalendar.recordTypeId = recordId;
        testCalendar.classification__c = 'Spirits';
        
        insert testCalendar;
        
        return testCalendar;
    }
    
    public static Calendar__c testCreateCalendar(String name, String salesChannel, String segment, 
        String priority, String description, Date startDate, Date endDate, Boolean archive, Boolean isMonthlyExecutionPlan){
            
        String recordName = isMonthlyExecutionPlan ? Constant.MONTHLY_EXECUTION_PLAN : Constant.INNOVATION_AND_SUSTAINOVATION;
        Id recordId = [select Id from RecordType where Name =: recordName and sObjectType = 'Calendar__c'].Id;
        Calendar__c testCalendar = new Calendar__c();
        testCalendar.Name = name;
        testCalendar.Sales_Channel__c = salesChannel;
        testCalendar.Segment__c = segment;
        testCalendar.Priority__c = priority;
        testCalendar.Description__c = description;
        testCalendar.Start_Date__c = startDate;
        testCalendar.End_Date__c = endDate;
        testCalendar.Archive__c = archive;
        testCalendar.recordTypeId = recordId;
        testCalendar.classification__c = 'Spirits';
        
        return testCalendar;
    }
    
    public static Calendar__c testCreateCalendar(String name, String salesChannel, String segment, 
        String priority, String description, Date startDate, Date endDate, Boolean archive, String recordName){
            
        Id recordId = [select Id from RecordType where Name =: recordName and sObjectType = 'Calendar__c'].Id;
        Calendar__c testCalendar = new Calendar__c();
        testCalendar.Name = name;
        testCalendar.Sales_Channel__c = salesChannel;
        testCalendar.Segment__c = segment;
        testCalendar.Priority__c = priority;
        testCalendar.Description__c = description;
        testCalendar.Start_Date__c = startDate;
        testCalendar.End_Date__c = endDate;
        testCalendar.Archive__c = archive;
        testCalendar.recordTypeId = recordId;
        testCalendar.classification__c = 'Spirits';
        
        return testCalendar;
    }
    
   /**
    * @author Denise Bacher
    * @date 18/08/2011
    * @description Insert a test Calendar Brand
    * @return A test Calendar Brand
    */
    // START : Changed to avoid Test Class Failures and Improve test classes : Basant Verma (Appirio JDC) : 4th Feb, 2014
    public static CalendarBrand__c testInsertCalendarBrand(ID calendarID, ID brandID){
        return testCreateCalendarBrand(calendarID, brandID, true);
    }
    
    public static CalendarBrand__c testCreateCalendarBrand(ID calendarID, ID brandID, Boolean isInsert){
        CalendarBrand__c testCB = new CalendarBrand__c(name='test', Calendar__c = calendarID, Brand__c = brandID);
        if(isInsert)
            insert testCB;
        
        return testCB;
    }
        // END : Changed to avoid Test Class Failures and Improve test classes : Basant Verma (Appirio JDC) : 4th Feb, 2014
   /**
    * @author Bartosz Dudziak
    * @date 14/11/2011
    * @description Insert a folder
    * @return A test Folder
    */
    public static User generateTestMDUser(String randomFiveDigitString, Boolean insertUser, String profileName){
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        User userToReturn = new User();
        System.runAs ( thisUser ) {
            userToReturn.Alias = randomFiveDigitString;
            userToReturn.Email = randomFiveDigitString + '@testorg.com';
            userToReturn.EmailEncodingKey = 'UTF-8';
            userToReturn.LastName = 'Test' + randomFiveDigitString;
            userToReturn.LanguageLocaleKey = 'en_US';
            userToReturn.LocaleSidKey = 'en_US';
            userToReturn.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
            userToReturn.TimeZoneSidKey = 'America/Chicago';
            userToReturn.Username = randomFiveDigitString + '@test' + Math.round(Math.random() * 10000) + '.com';
            userToReturn.UserRoleId = [select Id from UserRole where name ='Marketing Directors' limit 1].Id;
            userToReturn.Country = 'United States';
            userToReturn.Available_Themes__c = 'Spirits; Wine; Beer';
            
            /*User userToReturn = new User();
            userToReturn.Alias = '12345';
            userToReturn.Email = '12345' + '@testorg.com';
            userToReturn.EmailEncodingKey = 'UTF-8';
            userToReturn.LastName = 'Test' + '12345';
            userToReturn.LanguageLocaleKey = 'en_US';
            userToReturn.LocaleSidKey = 'en_US';
            userToReturn.ProfileId = [SELECT Id FROM Profile limit 1].Id;
            userToReturn.TimeZoneSidKey = 'America/Chicago';
            userToReturn.Username = '12345' + '@test' + Math.round(Math.random() * 10000) + '.com';
            userToReturn.UserRoleId = '00EA0000000rueYMAQ';
            userToReturn.Country = 'United States';*/
            
//          if(insertUser)
                insert userToReturn;
            MDUser = userToReturn;
        }       
        return userToReturn;
    }
    public static Folder__c testInsertFolder(Boolean allowComment, Boolean allowUpload, Id OUId, Boolean brandFilter, Boolean timeFilter, String section, String parentFolder, Id DId){
        Folder__c testfolder;
        System.RunAs(MDUser){
        testFolder = new Folder__c(   
                                                name='test folder',
                                                Allow_Add_Comment__c = allowComment,
                                                Allow_File_Upload__c = allowUpload,
                                                OrgUnits__c = OUId,
                                                Filter_By_Brand__c = brandFilter,
                                                Filter_By_Time__c = timeFilter,
                                                Page_Section__c = section,
                                                Parent_Folder__c = parentFolder,
                                                Classification__c = 'Spirits',
                                                Distributors__c = DId
                                            );
        insert testFolder;
      }  
        return testFolder;
    }
    
    public static Folder__c testInsertFolder(String name, Boolean allowComment, Boolean allowUpload, Id OUId, Boolean brandFilter, Boolean timeFilter, String section, String parentFolder, Id DId){
        Folder__c testfolder;
        System.RunAs(MDUser){
        testFolder = new Folder__c(   
                                                name=name,
                                                Allow_Add_Comment__c = allowComment,
                                                Allow_File_Upload__c = allowUpload,
                                                OrgUnits__c = OUId,
                                                Filter_By_Brand__c = brandFilter,
                                                Filter_By_Time__c = timeFilter,
                                                Page_Section__c = section,
                                                Parent_Folder__c = parentFolder,
                                                Classification__c = 'Spirits',
                                                Distributors__c = DId
                                            );
        insert testFolder;
        }
        return testFolder;
    }

   /**
    * @author Bartosz Dudziak
    * @date 14/11/2011
    * @description Insert a File
    * @return A test File
    */
    public static File__c testInsertFile(){
      /*  File__c testFile = new File__c();
        testFile.Content_ID__c = '986598654578569854';
        testFile.Content_Version_Id__c = '235469878965412356';
        insert testFile;
        
        return testFile;
        */
        ContentWorkspace CW = [select Id, DefaultRecordTypeId from ContentWorkspace where name = 'planning'];
        
        ContentVersion c = new ContentVersion();
        //set mandatory fields
        
        c.Title = 'test upload';        // some title
        c.PathOnClient = 'c:\\video.pdf'; //dummy filepath, file doesn't exist on my computer. filetype is set based on a value of this field
        c.VersionData = blob.valueof('1115660548001'); //We store video Id from the BrightCove webstire
        c.Description = 'Test Description';
        c.RecordTypeId = CW.DefaultRecordTypeId;

        insert c;
        c = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: c.Id];
        
        
        
        ContentWorkspaceDoc cwd = new ContentWorkspaceDoc(
            ContentDocumentId = [select ContentDocumentId from ContentVersion where id = :c.id].ContentDocumentId,
            ContentWorkspaceId = CW.Id
        );
            
        insert cwd;
        
        Id testFileId = [SELECT Id, ContentDocumentId, File__c FROM ContentVersion WHERE Id =: c.Id Limit 1].File__c;
        File__c testFile = [SELECT Content_ID__c, Content_Version_Id__c, Folders__c, Page_Section__c, Distributors__c, Division_Access__c, OrgUnits__c From File__c Where Id =:testFileId Limit 1 ];

        testFile.Classification__c = 'Spirits';
        update testFile;
    
        return testFile;
    }

   /**
    * @author Bartosz Dudziak
    * @date 14/11/2011
    * @description Insert a File
    * @return A test File
    */
    public static File__c testInsertFile(String parentFolder, String section, String division, Id OUId, String distributorId){
        ContentWorkspace CW = [select Id, DefaultRecordTypeId from ContentWorkspace where name = :section];
        
        ContentVersion c = new ContentVersion();
        //set mandatory fields
        
        c.Title = 'test upload';        // some title
        c.PathOnClient = 'c:\\video.pdf'; //dummy filepath, file doesn't exist on my computer. filetype is set based on a value of this field
        c.VersionData = blob.valueof('1115660548001'); //We store video Id from the BrightCove webstire
        c.Description = 'Test Description';
        c.RecordTypeId = CW.DefaultRecordTypeId;

        insert c;
        c = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: c.Id];
        
        
        
        ContentWorkspaceDoc cwd = new ContentWorkspaceDoc(
            ContentDocumentId = [select ContentDocumentId from ContentVersion where id = :c.id].ContentDocumentId,
            ContentWorkspaceId = CW.Id
        );
            
        insert cwd;
        
        Id testFileId = [SELECT Id, ContentDocumentId, File__c FROM ContentVersion WHERE Id =: c.Id Limit 1].File__c;
        File__c testFile = [SELECT Content_ID__c, Content_Version_Id__c, Folders__c, Page_Section__c, Distributors__c, Division_Access__c, OrgUnits__c From File__c Where Id =:testFileId Limit 1 ];
        
        testFile.Content_ID__c = c.ContentDocumentId;
        testFile.Content_Version_Id__c = c.Id;
        testFile.Folders__c = parentFolder;
        testFile.Page_Section__c = section;
        testFile.Distributors__c = distributorId;
        testFile.Division_Access__c = division;
        testFile.OrgUnits__c = OUId;
        testFile.Classification__c = 'Spirits';
        update testFile;
        
        return testFile;
    }

   /**
    * @author Bartosz Dudziak
    * @date 14/11/2011
    * @description Insert a File
    * @return A test File
    */
    public static File__c testInsertFile(String parentFolder, String section, Calendar__c cal, Organizational_Unit__c OU){
        File__c testFile = new File__c();
        testFile.Content_ID__c = '986598654578569854';
        testFile.Content_Version_Id__c = '235469878965412356';
        testFile.Folders__c = parentFolder;
        testFile.Page_Section__c = section;
        testFile.Division_Access__c = OU.Name;
        testFile.OrgUnits__c = OU.Id;
        testFile.Calendar__c = cal.Id;
        testFile.Classification__c = 'Spirits';
        insert testFile;
        
        return testFile;
    }

   /**
    * @author Bartosz Dudziak
    * @date 14/11/2011
    * @description Insert a File
    * @return A test File
    */
    public static Content_Description__c testInsertContentDescription(){

        ContentWorkspace CW = [select Id, DefaultRecordTypeId from ContentWorkspace where name = 'Distributor Portal'];
        
        ContentVersion c = new ContentVersion();
        //set mandatory fields
        
        c.Title = 'test upload';        // some title
        c.PathOnClient = 'c:\\video.pdf'; //dummy filepath, file doesn't exist on my computer. filetype is set based on a value of this field
        c.VersionData = blob.valueof('1115660548001'); //We store video Id from the BrightCove webstire
        c.Description = 'Test Description';
        c.RecordTypeId = CW.DefaultRecordTypeId;

        insert c;
        
        
        
        ContentWorkspaceDoc cwd = new ContentWorkspaceDoc(
            ContentDocumentId = [select ContentDocumentId from ContentVersion where id = :c.id].ContentDocumentId,
            ContentWorkspaceId = CW.Id
        );
            
        insert cwd;
            
        Content_Description__c descr = [ select Content_ID__c, Content_Version_Id__c, Description__c, filetype__c, Innovation__c, Is_Video__c, Title__c, Video_Id__c, Preview_Id__c, Preview_Available__c, share_link__c
                                                                from Content_Description__c
                                                                where Content_Version_Id__c = :c.id
                                                                limit 1 ];
        descr.share_link__c = 'http://test.com';
        descr.Preview_Available__c = false;
        descr.Preview_Id__c = null;
        descr.Classification__c = 'Spirits';
        
        update descr;
        return descr;
    }
    
    public static Content_Description__c testInsertContentDescriptionExtended(String title){
        ContentWorkspace CW = [select Id, DefaultRecordTypeId from ContentWorkspace where name = 'Distributor Portal'];

        ContentVersion c = new ContentVersion();
        //set mandatory fields
        c.Title = title;        // some title
        c.PathOnClient = 'c:\\video.pdf'; //dummy filepath, file doesn't exist on my computer. filetype is set based on a value of this field
        c.VersionData = blob.valueof('1115660548001'); //We store video Id from the BrightCove webstire
        c.Description = 'Test Description';
        c.RecordTypeId = CW.DefaultRecordTypeId;
        insert c;
        
        
        
        ContentWorkspaceDoc cwd = new ContentWorkspaceDoc(
            ContentDocumentId = [select ContentDocumentId from ContentVersion where id = :c.id].ContentDocumentId,
            ContentWorkspaceId = CW.id
        );
            
        insert cwd;
            
        Content_Description__c descr = [ select Content_ID__c, Content_Version_Id__c, Description__c, filetype__c, Innovation__c, Is_Video__c, Title__c, Video_Id__c, Preview_Id__c, Preview_Available__c, share_link__c
                                                                from Content_Description__c
                                                                where Content_Version_Id__c = :c.id
                                                                limit 1 ];
        descr.share_link__c = 'http://test.com';
        descr.Preview_Available__c = false;
        descr.Preview_Id__c = null;
        descr.Classification__c = 'Spirits';
        
        update descr;
        return descr;
    }
    
    public static List<Content_Description__c> testInsertContentDescriptionExtended(List<String> titles){
        ContentWorkspace CW = [select Id, DefaultRecordTypeId from ContentWorkspace where name = 'Distributor Portal'];
                List<ContentVersion> cvList = new List<ContentVersion>();
                for(String title : titles){
            ContentVersion c = new ContentVersion();
            //set mandatory fields
            c.Title = title;        // some title
            c.PathOnClient = 'c:\\video.pdf'; //dummy filepath, file doesn't exist on my computer. filetype is set based on a value of this field
            c.VersionData = blob.valueof('1115660548001'); //We store video Id from the BrightCove webstire
            c.Description = 'Test Description';
            c.RecordTypeId = CW.DefaultRecordTypeId;
            cvList.add(c);
                }
                insert cvList;
        
        List<ContentWorkspaceDoc> cwdList = new List<ContentWorkspaceDoc>();
        List<String> cvIds = new List<String>();
        cvList = new List<ContentVersion>([select ContentDocumentId from ContentVersion where id IN :cvList]);
        for(ContentVersion c : cvList){
            ContentWorkspaceDoc cwd = new ContentWorkspaceDoc(
                ContentDocumentId = c.ContentDocumentId,
                ContentWorkspaceId = CW.id
            );
           cwdList.add(cwd);
           cvIds.add(c.Id);
        }    
        insert cwdList;
            
        List<Content_Description__c> descrList = [ select Content_ID__c, Content_Version_Id__c, Description__c, filetype__c, Innovation__c, Is_Video__c, Title__c, Video_Id__c, Preview_Id__c, Preview_Available__c, share_link__c
                                                                from Content_Description__c
                                                                where Content_Version_Id__c IN :cvIds ];
                for(Content_Description__c descr : descrList){
            descr.share_link__c = 'http://test.com';
            descr.Preview_Available__c = false;
            descr.Preview_Id__c = null;
            descr.Classification__c = 'Spirits';
                }
                
        update descrList;
        return descrList;
    }
    
    public static Case testInsertCase(String status){
        Case newCase = new Case();
        newCase.Description = 'Case test description';
        newCase.ContactId = Service_API.getCID();
        newCase.AccountId = Service_API.getAID();
        newCase.Status = status;
        newCase.Subject = 'Case test title';
        newCase.Phone__c = '000000';
        newCase.Email__c = 'text@test.com';
        newCase.First_Name__c = 'first name';
        newCase.Last_Name__c = 'last name';
        newCase.Type = 'Other';
        newCase.Origin = 'Web';        
        
        insert newCase;
        return newCase;
    }
    
     public static Content_Property__c testInsertContentProperty(String name, Id calendarId, Id contentDescriptionId, String category, String subCategory, String subSubCategory, String subSubSubCategory){
        Content_Property__c testContentProperty = new Content_Property__c(  
                                                name = name,
                                                Calendar__c = calendarId,
                                                Category__c = category,
                                                Content_Description__c = contentDescriptionId,
                                                Sub_Category__c = subCategory,
                                                Sub_Sub_Category__c = subSubCategory,
                                                Sub_Sub_Sub_Category__c = subSubSubCategory,
                                                end_date__c = date.today(),
                                                start_date__c = date.today().addDays(-1)
                                            );
        insert testContentProperty;
        
        return testContentProperty;
    }
    
    public static Content_Property__c testCreateContentProperty(String name, Id calendarId, Id contentDescriptionId, String category, String subCategory, String subSubCategory, String subSubSubCategory){
        Content_Property__c testContentProperty = new Content_Property__c(  
                                                name = name,
                                                Calendar__c = calendarId,
                                                Category__c = category,
                                                Content_Description__c = contentDescriptionId,
                                                Sub_Category__c = subCategory,
                                                Sub_Sub_Category__c = subSubCategory,
                                                Sub_Sub_Sub_Category__c = subSubSubCategory
                                            );
        
        return testContentProperty;
    }
    
     public static Content_Property__c testCreateContentProperty(String name, Id calendarId, Id contentDescriptionId, String category, String subCategory, String subSubCategory, String subSubSubCategory, date StartDate, date EndDate){
        Content_Property__c testContentProperty = new Content_Property__c(  
                                                name = name,
                                                Calendar__c = calendarId,
                                                Category__c = category,
                                                Content_Description__c = contentDescriptionId,
                                                Sub_Category__c = subCategory,
                                                Sub_Sub_Category__c = subSubCategory,
                                                Sub_Sub_Sub_Category__c = subSubSubCategory,
                                                Start_Date__c = StartDate,
                                                End_date__c = EndDate
                                            );
        
        return testContentProperty;
    }
    
     public static FAQ__c testInsertFAQ(String question, String answer){
        FAQ__c f = new FAQ__c(
            Question__c = question,
            Answer__c = answer
        );
        
        insert f;
        return f;
    } 
    
    public static Hyperlink__c testInsertLink(String url, String name, String category){
        Hyperlink__c h = new Hyperlink__c(
            URL__c = url,
            Name = name,
            Category__c = category
        );
        
        insert h;
        return h;
    } 
    
     public static NewsAndArticles__c testInsertNewsAndArticles(String title, String body){
        NewsAndArticles__c nea = new NewsAndArticles__c(
            Title__c = title,
            BodyText__c = body,
            Classification__c = 'Spirits'
        );
        
        insert nea;
        return nea;
    } 
    
     public static HomeVideo__c testInsertHomeVideo(String videoId, String name, String description, Boolean isCurrent){
        
        HomeVideo__c v = new HomeVideo__c(
            videoId__c = videoId,
            name = name,
            description__c  = description,
            current__c = isCurrent,
            Classification__c = 'Spirits'
        );
        
        insert v;
        return v;
    }
    
    public static Sections__c  createSectionTab(String name, String classification, String parentTab, String salesDriver,
                                                String sectionName, String tabName, Integer orderNumber){
      Sections__c section = new Sections__c();
      section.Classification__c = classification;
      section.Name = name;
      section.Order__c = orderNumber;
      section.Parent_Tab__c = parentTab;
      section.Sales_Driver__c = salesDriver;
      section.Section__c = sectionName;
      section.Tab__c = tabName;
      
      return section;
    } 
    
    // Method to Create Calendar Object
    public static Calendar__c createCalendar(String name, String salesChannel, String subChannel, String progType, Date stDate, 
    Date enDate, String fiscalYear, String classification, String description, String callOnAction, String recordTypeName, Boolean isInsert){
        
      Id recordId = [select Id from RecordType where Name =: recordTypeName and sObjectType = 'Calendar__c'].Id;
      
      Calendar__c testCalendar = new Calendar__c();
        testCalendar.Name = name;
        testCalendar.Sales_Channel__c = salesChannel;
        testCalendar.Sub_Channel__c = subChannel;
        testCalendar.Program_Type__c = progType;
        testCalendar.Start_Date__c = stDate;
        testCalendar.End_Date__c = enDate;
        testCalendar.Fiscal_Year__c = fiscalYear;
        testCalendar.Classification__c = classification;
        testCalendar.Description__c = description;
        testCalendar.Call_to_Action__c = callOnAction;
        testCalendar.recordTypeId = recordId;
        
        if(isInsert)
            insert testCalendar;
        
        return testCalendar;
    }
    
    public static contentCategory__c  createContentCategory(String name, String classification, String description, String parentTheme,
                                                Integer orderNumber){
      contentCategory__c contentCategory = new contentCategory__c();
      contentCategory.Classification__c = classification;
      contentCategory.Name = name;
      contentCategory.Description__c = description;
      contentCategory.Parent_Theme__c = parentTheme;
      contentCategory.Sort_Order__c = orderNumber;
                  
      return contentCategory;
    }
    
    public static Content_Matrix__c testCreateContentMatrix(String name, String category, String matrixType, String subCategory, String subSubCategory, String subSubSubCategory){
        Content_Matrix__c testContentMatrix = new Content_Matrix__c(  
                                                name = name,
                                                Category__c = category,
                                                Matrix_type__c = matrixType,
                                                Sub_Category__c = subCategory,
                                                Sub_Sub_Category__c = subSubCategory,
                                                Sub_Sub_Sub_Category__c = subSubSubCategory
                                            );
        
        return testContentMatrix;
    }
    
    public static Budget__c createBudgetRecord(Id budgeterId, Id shopperId, Id brandId, Id orderWindowId){
      Budget__c budget = new Budget__c();
      budget.Budget_Creator__c = budgeterId;
      budget.Budgeter__c = budgeterId;
      budget.Brand__c = brandId;
      budget.Amount__c = 100;
      budget.Spent_Amount__c = 10000;
      budget.My_Spent_Amount__c = 5000;
      budget.Shopper__c = shopperId;
      budget.Order_Window__c = orderWindowId;
      return budget;
    }
    
    public static Item_Brand__c createItemBrand(Id itemId, Id brandId, Boolean isPrimary){        
      Item_Brand__c itemBrand = new Item_Brand__c(Item__c = itemId, Brand__c = brandId, Primary__c = isPrimary);
      return itemBrand;
    }
    
    public static POS_Magento_Configuration__c createPOSMagentoConfigSettings(){
        POS_Magento_Configuration__c settings = new POS_Magento_Configuration__c(Name = 'test settings');
        settings.BRAND_CATEGORY__c = '483';
        settings.Budget_Overage_Amount__c = 500.00;
        settings.Budget_Overage_Percent__c = 1.00;
        settings.Diageo_Spirits_District__c = '4648';
        settings.Diageo_Spirits_Responsible__c = 'VN';
        settings.Diageo_Wine_District__c = '';
        settings.Diageo_Wine_Responsible__c = '';
        settings.IDP_Url__c = '/idp/login?app=0spJ0000000002M';
        settings.Item_URL__c = 'https://qa.devdiageo.info/catalog/product/view/id/';
        settings.Magento_API_Key__c = 'posapi100';
        settings.Magento_Catalog_Path__c = 'https://qa.devdiageo.info/carts/orderwindow/view/id/';
        settings.Magento_Endpoint__c = 'http://qa.devdiageo.info/index.php/api/inchoo/rest';
        settings.Magento_WS_Username__c = 'pos-api-user';
        settings.Monthly_Ordering_URL__c = 'BrandMarketingInformation?section=Programming&subsection=POS+Reports';
        settings.ORDERWINDOW_CATEGORY__c = '485';
        settings.Portal_Redirect_URL__c = 'https://sk2-diageodirect.cs10.force.com';
        settings.ProductImage_FolderPath__c = 'https://qa.devdiageo.info/media/catalog/product/';
        settings.PROGRAM_CATEGORY__c = '484';
        settings.Quarterly_Ordering_URL__c = 'BrandMarketingInformation?section=Programming&subsection=POS+Reports';
        settings.Salesforce_apexrest_uri__c = 'https://cs10.salesforce.com/services/apexrest/';
        settings.Tangerine_URL__c = 'https://ondemand.mytangerineorders.com';
        settings.Thumbnail_URL__c = 'http://qa.devdiageo.info/thumbnail.php';
        settings.TYPE_BRAND__c = '300';
        settings.TYPE_ORDER_WINDOW__c = '100';
        settings.TYPE_PROGRAM__c = '200';
        insert settings;
        return settings;
    }
    
    public static Organizational_Unit__c createOrgUnit(String name, String label, String unitType){
    	Organizational_Unit__c orgUnit = new Organizational_Unit__c(Label__c = label, Name = name, Type__c = unitType);
      return orgUnit;  
    }
    
    public static Folder__c testCreateFolder(Boolean allowComment, Boolean allowUpload, Id OUId, Boolean brandFilter, Boolean timeFilter, String section, String parentFolder, Id DId){
        Folder__c testFolder = new Folder__c(   
                                                name='test folder',
                                                Allow_Add_Comment__c = allowComment,
                                                Allow_File_Upload__c = allowUpload,
                                                OrgUnits__c = OUId,
                                                Filter_By_Brand__c = brandFilter,
                                                Filter_By_Time__c = timeFilter,
                                                Page_Section__c = section,
                                                Parent_Folder__c = parentFolder,
                                                Classification__c = 'Spirits',
                                                Distributors__c = DId
                                            );
        
        
      return testFolder;
    }
    
    public static Folder__c testCreateFolder(String name, Boolean allowComment, Boolean allowUpload, Id OUId, Boolean brandFilter, Boolean timeFilter, String section, String parentFolder, Id DId){
        Folder__c testFolder = new Folder__c(   
                                                name=name,
                                                Allow_Add_Comment__c = allowComment,
                                                Allow_File_Upload__c = allowUpload,
                                                OrgUnits__c = OUId,
                                                Filter_By_Brand__c = brandFilter,
                                                Filter_By_Time__c = timeFilter,
                                                Page_Section__c = section,
                                                Parent_Folder__c = parentFolder,
                                                Classification__c = 'Spirits',
                                                Distributors__c = DId
                                            );
        
        return testFolder;
    }
    
}