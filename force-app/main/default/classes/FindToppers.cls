public with sharing class FindToppers {
    
    @AuraEnabled
    public static Map<Id,List<String>> getToppers(){

        Set<Id> collegeIdSet = new Set<Id>();
        for(College__c clg : [SELECT Id, Name,Student_Count__c 
                             FROM College__c
                             WHERE Student_Count__c > 0]){
                                 collegeIdSet.add(clg.Id);
                             }
        Map<Id, Double> collegeIdToMaxMarksMap = new Map<Id,Double>();
        Map<Id,String> collegeIdToTopperName = new Map<Id,String>();
        for(Student__c student : [SELECT Id, Name, College__c,College__r.Name, Total_Marks__c
                                  FROM  Student__c 
                                  WHERE College__c IN : collegeIdSet]){
                                      if(!collegeIdToMaxMarksMap.containsKey(student.College__c)){
                                        collegeIdToMaxMarksMap.put(student.College__c,0);
                                        collegeIdToTopperName.put(student.College__c, student.Name);
                                      }
                                      Double currentMarks = collegeIdToMaxMarksMap.get(student.College__c);
                                      if(currentMarks < student.Total_Marks__c){
                
                                          collegeIdToMaxMarksMap.put(student.College__c, student.Total_Marks__c);
                                          collegeIdToTopperName.put(student.College__c, student.Name);
                                      }
                                  }
            Map<Id,String> collegeIdToCollegeNameMap = new Map<Id,String>();
            for(College__c clg : [SELECT Id, Name 
                                  FROM College__c 
                                  WHERE Id IN: collegeIdToMaxMarksMap.keySet()]){
                                    collegeIdToCollegeNameMap.put(clg.Id, clg.Name);
                                  }

            // collegeId -> collegeName, topperStudentName, totalMarks

            // preprocess to pass the data into single unit
            Map<Id,List<String>> topperInfo = new Map<Id,List<String>>();
            for(Id collegeId : collegeIdToMaxMarksMap.keySet()){
                if(!topperInfo.containsKey(collegeId)){
                    List<String> data = new List<String>();
                    String topperName = collegeIdToTopperName.get(collegeId);
                    String collegeName = collegeIdToCollegeNameMap.get(collegeId);
                    String totalMarks = '' + collegeIdToMaxMarksMap.get(collegeId);
                    data.add(collegeName);
                    data.add(topperName);
                    data.add(totalMarks);


                    topperInfo.put(collegeId, data);
                }
            }

            // for(Id collegeId : topperInfo.keySet()){
            //     System.debug('college Id ' + collegeId + 'College information ' + topperInfo.get(collegeId));
            // }

            // return JSON.serialize(topperInfo);
            return topperInfo;
    }

    @AuraEnabled
    public static string getTopperStudentName(String collegeId){
        String topperName = '';
        Double totalMarks = 0;
        Id clgId = (Id) collegeId;

        for(Student__c student : [SELECT Id, Name, Total_Marks__c, College__c
                                 FROM Student__c 
                                 WHERE College__c =: clgId]){
                                     if(totalMarks < student.Total_Marks__c){
                                         totalMarks = student.Total_Marks__c;
                                         topperName = student.Name;
                                     }
                                 }
        // System.debug(topperName + '*' + totalMarks);
        return topperName + '*' + totalMarks;
    }

    @AuraEnabled
    public static List<College__c> getColleges(){
        List<College__c> collegeList = new List<College__c>();
        for(College__c clg : [SELECT Id, Name
                             FROM College__c]){
                                 collegeList.add(clg);
                             }
        return collegeList;
    }
    @AuraEnabled
    public static List<Student__c> getStudent(Integer start_row, Integer end_row){
        List<Student__c> studentList = new List<Student__c>();
        studentList = [SELECT Id, Name, Student_Email__c
                      FROM Student__c
                      LIMIT :end_row
                      OFFSET :start_row];
        return studentList;
    }

    @AuraEnabled
    public static Integer countOfStudents(){
        List<Student__c> studentList = new List<Student__c>();
        studentList = [SELECT Id FROM Student__c];
        return studentList.size();
    }

    @AuraEnabled
    public static List<Student__c> getTotalStudents(){
        List<Student__c> studentList = new List<Student__c>();
        studentList = [SELECT Id, Name, Student_Email__c, Total_Marks__c
                       FROM Student__c];
        return studentList;
    }


}