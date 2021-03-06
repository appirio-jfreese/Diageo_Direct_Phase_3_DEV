/*******************************************************************************
	(c) 2013 Appirio, Inc.
Created By 	:	Vikash Goyal	(Appirio JDC) 
Story/Task	: US765/TA1564
Description	: Controller class for ReviewDistributorChangeRequest
*******************************************************************************/
public with sharing class ReviewDistributorChangeRqstCtrl {
	public String selectedContactId {get;set;}
	public List<ContactWrapper> lstContacts {get;set;}
	public String sortField {
    get;
    set {
      sortField = value;  
    }
  }
  public boolean isAsc{set; get;}
  private String sortOrder;
  private String previousSortField;
  private Boolean isMultiSelect;
	private Map<Id, Contact> mapContact;
	private Map<String, String> mapSelectedContactToProcess;
	
	private static String ERROR_MSG = 'You have not selected any record.';
	private static String ERROR_MSG2 = 'You have not selected related record.'; 
	
	//Constructor
	public ReviewDistributorChangeRqstCtrl(ApexPages.StandardController stdController){
		
	}
	
	public ReviewDistributorChangeRqstCtrl(ApexPages.StandardSetController stdController){
	  lstContacts = new List<ContactWrapper>();
	  mapSelectedContactToProcess = new Map<String, String>();
	  mapContact = new Map<Id, Contact>();
	  selectedContactId = '';	
	  sortOrder = ' ASC ';
		sortField = 'Name';
		previousSortField = 'Name';
		isAsc = true;	
		isMultiSelect = false;
	  populateContacts();	
	}
	
	public void doSort(){
  	if (previousSortField.equals(sortField)){
			isAsc = !isAsc;  
		} else {
			isAsc = true;
		}
		if(sortField == 'Subscribe_Interested_In__c' || sortField == 'Subscribe_Premise__c'){
			isMultiSelect = true;
		}   
		sortOrder = isAsc ? ' ASC ' : ' DESC ';
		previousSortField = sortField;		
		if(isMultiSelect || sortField == 'Date_Submitted'){
			lstContacts = sortWrapperList(lstContacts);
		}
		else{
			populateContacts();
		}		
	}
	
	//=======================================================================//
	// Method to get list of contact that need to approve
	//=======================================================================//
	private void populateContacts(){
		lstContacts = new List<ContactWrapper>();
		mapSelectedContactToProcess = new Map<String, String>();
		
		if(sortField == 'Date_Submitted'){
		 	sortField = 'Name';
		}
		
		Map<String, ProcessInstanceWorkitem> mapProcessToWorkItem = new Map<String, ProcessInstanceWorkitem>();
		for(ProcessInstanceWorkitem processStep : [SELECT ProcessInstanceId, Id, ActorId, CreatedDate FROM ProcessInstanceWorkitem 
																//WHERE ActorId = :UserInfo.getUserId()
																]){
			mapProcessToWorkItem.put(processStep.ProcessInstanceId, processStep);
		}
		
		Map<String, String> mapContactToProcess = new Map<String, String>();
		for(ProcessInstance processInstance : [SELECT Id, TargetObjectId, CreatedDate FROM ProcessInstance 
																											WHERE Status = 'Pending' AND Id IN :mapProcessToWorkItem.keySet()]){
			mapContactToProcess.put(processInstance.TargetObjectId, processInstance.Id);
		}
		
		String queryString = 'SELECT Id, Name, FirstName, LastName, Title, Email, Phone, Subscribe_Status__c, Distributor_Name__c, ' +
		  					'Distributor_City__c, Distributor_State__c, Distributor_Postal_Code__c, Distributor_Address__c, ' +
		  					'Subscribe_Premise__c, Subscribe_Interested_In__c, ' +
		  					'First_Name_copy__c, Last_Name_copy__c, Title_copy__c, Email_copy__c, ' +
							'Phone_copy__c, Distributor_Name_copy__c, Distributor_City_copy__c,  ' +
							'Distributor_State_copy__c, Distributor_Postal_Code_copy__c,  ' +
							'Subscribe_Interested_In_copy__c,Subscribe_Premise_copy__c,  ' +
							'Update_Request_Status__c,Distributor_Address_copy__c, Select_Managed_States_Copy__c, Select_Managed_States__c FROM Contact ' +
							'WHERE Update_Request_Status__c = \'Submitted\' AND Unsubscribe__c = false ' +
		  					'Order by '  + sortField + sortOrder + ' NULLS LAST'; 
		
		for(Contact con : (List<Contact>)Database.query(queryString)){
			mapContact.put(con.Id,con); 
			if(!mapContactToProcess.containsKey(con.Id) || !mapProcessToWorkItem.ContainsKey(mapContactToProcess.get(con.Id))){
			  lstContacts.add(new ContactWrapper(con, new ProcessInstanceWorkitem()));
			}
			else{		  						
		  		lstContacts.add(new ContactWrapper(con, mapProcessToWorkItem.get(mapContactToProcess.get(con.Id))));
			}		  			
		}
	}
	
	private List<ContactWrapper> sortWrapperList(List<ContactWrapper> ListToSort) {        
    if(ListToSort == null || ListToSort.size() <= 1) {
      return ListToSort;                  
    }
        
    List<ContactWrapper> Less = new List<ContactWrapper>();       
    List<ContactWrapper> Greater = new List<ContactWrapper>();
    List<ContactWrapper> blankRecords = new List<ContactWrapper>();    
            
    Integer pivot = 0;              
    ContactWrapper pivotValue = ListToSort[pivot];     
    ListToSort.remove(pivot);               
    for(ContactWrapper x : ListToSort) {
    	if(sortField == 'Date_Submitted'){
	    	if(x.processInstance.CreatedDate == null){
	    		blankRecords.add(x);
	    	}
	    	else{
	    		if(isAsc){           
		      	if(x.processInstance.CreatedDate > pivotValue.processInstance.CreatedDate ) {
		        	Less.add(x);
		      	} else if(x.processInstance.CreatedDate <= pivotValue.processInstance.CreatedDate) {
		        	Greater.add(x);
		      	}
		    	}
		    	else{
		    		if(x.processInstance.CreatedDate > pivotValue.processInstance.CreatedDate ) {
		        	Greater.add(x);
		      	} else if(x.processInstance.CreatedDate <= pivotValue.processInstance.CreatedDate ) {
		        	Less.add(x);
		      	}
		    	}
	    	}
    	}
    	else{
    		if(x.contact.get(sortField) == null){
	    		blankRecords.add(x);
	    	}
	    	else{
	    		String fieldValue1 = String.valueOf(x.contact.get(sortField));
	    		String fieldValue2 = String.valueOf(pivotValue.contact.get(sortField));
	    		if(isAsc){           
		      	if(fieldValue1 > fieldValue2) {
		        	Less.add(x);
		      	} else if(fieldValue1 <= fieldValue2) {
		        	Greater.add(x);
		      	}
		    	}
		    	else{
		    		if(fieldValue1 > fieldValue2) {
		        	Greater.add(x);
		      	} else if(fieldValue1 <= fieldValue2 ) {
		        	Less.add(x);
		      	}
		    	}
	    	}
    	}   
    }       
    List<ContactWrapper> returnList = new List<ContactWrapper> ();        
    returnList.addAll(sortWrapperList(Less));
    returnList.add(pivotValue); 
    returnList.addAll(sortWrapperList(Greater));
    returnList.addAll(blankRecords);    
     
    return returnList; 
  }
	
	//=======================================================================//
	// Method to get list of selected contact that need to approve/reject
	//=======================================================================//	
	public void populateSelected(){
		mapSelectedContactToProcess = new Map<String, String>();
		for(ContactWrapper conWrap : lstContacts){
			if(conWrap.isSelected){
				mapSelectedContactToProcess.put(conWrap.contact.Id, conWrap.processInstance.Id);				
			}
		}
	}
	
	//=======================================================================//
	// Method to approve selected contacts
	//=======================================================================//	
	public PageReference approveSelected(){
		if(mapSelectedContactToProcess.isEmpty()){
	 	  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ERROR_MSG));
	 	  return null;
		}
		List<Approval.ProcessWorkitemRequest> lstWorkItems = new List<Approval.ProcessWorkitemRequest>();
		List<Contact> lstUpdateContact = new List<Contact>();
		for(String conId : mapSelectedContactToProcess.keyset()){
			Approval.ProcessWorkitemRequest workItemReq = prepareProcessItem('Approve', mapSelectedContactToProcess.get(conId));
			lstWorkItems.add(workItemReq);
			Contact con = mapContact.get(conId);
			populateChangedContactInfo(con);
			resetContactCopyInfo(con);
			lstUpdateContact.add(con);			
			
		}
		try{
			update lstUpdateContact;
			Approval.ProcessResult[] result =  Approval.process(lstWorkItems);			
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
			return null;
		}
		populateContacts();
		return null;		
	}
	
	//=======================================================================//
	// Method to reject selected contacts
	//=======================================================================//
	public PageReference rejectSelected(){
		if(mapSelectedContactToProcess.isEmpty()){
	 	  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ERROR_MSG));
	 	  return null;
		}
		List<Approval.ProcessWorkitemRequest> lstWorkItems = new List<Approval.ProcessWorkitemRequest>();
		List<Contact> lstUpdateContact = new List<Contact>();
		for(String conId : mapSelectedContactToProcess.keyset()){
			Approval.ProcessWorkitemRequest workItemReq = prepareProcessItem('Reject', mapSelectedContactToProcess.get(conId));
			lstWorkItems.add(workItemReq);			
			Contact con = mapContact.get(conId);
			resetContactCopyInfo(con);
			lstUpdateContact.add(con);			
			
		}
		try{
			update lstUpdateContact;
			Approval.ProcessResult[] result =  Approval.process(lstWorkItems);			
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
			return null;
		}
		populateContacts();		
	  return null;	
	}
	
	//=======================================================================//
	// Method to approve selected contact
	//=======================================================================//
	public PageReference approveRequest(){
		System.debug('========'+mapSelectedContactToProcess+'======='+selectedContactId);		
		if(mapSelectedContactToProcess.isEmpty() || selectedContactId == '' || !mapSelectedContactToProcess.containsKey(selectedContactId)){
	 	  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ERROR_MSG2));
	 	  return null;
		}
				
		try{
			Approval.ProcessWorkitemRequest workItemReq = prepareProcessItem('Approve', mapSelectedContactToProcess.get(selectedContactId));
			
			Contact con = mapContact.get(selectedContactId);
			populateChangedContactInfo(con);
			resetContactCopyInfo(con);
			update con;
			
			Approval.ProcessResult result =  Approval.process(workItemReq);			
			
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
			return null;
		}
		populateContacts();
		return null;
	}
	
	//=======================================================================//
	// Method to reject selected contacts
	//=======================================================================//
	public PageReference rejectRequest(){
		if(mapSelectedContactToProcess.isEmpty() || selectedContactId == '' || !mapSelectedContactToProcess.containsKey(selectedContactId)){
	 	  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ERROR_MSG2));
	 	  return null;
		}
		
		try{
			Approval.ProcessWorkitemRequest workItemReq = prepareProcessItem('Reject', mapSelectedContactToProcess.get(selectedContactId));
			
			Contact con = mapContact.get(selectedContactId);
			resetContactCopyInfo(con);
			update con;
			
			Approval.ProcessResult result =  Approval.process(workItemReq);				
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
			return null;
		}
		populateContacts();
		return null;
	}
	
	public PageReference cancel(){
		return new PageReference('/003');
	}
	
	//=======================================================================//
	// Method to prepare process envelope
	//=======================================================================//
	private Approval.ProcessWorkitemRequest prepareProcessItem(String action, String workItemId){
		Approval.ProcessWorkitemRequest workItemReq = new Approval.ProcessWorkitemRequest();
		workItemReq.setWorkitemId(workItemId);
		workItemReq.setAction(action);
		return workItemReq;
	}
	
	//Wrapper class
	public class ContactWrapper{
		public Contact contact{get;set;}
		public ProcessInstanceWorkitem processInstance{get;set;}
		public Boolean isSelected {get;set;}
		
		public ContactWrapper(Contact contact, ProcessInstanceWorkitem processInstance){
			this.contact = contact;
			this.processInstance = processInstance;
			isSelected = false;
		}
	}
	
	private Contact populateChangedContactInfo(Contact distribuorCon){
		distribuorCon.FirstName = distribuorCon.First_Name_copy__c ;
		distribuorCon.LastName = distribuorCon.Last_Name_copy__c;
		distribuorCon.Title = distribuorCon.Title_copy__c ;
		distribuorCon.Email = distribuorCon.Email_copy__c ;
		distribuorCon.Phone = distribuorCon.Phone_copy__c ;
		distribuorCon.Distributor_Name__c = distribuorCon.Distributor_Name_copy__c;
		distribuorCon.Distributor_City__c = distribuorCon.Distributor_City_copy__c;
		distribuorCon.Distributor_State__c = distribuorCon.Distributor_State_copy__c ;
		distribuorCon.Distributor_Postal_Code__c = distribuorCon.Distributor_Postal_Code_copy__c;
		distribuorCon.Subscribe_Interested_In__c = distribuorCon.Subscribe_Interested_In_copy__c;
		distribuorCon.Subscribe_Premise__c = distribuorCon.Subscribe_Premise_copy__c;
		distribuorCon.Distributor_Address__c = distribuorCon.Distributor_Address_copy__c;
		distribuorCon.Select_Managed_States__c = distribuorCon.Select_Managed_States_Copy__c;
		return distribuorCon;
	} 
	
	private Contact resetContactCopyInfo(Contact distribuorCon){
		distribuorCon.First_Name_copy__c = null;
		distribuorCon.Last_Name_copy__c =  null;
		distribuorCon.Title_copy__c = null;
		distribuorCon.Email_copy__c = null;
		distribuorCon.Phone_copy__c = null;
		distribuorCon.Distributor_Name_copy__c = null;
		distribuorCon.Distributor_City_copy__c = null;
		distribuorCon.Distributor_State_copy__c = null;
		distribuorCon.Distributor_Postal_Code_copy__c = null;
		distribuorCon.Subscribe_Interested_In_copy__c = null;
		distribuorCon.Subscribe_Premise_copy__c = null;
		distribuorCon.Distributor_Address_copy__c = null;
		distribuorCon.Is_Update_Link_Used__c = false;
		distribuorCon.Select_Managed_States_Copy__c = null;
		return distribuorCon;
	}
}