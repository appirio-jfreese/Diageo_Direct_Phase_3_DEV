@IsTest(SeeAllData=false)
public class customEmailAuthorControllerNew_Test{

    @isTest(seeAllData = true)
        public static void testCustomEmailAuthorController()
    {
        Test.startTest();
        customEmailAuthorControllerNew testController = new customEmailAuthorControllerNew();
        testController.getTemplates();
        testController.toAddress = 'test@gmail.com;\n';
        testController.newEmailTemplate.Name = 'Temaplate Name';
        testController.emailSubject = 'Testing Email';
        testController.newEmailTemplate.DeveloperName = 'TemaplateName';
        testController.renderNewTemplateSection = false;
        testController.createNewTemplate();
        testController.renderNewTemplateSection = true;
        testController.createNewTemplate();
        testController.getTemplates();
        testController.emailSubject = null;
        testController.sendEmail();
        testController.emailSubject = 'Testing Email';
        testController.CCAddress = 'test@gmail.com;\n';
        testController.BccAddress = 'test@gmail.com;\n';
        testController.sendEmail();
        testController.selectTemplate();
        testController.createNewTemplate();
        testController.createNewTemplate();
        testController.cancelNewTemplate();
        
        testController.redirect();
        Test.stopTest();
    }
}