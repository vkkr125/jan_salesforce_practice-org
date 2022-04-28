public class ApexScenario1OnCustomeObjects {
    
    // iterate through student and get the college
    public void solutionWithListAndSet(){
      /*  List<College__c> collegeList = new List<College__c>();
        for(Student__c student : [SELECT Id,Name,College__c
                                  FROM Student__c
                                  WHERE College__r.is_Active__c = TRUE]){
                                      
                                      College__c clg = new College__c();
                                      clg.Id = student.College__c;
                                      clg.is_Active__c = True;
                                      clg.College_Email__c = 'vkkr125@mtxb2b.com';
                                      
                                      collegeList.add(clg);
                                  }
        if(collegeList.size() > 0){
            update collegeList;
            for(College__c clg : collegeList){
                System.debug('Update college id is ' + clg.Id);
            }
        }*/ 
        // above code will give error for duplciate DML operattions
        
        List<College__c> collegeUpdateList = new List<College__c>();
        Set<Id> collegeIdSet = new Set<Id>();
        
        for(Student__c student : [SELECT Id,Name,College__c
                                  FROM Student__c
                                  WHERE College__c != NULL]){
                                      if(!collegeIdSet.contains(student.College__c)){
                                          College__c college = new College__c();
                                          college.Id = student.College__c;
                                          college.College_Email__c = 'vkkr125@mtxb2b.com';
                                          
                                          collegeUpdateList.add(college);
                                          collegeIdSet.add(college.Id);
                                      }
                                  }
        
        if(collegeUpdateList.size() > 0){
            update collegeUpdateList;
            for(College__c clg : collegeUpdateList){
                System.debug('Updated College Id is ' + clg.Id);
            }
        }
        
        
        
    }
    
    public void solutionUsingMap(){
        Map<Id,College__c> collegeIdToCollegeMap = new Map<Id,College__c>();
        for(Student__c student : [SELECT Id,Name,College__c
                                  FROM Student__c
                                  WHERE College__c != NULL]){
                                      if(!collegeIdToCollegeMap.containsKey(student.College__c)){
                                          College__c college = new College__c();
                                          college.Id = student.College__c;
                                          college.College_Email__c = 'vkkr125@mtxb2b.com';
                                          
                                          collegeIdToCollegeMap.put(college.Id,college);
                                      }
                                  }
        if(collegeIdToCollegeMap.size() > 0){
            update collegeIdToCollegeMap.values();
        }
    }
    
    
}