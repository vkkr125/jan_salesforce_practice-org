public class QuableClassDemo implements Queueable{
    
    List<Account> accList;
    public QuableClassDemo(){
        accList = [SELECT Id,Name, Active__c, Industry
                   FROM Account
                   WHERE Active__c =: 'Yes'];
    }
    public void execute(QueueableContext qc){
        List<Account> accountInsertList = new List<Account>();
        for(Integer i = 0; i < 40; i++){
            Account acc = new Account();
            acc.Name = 'Test q account ' + i;
            acc.Active__c = 'No';
            accountInsertList.add(acc);
        }
        if(accountInsertList.size() > 0){
            insert accountInsertList;
        }
    }
    public void finish(){
        System.debug('All Account Active Field has been update successfully !!');
    }
}