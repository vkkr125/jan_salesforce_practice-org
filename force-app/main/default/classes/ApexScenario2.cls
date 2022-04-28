public class ApexScenario2 {
    public void createMapUsingParent(){
        
        
        // this code will returen error if inner query return more the 200 records
        Map<Id,List<Contact>> accountIdToContactMap = new Map<Id,List<Contact>>();
        for(Account acc : [SELECT Id,Name,Active__c,
                           (SELECT Id,Name FROM Contacts)
                           FROM Account]){
                               if(acc.Contacts.size() > 0){
                                   accountIdToContactMap.put(acc.Id,acc.Contacts);
                               }
                           }
        for(Id accountId : accountIdToContactMap.keySet()){
            String allContacts = '';
            if(accountIdToContactMap.get(accountId).size() > 0){
                for(Contact con : accountIdToContactMap.get(accountId)){
                allContacts += con.Name + ' ; ';
               }
               System.debug('total number of contacts are '+  accountIdToContactMap.get(accountId).size() +
                            'all the contacts for account id ' + accountId + ' is ' + allContacts);
            }else{
                System.debug('for account id ' + accountId + ' contacts are 0');
            }
            
        }
    }
    public void createMapUsingChild(){
        Map<Id,List<Contact>> accountIdToContactMap = new Map<Id,List<Contact>>();
        for(Contact con : [SELECT Id,Name,AccountId
                           FROM Contact]){
                               if(!accountIdToContactMap.containsKey(con.AccountId)){
                                   accountIdToContactMap.put(con.AccountId,new List<Contact>());
                               }
                               accountIdToContactMap.get(con.AccountId).add(con);
                           }
        for(Id accountId : accountIdToContactMap.keySet()){
            String allContacts = '';
            if(accountIdToContactMap.get(accountId).size() > 0){
                for(Contact con : accountIdToContactMap.get(accountId)){
                allContacts += con.Name + ' ; ';
               }
               System.debug('total number of contacts are ' +  accountIdToContactMap.get(accountId).size() +
                            'all the contacts for account id ' + accountId + ' is ' + allContacts);
            }else{
                System.debug('For Account Id ' + accountId + 'contacts are 0');
            }
        }
    }
    
    public void createMapUsingParentwithMoreThen200Child(){
         Map<Id,List<Contact>> accountIdToContactMap = new Map<Id,List<Contact>>();
         Set<Id> accountIdSet = new Set<Id>();
        
         for(Account acc : [SELECT Id,Name
                            FROM Account]){
                                accountIdSet.add(acc.Id);
                                accountIdToContactMap.put(acc.Id,new List<Contact>());
                            }
         for(Contact con : [SELECT Id,Name,AccountId
                            FROM Contact
                            WHERE AccountId IN :accountIdSet]){
                               /* if(!accountIdToContactMap.containsKey(con.AccountId)){
                                    accountIdToContactMap.put(con.AccountId, new List<Contact>());
                                }*/
                                accountIdToContactMap.get(con.AccountId).add(con);
                            }
        
        
        for(Id accountId : accountIdToContactMap.keySet()){
            String allContacts = '';
            if(accountIdToContactMap.get(accountId).size() > 0){
                for(Contact con : accountIdToContactMap.get(accountId)){
                    allContacts += con.Name + ' ; ';
                }
                System.debug('total number of contacts are ' +  accountIdToContactMap.get(accountId).size() +
                            'all the contacts for account id ' + accountId + ' is ' + allContacts);
            }else{
                System.debug('For Account Id ' + accountId + 'contacts are 0');
            }
        }
        
        
    }
}