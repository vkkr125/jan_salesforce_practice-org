public class ApexCreateOpportunityReport {
    
    
    public Map<String,Integer> monthTypeToAmountMap;
    public Map<String,Integer> monthTypeToCountMap;
    
    public ApexCreateOpportunityReport(String stage){
        List<String> monthList = new List<String>{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
        monthTypeToAmountMap = new Map<String,Integer>();
        monthTypeToCountMap = new Map<String,Integer>();
        
        for(Opportunity opp : [SELECT Id, Name, Type, OwnerId, CloseDate, Amount
                               FROM Opportunity
                               WHERE Type != NULL
                               AND StageName =: stage
                               AND Amount > 0]){
                                   Integer month = opp.CloseDate.month();
                                   Integer year = opp.CloseDate.year();
                                   
                                   String key = monthList.get(month - 1) + '-' + year + '-' + opp.Type + '-' + opp.OwnerId;
                                   if(!monthTypeToAmountMap.containsKey(key)){
                                       monthTypeToAmountMap.put(key, 0);
                                       monthTypeToCountMap.put(key, 0);
                                   }
                                   Integer current_amount = monthTypeToAmountMap.get(key);
                                   current_amount += (Integer)opp.Amount;
                                   monthTypeToAmountMap.put(key, current_amount);
                                   
                                   Integer current_count = monthTypeToCountMap.get(key);
                                   current_count += 1;
                                   monthTypeToCountMap.put(key, current_count);  
                               }
        
        for(String key : monthTypeToAmountMap.keySet()){
            System.debug(key + '%%%%%%' + monthTypeToAmountMap.get(key) + '%%%%%%%%' + monthTypeToCountMap.get(key));
        }
    }
    
    public void utility(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = College__c.State__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            //pickListValuesList.add(pickListVal.getLabel());
            System.debug('>>>'+pickListVal.getLabel());
        }  
        
        // get record type
        Id recordTypeId = Schema.SObjectType.Student__c.getRecordTypeInfosByName().get('Graduation').getRecordTypeId();
        System.debug('Record Type id is '+recordTypeId);
    }
}