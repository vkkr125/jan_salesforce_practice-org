trigger UserTrigger on User (before update) {
    UserTriggerHandler.updateAccountFavColor(Trigger.New,Trigger.oldMap);
}