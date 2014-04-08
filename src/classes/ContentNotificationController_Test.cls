@isTest(SeeAllData=false)
public class ContentNotificationController_Test{
    static testmethod void testController() {
        ContentNotificationController cnc = new ContentNotificationController();
        cnc.getContentSubs();
    }
}