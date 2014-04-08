@IsTest(seeAllData=false)
public class SelectCombo_Test {
    static testmethod void test_getData(){
        Test.startTest();
                List<User> userList = new List<User>([Select Id, Name from User LIMIT 999]);
                List<Account> accList = new List<Account>([Select Id, Name from Account LIMIT 999]);
            System.assertEquals(userList.size(), SelectCombo.getData('User','Name','Id','','','').size());
            System.assertEquals(accList.size(),SelectCombo.getData('Account','Name','Id','','','').size());
            SelectCombo controller = new SelectCombo();
            controller.setTargetField(null);
        Test.stopTest();
        
    }
}