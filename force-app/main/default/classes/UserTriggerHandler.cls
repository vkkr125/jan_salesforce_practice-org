public class UserTriggerHandler {
    public static void updateAccountFavColor(List<User> newList,Map<Id,User> oldMap){
        Map<Id,String> userIdToFavColorMap = new Map<Id,String>();
        for(User usr : newList){
            if(usr.Favourite_Color__c != oldMap.get(usr.Id).Favourite_Color__c){
              userIdToFavColorMap.put(usr.Id,usr.Favourite_Color__c);
            }
        }
        
        if(userIdToFavColorMap.keySet().size() == 0) return;
        List<Account> accountList = new List<Account>();
        for(Account acc : [SELECT Id,OwnerId,Favourite_Color__c
                           FROM Account
                           WHERE OwnerId IN :userIdToFavColorMap.keySet()]){
                               
                               acc.Favourite_Color__c = userIdToFavColorMap.get(acc.OwnerId);
                               accountList.add(acc);
                           }
        System.debug(userIdToFavColorMap.keySet());
        if(accountList.size() > 0){
            update accountList;
        }
        System.debug('&&&&& check');
    }
}