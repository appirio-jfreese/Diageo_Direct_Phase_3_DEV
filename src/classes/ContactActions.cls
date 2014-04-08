public with sharing class ContactActions {
  //Variable to hold the activation code size 
   public static Integer DialActivationCodeSize=1000000;
    
    	
    public static void GenerateActivationCode(List<Contact> newList){
     
    List<Contact> consToUpdate = new List<Contact>();
    //loop through incoming contacts and generate an activation code 
    //when the Direct_Dial_Mobile_User is checked  
       for(Contact con : newList){
      	  	  if(con.Direct_Dial_Mobile_User__c ){
			 	con.Direct_Dial_Activation_Code__c=getRandomNumber(DialActivationCodeSize);
		        con.Direct_Dial_Activation_Code_Time_Set__c	=DateTime.now();
	   		} else {
			 	con.Direct_Dial_Activation_Code__c=0;
			 	con.Direct_Dial_Activation_Code_Time_Set__c	=null;
	 	     }
      } 
 	} 
 
   public static void GenerateActivationCode(Map<Id, Contact> oldConMap, List<Contact> NewList){
 	 List<Contact> consToUpdate = new List<Contact>();
 
  	 for(Contact con : newList){
      	    if(con.Direct_Dial_Mobile_User__c != oldConMap.get(con.Id).Direct_Dial_Mobile_User__c && con.Direct_Dial_Mobile_User__c ){
		        con.Direct_Dial_Activation_Code__c=getRandomNumber(DialActivationCodeSize);
		        con.Direct_Dial_Activation_Code_Time_Set__c	=DateTime.now();
 	  		} else if(con.Direct_Dial_Mobile_User__c != oldConMap.get(con.Id).Direct_Dial_Mobile_User__c && !con.Direct_Dial_Mobile_User__c ){
		        con.Direct_Dial_Activated__c =false;
			 	con.Direct_Dial_Activation_Code__c=0;
			 	con.Direct_Dial_Activation_Code_Time_Set__c	=null;
 		    } 
         }    
    }
    //Method to  generate random activation codes
    public static Integer getRandomNumber(Integer size){
		Double d = math.random() * size;
		return d.intValue();
	}
}