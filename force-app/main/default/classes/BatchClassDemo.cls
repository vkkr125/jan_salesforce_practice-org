global class BatchClassDemo implements Database.Batchable<sObject>, Database.Stateful{
    
    Integer successCount = 0, failure = 0;
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name,Active__c,Industry FROM Account';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Account> accList){
        
        for(Account acc : accList){
            if(acc.Active__c == 'Yes'){
                acc.Active__c = 'No';
            }else{
                acc.Active__c = 'Yes';
            }
        }
        
        Database.SaveResult []srList = Database.update(accList, false);
        for(Database.SaveResult sr : srList){
            if(sr.isSuccess()){
                successCount ++;
            }else{
                failure++;
            }
        }
    }
    global void finish(Database.BatchableContext bc){
        System.debug('Updated Record Count : ' + successCount);
        System.debug('Failure Record Count : ' + failure);
    }
}