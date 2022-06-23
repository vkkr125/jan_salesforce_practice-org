public with sharing class lwcwrapper {


    public static String getData(String accountId){
        List<Contact> contactList = new List<Contact>();
        List<Opportunity> oppotunityList = new List<Opportunity>();
        contactList = [
                SELECT Id,FirstName, LastName, Email, Phone, AccountId
                FROM Contact 
                WHERE AccountId =: accountId
            ];
        oppotunityList = [
            SELECT Id, Name, StageName, Amount, Owner.Email, Account.Name, AccountId
            FROM Opportunity 
            WHERE AccountId =: accountId
        ];

        List<ContactWrapper> contactWrapperList = new List<ContactWrapper>();
        List<OpportunityWrapper> oppotunityWrapperList = new List<OpportunityWrapper>();
        for(Contact con : contactList){
            contactWrapperList.add(new ContactWrapper(con));
        }
        for(Opportunity opp : oppotunityList){
            oppotunityWrapperList.add(new OpportunityWrapper(opp));
        }
        JSONWRapper wrapper = new JSONWRapper(contactWrapperList, oppotunityWrapperList);
        return JSON.serialize(wrapper);      
    }
    class JSONWRapper{
        Boolean isEditable;
        List<ContactWrapper> contactWrapperList;
        List<OpportunityWrapper> opportunityWrapperList;
        public JSONWrapper(List<ContactWrapper> contWrapList, List<OpportunityWrapper> oppWrapList){
            this.isEditable = false;
            this.contactWrapperList = contWrapList;
            this.opportunityWrapperList = oppWrapList;
        }
    }
    class ContactWrapper{
        Boolean isEditable;
        Contact contactObj;
        public ContactWrapper(){
            this.isEditable = false;
            this.contactObj = new Contact();
        }
        public ContactWrapper(Contact con){
            this.isEditable = false;
            this.contactObj = con;
        }
    }
    class OpportunityWrapper{
        Boolean isEditable;
        Opportunity opportunityObj;
        public OpportunityWrapper(){
            this.isEditable = false;
            this.opportunityObj = new Opportunity();
        }
        public OpportunityWrapper(Opportunity opp){
            this.isEditable = false;
            this.opportunityObj = opp;
        }

    }
}
