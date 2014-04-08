/*------------------------------------------------------------------------------
Name        : NACExistingRecipientsController
Modified By : Siddharth Varshneya (Appirio OffShore)
Description : For email template National Accounts Email
Date        : 12/13/13
Story/Task  : US940/TA1749
-------------------------------------------------------------------------------*/
public without sharing class NACExistingRecipientsController
{
    public string contactId {get;set;}
    public string oId {get;set;}
    public string diageoLogoDocId {get;set;}
    public string diagoteaserDocId {get;set;}
    
    public NACExistingRecipientsController(){
        oid = UserInfo.getOrganizationId();
        for(Document d : [Select d.Name, d.Id From Document d where Name='diageo_direct_logo' Limit 1]){
            diageoLogoDocId = d.Id;
        }
        for(Document d : [Select d.Name, d.Id From Document d where Name='diagoteaser' Limit 1]){
            diagoteaserDocId = d.Id;
        }

    }
}