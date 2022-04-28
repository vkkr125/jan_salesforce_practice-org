public class ApexCopyBillingToShipping {
    
    // in account object copy billing address to shipping address
    public void copyBillingToShipping(Set<Id> accountIdSet){
        List<Account> accountUpdateList = new List<Account>();
        for(Account acc : [SELECT Id,Name,BillingStreet, BillingCity,BillingState,
                           BillingPostalCode, BillingCountry
                           FROM Account
                           WHERE BillingStreet != NULL]){
                               acc.ShippingStreet = acc.BillingStreet;
                               acc.ShippingCity = acc.BillingCity;
                               acc.ShippingState = acc.BillingState;
                               acc.ShippingCountry = acc.BillingCountry;
                               acc.ShippingPostalCode = acc.BillingPostalCode;
                               
                               accountUpdateList.add(acc);
                           }
        if(accountUpdateList.size() > 0){
            update accountUpdateList;
        }
    }
    
    
}