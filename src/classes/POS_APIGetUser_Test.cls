@IsTest(SeeAllData=false)
public class POS_APIGetUser_Test{

    static testmethod void testGetUser () {
        //Get the current time
        Datetime now = System.now();
        
        Profile p = [select id from profile where name='System Administrator'];
        
        User u = new User(alias = 'posmmtst', email='posmmunittest@diageo.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id,
                          timezonesidkey='America/Chicago', username='posmmunittest@diageo.com',
                          Available_Themes__c='Spirits');
        
        insert u;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('UserId',u.Id);
        
        RestContext.request=req;
        
        User returnedUser = POS_APIGetUser.doGet();
        System.assert(returnedUser!=null);
        
        
    }
}