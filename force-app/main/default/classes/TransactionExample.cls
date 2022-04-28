public class TransactionExample {
    
    
    public void transaction_example(){
        
        
        Account acc = new Account();
        acc.Name = 'hello transactions';
        
        insert acc;
        
        College__c clg = new College__c();
        clg.College_Email__c = 'vickykr25@gmail.com';
        clg.is_Active__c = true;
        clg.Name = 'transaction college';
        clg.State__c = 'Bihar';
        
        insert clg;
    }
}