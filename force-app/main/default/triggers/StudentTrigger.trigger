trigger StudentTrigger on Student__c (after insert,after update,after delete,after undelete) {
    StudentTriggerHandler.updateCount(Trigger.New,Trigger.oldMap);
}