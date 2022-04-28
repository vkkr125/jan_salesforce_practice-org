trigger OpportunityTrigger on Opportunity (before insert,before update, after update) {
    
    // if we try to access parent record from the Trigger.New in any case after or before it will return null
   /* for(Opportunity opp : Trigger.New){
        System.debug('>>> 1' + opp.Name); // name
        System.debug('>>> 2' + opp.AccountId); // accountId;
        System.debug('>>> 3' + opp.Account.Id); // Null
        System.debug('>>> 4' + opp.Account.Name); // Null
        System.debug('>>> 5' + opp.RecordTypeId); // recordTypeId
        System.debug('>>> 6' + opp.RecordType.Name); // Null 
    }*/
    
   if(Trigger.isBefore && Trigger.isInsert){
        OpportunityTriggerHandler.closeAllRelatedOpportunityClosedBySystemAdmin(Trigger.New, Trigger.oldMap);
        OpportunityTriggerHandler.changeStageOfOpportunity(Trigger.New, Trigger.oldMap);
    }
    
   if(Trigger.isBefore && Trigger.isUpdate){
        OpportunityTriggerHandler.changeStageOfOpportunity(Trigger.New, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        if(StaticConstants.handleOpportunityUpdate){
            OpportunityTriggerHandler.closeAllRelatedOpportunityClosedBySystemAdmin(Trigger.new, Trigger.oldMap);
        }
    }
    
    
}