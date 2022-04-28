trigger ContactTrigger on Contact (before insert,before update) {
    ContactTriggerHandler.preventDuplicateContact(Trigger.New,Trigger.oldMap);
}