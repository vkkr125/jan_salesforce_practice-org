public class Q_ClassDemo implements Queueable {
    public Account acc;
    public Q_ClassDemo(Account acc){
        this.acc = acc;
    }
    public void execute(QueueableContext qc){
        this.acc.Name = 'Update Account';
        this.acc.Industry = 'Education';
        update this.acc;
        
         // this line will not execute while running test classes because chaining of jobs are not allowed in test class
         // we have to write seprate test class for the child class 
         // 
         // Note : we can chain up to 5 level of queable class chaining
         // From a single quable class we can call single another queable class if we call more then one it will give error
        if(!Test.isRunningTest()){
            Id batchId1, batchId2;
            Q_ClassDemo_1 qClass1 = new Q_ClassDemo_1(this.acc.Id);
          //  Q_ClassDemo_2 qClass2 = new Q_ClassDemo_2(this.acc.Id);
            batchId1 = System.enqueueJob(qClass1);
         //   batchId2 = System.enqueueJob(qClass2);  // this will give two many queueable job added to queue, so we can not chain multiple jobs
         //   we can chain multilevel  job up to 5 level in developer edition but in entrprise edition there is no limit
            AsyncApexJob jobInfo = [SELECT Id, ApexClassId, Status, JobItemsProcessed,
                                    NumberOfErrors, MethodName, TotalJobItems
                                    FROM AsyncApexJob
                                    WHERE Id =: batchId1];
            
            System.debug('JobInfo ' + JobInfo);
        }
    }
}


// some important points 
// we can add upto 50 jobs using system.enquejob(job) in a single transaction
// To avoid MIXED_DML_OPERATION we use future method 
// future method must be static and can't take non-premitive data types as parameter but queueable accept future method as datatype
// monitoring very difficult and complex in future method
// 
// queueable has featers of future method and queueable method
// we can call future method from queueable apex
//