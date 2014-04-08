global class ScheduleGenerateSurveys implements Schedulable 
{

    global void execute(SchedulableContext SC) 
    {
        BatchGenerateSurveysAfterActivation batch = new BatchGenerateSurveysAfterActivation();
        database.executebatch(batch,1);
    }
}