global class AccountBatchTest implements Database.Batchable<sObject>,Database.stateful{
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name FROM Account WHERE Name Like \'Demo%\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Account> accList){
        for(Account acc : accList){
            acc.Name = 'Updated Demo Account';
            acc.Industry = 'Education';
        }
        update accList;
    }
    global void finish(Database.BatchableContext bc){
        // notify the user 
    }

}