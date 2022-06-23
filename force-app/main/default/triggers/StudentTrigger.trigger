trigger StudentTrigger on Student__c (before insert,before update,after insert,after update,after delete,after undelete) {
    if(Trigger.isAfter){
        StudentTriggerHandler.updateCount(Trigger.New,Trigger.oldMap);
        if(Trigger.isInsert || Trigger.isUndelete){
            StudentTriggerHandler.maxStudentInCollege(Trigger.New);
        }
    }
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            StudentTriggerHandler.uniqueStudentInCollege(Trigger.new,Trigger.oldMap);
        }
        if(Trigger.isUpdate){
            StudentTriggerHandler.uniqueStudentInCollege(Trigger.new,Trigger.oldMap);
        }
    }
}