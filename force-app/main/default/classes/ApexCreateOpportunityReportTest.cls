@isTest
public class ApexCreateOpportunityReportTest {
    
    public static testmethod void testOpportunityReport(){
        Id prepaidRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Prepaid').getRecordTypeId();
        List<opportunity> oppList = new List<Opportunity>();
        
        for(Integer i = 1; i<=30; i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Default-Test Opportunity ' + i;
            opp.StageName = 'Closed Won';
            opp.Amount = 1000;
            opp.RecordTypeId = prepaidRecordTypeId;
            
            if(i <= 15){
                opp.Type = 'New Customer';
                opp.CloseDate = Date.today();
            }else{
                opp.Type = 'Existing Customer-Upgrade';
                opp.CloseDate = Date.today().addDays(20);
                System.debug(opp.CloseDate);
            }
            oppList.add(opp);
        }
        insert oppList;
        
        ApexCreateOpportunityReport obj = new ApexCreateOpportunityReport('Closed Won');
        System.debug(obj.monthTypeToAmountMap);
        System.debug(obj.monthTypeToCountMap);
        
        String key = 'Mar-2022-New Customer-' + UserInfo.getUserId();
        System.assert(obj.monthTypeToAmountMap.containsKey(key));
        System.assertEquals(15000, obj.monthTypeToAmountMap.get(key));
        System.assertEquals(15, obj.monthTypeToCountMap.get(key));
        
        key = 'Apr-2022-Existing Customer-Upgrade-' + UserInfo.getUserId();
        System.assert(obj.monthTypeToAmountMap.containsKey(key));
        System.assertEquals(15000, obj.monthTypeToAmountMap.get(key));
        System.assertEquals(15, obj.monthTypeToCountMap.get(key));
    }
}