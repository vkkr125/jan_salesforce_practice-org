public class AccountTriggerHandler {
    
    
    public static void copyBillingToShipping(List<Account> newList, Map<Id,Account> oldMap){ 
        Boolean isBillingChanged, isShippingChanged;
        for(Account acc : newList){
            isBillingChanged = false;
            isShippingChanged = false;
            
            if(oldMap != NULL){
                isBillingChanged = (acc.BillingCity != oldMap.get(acc.Id).BillingCity
                                    || acc.BillingCountry != oldMap.get(acc.Id).BillingCountry
                                    || acc.BillingState != oldMap.get(acc.Id).BillingState
                                    || acc.BillingPostalCode != oldMap.get(acc.Id).BillingPostalCode
                                    || acc.BillingStreet != oldMap.get(acc.Id).BillingStreet);
                
                isShippingChanged =  (acc.ShippingCity != oldMap.get(acc.Id).ShippingCity
                                      || acc.ShippingCountry != oldMap.get(acc.Id).ShippingCountry
                                      || acc.ShippingState != oldMap.get(acc.Id).ShippingState
                                      || acc.ShippingPostalCode != oldMap.get(acc.Id).ShippingPostalCode
                                      || acc.ShippingStreet != oldMap.get(acc.Id).ShippingStreet);
            }
            if(oldMap == NULL || acc.Copy_Billing_To_Shipping__c != oldMap.get(acc.Id).Copy_Billing_To_Shipping__c
               || isBillingChanged 
               || isShippingChanged){
                   if(acc.Copy_Billing_To_Shipping__c){
                       if(isShippingChanged){
                           acc.addError('You Are Not Allowed To Change Shipping Address');
                       }else{
                           acc.ShippingCity = acc.BillingCity;
                           acc.ShippingCountry = acc.BillingCountry;
                           acc.ShippingPostalCode = acc.BillingPostalCode;
                           acc.ShippingState = acc.BillingState;
                           acc.ShippingStreet = acc.BillingStreet;
                       }
                   }
               }
        }
        
        
    }
    // trigger question 2
    public static void restrictAccountFromDeletion(List<Account> oldList,Map<Id,Account> oldMap){
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc : oldList)
            accountIdSet.add(acc.Id);
        Map<Id,Integer> accountIdToTotalContacts = new Map<Id,Integer>();
        for(Contact con : [SELECT Id, AccountId
                           FROM Contact
                           WHERE AccountId IN: accountIdSet]){
                               if(!accountIdToTotalContacts.containsKey(con.AccountId)){
                                   accountIdToTotalContacts.put(con.AccountId, 0);
                               }
                               Integer currentCount = accountIdToTotalContacts.get(con.AccountId);
                               currentCount += 1;
                               accountIdToTotalContacts.put(con.AccountId, currentCount);
                           }
        
       /* System.debug('System is running ');
        for(Account acc : oldList){
            System.debug('hello && ' + acc.Id);
        }*/
        
        for(Account acc : oldList){
            if(accountIdToTotalContacts.get(acc.Id) > 0){
                acc.addError('The Account can not be deleted caz it has ' +  accountIdToTotalContacts.get(acc.Id) + ' contacts associated with it');
            }
        } 
        
    }
    
    
    public static void populateFavouriteColor(List<Account> newList,Map<Id,Account> oldMap){
        Set<Id> userIdSet = new Set<Id>();
        for(Account acc : newList){
            if(oldMap == NULL || acc.OwnerId != oldMap.get(acc.Id).OwnerId){
              userIdSet.add(acc.OwnerId);   
            }
        }
        
        if(userIdSet.size() == 0) return;
        Map<Id,String> userIdToFavouriteColor = new Map<Id,String>();
        for(User usr : [SELECT Id,Favourite_Color__c
                        FROM User 
                        WHERE Id IN : userIdSet
                        AND Favourite_Color__c != NULL]){
                            userIdToFavouriteColor.put(usr.Id, usr.Favourite_Color__c);
                        }
        
        for(Account acc : newList){
            acc.Favourite_Color__c = userIdToFavouriteColor.get(acc.OwnerId);
        }
        System.debug('@@@@@@@@');
    }
    public static void populateSLAExpirationDate(List<Account> newList){
        for(Account acc : newList){
            acc.SLAExpirationDate__c = Date.today().addDays(180);
            acc.Active__c = 'Yes';
          
        }
    }
    
    public static void createDefaultOpportunity(List<Account> newList){
        List<Opportunity> opportunitList = new List<Opportunity>();
        Id prepaidRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Prepaid').getRecordTypeId();
        for(Account acc : newList){
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = acc.Name + '- Default Opportunity';
            opp.RecordTypeId = prepaidRecordTypeId;
            opp.CloseDate = Date.today().addDays(180);
            opp.StageName = 'Prospecting';
            
            opportunitList.add(opp);
        }
        if(opportunitList.size() > 0){
            insert opportunitList;
        }
    } 
    
    public static void populateSLAExpirationDateAfterInsert(List<Account> newList){
        List<Account> updateAccountList = new List<Account>();
        for(Account acc : newList){
            Account temp = new Account();
            temp.Id = acc.Id;
            temp.SLAExpirationDate__c = Date.today().addDays(180);
            temp.Active__c = 'Yes';
            
            updateAccountList.add(temp);
        }
        if(updateAccountList.size() > 0){
            StaticConstants.runAccountTrigger = false;
            update updateAccountList;
        }
    }
    
    public static Account solve(Account acc){
        if(acc.ParentId == NULL) return acc;
        Account acc2 = [SELECT Id,ParentId FROM Account WHERE Id =: acc.ParentId][0];
        
        return solve(acc2);
    }
}