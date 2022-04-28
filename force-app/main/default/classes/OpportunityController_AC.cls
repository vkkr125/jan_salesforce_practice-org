public with sharing class OpportunityController_AC {
    @AuraEnabled
    public static List<Opportunity> getOpportunities(){
        return [SELECT Id, Name,StageName,CloseDate,Amount
                FROM Opportunity
                WHERE Amount!= Null];
    }
    @AuraEnabled
    public static List<Opportunity> getByName(String searchKey) {
        string name = '%' + searchKey + '%';
        return [SELECT id, Name,StageName, CloseDate,Amount
                FROM Opportunity
                WHERE name
                LIKE :name and Amount!= Null];

    }
    
}