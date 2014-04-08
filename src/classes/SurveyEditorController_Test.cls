@isTest
private class SurveyEditorController_Test {

    static testMethod void unit_test_1() {
    	DMS_Survey__c s = new DMS_Survey__c();
    	s.Name = 'test survey';
    	insert s;
    	
    	DMS_Question__c question1 = new DMS_Question__c( DMS_Survey__c = s.Id);
    	insert question1;
    	DMS_Question__c  question2 = new DMS_Question__c( DMS_Survey__c = s.Id, Parent_Question__c = question1.Id);
    	insert question2;
    	DMS_Question__c  question3 = new DMS_Question__c( DMS_Survey__c = s.Id, NEXT_Question__c = question1.id);
    	insert question3;
    	
    	s.First_question__c = question3.id;
    	update s;
    	
        Test.startTest();
        SurveyEditorController controller = new SurveyEditorController(new ApexPages.StandardController(s));
        
        try{
        	SurveyEditorController.getSurvey(null);
        	System.assert(false,'Why not an exception for null ID?');
        }catch(Exception e){}
        
        try{
        	SurveyEditorController.getSurvey('000000000000000');
        	System.assert(false,'Why not an exception for survey not found?');
        }catch(Exception e){}
        
        SurveyEditorController.getSurvey(s.Id);
        
        SurveyEditorController.SurveyQuestion q = new SurveyEditorController.SurveyQuestion(question3);
        try{
        	SurveyEditorController.upsertQuestion(null);
        	System.assert(false,'Why not an exception for null question on upsert?');
        }catch(Exception e){}
        
        SurveyEditorController.upsertQuestion(q);
        
         try{
         	q.surveyId = null;
         	q.Id = null;
        	SurveyEditorController.upsertQuestion(q);
        	System.assert(false,'Why not a DML exception ?');
        }catch(Exception e){}
        
       
        try{
        	SurveyEditorController.setFirstQuestion(null);
        	System.assert(false,'Why not an exception for null survey ID for setFirstQuestion?');
        }catch(Exception e){}
        try{
        	SurveyEditorController.setFirstQuestion('000000000000000');
        	System.assert(false,'Why not an exception for survey not found for setFirstQuestion?');
        }catch(Exception e){}
        try{
        	SurveyEditorController.setFirstQuestion('XXXXXXXXX');
        	System.assert(false,'Why not an exception for survey not found for SOQL exception for setFirstQuestion?');
        }catch(Exception e){}
        SurveyEditorController.setFirstQuestion(question3.Id);
        
        
        try{
        	SurveyEditorController.removeQuestion(null);
        	System.assert(false,'Why not an exception for null question for removeQuestion?');
        }catch(Exception e){}
        SurveyEditorController.removeQuestion(question2.Id);
        Test.stopTest();
    }
}