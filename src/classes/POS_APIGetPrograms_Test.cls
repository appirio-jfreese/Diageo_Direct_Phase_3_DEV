@IsTest(SeeAllData=false)
public class POS_APIGetPrograms_Test{
    
    static testmethod void testGetPrograms () {
        
        POS_TestDataUtil.initializeTestData();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
        
        //Try query with no populated data first
        POS_APIGetPrograms.APIProgramResponse response = POS_APIGetPrograms.doGet();
        List<Program__c> programs = response.Programs;
        System.assert(programs.size()==0);
        
        //Now add data and test again
        Order_Window__c window = POS_TestDataUtil.createOrderWindow();
        window.Status__c='New';
        window.Magento_Id__c = '12345';
        update window;
        
        
        
        Program__c program = POS_TestDataUtil.createProgram();
        program.Order_Window__c=window.Id;
        update program;
        
        //Check to make sure no results come back with a new window
        response = POS_APIGetPrograms.doGet();
        programs = response.Programs;
        System.assert(programs.size()==0);
        
        window.Status__c='In Review';
        update window;
        
        //Now we should get results
        response = POS_APIGetPrograms.doGet();
        programs = response.Programs;
        System.assert(programs.size()==1);
        
        //Now try with Window ID
        req.addParameter('WindowId',window.Id);
        response = POS_APIGetPrograms.doGet();
        programs = response.Programs;
        System.assert(programs.size()==1);
        
        //And with a bad Window ID we should get no results
        req.addParameter('WindowId','000000000000000');
        response = POS_APIGetPrograms.doGet();
        programs = response.Programs;
        System.assert(programs.size()==0);
        
        //Now try using a more recent update time and see if we get no results again
        req=new RestRequest();
        Datetime now = System.now();
        now=now.addDays(2);
        
        String dateString = now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        req.addParameter('UpdateTime',dateString);
        RestContext.request=req;
        
        response = POS_APIGetPrograms.doGet();
        programs = response.Programs;
        System.assert(programs.size()==0);
        
        
    }
   
}