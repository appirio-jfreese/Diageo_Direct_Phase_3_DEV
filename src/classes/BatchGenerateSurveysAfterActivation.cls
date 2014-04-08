/**
*   @Someone added a query inside of a loop here.   
*
*/
global class BatchGenerateSurveysAfterActivation implements Database.Batchable<sObject>
{
    string query = 'select id from Account where Name like \'Diageo%\'';
    
    global BatchGenerateSurveysAfterActivation() 
    {
    }
    
    global BatchGenerateSurveysAfterActivation(String constructorQuery) 
    {
        query = constructorQuery;
    }
    
    global database.queryLocator start(Database.BatchableContext BC) 
    {
        if(test.isRunningTest()) {
            query += ' LIMIT 1' ;
        }
        return database.getQueryLocator(query);
    }
    
    
    
    global void execute(Database.BatchableContext BC, List<Survey_Layout__c> surveyLayoutList) 
    {

    }
 
    global void finish(Database.BatchableContext BC) 
    {
    
    }
}