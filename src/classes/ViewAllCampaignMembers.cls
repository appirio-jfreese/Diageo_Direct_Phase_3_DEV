/*******************************************************************************

Updated By  : Basant Verma (Appirio JDC)   
Date        : 01/22/2014
Story/Task  : US1061/TA1875

Updated By  : Basant Verma (Appirio JDC)   
Date        : 02/13/2014
Story/Task  : DE1037
*******************************************************************************/
public class ViewAllCampaignMembers {
    public String campId {get;set;}
    public String firstLoad {get; set;}
    public Campaign camp {get;set;}
    public List<CampaignMember> campMembers{
    	get{
    		if(firstLoad != null && firstLoad.trim().equalsIgnoreCase('TRUE')){
            init();
            firstLoad = 'false';
        }
        return campMembers;
    	}
			private set;
		}
    public Lead lead {get;set;}
    public Boolean isMemberRequest {get;set;}
    
    public ViewAllCampaignMembers(){
    	init();
    }
    
    public ViewAllCampaignMembers(ApexPages.StandardController stdController) {
    		campId = stdController.getId();
        init();
    }
    
    private void init(){
    		firstLoad = 'false';
    		if ( campId == null && System.currentPageReference().getParameters().containsKey( 'id' )) {
            campId = System.currentPageReference().getParameters().get( 'id' );
        }
        camp = [Select Id, Name From Campaign Where Id = :campId];
        campMembers = [select Id, Status, Contact.title, Contact.FirstName, Contact.LastName,
                            Contact.Owner.Name,ContactId,
                            Contact.Phone, Contact.MobilePhone, Contact.Email,
                            Lead.Email, Lead.MobilePhone, Lead.Phone, Lead.Company, Lead.Title, 
                            Lead.FirstName, Lead.LastName, LeadId, Lead.Owner.Name, Processed__c 
                            from CampaignMember
                            where CampaignId=:campId limit 1000];
      lead = new Lead();
      isMemberRequest = false;
      if(ApexPages.currentPage().getParameters().get('method') != null && ApexPages.currentPage().getParameters().get('method') == 'CreateMember'){
        isMemberRequest = true;
      }
      
      System.debug('================= campMembers '+campMembers);
    }
    
    public Pagereference createCampaignMember(){
        try{
            lead.Status = 'Open';
            insert lead;
            CampaignMember cm = new CampaignMember();
          cm.CampaignId = camp.Id;
            cm.LeadId = lead.Id;
            insert cm;
            init();
        }
        catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
}