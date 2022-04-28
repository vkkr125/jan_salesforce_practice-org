public class SetExample {
    
    public void test_example(){
        
        // why we should not create set of sObjects
        Set<Account> accountSet = new Set<Account>();
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        accountSet.add(acc);
        System.debug('Set Size is ' + accountSet.size());
        System.debug('Set Values are ' + accountSet);
        
        acc.Active__c = 'Yes';
        accountSet.add(acc);
        System.debug('===================================');
        System.debug('Set Size is ' + accountSet.size());
        System.debug('Set Values are ' + accountSet);
        
        Account tempAccount = new Account();
        tempAccount.Id = acc.Id;
        tempAccount.Name = 'Test';
        update tempAccount;
        
        accountSet.add(tempAccount);
        System.debug('===================================');
        System.debug('Set Size is ' + accountSet.size());
        System.debug('Set Values are ' + accountSet);
        for(Account abb : accountSet){
            System.debug(abb.Id);
        }

        
    }
    public void test_example2(){
        Account acc = new Account();
        List<Account> testList = new List<Account>();
        acc.Active__c ='No';
        testList.add(acc);
        testList.add(acc);
        testList.add(acc);
        testList.add(acc);
        
        System.debug('size of list is ' + testList);
        Set<Account> mySet = new Set<Account>();
        mySet.addAll(testList);
        System.debug('size of set is ' + mySet.size());
    }
    
    public void test_example_3(){
     /*   List<Account> testList = new List<Account>();
        Account acc1 = new Account();
        acc1.Name = 'test';
        insert acc1;
        
        testList.add(acc1);
        acc1.Active__c = 'Yes';
        update acc1;
       
        System.debug('$$$$$$$$$$ ' + testList.contains(acc1)); // true */
        
        List<Account> testList = new List<Account>();
        Account acc1 = new Account();
        acc1.Name = 'test5';
        insert acc1;
        
        Id recordId = acc1.Id;
        testList.add(acc1);
        acc1 = new Account();
        acc1.Id = recordId;
        
        System.debug('$$$$$$$$$$$$ ' + testList.contains(acc1)); // false
        // because values are passed here as reference, so after creating new instance even though id is same but 
        // reference id different that's why we are getting false 
        // but id is same
        if(testList[0].Id == acc1.Id){
            System.debug('both id are same');
        }
        
        
        
        
        
    }
    
}