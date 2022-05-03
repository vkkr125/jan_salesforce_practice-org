// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents


// Set<Id> accountIdSet = new Set<Id>();
// for(Account acc : [SELECT Id, Name FROM Account])
//     accountIdSet.add(acc.Id);

// Map<Id, List<Opportunity>> accountIdToOpportunityMapList = AssignmentOnAccountObject.returnsAllOpprotunityOfAccountIds(accountIdSet);
// for(Id accountId : accountIdToOpportunityMapList.keySet()){
//     String res = accountId + ':->';
//     for(Opportunity opp : accountIdToOpportunityMapList.get(accountId)){
//         res += opp.Name + '*';
//     }
//     System.debug(res);
// }


ApexRevision.ApexCreateOpportunityReport('Closed Won');
