trigger MarksTrigger on Marks__c (before insert,before update) {
    if(Trigger.isBefore && Trigger.isInsert){
        MarksTriggerHandler.checkDuplicateSubject(Trigger.New,Trigger.oldMap);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        MarksTriggerHandler.checkDuplicateSubject(Trigger.New,Trigger.oldMap);
    }
    
}