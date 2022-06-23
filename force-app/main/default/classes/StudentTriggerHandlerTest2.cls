@isTest
public class StudentTriggerHandlerTest2 {
    
    @testSetup
    public static void setup(){
        List<College__c> collegeList = new List<College__c>();
        List<Student__c> studentList = new List<Student__c>();
        collegeList = TestDataFactory.createCollegeList(5, 'testcollege',false);
        for(College__c clg : collegeList){
            clg.Is_Active__c = true;
        }
        insert collegeList;
        for(College__c clg : collegeList){
            studentList.addAll(TestDataFactory.createStudentList(10, 'teststudent', clg, false));
        }
        insert studentList;
    }

    @isTest
    public static void testStudentCountOnCreate(){
        List<College__c > collegeList = [SELECT Id FROM College__c WHERE Name LIKE 'testcollege%'];
        for(College__c clg : [SELECT Id,Student_Count__c
                              FROM College__c
                              WHERE Id IN : collegeList]){
                                  System.assertEquals(10, clg.Student_Count__c);
                              }
    }
    
    @isTest
    public static void testStudentCountOnUpdate(){
        List<Student__c> studentList = [SELECT Id,College__c FROM Student__c WHERE Name LIKE 'teststudent%'];
        List<College__c> collegeList = [SELECT Id FROM College__c WHERE Name LIKE 'testcollege%'];
        
        for(Student__c stud : studentList){
            if(stud.College__c != collegeList.get(0).Id){
                stud.College__c = collegeList.get(0).Id;
            }
        }
        update studentList;
        for(College__c clg : [SELECT Id, Student_Count__c
                              FROM College__c
                              WHERE Id =: collegeList.get(0).Id]){
                                  System.assertEquals(50,clg.Student_Count__c);
                              }
    }
    @isTest
    public static void testStudentCountOnDelete(){
        List<Student__c> studentList = [SELECT Id, College__c FROM Student__c WHERE Name LIKE 'teststudent%'];
        List<College__c> collegeList = [SELECT Id FROM College__c WHERE Name LIKE 'testcollege%'];
        
        delete studentList;
        for(College__c clg : [SELECT Id, Student_Count__c 
                              FROM College__c
                              WHERE Id IN : collegeList]){
                                  system.assertEquals(0,clg.Student_Count__c);
                              }
    }
    
    @isTest
    public static void testStudentCountOnUndelete(){
        List<Student__c> studentList = [SELECT Id, College__c FROM Student__c WHERE Name LIKE 'teststudent%'];
        List<College__c> collegeList = [SELECT Id FROM College__c WHERE Name LIKE 'testcollege%'];
                
        List<Student__c> deleteList = new List<Student__c>();
        for(Student__c stud : studentList){
            if(stud.College__c != collegeList.get(0).Id){
                deleteList.add(stud);
            }
        }
        delete deleteList;
        List<Student__c> undeleteList = [SELECT Id, Name
                                         FROM Student__c
                                         WHERE isDeleted = true
                                         ALL ROWS];
        
        System.debug(undeleteList.size());
       // System.assert(false,undeleteList.size());
        undelete deleteList;
        for(College__c clg : [SELECT Id, Student_Count__c
                              FROM College__c
                              WHERE Id IN : CollegeList]){
            System.assertEquals(10, clg.Student_Count__c);
        }
        
    }
}