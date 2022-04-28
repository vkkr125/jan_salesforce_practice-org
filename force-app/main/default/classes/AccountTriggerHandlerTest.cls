@isTest
public class AccountTriggerHandlerTest {
    
    
    public static testmethod void testcopyBillingToShippingOnCreate(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Copy_Billing_To_Shipping__c = true;
        acc.BillingCity = 'Ajmer';
        acc.BillingCountry = 'India';
        acc.BillingState = 'Rajasthan';
        acc.BillingPostalCode = '305002';
        acc.BillingStreet = 'Parbatpura Bypass Road';
        
        insert acc;
        
        List<Account> accList = [SELECT Id, Name, ShippingCity, ShippingCountry, ShippingStreet,
                                 ShippingState, ShippingPostalCode
                                 FROM Account
                                 WHERE Id =: acc.Id];
        
        System.assertEquals(acc.BillingCity, accList.get(0).ShippingCity);
        System.assertEquals(acc.BillingCountry, accList.get(0).ShippingCountry);
        System.assertEquals(acc.BillingState, accList.get(0).ShippingState);
        System.assertEquals(acc.BillingStreet, accList.get(0).ShippingStreet);
        System.assertEquals(acc.BillingPostalCode, accList.get(0).ShippingPostalCode);
        
    }
    
    public static testmethod void testcopyBillingToShippingOnUpdate(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Copy_Billing_To_Shipping__c = true;
        acc.BillingCity = 'Ajmer';
        acc.BillingCountry = 'India';
        acc.BillingState = 'Rajasthan';
        acc.BillingPostalCode = '305002';
        acc.BillingStreet = 'Parbatpura Bypass Road';
        
        insert acc;
        
        acc.BillingCity = 'Jaipur';
        update acc;
        List<Account> accList = [SELECT Id, Name, ShippingCity, ShippingCountry, ShippingStreet,
                                 ShippingState, ShippingPostalCode
                                 FROM Account
                                 WHERE Id =: acc.Id];
        
        System.assertEquals(acc.BillingCity, accList.get(0).ShippingCity);
        System.assertEquals(acc.BillingCountry, accList.get(0).ShippingCountry);
        System.assertEquals(acc.BillingState, accList.get(0).ShippingState);
        System.assertEquals(acc.BillingStreet, accList.get(0).ShippingStreet);
        System.assertEquals(acc.BillingPostalCode, accList.get(0).ShippingPostalCode);
        
    }
}