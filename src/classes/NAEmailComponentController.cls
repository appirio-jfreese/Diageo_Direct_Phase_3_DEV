/*------------------------------------------------------------------------------
Name        : NAEmailComponentController
Modified By : Siddharth Varshneya (Appirio OffShore)
Description : For email template National Accounts Email
Date        : 11/08/13
Story/Task  : US728/TA1294

Modified By : Basant Verma (Appirio OffShore)
Date        : 11/15/13
Story/Task  : US871/TA1589
Modified By : Siddhart Varshneya (Appirio OffShore)
Date        : 11/20/13
Story/Task  : US900/TA1649
Modified By : Siddhart Varshneya (Appirio OffShore)
Date        : 12/13/13
Story/Task  : US940/TA1748
Modified By : Vikash Goyal(Appirio JDC)
Date        : 1/17/14
Story/Task  : US1021/TA1863
-------------------------------------------------------------------------------*/
public without sharing class NAEmailComponentController
{
    public string Cid {get;set{
        Cid = value;
      populateData();
      }}
    public string contactId {get;set{
        contactId = value;
     setUnsubscribeLink();}}
    public Calendar__c cal {get;set;}
    public string activityTypes {get;set;}
    public string states {get;set;}
    public string brandName {get;set;}
    public string createdBy {get;set;}
    public string encryptedUrl {get;set;}
    public string styleBackgroundColor {get;set;}
    public string styleBackgroundImage {get;set;}
    public string styleTextColor {get;set;}
    public string textColor {get;set;}
    public string unsubscribeImgUrl {get;set;}
    public string subscribeImgUrl {get;set;}
    public string logoImgUrl {get;set;}
    public string baseUrl {get;set;}
    
    public string oId {get;set;}
    public string subscribeDocId {get;set;}
    public string diageoLogoDocId {get;set;}
    public string unsubscribeDocId {get;set;}
     
    public NAEmailComponentController()
    {
		System.debug('-----------'+ Cid );
		setImageUrls();
    }
    
    public void populateData(){
    
        oid = UserInfo.getOrganizationId();
        
        for(Document d : [Select d.Name, d.Id From Document d where Name='diageo_direct_logo' Limit 1]){
            diageoLogoDocId = d.Id;
        }
        for(Document d : [Select d.Name, d.Id From Document d where Name='subscribe' Limit 1]){
            subscribeDocId = d.Id;
        }
        for(Document d : [Select d.Name, d.Id From Document d where Name='unsubscribe' Limit 1]){
            unsubscribeDocId = d.Id;
        }

        if(Cid == null || Cid == ''){
            cal = new Calendar__c();
        return;
        } 
        
        // START - Changed for US900/TA1649 - Siddharth      
        for(Calendar__c calendar : [Select Volume_Opportunity__c, Suggested_Case_Minimum__c, Start_Date__c, Programs__c,
         Program_Name__c, Name,Text_Color__c, background_color__c,Background_Color2__c, Logo_Image_Small__r.Content_Version_Id__c, Local_Action_Required_text__c, End_Date__c,
          Description__c, CreatedById, Call_to_Action__c,  (Select Brand__r.Name , Name, Primary_Brand__c From CalendarBrand__r ORDER BY Name) , (Select Activity_Type__c From Program_Activities__r),
           (Select Id, Campaign_States__c From Campaigns__r) , Marketing_Group__r.calendar_small_logo__r.Content_Version_Id__c, Marketing_Group__r.calendar_small_logo__r.Document_Id__c From Calendar__c  where id =:Cid]){
         cal = calendar;
       }
       
       /*if(cal == null){
        cal = new Calendar__c();
        return;
       }*/
       
       brandName = '';
       // START - Changed for US1021/TA1863 - Vikash Goyal 
       for(CalendarBrand__c cb : cal.CalendarBrand__r )
         {
             brandName  += cb.Brand__r.Name + ','; 
         }
       
       if(brandName.endsWith(','))
         {
             brandName =brandName.substring(0,brandName.lastIndexOf(','));
         }
         // END - Changed for US1021/TA1863 - Vikash Goyal
          
       // End - Changed for US900/TA1649 - Siddharth 
       
          states  ='';
          Set<String> distinctStates = new Set<String>();  
          for(Campaign camp : cal.Campaigns__r){
            if(camp.Campaign_States__c != null){
         	  for(String stateStr : camp.Campaign_States__c.split(',')){
                if(!distinctStates.contains(stateStr.trim())){
          	      states += (states.trim() == '') ? stateStr.trim() : ','+stateStr.trim();
          	      distinctStates.add(stateStr.trim());
                }
              }         	         
         	}
          }
                    
          activityTypes ='';
        // START - Changed for US871/TA1589 : Now don't need Campaign_State__c object - Basant
            /*List<Campaign_State__c> lstCampState = [Select c.Name, c.Campaign__c From Campaign_State__c c WHERE c.Campaign__c =: cal.Campaigns__r];
            for(Campaign_State__c cs : lstCampState )
            {
            states  +=cs.Name+',';
            }*/
        /*Set<String> distinctStates = new Set<String>();
        for(CampaignMember cm : [Select Id, Contact.Distributor_State__c From CampaignMember Where CampaignId = :cal.Campaigns__r]){
                    if(cm.Contact.Distributor_State__c != null && !cm.Contact.Distributor_State__c.trim().equals('') 
                    	&& !distinctStates.contains(cm.Contact.Distributor_State__c)){
                        distinctStates.add(cm.Contact.Distributor_State__c);
                    }
                }
                for(String state : distinctStates ){
                    states  +=state+',';
                }
                if(states.endsWith(',')){
                    states = states.substring(0,states.lastIndexOf(','));
                }*/
                // END - Changed for US871/TA1589 : Now don't need Campaign_State__c object - Basant
        for(Program_Activity__c PA : cal.Program_Activities__r)
        {
            activityTypes += PA.Activity_Type__c + ',';
        }
        
         if(activityTypes.endsWith(','))
         {
             activityTypes =activityTypes.substring(0,activityTypes.lastIndexOf(','));
         }
         
        User usr=[Select u.Name From User u where u.id=: cal.CreatedById];
        createdBy =usr.name;
        if(cal.Text_Color__c != null){
        textColor= '#'+cal.Text_Color__c;
        }
        if (cal.background_color__c != null && cal.background_color2__c == null) {
            styleBackgroundColor = 'background-color: #' + cal.background_color__c + ';';
        } else if (cal.background_color__c != null && cal.background_color2__c != null) {
            styleBackgroundColor = 'background: #' + cal.background_color__c + ';';
            styleBackgroundColor += 'background: -moz-linear-gradient(top, #' + cal.background_color__c + ' 0%, #' + cal.background_color2__c + ' 100%);';
            styleBackgroundColor += 'background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#' + cal.background_color__c + '), color-stop(100%,#' + cal.background_color2__c + '));';
            styleBackgroundColor += 'background: -webkit-linear-gradient(top, #' + cal.background_color__c + ' 0%,#' + cal.background_color2__c + ' 100%);';
            styleBackgroundColor += 'background: -o-linear-gradient(top, #' + cal.background_color__c + ' 0%,#' + cal.background_color2__c + ' 100%);';
            styleBackgroundColor += 'background: -ms-linear-gradient(top, #' + cal.background_color__c + ' 0%,#' + cal.background_color2__c + ' 100%);';
            styleBackgroundColor += 'filter: progid:DXImageTransform.Microsoft.gradient(startColorStr=\'#' + cal.background_color__c + '\', EndColorStr=\'#' + cal.background_color2__c + '\');';
        }
         styleTextColor = 'color: #' + cal.text_color__c + ';';
        styleBackgroundImage = 'background-image: url(/sfc/servlet.shepherd/version/download/' + cal.Logo_Image_Small__r.Content_Version_Id__c + ');';
    }
    
    public void setUnsubscribeLink()
    {
        String plainText = contactId +'_'+ (Date.Today()).addDays(10) + '_Unsubscribe';
        String encryptedText = Utility.encryptText(plainText);
        encryptedUrl = Label.SiteUrlPrefix+'/signup?key='+Encodingutil.urlEncode(encryptedText, 'UTF-8');
    }
    
    public void setImageUrls(){     
     // Fetching the resource
     List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = 'NAEmailImgs'];
     String resUrl = '';
     // Checking if the result is returned or not
     if(resourceList.size() == 1){

       // Getting namespace
       String namespace = resourceList[0].NamespacePrefix;
       // Resource URL
       baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
       resUrl = baseUrl+ '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + 'NAEmailImgs';
       unsubscribeImgUrl = resUrl + '/img/unsubscribe.gif';
       subscribeImgUrl = resUrl + '/img/subscribe.gif';
       logoImgUrl = resUrl + '/img/diageo_direct_logo.gif'; 
     }  
    
   }
}