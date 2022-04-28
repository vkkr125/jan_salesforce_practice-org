@isTest
public class Q_ClassDemoTest {
    public static testmethod void Q_ClassDemoTestFunction(){
        List<Account> accList = TestDataFactory.createAccountList(1, 'testdemoaccount', true);
        Q_ClassDemo qClass = new Q_ClassDemo(accList.get(0));
        
        Test.startTest();
          Id batchId = System.enqueueJob(qClass);
        Test.stopTest();
        
        AsyncApexJob jobInfo = [SELECT Id, ApexClassId, Status, JobItemsProcessed,
                                NumberOfErrors, MethodName, TotalJobItems
                                FROM AsyncApexJob
                                WHERE Id =: batchId];
        
        System.debug('JobInfo ' + jobInfo);
       
        List<Account> accountListInfo = [SELECT Id, Name, Industry FROM Account WHERE Id =: accList.get(0).Id];
        System.assertNotEquals(null, accountListInfo);
        System.assertEquals(1,accountListInfo.size(), 'More then one contact found!!');
        System.assertEquals('Update Account', accountListInfo.get(0).Name);
        System.assertEquals('Education', accountListInfo.get(0).Industry);
        
        
    }
}