trigger AccountTrigger on Account (before insert,after insert,before update,after update,before delete) {
    
    if(StaticConstants.tempAccountTrigger){
        if(Trigger.isBefore && Trigger.isInsert){
            AccountTriggerHandler.copyBillingToShipping(Trigger.New, Trigger.oldMap);
            AccountTriggerHandler.populateFavouriteColor(Trigger.New,Trigger.oldMap);
            // AccountTriggerHandler.populateSLAExpirationDate(Trigger.New);
        }
        if(Trigger.isAfter){
            if(StaticConstants.runAccountTrigger){
                AccountTriggerHandler.populateSLAExpirationDateAfterInsert(Trigger.New);
            }
        }
        if(Trigger.isBefore && Trigger.isUpdate){
          AccountTriggerHandler.copyBillingToShipping(Trigger.New, Trigger.oldMap);
          AccountTriggerHandler.populateFavouriteColor(Trigger.New,Trigger.oldMap);   
        }
        if(Trigger.isAfter && Trigger.isInsert){
            AccountTriggerHandler.createDefaultOpportunity(Trigger.New);
        }
        if(Trigger.isBefore && Trigger.isDelete){
            AccountTriggerHandler.restrictAccountFromDeletion(Trigger.old, Trigger.oldMap);
        }
    }
    
}