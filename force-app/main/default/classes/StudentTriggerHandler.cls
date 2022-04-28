public class StudentTriggerHandler {
    
    public static void updateCountQueryOnStudentUsingAggrigateQuery(List<Student__c> newList, Map<Id,Student__c> oldMap){
        Set<Id> collegeIdSet = new Set<Id>();
        if(newList != NULL){
            for(Student__c student : newList){
                if(oldMap == NULL || student.college__c != oldMap.get(student.Id).college__c){
                    if(student.College__c != NULL){
                        collegeIdSet.add(student.College__c);
                    }
                    if(oldMap != NULL &&  oldMap.get(student.Id).college__c != NULL){
                        collegeIdSet.add(oldMap.get(student.Id).college__c);
                    }
                }
            }  
        }else{
            for(Student__c student : oldMap.values()){
                if(student.College__c != NULL){
                    collegeIdSet.add(student.College__c);
                }
            }
        }
        List<College__c> collegeUpdateList = new List<College__c>();
        Map<Id,Integer> collegeIdToStudentCountMap = new Map<Id,Integer>();
        for(Id collegeId : collegeIdSet){
            collegeIdToStudentCountMap.put(collegeId,0);
        }
        
        for(AggregateResult ar : [SELECT College__c, COUNT(ID) cnt,AVG(Age__c)
                                  FROM Student__c
                                  WHERE College__c IN : collegeIdSet
                                  GROUP BY College__c]){
                                      collegeIdToStudentCountMap.put((Id)ar.get('College__c'), (Integer)ar.get('cnt'));
                                  }
        
        
        for(Id collegeId : collegeIdToStudentCountMap.keySet()){
            College__c college = new College__c();
            college.Id = collegeId;
            college.Student_Count__c = collegeIdToStudentCountMap.get(collegeId);
            
            collegeUpdateList.add(college);
        }         
        if(collegeUpdateList.size() > 0){
            update collegeUpdateList;
        }
    }
    public static void updateCount(List<Student__c> newList,Map<Id,Student__c> oldMap){
        // get all colleges which are getting impected
        Set<Id> collegeIdSet = new Set<Id>();
        if(newList != NULL){
            for(Student__c student : newList){
                if(oldMap == NULL || student.college__c != oldMap.get(student.Id).college__c){
                    if(student.College__c != NULL){
                        collegeIdSet.add(student.College__c);
                    }
                    if(oldMap != NULL &&  oldMap.get(student.Id).college__c != NULL){
                        collegeIdSet.add(oldMap.get(student.Id).college__c);
                    }
                }
            }  
        }else{
            for(Student__c student : oldMap.values()){
                if(student.College__c != NULL){
                    collegeIdSet.add(student.College__c);
                }
            }
        }
                // first approach
                /* List<College__c> collegeUpdateList = new List<College__c>();
        for(College__c college : [SELECT Id,Name,Student_Count__c,
        (SELECT Id,Name FROM Students__r)
        FROM College__c
        WHERE Id IN : collegeIdSet]){
        college.Student_Count__c = college.Students__r.size();
        collegeUpdateList.add(college);
        } */
        
        // second approach 
        if(collegeIdSet.size() == 0) return;
        List<College__c> collegeUpdateList = new List<College__c>();
        Map<Id,Integer> collegeIdToStudentCountMap = new Map<Id,Integer>();
        for(College__c college : [SELECT Id,Name,Student_Count__c,
                                  (SELECT Id FROM Students__r)
                                  FROM College__c 
                                  WHERE Id IN : collegeIdSet]){
                                      collegeIdToStudentCountMap.put(college.Id,college.Students__r.size());
                                      
                                  }
        
        for(Id collegeId : collegeIdToStudentCountMap.keySet()){
            College__c college = new College__c();
            college.Id = collegeId;
            college.Student_Count__c = collegeIdToStudentCountMap.get(collegeId);
            
            collegeUpdateList.add(college);
        }         
        if(collegeUpdateList.size() > 0){
            update collegeUpdateList;
        }
    }
    
    
    public static void updateCountQueryOnStudent(List<Student__c> newList,Map<Id,Student__c> oldMap){
        // get all colleges which are getting impected
        Set<Id> collegeIdSet = new Set<Id>();
        if(newList != NULL){
            for(Student__c student : newList){
                if(oldMap == NULL || student.college__c != oldMap.get(student.Id).college__c){
                    if(student.College__c != NULL){
                        collegeIdSet.add(student.College__c);
                    }
                    if(oldMap != NULL &&  oldMap.get(student.Id).college__c != NULL){
                        collegeIdSet.add(oldMap.get(student.Id).college__c);
                    }
                }
            }  
        }else{
            for(Student__c student : oldMap.values()){
                if(student.College__c != NULL){
                    collegeIdSet.add(student.College__c);
                }
            }
        }
        
        List<College__c> collegeUpdateList = new List<College__c>();
        Map<Id,Integer> collegeIdToStudentCountMap = new Map<Id,Integer>();
        for(Id collegeId : collegeIdSet){
            collegeIdToStudentCountMap.put(collegeId,0);
        }
        for(Student__c student : [SELECT Id,College__c
                                  FROM Student__c
                                  WHERE College__c IN : collegeIdSet]){
                                      
                                      /* if(!collegeIdToStudentCountMap.containsKey(student.College__c)){
                                               collegeIdToStudentCountMap.put(student.College__c, 0);
                                           }*/
                                      Integer currentStudents = collegeIdToStudentCountMap.get(student.College__c);
                                      currentStudents += 1;
                                      collegeIdToStudentCountMap.put(student.College__c, currentStudents);
                                  }
        
        
        for(Id collegeId : collegeIdToStudentCountMap.keySet()){
            College__c college = new College__c();
            college.Id = collegeId;
            college.Student_Count__c = collegeIdToStudentCountMap.get(collegeId);
            
            collegeUpdateList.add(college);
        }         
        if(collegeUpdateList.size() > 0){
            update collegeUpdateList;
        }
        
    }
    
    
}