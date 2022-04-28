public with sharing class DemoGetData {
    @AuraEnabled
    public static List<Student__c> getStudents(){
        List<Student__c> studentList = new List<Student__c>();
        studentList = [SELECT Id, Name, Student_Email__c
                       FROM Student__c LIMIT 20];
        return studentList;
    }
    @AuraEnabled
    public static List<Course__c> getCourses(){
        List<Course__c> courseList = new List<Course__c>();
        courseList = [SELECT Id, Name FROM Course__c];
        return courseList;
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        return [
            SELECT Id,FirstName,LastName,Title,Phone,Email
            FROM Contact 
            LIMIT 30
        ];
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsParam(String accountId){
        Id accId = (Id)accountId;
        return [
            SELECT Id,FirstName,LastName,Title,Phone,Email,AccountId
            FROM Contact 
            WHERE AccountId =: accId
        ];
    }
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunityParam(String accountId){
        return [
            SELECT Id,Name,StageName,CloseDate,Amount,Account.Name, AccountId,Owner.Email
            FROM Opportunity 
            WHERE AccountId =: accountId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        return [
            SELECT Id, Name, Industry
            FROM Account
            LIMIT 20
        ];
    }

    @AuraEnabled(cacheable=true)
    public static string updateContacts(Object data){
        List<Contact> contactsForUpdate = (List<Contact>) JSON.deserialize(
            JSON.serialize(data),
            List<Contact>.class
       );
       try {
           update contactsForUpdate;
           return 'Success: contacts updated successfully';
       }
       catch (Exception e) {
           return 'The following exception has occurred: ' + e.getMessage();
       }
    }
}