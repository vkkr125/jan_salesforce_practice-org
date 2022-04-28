public class AssignmentOnAccountObject {
    
    // question 1
    public static List<String> returnsAllCaseNumbersOfAccountIds(Set<Id> accountIdSet){
        
        List<String> caseNumbers = new List<String>();
        for(Case cs : [SELECT Id,CaseNumber, AccountId
                       FROM Case
                       WHERE AccountId IN : accountIdSet]){
                           caseNumbers.add(cs.CaseNumber);
                       }
        return caseNumbers;
    }
    
    // question 2
    public static Map<Id,List<Opportunity>> returnsAllOpprotunityOfAccountIds(Set<Id> accountIdSet){
        // Map<Id, Set<Id>> accountIdToOpportunityIdSetMap = new Map<Id,Set<Id>>();
        // for(Id accountId : accountIdSet)
        //     accountIdToOpportunityIdSetMap.put(accountId, new Set<Id>());
        // for(Opportunity opp : [SELECT Id,AccountId
        //                        FROM Opportunity
        //                        WHERE AccountId IN:accountIdSet]){
        //                            /*if(!accountIdToOpportunityIdSetMap.containsKey(opp.AccountId)){
        //                                accountIdToOpportunityIdSetMap.put(opp.AccountId, new Set<Id>());
        //                            }*/
        //                            accountIdToOpportunityIdSetMap.get(opp.AccountId).add(opp.Id);
        //                        }
        // return accountIdToOpportunityIdSetMap;


        Map<Id,List<Opportunity>> accountIdToOpportunities = new Map<Id,List<Opportunity>>();
        for(Opportunity opp : [SELECT Id, Name, AccountId
                               FROM Opportunity
                               WHERE AccountId IN:accountIdSet]){
                                   if(!accountIdToOpportunities.containsKey(opp.AccountId)){
                                     accountIdToOpportunities.put(opp.AccountId, new List<Opportunity>());
                                   }
                                   accountIdToOpportunities.get(opp.AccountId).add(opp);
                               }
        return accountIdToOpportunities;
                            
    }
    // question 3
    public static Integer totalNumberOfWorkingDays(Date startDate, Date endDate){
        Integer totalDays = startDate.daysBetween(endDate);
        Integer totalWeeks = totalDays / 7;
        
        return totalDays - totalWeeks * 2; // total working days
    }
    
    // question 5
    public static List<Schema.SObjectType> showAllsObjectsOfOrg(){
        
        List<Schema.SObjectType> objectsList = new List<Schema.SObjectType>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            objectsList.add(objTyp);
        }    
        return objectsList;
    }
    
    
    public void populateContactIdOnAccount(){
        
        
        Map<Id,String> accountIdToContactsMap = new Map<Id,String>();
        for(Contact con : [SELECT Id, AccountId
                           FROM Contact
                           WHERE AccountId != NULL]){
                               if(!accountIdToContactsMap.containsKey(con.AccountId)){
                                   accountIdToContactsMap.put(con.AccountId, '');
                               }
                               String prevContacts = accountIdToContactsMap.get(con.AccountId);
                               prevContacts += String.valueOf(con.Id);
                               accountIdToContactsMap.put(con.AccountId, prevContacts);
                           }
        
        List<Account> accountUpdateList = new List<Account>();
        for(Account acc : [SELECT Id,Contact_Ids__c
                           FROM Account 
                           WHERE Id IN : accountIdToContactsMap.keySet()]){
                               acc.Contact_Ids__c = accountIdToContactsMap.get(acc.Id);
                               accountUpdateList.add(acc);
                           }
        if(accountUpdateList.size() > 0){
            update accountUpdateList;
        }
        
    }
}