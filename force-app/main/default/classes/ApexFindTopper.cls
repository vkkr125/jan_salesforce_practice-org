public class ApexFindTopper {
    public void findTopperForCollege(Set<Id> collegeIdSet){
        // key = collegeId + studentId -> sum(marks)
        // 
        Map<String, Integer> collegeAndStudentIdToMarks = new Map<String,Integer>();
        Map<Id,String> collegeIdToCollegeNameMap = new Map<Id,String>();
        Map<Id,String> studentIdToStudentNameMap = new Map<Id,String>();
        
        
        for(Marks__c marks : [SELECT Id,Score__c,Student__c,Student__r.College__c,
                              Student__r.Name, Student__r.College__r.Name
                              FROM Marks__c
                              WHERE Student__r.College__c IN :collegeIdSet]){
                                  if(!collegeAndStudentIdToMarks.containsKey(marks.Student__c + '*' + marks.Student__r.College__c)){
                                      collegeAndStudentIdToMarks.put(marks.Student__c + '*' + marks.Student__r.College__c, 0);
                                  }
                                  Integer currentMarks = collegeAndStudentIdToMarks.get(marks.Student__c + '*' + marks.Student__r.College__c);
                                  currentMarks += (Integer)marks.Score__c;
                                  collegeAndStudentIdToMarks.put(marks.Student__c + '*' + marks.Student__r.College__c, currentMarks);
                                  
                                  
                                  // collegeId -> collegeName
                                  if(!collegeIdToCollegeNameMap.containsKey(marks.Student__r.College__c)){
                                      collegeIdToCollegeNameMap.put(marks.Student__r.College__c,marks.Student__r.College__r.Name);
                                  }
                                  // studentId -> studentName
                                  if(!studentIdToStudentNameMap.containsKey(marks.Student__c)){
                                      studentIdToStudentNameMap.put(marks.Student__c, marks.Student__r.Name);
                                  }
                              }
        
        
        Map<Id,String> collegeIdToTopperIdAndMarks = new Map<Id,String>();
        for(String key : collegeAndStudentIdToMarks.keySet()){
            Id collegeId = key.split('\\*').get(1);
            Id studentId = key.split('\\*').get(0);
            Integer total_marks = collegeAndStudentIdToMarks.get(key);
            if(!collegeIdToTopperIdAndMarks.containsKey(collegeId)){
                collegeIdToTopperIdAndMarks.put(collegeId, studentId + '*' + 0);
            }
            Integer tempMarks = Integer.valueOf(collegeIdToTopperIdAndMarks.get(collegeId).split('\\*').get(1));
            if(total_marks > tempMarks){
                collegeIdToTopperIdAndMarks.put(collegeId, studentId + '*' + total_marks);
            }
        }
        for(Id collegeId : collegeIdToTopperIdAndMarks.keySet()){
            Id studentId = collegeIdToTopperIdAndMarks.get(collegeId).split('\\*').get(0);
            Integer topperStudentMarks = Integer.valueOf(collegeIdToTopperIdAndMarks.get(collegeId).split('\\*').get(1));
            System.debug('For the College :' + collegeIdToCollegeNameMap.get(collegeId) +
                         ' The Topper Student is ' + studentIdToStudentNameMap.get(studentId) +
                         ' With Total Marks ' + topperStudentMarks );
        }
    }
}