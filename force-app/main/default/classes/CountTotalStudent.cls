public with sharing class CountTotalStudent {
    public CountTotalStudent(Set<Id> collegeIdSet) {

        Map<Id,Integer> collegeIdToMaxMarksMap = new Map<Id,Integer>();

        // querying from marks
        for(Marks__c marks : [SELECT Id, Score__c, Student__r.Total_Marks__c,Student__c, Student__r.College__c
                             FROM Marks__c
                             WHERE Student__r.College__c IN : collegeIdSet]){
                                 if(!collegeIdToMaxMarksMap.containsKey(marks.Student__r.College__c)){
                                     collegeIdToMaxMarksMap.put(marks.Student__r.College__c, 0);
                                 }
                                 Integer currentMaxMarks = (Integer)collegeIdToMaxMarksMap.get(marks.Student__r.College__c);
                                 currentMaxMarks = Math.max(currentMaxMarks, (Integer)marks.Student__r.Total_Marks__c);
                                 collegeIdToMaxMarksMap.put(marks.Student__r.College__c, currentMaxMarks);
                             }

        // quering from student
        Map<Id,Integer> collegeIdToMaximumTotalMarksMap = new Map<Id,Integer>();
        for(Student__c student : [SELECT Id, Name, College__c,Total_Marks__c
                                 FROM Student__c
                                 WHERE College__c IN : collegeIdSet]){
                                    if(!collegeIdToMaximumTotalMarksMap.containsKey(student.College__c)){
                                        collegeIdToMaximumTotalMarksMap.put(student.College__c, 0);
                                    }
                                    Integer currentMarks = (Integer)collegeIdToMaximumTotalMarksMap.get(student.College__c);
                                    currentMarks = Math.max(currentMarks, (Integer)student.Total_Marks__c);
                                    collegeIdToMaximumTotalMarksMap.put(student.College__c, currentMarks);
                                 }
        
        

    }
    
}