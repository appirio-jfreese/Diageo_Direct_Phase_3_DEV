/*******************************************************************************
Name        : Test_ContentMatrixContentDescriptionTrig
Created By  : Vikash Goyal (Appirio JDC)
Date        : 07th Mar, 2014
Reason      : For Code Coverage of trigger ContentMatrixContentDescription 
*******************************************************************************/
@isTest(SeeAllData=false)
private class Test_ContentMatrixContentDescriptionTrig {

    static testMethod void testContentMatrixTypeUpdate() {
      List<Content_Description__c> contentDescriptionList = Test_Helper.testInsertContentDescriptionExtended(new List<String>
                                        {'title1','title2','title3','title4'});
      Content_Matrix__c conMatrix = Test_Helper.testCreateContentMatrix('test', Constant.INNOVATION_AND_SUSTAINOVATION, 'Program', Constant.SELLING_MATERILAS, null, null);
      insert conMatrix;
      List<Content_Property__c> lstContentProps = new List<Content_Property__c>();
      lstContentProps.add(Test_Helper.testCreateContentProperty('property1', null, contentDescriptionList[0].Id, Constant.INNOVATION_AND_SUSTAINOVATION, 
                                                    Constant.SELLING_MATERILAS, null, null));
      lstContentProps.add(Test_Helper.testCreateContentProperty('property1', null, contentDescriptionList[1].Id, Constant.INNOVATION_AND_SUSTAINOVATION, 
                                                    Constant.SELLING_MATERILAS, 'Final Launch Deck', null));
      
      insert lstContentProps;
      
      Test.startTest();
        list<Content_Property__c> currentProperty1 = [SELECT Id FROM Content_Property__c WHERE Content_Description__c = :contentDescriptionList[0].id];
        list<Content_Property__c> currentProperty2 = [SELECT Id FROM Content_Property__c WHERE Content_Description__c = :contentDescriptionList[1].id]; 
        System.assertEquals(1, currentProperty1.size());
        System.assertEquals(1, currentProperty2.size());
        
        contentDescriptionList[0].Matrix_type__c = 'Program';
        contentDescriptionList[1].Matrix_type__c = 'Program';
        update contentDescriptionList;
        
        list<Content_Property__c> currentProperty3 = [SELECT Id FROM Content_Property__c WHERE Content_Description__c = :contentDescriptionList[0].id];
        list<Content_Property__c> currentProperty4 = [SELECT Id FROM Content_Property__c WHERE Content_Description__c = :contentDescriptionList[1].id];
        System.assertEquals(1, currentProperty3.size());
        System.assertEquals(2, currentProperty4.size());
        
        contentDescriptionList[0].Description__c = 'test record';
        update contentDescriptionList[0];
        
        Test.stopTest();
    }
}