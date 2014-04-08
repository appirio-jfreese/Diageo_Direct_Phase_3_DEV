@isTest
private class ContactActionsTest {
	static testMethod void testGenerateActivationCode() {
	    Account acc1 = new Account();
        acc1.Name = 'test account';
        acc1.NABCA_Sector_Code__c = 'o';
        insert acc1;
         
        Contact cont1 = new Contact();
      
        cont1.AccountId = acc1.id;
        cont1.Email='email1@email.com';
        cont1.LastName='TestLastName1';
        cont1.Direct_Dial_Mobile_User__c=true;
     
       Contact cont2 = new Contact();
      
        cont2.AccountId = acc1.id;
        cont2.Email='email2@email.com';
        cont2.LastName='TestLastName2';
        cont2.Direct_Dial_Mobile_User__c=false;
        
        Test.startTest();
         
         insert cont1;
         insert cont2;
         Test.stopTest();
        
        cont1 = [SELECT Id, Direct_Dial_Mobile_User__c,Direct_Dial_Activation_Code__c,Direct_Dial_Activation_Code_Time_Set__c  FROM Contact WHERE Id = :cont1.Id];
       	System.assert(cont1.Direct_Dial_Activation_Code__c>0,true);
       	
       	String strConvertedDate = cont1.Direct_Dial_Activation_Code_Time_Set__c.format('MM/dd/yyyy HH:mm:ss', 
                 'America/New_York');
        Boolean val= String.isNotEmpty(strConvertedDate);
                 
        System.assertequals(val, true);
        	
       	cont2 = [SELECT Id, Direct_Dial_Mobile_User__c,Direct_Dial_Activation_Code__c ,Direct_Dial_Activation_Code_Time_Set__c FROM Contact WHERE Id = :cont2.Id];
       	System.assertequals(cont2.Direct_Dial_Activation_Code__c ,0 );
        System.assertequals(cont2.Direct_Dial_Activation_Code_Time_Set__c ,null );
       	
       				 	 
       	
       	 cont1.Direct_Dial_Mobile_User__c=false;
       	 update cont1;
       	
       	cont1 = [SELECT Id, Direct_Dial_Mobile_User__c,Direct_Dial_Activation_Code__c,Direct_Dial_Activation_Code_Time_Set__c  FROM Contact WHERE Id = :cont1.Id];
       	System.assertequals(cont1.Direct_Dial_Activation_Code__c ,0 );
       	System.assertequals(cont1.Direct_Dial_Activation_Code_Time_Set__c ,null );
       
        cont2.Direct_Dial_Mobile_User__c=true;
       	update cont2;
       	
       	cont2 = [SELECT Id, Direct_Dial_Mobile_User__c,Direct_Dial_Activation_Code__c ,Direct_Dial_Activation_Code_Time_Set__c FROM Contact WHERE Id = :cont2.Id];
       	System.assert(cont2.Direct_Dial_Activation_Code__c>0,true);
       //	System.assertequals(cont2.Direct_Dial_Activation_Code_Time_Set__c ,null );
       
        strConvertedDate = cont2.Direct_Dial_Activation_Code_Time_Set__c.format('MM/dd/yyyy HH:mm:ss', 
                 'America/New_York');		
        val= String.isNotEmpty(strConvertedDate); 
        System.assertequals(val, true);         
         	  
	}

}