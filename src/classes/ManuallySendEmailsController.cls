/*------------------------------------------------------------------------------
Name        : ManuallySendEmailsController
Created By : Siddharth Varshneya (Appirio OffShore)
Date        : 11/12/13
Story/Task  : US897/TA1591
-------------------------------------------------------------------------------*/
public class ManuallySendEmailsController{
    
    private final string lblUser = 'User :';
    private final string lblContact = 'Contact :';
    private final string lblLead = 'Lead :';
    private final String EMAIL_EXISTS = 'This email address already exists';
    private final String EMAIL_SENT_SUCCESSFULLY = 'The email was sent successfully.';
    private final String EMAIL_FAILED = 'The email failed to send: ';
     
    public integer currentObject {get; set;}
    public boolean showSendBtn {get;private set;}
    
    public Contact tempContact {get; set;}
    public map<integer,CommonObject> mapEmails {get; set;}
    
    //Constructor
    public ManuallySendEmailsController(){
        mapEmails = new map<integer,CommonObject>();
        tempContact =new Contact();
    }
    
    public void sendMail()
    {
        for(Integer temp : mapEmails.keySet()){
            if(temp != currentObject){
                mapEmails.get(temp).showBtn = false;
            }
        }
        
        try{        
           Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
           message.setSubject('Diageo National Account Program Communication Sign-Up');
           message.setPlainTextBody('To Distributor Contact '+'\r\n\r\n'
           +'Your request to be added to the Diageo National Accounts program communcations has been received. '+'\r\n'+
           'Please click the \'Subscribe\' link below to provide your complete contact details and begin receiving National Accounts Communications.'+'\r\n\r\n'+
            'Thank you' +'\r\n\r\n'+
            +Label.SiteUrlPrefix+'/apex/signup' +'\r\n\r\n'+
            'This email is sent on behalf of a member of the Diageo group of companies, whose holding company is Diageo plc, registered in England and Wales with number 23307 and with registered address at Lakeside Drive, Park Royal, London NW10 7HQ, England.'
            +'\r\n\r\n'+
            'This email and any files transmitted with it are confidential and intended solely for the use of the individual or entity to which they are addressed.');
           message.setToAddresses(new String[] { tempContact.Email });
           List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{message});
           
           if (!results.get(0).isSuccess()) {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, EMAIL_FAILED + results.get(0).getErrors()[0].getMessage()));
           }
           else{
             showSendBtn=false;
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, EMAIL_SENT_SUCCESSFULLY));
           }
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getMessage())); 
        }
    }
    
    public void validateEmail(){
         try{
             mapEmails = new Map<integer,CommonObject>();
             if(tempContact.Email  != null){
                 List<User> lstuser= [Select Email,Phone,Name From User WHERE Email =: tempContact.Email];
                 List<Contact> lstContact =[Select Email,Phone,Name,Subscribe_Status__c,Unsubscribe__c From Contact WHERE Email =: tempContact.Email];
                 List<Lead> lstLead = [Select Email,Phone,Name From Lead WHERE Email =: tempContact.Email]; 
                
                 if(lstuser.size() == 0 && lstContact.size() == 0 && lstLead.size() == 0){
                    showSendBtn = true;
                    mapEmails.clear();
                 }
                 else{
                    showSendBtn=false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, EMAIL_EXISTS)); 
                    if(lstuser.size()>0){
                        mapEmails.put(mapEmails.size(),new CommonObject(lblUser,lstuser.get(0).Name,lstuser.get(0).Phone,lstuser.get(0).Email,true, '', false));
                    }
                    if(lstContact.size()>0){
                        mapEmails.put(mapEmails.size(),new CommonObject(lblContact,lstContact.get(0).Name,lstContact.get(0).Phone,lstContact.get(0).Email,true, lstContact.get(0).Subscribe_Status__c, lstContact.get(0).Unsubscribe__c));
                    }
                    if(lstLead.size()>0){
                        mapEmails.put(mapEmails.size(),new CommonObject(lblLead,lstLead.get(0).Name,lstLead.get(0).Phone,lstLead.get(0).Email,true, '', false));
                    }
                 }
             }
         }
         catch(Exception e){
            showSendBtn=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getMessage())); 
         }
    }
    
    //wrapper class for object Contact,Lead and User
    class CommonObject{
        public string objType {get; set;}
        public string objName {get; set;}
        public string Phone {get; set;}
        public string EmailId {get; set;}
        public boolean showBtn {get; set;}
        public String subscribeStatus { get; set; }
        public boolean unsubscribed { get; set; }
        
        public CommonObject(String Type,String name,String phn, String email,boolean IsVisible, String subscribeStatus, boolean unsubscribed){
            this.objType = Type;
            this.objName = name;
            this.Phone = phn;
            this.EmailId = email;
            this.showBtn = IsVisible;
            this.subscribeStatus = subscribeStatus;
            this.unsubscribed = unsubscribed;
         }
    } 

}