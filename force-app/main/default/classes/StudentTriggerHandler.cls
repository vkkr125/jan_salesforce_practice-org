public class StudentTriggerHandler {
    // write trigger to validate students could take admission in only active colleges
   /* public static void collegeActiveValidation(List<Student__c> newList, Map<Id,Student__c> oldMap){
        Set<Id> collegeIdSet = new Set<Id>();
        for(Student__c student : newList){
            if(student.College__c != NULL){
                if(oldMap == NULL || student.College__c != oldMap.get())
            }
        }
    }*/
    
    
    // write a validation using trigger a college could have maximum 20 student
    public static void maxStudentInCollege(List<Student__c> newList){
        // will run on undelete and insert
        Set<Id> collegeIdSet = new Set<Id>();
        for(Student__c student : newList){
            if(student.College__c != NULL){
                collegeIdSet.add(student.College__c);
            }
        }
        if(collegeIdSet.size() == 0) return ;
        
        Map<Id,Integer> collegeIdToNumberOfStudentsMap = new Map<Id,Integer>();
        for(Student__c student : [SELECT Id, Name,College__c
                                  FROM Student__c
                                  WHERE College__c IN :collegeIdSet]){
                                      if(!collegeIdToNumberOfStudentsMap.containsKey(student.College__c)){
                                          collegeIdToNumberOfStudentsMap.put(student.College__c, 0);
                                      }
                                      Integer currentStudents = collegeIdToNumberOfStudentsMap.get(student.College__c);
                                      currentStudents += 1;
                                      collegeIdToNumberOfStudentsMap.put(student.College__c, currentStudents);
                                  }
        for(Student__c student : newList){
            if(collegeIdToNumberOfStudentsMap.get(student.College__c) > 20){
                student.addError('A College Can Not Have More Then 20 Students');
            }
        }   
    }
    // write a trigger to such that duplicate student can't be in a college 
    public static void uniqueStudentInCollege(List<Student__c> newList,Map<Id,Student__c> oldMap){
        // check the uniqueness based on collegeId, studentName, Email
        Set<String> studentNames = new Set<String>();
        Set<String> studentEmails = new Set<String>();
        Set<Id> collegeIds = new Set<Id>();
        for(Student__c student : newList){
            if(student.College__c != NULL){
                if(oldMap == NULL 
                   || student.College__c != oldMap.get(student.Id).College__c
                   || student.Name != oldMap.get(student.Id).Name
                   || student.Student_Email__c != oldMap.get(student.Id).Student_Email__c){
                        studentNames.add(student.Name);
                        studentEmails.add(student.Student_Email__c);
                        collegeIds.add(student.College__c);
                   }
            }
        }
        if(collegeIds.size() == 0) return;
        Set<String> uniqueueStudents = new Set<String>();
        System.debug('total student ' + uniqueueStudents);
        for(Student__c student : [SELECT Id, Name, College__c, Student_Email__c
                                  FROM Student__c
                                  WHERE College__c IN :collegeIds
                                  AND Name IN :studentNames
                                  AND Student_Email__c IN:studentEmails]){
                                   uniqueueStudents.add(student.College__c + '*' + student.Name + '*' + student.Student_Email__c);
                               }
        for(Student__c student : newList){
            String key = student.College__c + '*' + student.Name + '*' + student.Student_Email__c;
            if(uniqueueStudents.contains(key)){
                student.addError('Duplicate Student In this College');
            }else{
                uniqueueStudents.add(key);
            }
        }
    }
    
    
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