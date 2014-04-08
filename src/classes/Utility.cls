/*******************************************************************************
    (c) 2013 Appirio, Inc.
Created By  :   Vikash Goyal    (Appirio JDC) 
Story/Task  : US765/TA1462
Description : Class contains the utility methods
*******************************************************************************/
global class Utility {
    
    private static String PRIVATE_KEY = 'mRMjHmlC1C+1L/Dkz8EJuw==';
    private static String ENCRYPTION_ALGO = 'AES128';
    
  
  webservice static string sendQuarterlyRequestEmail(List<String> contactIds){
    String status = 'failure';
    List<Contact> lstContacts = new List<Contact>();
    if(contactIds.size() > 0){
    	  List<OrgWideEmailAddress> orgWideAddr = new List<OrgWideEmailAddress>([SELECT Id, DisplayName, Address FROM OrgWideEmailAddress 
			                                         WHERE Address = 'nac.admin@diageo.com' LIMIT 1]);
        List<Messaging.Singleemailmessage> lstEmailMessages = new List<Messaging.Singleemailmessage>();     
        String subject = 'Diageo National Account Program Communication Quarterly Contact Update';    
        String bodyText = 'This is a quarterly request to update your contact information for the ' + 
                                            'Diageo National Accounts Program Communication emails. If you have changes ' +
                                            'and/or would like to unsubscribe please click the link below. The link will ' +
                                            'expire in 10 days. If you have no changes and want to continue receiving the program communications, '+
                                            'there is no action required. '+'<br/>'+'<br/>'+
                                            'Thank you' +
                                            '<br/>'+'<br/>'+'<br/>'+
                                            'This email is sent on behalf of a member of the Diageo group of companies, whose holding company is Diageo plc, registered in England and Wales with number 23307 and with registered address at Lakeside Drive, Park Royal, London NW10 7HQ, England.'+
                                            '<br/>'+'<br/>'+
                                            'This email and any files transmitted with it are confidential and intended solely for the use of the individual or entity to which they are addressed.';
      //EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Quarterly_Request_Email_Template'];
      for(Contact con : [SELECT Id, Name FROM Contact WHERE Id IN :contactIds AND Subscribe_Status__c != 'Submitted' AND Update_Request_Status__c != 'Submitted' AND Unsubscribe__c != TRUE]){
        con.Is_Update_Link_Used__c = false;
        lstContacts.add(con);
        String plainText = con.Id +'_'+ (Date.Today()).addDays(10);
        String encryptedText = encryptText(plainText);
        String encryptedUrl = Label.SiteUrlPrefix+'/signup?key='+Encodingutil.urlEncode(encryptedText, 'UTF-8');
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
          //mail.setTemplateId(template.Id);
          mail.setsubject(subject);
          mail.setHtmlBody('Hi '+con.Name+',<br/><p>'+bodyText+'</p><br/><p>'+encryptedUrl+'</p>');
          mail.setTargetObjectId(con.Id);
          if(orgWideAddr.size() > 0){
	  				mail.setOrgWideEmailAddressId(orgWideAddr[0].Id);
	  			}
          lstEmailMessages.add(mail);
      }
    
      List<Messaging.Sendemailresult> result = Messaging.sendEmail(lstEmailMessages);
      if(result != null && result.size() > 0 && result[0].isSuccess()){
        update lstContacts;
        status = 'success';
      }
    }
    return status;
  }
  
  public static String encryptText(String plainText){
    String encodedCipherText = null;
    if(plainText != null && !plainText.trim().equals('')){
      encodedCipherText = plainText;
            Blob key = EncodingUtil.base64Decode(PRIVATE_KEY);
            Blob cipherText = Crypto.encryptWithManagedIV(ENCRYPTION_ALGO, key, Blob.valueOf(plainText));
            encodedCipherText = EncodingUtil.base64Encode(cipherText);
        }
        return encodedCipherText;
    }
  
}