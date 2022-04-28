@isTest
public class StudentTriggerHandlerTest {
    
    
    // here the we care copy pasting the same code for creating the data 
    // which is not a best practice so create DataFactory to create any kind of data that could be reused
    // another version (folllowing best practices implemented in studenttriggertest1 class)
    // 
    // 
    @isTest
    public static void testStudentCountOnCreate(){
        List<College__c> collegeList = new List<College__c>();
        for(Integer i = 1; i<=5; i++){
            College__c clg = new College__c();
            clg.Name = 'Test College ' + i;
            clg.College_Email__c = 'testcollege@mtxb2b.com';
            clg.is_Active__c = true;
            clg.State__c = 'Bihar';
            collegeList.add(clg);
        }
        if(collegeList.size() > 0){
            insert collegeList;
        }
        
        List<Student__c> studentList = new List<Student__c>();
        for(Integer i = 1; i<=50; i++){
            Student__c stud = new Student__c();
            stud.Name = 'test student' + i;
            stud.State__c = 'Bihar';
            stud.adhar_Number__c = i < 10 ? '1112-2224-323' + i : '2343-3232-32' + i;
            stud.Student_Email__c = 'vkkr125@gmail.com';
            stud.College__c = collegeList.get(math.mod(i,5)).Id;
            studentList.add(stud);
            
        }
        
        insert studentList;
        for(College__c clg : [SELECT Id, Student_Count__c 
                              FROM College__c
                              WHERE Id IN : collegeList]){
                                  
            System.assertEquals(10, clg.Student_Count__c);
        }
        
    }
    
    @isTest
    public static void testStudentCountOnUpdate(){
        List<College__c> collegeList = new List<College__c>();
        for(Integer i = 1; i<=5; i++){
            College__c clg = new College__c();
            clg.Name = 'Test College ' + i;
            clg.College_Email__c = 'testcollege@mtxb2b.com';
            clg.is_Active__c = true;
            clg.State__c = 'Bihar';
            collegeList.add(clg);
        }
        if(collegeList.size() > 0){
            insert collegeList;
        }
        
        List<Student__c> studentList = new List<Student__c>();
        for(Integer i = 1; i<=50; i++){
            Student__c stud = new Student__c();
            stud.Name = 'test student' + i;
            stud.State__c = 'Bihar';
            stud.adhar_Number__c = i < 10 ? '1112-2224-323' + i : '2343-3232-32' + i;
            stud.Student_Email__c = 'vkkr125@gmail.com';
            stud.College__c = collegeList.get(math.mod(i,5)).Id;
            studentList.add(stud);
            
        }
        
        insert studentList;
        
        for(Student__c stud : studentList){
            if(stud.College__c != collegeList.get(0).Id){
                stud.College__c = collegeList.get(0).Id;
            }
        }
        
        update studentList;
        for(College__c clg : [SELECT Id, Student_Count__c 
                              FROM College__c
                              WHERE Id =: collegeList.get(0).Id]){
                                  
            System.assertEquals(50, clg.Student_Count__c);
        }
        
    }
    
    @isTest
    public static void testStudentCountOnDelete(){
        List<College__c> collegeList = new List<College__c>();
        for(Integer i = 1; i<=5; i++){
            College__c clg = new College__c();
            clg.Name = 'Test College ' + i;
            clg.College_Email__c = 'testcollege@mtxb2b.com';
            clg.is_Active__c = true;
            clg.State__c = 'Bihar';
            collegeList.add(clg);
        }
        if(collegeList.size() > 0){
            insert collegeList;
        }
        
        List<Student__c> studentList = new List<Student__c>();
        for(Integer i = 1; i<=50; i++){
            Student__c stud = new Student__c();
            stud.Name = 'test student' + i;
            stud.State__c = 'Bihar';
            stud.adhar_Number__c = i < 10 ? '1112-2224-323' + i : '2343-3232-32' + i;
            stud.Student_Email__c = 'vkkr125@gmail.com';
            stud.College__c = collegeList.get(math.mod(i,5)).Id;
            studentList.add(stud);
            
        }
        
        insert studentList;
        
        delete studentList;
        
        for(College__c clg : [SELECT Id, Student_Count__c 
                              FROM College__c
                              WHERE Id IN : collegeList]){
                                  
            System.assertEquals(0, clg.Student_Count__c);
        }
        
    }
}