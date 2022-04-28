public class DatabaseOperationsOnCustomeObjects {
    public void createSingleRecord(){
        Student__c student = new Student__c();
        student.Name = 'Sameer Maheshwari';
        student.State__c = 'Bihar';
        student.Student_Email__c = 'vickykr26941@gmail.com';
        insert student;
        
    }
    
    // create 200 Student records Assign random state and random college
    public void createMultipleRecords(){
        List<Id> collegeList = new List<Id>();
        List<String> stateList = new List<String>{'Bihar','Rajastha','Uttar Pradesh','Madhya Predesh','Haryana','Telengna'};
            
            
        for(College__c clg : [SELECT Id,Name,College_email__c
                              FROM College__c
                              WHERE is_Active__c = True])
            collegeList.add(clg.Id);
        
        
       
        List<Student__c> createStudentList = new List<Student__c>();
        for(Integer i = 0; i<200; i++){
            Student__c student = new Student__c();
            student.Name = 'test student ' + i;
            student.Student_Email__c = 'vkkr125@gmail.com';
            student.College__c = collegeList.get((Integer)(Math.random() * collegeList.size()));
            student.State__c = stateList.get((Integer)(Math.random() * stateList.size()));
            student.RecordTypeId = Math.mod(i, 2) == 0 ? '0125j000000Ys3AAAS' : '0125j000000Ys3FAAS';
            
            createStudentList.add(student);
            
        }
        if(createStudentList.size() > 0){
            insert createStudentList;
        }
        
        
    }
    public void updateRecords(){
        List<Student__c> studentUpdateList = new List<Student__c>();
        for(Student__c student : [SELECT Id,Name FROM Student__c]){
            if(student.RecordType.Name == 'Graduation'){
                Student__c newStudent = new Student__c();
                newStudent.Id = student.Id;
                newStudent.Graduated__c = 'Yes';
                
                studentUpdateList.add(student);
            }
        }
        if(studentUpdateList.size() > 0){
            update studentUpdateList;
        }
    }
    public void deleteRecords(){
        List<Student__c> deleteRecordList = new List<Student__c>();
        for(Student__c student : [SELECT Id,Name
                                  FROM Student__c
                                  WHERE Name like 'test student%'])
            deleteRecordList.add(student);
        
        if(deleteRecordList.size() > 0){
            delete deleteRecordList;
        } 
    }
}