@isTest(SeeAllData=false)
public class BreadcrumbsHolder_Test{
	static testmethod void testBreadcrumbsHolder() {
        Organizational_Unit__c o = new Organizational_Unit__c(name='Test Unit');
        insert o;
        
        Organizational_Unit__c o1 = new Organizational_Unit__c(name='Test Unit - 1');
        insert o1;
        
        Account a1 = Test_Helper.testInsertAccount('TestAccount - 1');
        
        List<Account> accountList = new List<Account>();
        accountList.add(a1);
        
        List<Organizational_Unit__c> ol = [SELECT Id, Name FROM Organizational_Unit__c];
        
        Test.startTest();
        BreadcrumbsHolder bh = new BreadcrumbsHolder();
        bh.setupOrganizationalUnitsMap(ol);
        OrganizationalUnit ou = new OrganizationalUnit(o.Id, o.Name);
        OrganizationalUnit ou1 = new OrganizationalUnit(o1.Id, o1.Name);
        ou.assignDistributors(accountList);
        ou.compareTo(ou);
        ou.compareTo(ou1);
        bh.addOrganizationalUnit(ou1);
        bh.clear();
        Test.stopTest();
    }
}