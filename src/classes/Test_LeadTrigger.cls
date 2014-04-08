@isTest
private class Test_LeadTrigger {
  
    static testMethod void testLeadTrigger(){       
        
        Contact contact = new Contact(FirstName='First', LastName='Last', Email='firstlast@diageo.com');
        insert contact;
        
        Lead lead = new Lead(FirstName='First', LastName='Last', Company='Diageo', Email='firstlast@diageo.com');
        insert lead;
        update lead;
        delete lead;
    }
}