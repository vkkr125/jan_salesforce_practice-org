public class ApexScenario1 {
    public ApexScenario1(){
      /*  List<Account> accountUpdateList = new List<Account>();
        for(Contact con : [SELECT Id,Name,AccountId
                           FROM Contact
                           WHERE Name like 'Contact Demo%']){
                               Account acc = new Account();
                               acc.Id = con.AccountId;
                               acc.Active__c = 'Yes';
                               accountUpdateList.add(acc);
                           }
        if(accountUpdateList.size() > 0){
            update accountUpdateList;
        }*/
        
        // the above code is will give erro coz list contais duplicate accounts (based on id)
        // and DML operation can not be perforemed on duplicate id's
        
        List<Account> accountUpdateList = new List<Account>();
        Set<Id> accountIdSet = new Set<Id>();
        for(Contact con : [SELECT Id,Name,AccountId
                           FROM Contact
                           WHERE Name like 'Contact Demo%']){
                               if(!accountIdSet.contains(con.AccountId)){
                                   
                                   Account acc = new Account();
                                   acc.Id = con.AccountId;
                                   acc.Active__c = 'Yes';
                                   accountUpdateList.add(acc);
                                   accountIdSet.add(acc.Id);
                               }
                           }
        
        if(accountUpdateList.size() > 0){
            update accountUpdateList;
        } 
        
        
    }
    
    public void solutionUsingMap(){
        Map<Id,Account> recordIdToRecordMap = new Map<Id,Account>();
        for(Contact con : [SELECT Id,Name,AccountId
                           FROM Contact
                           WHERE Name like 'Contact Demo%']){
                               if(!recordIdToRecordMap.containsKey(con.AccountId)){
                                   Account acc = new Account();
                                   acc.Id = con.AccountId;
                                   acc.Active__c = 'Yes';
                                   recordIdToRecordMap.put(acc.Id,acc);
                               }
                           }
        if(recordIdToRecordMap.size() > 0){
            update recordIdToRecordMap.values();
            for(Account acc : recordIdToRecordMap.values()){
                System.debug('updated account id is ' + acc.Id);
            }
        }
    }
}