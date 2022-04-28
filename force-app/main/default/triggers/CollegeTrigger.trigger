trigger CollegeTrigger on College__c (after delete) {
    
    Set<Id> collegeIdSet = new Set<Id>();
    for(College__c clg : Trigger.old){
        collegeIdSet.add(clg.Id);
    }
    
    System.debug('>>>> deleted collegeId set are ' + collegeIdSet);
    List<Student__c> studentList = new List<Student__c>();
    studentList = [SELECT Id,College__c
                   FROM Student__c
                   WHERE college__c IN : collegeIdSet];
    System.debug('>>>>>>> size of students are ' + studentList.size());
    
}