@isTest
public class Test_TriggerState{
    static testMethod void testLeadTrigger(){
        Map<String, TriggerSettings__c> triggerSetting = TriggerSettings__c.getAll();
/*        
        if(!triggerSetting.containsKey('DummyTrigger')) {
            TriggerSettings__c triggerSettings = new TriggerSettings__c();
            triggerSettings.Name = 'DummyTrigger';
            triggerSettings.isActive__c = true;
            triggerSettings.isTestMode__c = true;
                    
            insert triggerSettings;
            
            triggerSetting = TriggerSettings__c.getAll();
        }
*/        
        TriggerState.isActive('DummyTrigger');
        
        triggerSetting = TriggerSettings__c.getAll();
        
        TriggerSettings__c ts = triggerSetting.get('DummyTrigger');
        ts.isActive__c = false;
        ts.isTestMode__c = true;
        
        update ts;
        
        TriggerState.isActive('LeadTrigger');
        TriggerState.executeForTestMethods('LeadTrigger');
    }
}