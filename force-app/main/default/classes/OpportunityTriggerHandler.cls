public class OpportunityTriggerHandler {
    
    // Trigger Question 1
    public static void changeStageOfOpportunity(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        for(Opportunity opp : newList){
            if(oldMap == NULL || oldMap.get(opp.Id).StageName != opp.StageName){
                if(opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost'){
                    opp.CloseDate = Date.today();
                }
            }
        }
    }
    
    
    // Trigger question 4
    public static void closeAllRelatedOpportunityClosedBySystemAdmin(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        
        Set<Id> accountIdSet = new Set<Id>();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        for(Opportunity opp : newList){
            if(oldMap == NULL || opp.StageName != oldMap.get(opp.Id).StageName){
                if(opp.StageName == 'Closed Won' && profileName == 'System Administrator'){
                    accountIdSet.add(opp.AccountId);
                }
            }
        }
        
        
        //a-> (o1,o2, o3 , )
        Map<Id,Set<Id>> accountIdToOpportunityIdSetMap = new Map<Id, Set<Id>>();
        for(Opportunity opp : [SELECT Id, AccountId
                               FROM Opportunity
                               WHERE AccountId IN: accountIdSet]){
                                   if(!accountIdToOpportunityIdSetMap.containsKey(opp.AccountId)){
                                       accountIdToOpportunityIdSetMap.put(opp.AccountId, new Set<Id>());
                                   }
                                   accountIdToOpportunityIdSetMap.get(opp.AccountId).add(opp.Id);
                               }
        
        List<Opportunity> opportunityUpdateList = new List<Opportunity>();
        for(Id accountId : accountIdToOpportunityIdSetMap.keySet()){
            for(Id opportunityId : accountIdToOpportunityIdSetMap.get(accountId)){
                Opportunity opp = new Opportunity();
                opp.Id = opportunityId;
                opp.AccountId = accountId;
                opp.StageName = 'Closed Won';
                
                opportunityUpdateList.add(opp);
            }
        }
        if(opportunityUpdateList.size() > 0){
            StaticConstants.handleOpportunityUpdate = false;
            update opportunityUpdateList;
        }
    }
    
    // Trigger question 5
    public static void closeAllProductRelatedToOpportunity(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
        
        Set<Id> opportunityIdSet = new Set<Id>();
        for(Opportunity opp : newList){
            if(oldMap == NULL || opp.Custome_Status__c != oldMap.get(opp.Id).Custome_Status__c){
                if(opp.Custome_Status__c == 'Reset'){
                    opportunityIdSet.add(opp.Id);
                }
            }
        }
        List<OpportunityLineItem> opportunityLineItemDeleteList = new List<OpportunityLineItem>();
        for(OpportunityLineItem oppLine : [SELECT Id, OpportunityId
                                           FROM OpportunityLineItem
                                           WHERE OpportunityId IN: opportunityIdSet]){
                                              opportunityLineItemDeleteList.add(oppLine); 
                                           }
        
        if(opportunityLineItemDeleteList.size() > 0){
            delete opportunityLineItemDeleteList;
        }
    }
    
    // Trigger question 6
    
    
}