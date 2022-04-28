public with sharing class DemoWrapper {

    @AuraEnabled
    public static List<String> getPickListValuesIntoList(){
         List<String> pickListValuesList= new List<String>();
         Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry pickListVal : ple){
             pickListValuesList.add(pickListVal.getLabel());
         }     
         return pickListValuesList;
     }

    @AuraEnabled
    public static String saveSingleOpportunity(String json_string){
        OpportunityWrapper wrapper = new OpportunityWrapper();
        wrapper = (OpportunityWrapper) JSON.deserialize(json_string, OpportunityWrapper.class);
        upsert wrapper.opportunityObj;
        return wrapper.opportunityObj.Id;
    }
    @AuraEnabled
    public static String saveSingleContact(String json_string){
        ContactWrapper wrapper = new ContactWrapper();
        wrapper = (ContactWrapper) JSON.deserialize(json_string,ContactWrapper.class);
        upsert wrapper.contactObj;
        return wrapper.contactObj.Id;
    }
    @AuraEnabled
    public static List<Account> getAccounts(){
       List<Account> accountList = new List<Account>();
       accountList = [SELECT Id, Name, Active__c FROM Account LIMIT 100];
       return accountList;
    }
    @AuraEnabled
    public static void saveData(String jsonString){
        JSONwrapper wrapper = new JSONwrapper();
        wrapper = (JSONwrapper) JSON.deserialize(jsonString, JSONwrapper.class);
        List<ContactWrapper> wrapper_contact_list = new List<ContactWrapper>();
        List<OpportunityWrapper> wrapper_opportunity_list = new List<OpportunityWrapper>();

        wrapper_contact_list = wrapper.wrapper_contactList;
        wrapper_opportunity_list = wrapper.wrapper_opportunityList;
        List<Contact> contact_list = new List<Contact>();
        List<Opportunity> opportunity_list = new List<Opportunity>();

        for(ContactWrapper record : wrapper_contact_list)
            contact_list.add(record.contactObj);
        for(OpportunityWrapper record : wrapper_opportunity_list)
            opportunity_list.add(record.opportunityObj);

        if(contact_list.size() > 0)
            upsert contact_list;
        if(opportunity_list.size() > 0)
            upsert opportunity_list;

    }

    @AuraEnabled
    public static String getdata(String accountId){
        List<Contact> contactList = new List<Contact>();
        List<Opportunity> opportunityList = new List<Opportunity>();
        contactList = [SELECT Id, FirstName, LastName, Phone,Email,AccountId
                      FROM Contact
                      WHERE AccountId =: accountId];
        opportunityList = [SELECT Id, Name, StageName,Amount,CloseDate, Owner.Email,Account.Name,AccountId
                           FROM Opportunity
                           WHERE AccountId =: accountId];
        
        JSONwrapper wrapper = new JSONwrapper();
        List<ContactWrapper> contactWrapperList = new List<contactWrapper>();
        List<OpportunityWrapper> opportunityWrapperList = new List<OpportunityWrapper>();

        for(Contact con : contactList)
            contactWrapperList.add(new ContactWrapper(con));
        for(Opportunity opp : opportunityList)
            opportunityWrapperList.add(new OpportunityWrapper(opp));
        if(contactWrapperList.size() > 0)
            wrapper.wrapper_contactList = contactWrapperList;
        if(opportunityWrapperList.size() > 0)
            wrapper.wrapper_opportunityList = opportunityWrapperList;
        
        return JSON.serialize(wrapper);
    }
    public class JSONwrapper{
        public Boolean isEditable;
        public List<ContactWrapper> wrapper_contactList;
        public List<OpportunityWrapper> wrapper_opportunityList;
        public JSONwrapper(){
            isEditable = false;
            wrapper_contactList = new List<contactWrapper>();
            wrapper_opportunityList = new List<OpportunityWrapper>();
        }
    }
    public class ContactWrapper{
        public Boolean isEditable;
        public Contact contactObj;
        public ContactWrapper(){
            isEditable = false;
            contactObj = new Contact();
        }
        public ContactWrapper(Contact con){
            isEditable = false;
            contactObj = con;
        }
    }
    public class OpportunityWrapper{
        public Boolean isEditable;
        public Opportunity opportunityObj;
        public OpportunityWrapper(){
            isEditable = false;
            opportunityObj = new Opportunity();
        }
        public OpportunityWrapper(Opportunity opp){
            isEditable = false;
            opportunityObj = opp;
        }
    }
}