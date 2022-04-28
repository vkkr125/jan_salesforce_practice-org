public class Q_ClassDemo_1 implements Queueable {
    
    public Id parentId;
    public Q_ClassDemo_1(Id accountId){
        this.parentId = accountId;
    }
    public void execute(QueueableContext qc){
        Contact con = new Contact(LastName = 'Contact23', FirstName = 'Queueable', AccountId = this.parentId);
        insert con;
        if(!Test.isRunningTest()){
            
             Id batchId2;
             // 2nd level chaining
             Q_ClassDemo_2 qClass2 = new Q_ClassDemo_2(this.parentId);
             batchId2 = System.enqueueJob(qClass2);
            
            AsyncApexJob jobInfo = [SELECT Id, ApexClassId, Status, JobItemsProcessed,
                                    NumberOfErrors, MethodName, TotalJobItems
                                    FROM AsyncApexJob
                                    WHERE Id =: batchId2];
            
            System.debug('JobInfo ' + JobInfo);
        }
    }
}