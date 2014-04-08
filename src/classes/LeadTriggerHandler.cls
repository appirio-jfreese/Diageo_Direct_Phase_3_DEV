/***************************************************************************
// (c) 2013 Appirio, Inc.
//
// Description    : Class that contains all of the functionality called by the 
//                  LeadTrigger. All contexts should be in this class.
//                  
// Sep 12th, 2013 :  Randy Wandell  
//***************************************************************************/
public with sharing class LeadTriggerHandler {
    private boolean m_isExecuting = false;  
    private integer BatchSize = 0;
    
    private Map<String, Contact> contactEmails = new Map<String, Contact>();
    private List<Lead> duplicateLeads = new List<Lead>();
    private Map<String, Lead> leadEmails = new Map<String, Lead>(); 
    
    public LeadTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;    
    }
    
    //-------------------------------------------------------------------------  
    // On before insert trigger method
    //-------------------------------------------------------------------------
    public void OnBeforeInsert(List<lead> leads) {
        getContactsWithMatchingEmail(leads);

        for(Lead lead : leads) {
            checkEmailForMatch(lead);
        }
    } 

    //-------------------------------------------------------------------------
    // On after insert trigger method
    //-------------------------------------------------------------------------
    public void OnAfterInsert(List<Lead> leads) {   
         
    }

    //-------------------------------------------------------------------------
    // On before update trigger method
   //-------------------------------------------------------------------------
    public void OnBeforeUpdate(Map<Id, Lead>oldMap, Map<Id, Lead>newMap) {

    }

    //-------------------------------------------------------------------------
    // On after update trigger method
    //-------------------------------------------------------------------------
    public void OnAfterUpdate (Map<Id, Lead>oldMap, Map<Id, Lead>newMap) {    
      
    }

    //-------------------------------------------------------------------------
    // On before delete trigger method
    //-------------------------------------------------------------------------
    public void OnBeforeDelete (Map<Id, Lead>oldMap) {    
      
    }
    
    //-------------------------------------------------------------------------
    // On after delete trigger method
    //-------------------------------------------------------------------------
    public void OnAfterDelete (Map<Id, Lead>oldMap) {    
      
    }
    
    //------------------------------------------------------------------------
    // Get a list of contacts that an email that matches the lead so we
    // can ensure that duplicate contacts are not created
    //------------------------------------------------------------------------
    private void getContactsWithMatchingEmail(List<Lead> leads) {
        Set<String> emailAddresses = new Set<String>();
        for(Lead lead: leads) {
            emailAddresses.add(lead.Email);
        }
        
        List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Email IN : emailAddresses];
        for(Contact contact : contacts) {
            contactEmails.put(contact.Email, contact);
        }
    }
    
    //-------------------------------------------------------------------------
    // Check to see if the email on the lead matches an existing account
    //-------------------------------------------------------------------------
    private void checkEmailForMatch(Lead lead) {
        if(contactEmails.containsKey(lead.Email)) {
            lead.Has_Existing_Contact__c = true;
            lead.Existing_ContactId__c = contactEmails.get(lead.Email).Id;        
            duplicateLeads.add(lead);
        }
    }
}