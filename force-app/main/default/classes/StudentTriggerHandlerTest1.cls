@isTest
public class StudentTriggerHandlerTest1 {
    
    
    // here we are calling create data method each time to create the data we can use 'testSetup' to create the data and then we can qeury the data again 
    // that's the best practice (next version followed best practice implemented in : studentTriggerHandlerTest2)
    
    
    public static List<College__c> collegeList;
    public static List<Student__c> studentList;
    
    public static void createData(){
        collegeList = TestDataFactory.createCollegeList(5, 'testcollege', false);
        for(College__c clg : collegeList){
            clg.is_Active__c = true;
        }
        insert collegeList;
        studentList = new List<Student__c>();
        for(College__c clg : collegeList){
            studentList.addAll(TestDataFactory.createStudentList(10,'teststudent', clg, false));
        }
        insert studentList;
    }
    @isTest
    public static void testStudentCountOnCreate(){
        createData();
        for(College__c clg : [SELECT Id,Student_Count__c
                              FROM College__c
                              WHERE Id IN : collegeList]){
                                  System.assertEquals(10, clg.Student_Count__c);
                              }
    }
    
    @isTest
    public static void testStudentCountOnUpdate(){
        createData();
       
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
        createData();
        delete studentList;
        for(College__c clg : [SELECT Id, Student_Count__c 
                              FROM College__c
                              WHERE Id IN : collegeList]){
                                  system.assertEquals(0,clg.Student_Count__c);
                              }
    }
    
    @isTest
    public static void testStudentCountOnUndelete(){
        createData();
        
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
        
        System.assert(false,undeleteList.size());
        undelete studentList;
        for(College__c clg : [SELECT Id, Student_Count__c
                              FROM College__c
                              WHERE Id IN : CollegeList]){
            System.assertEquals(10, clg.Student_Count__c);
        }
        
        
    }
    
}