public class DatabaseOperations {
    
    
    public void createSingleRecord(){
        Account acc = new Account();
        acc.Name = 'test account 1';
        acc.Active__c = 'Yes';
        acc.Industry = 'Biotechnology';
        acc.Description = 'test Description';
        
        Date myDate = Date.newInstance(2022,2,28);
        acc.SLAExpirationDate__c = myDate;
        insert acc;
        
        System.debug('The inserted account id is ' + acc.Id);
    }
    
    

    public void createMultipleRecords(){
      /*  for(Integer i = 0; i<300; i++){
            Account acc = new Account();
            acc.Name = 'test account ' + i;
            acc.Active__c = 'Yes';
            acc.Industry = 'Biotechnology';
            acc.Description = 'test Description';
            Date myDate = Date.newInstance(2022,2,28);
            acc.SLAExpirationDate__c = myDate;
            
            insert acc;
            System.debug('The Inserted account id is ' + acc.Id); 
       
        } */
        
        // maximum number of DML operations can be up to 150
        // DML operations are // inser,delete, update, upsert
        // so belowe code will throw exception too many DML opeartons 151
        // 
        // best practice : NEVER write DML opeations in loop if the loop is running even for the 2 times
        // we can use collections(lsit,set,map) to solve DML's
        // to create multiple records or any DML operations we make use of DML collections
        // LIST : it contains the element of single dta type(premitve, sObjec, collection)
        // ,it allow duplicate element, it is used mostely for CRUD operations
        
        
        
        List<Account> accountList = new List<Account>();
        for(Integer i = 0; i<200; i ++){
            Account acc = new Account();
            acc.Name = 'test account ' + i;
            acc.Active__c = 'Yes';
            acc.Industry = 'Biotechnology';
            acc.Description = 'test description ' + i;
            Date myDate = Date.newInstance(2022, 2, 28);
            acc.SLAExpirationDate__c = myDate;
            
            accountList.add(acc);
        }
        if(accountList.size() > 0){
            insert accountList;
        }
        for(Account acc : accountList){
            System.debug('The Inserted Account Id is ' + acc.Id + '>>> Account Name is ' + acc.Name);
        }
        
    }
    
    // read the records form the database
    // best practice will writing queries
    // all keywords should be in capital, should not keep in single line if query is longer
    public void readRecords(){
        List<Account> accountList = [SELECT Id,Name,AccountNumber,OwnerId,Active__c,
                                     AnnualRevenue,Description,Industry,Phone,Rating
                                     FROM Account
                                     WHERE Active__c = 'Yes'
                                     AND Industry != NULL
                                     ORDER BY Name
                                     LIMIT 20];
        for(Account acc : accountList){
            System.debug('This id is ' + acc.Id + ' >>>> Account Name is ' + acc.Name);
        }
        
        // Alternative Way
        for(Account acc : [SELECT Id,Name,AccountNumber,OwnerId,Active__c,
                           AnnualRevenue,Description,Industry,Phone,Rating
                           FROM Account
                           WHERE Active__c = 'Yes'
                           AND Industry != NULL
                           ORDER BY Name
                           LIMIT 20]){
                              System.debug('This id is ' + acc.Id + ' >>>> Account Name is ' + acc.Name);
                           }
        
    }
    
    public void updateRecords(){
        
        // to update records, id is always required field
        List<Account> accountUpdateList = new List<Account>();
        for(Account acc :[SELECT Id,Name FROM Account]){
            acc.Active__c = 'Yes';
            accountUpdateList.add(acc);
        }
        if(accountUpdateList.size() > 0){
            update accountUpdateList;
            for(Account acc : accountUpdateList){
                System.debug(':::: ' + acc.Id);
            }
        }
        
    }
    
    public void deleteRecords(){
        List<Account> accountDeleteList = [SELECT Id,Name,Active__c
                                           FROM Account 
                                           WHERE Name like 'test%'];
        if(accountDeleteList.size() > 0){
            delete accountDeleteList;
            for(Account acc : accountDeleteList){
                System.debug('Deleted Account Id is ' + acc.Id);
            }
        }
        
        
    }
    
    
    
    
}