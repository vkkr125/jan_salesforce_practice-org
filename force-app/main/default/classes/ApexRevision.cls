public class ApexRevision {
    
    public static void apexScenario1SolutionUsingSet(){
        Set<Id> accountIdSet = new Set<Id>();
        List<Account> accountList = new List<Account>();
        for(Contact con : [SELECT Id, Name, AccountId
                           FROM Contact
                           WHERE Name LIKE 'Demo%'
                           AND AccountId != NULL]){
                               if(!accountIdSet.contains(con.AccountId)){
                                   Account acc = new Account();
                                   acc.Id = con.AccountId;
                                   acc.Active__c = 'Yes';

                                   accountList.add(acc);
                                   accountIdSet.add(con.AccountId);
                               }
                           }
        if(accountList.size() > 0){
            update accountList;
            for(Account acc : accountList){
                System.debug('updated account id is ' + acc.Id);
            }
        }
    }
    public static void apexScenario1SolutionUsingMap(){
        Map<Id,Account> accountIdToAccountMap = new Map<Id,Account>();
        for(Contact con : [SELECT Id, Name, AccountId
                           FROM Contact 
                           WHERE Name LIKE 'Demo%'
                           AND AccountId != NULL]){
                              Account acc = new Account();
                              acc.Id = con.AccountId;
                              acc.Active__c = 'Yes';
                              accountIdToAccountMap.put(con.AccountId, acc);
                           }
        if(accountIdToAccountMap.size() > 0){
            List<Account> accountList = accountIdToAccountMap.values();
            if(accountList.size() > 0){
                update accountList;
                for(Account acc : accountList){
                    System.debug('updated account id is ' + acc.Id);
                }
            }
        }
    }
    public static void apexScenario2createMapUsingParentwithMorethan200Child(){

        Map<Id, List<Contact>> accountIdToContactListMap = new Map<Id,List<Contact>>();
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc : [SELECT Id, Name
                           FROM Account]){
            accountIdSet.add(acc.Id);
        }
        for(Contact con : [SELECT Id, Name, Title, AccountId
                           FROM Contact 
                           WHERE AccountId IN :accountIdSet]){
                            if(!accountIdToContactListMap.containsKey(con.AccountId)){
                                accountIdToContactListMap.put(con.AccountId, new List<Contact>());
                            }
                            accountIdToContactListMap.get(con.AccountId).add(con);
                          }

        for(Id accountId : accountIdToContactListMap.keySet()){
            List<Contact> contactList = accountIdToContactListMap.get(accountId);
            if(contactList.size() > 0){
                String totalContacts = '';
                for(Contact con : contactList){
                    totalContacts += con.Name + ';';
                }
                System.debug('For Account Id ' + accountId + ' total contacts are ' + totalContacts);
            }else{
                System.debug('FOR Account Id ' + accountId + ' total contacts are 0');
            }
        }
    }
    public static void apexScenario2createMapUsingChild(){

        Map<Id, List<Contact>> accountIdToContactListMap = new Map<Id,List<Contact>>();
        for(Contact con : [SELECT Id, Name, Title, AccountId
                           FROM Contact
                           WHERE AccountId != NULL]){
                               if(!accountIdToContactListMap.containsKey(con.AccountId)){
                                   accountIdToContactListMap.put(con.AccountId, new List<Contact>());
                               }
                               accountIdToContactListMap.get(con.AccountId).add(con);
                           }
        
        for(Id accountId : accountIdToContactListMap.keySet()){
            List<Contact> contactList = accountIdToContactListMap.get(accountId);
            if(contactList.size() > 0){
                String totalContacts = '';
                for(Contact con : contactList){
                    totalContacts += con.Name + ';';
                }
                System.debug('For Account Id ' + accountId + ' total contacts are ' + totalContacts);
            }else{
                System.debug('FOR Account Id ' + accountId + ' total contacts are 0');
            }
        }
    }
    public static void apexScenario2createMapUsingParent(){

        // it will throw the error when inner query will return more then 200 records
        Map<Id, List<Contact>> accountIdToContactListMap = new Map<Id,List<Contact>>();
        for(Account acc : [SELECT Id, Name, Active__c,
                          (SELECT Id, Name,Title FROM Contacts)
                           FROM Account]){
                               if(acc.Contacts.size() > 0){
                                   accountIdToContactListMap.put(acc.Id, acc.Contacts);
                               }
                           }
        for(Id accountId : accountIdToContactListMap.keySet()){
            List<Contact> contactList = accountIdToContactListMap.get(accountId);
            if(contactList.size() > 0){
                String totalContacts = '';
                for(Contact con : contactList){
                    totalContacts += con.Name + ';';
                }
                System.debug('For Account Id ' + accountId + ' total contacts are ' + totalContacts);
            }else{
                System.debug('FOR Account Id ' + accountId + ' total contacts are 0');
            }
        }
    }

    public static void findTopper(){
        // find topper of each college
        Map<Id,Integer> collegeIdToTopperMarksMap = new Map<Id,Integer>();
        Set<Id> collegeIdSet = new Set<Id>();
        for(College__c clg : [SELECT Id, Name, Is_Active__c
                              FROM College__c]){
                                  if(clg.Is_Active__c){
                                      collegeIdSet.add(clg.Id);
                                      
                                  }
                              }
        for(Student__c student : [SELECT Id, Name, Total_Marks__c, College__c
                                  FROM Student__c 
                                  WHERE College__c IN :collegeIdSet
                                  AND College__c != NULL]){
                                      if(!collegeIdToTopperMarksMap.containsKey(student.College__c)){
                                          collegeIdToTopperMarksMap.put(student.College__c,(Integer)student.Total_Marks__c);
                                      }
                                      Integer currentMaxMarks = collegeIdToTopperMarksMap.get(student.College__c);
                                      currentMaxMarks = Math.max(currentMaxMarks, (Integer)student.Total_Marks__c);
                                      collegeIdToTopperMarksMap.put(student.College__c, currentMaxMarks);
                                  }
        for(Id collegeId : collegeIdToTopperMarksMap.keySet()){
            System.debug(collegeId + '---------' + collegeIdToTopperMarksMap.get(collegeId));
        }  
    }
    public static void findTopper2(){
        
        // do not use student Total_Marks__c value
        // collegeId + studentId -> total_marks
        Map<String, Integer> collegeAndStudentIdToTotalMarksMap = new Map<String,Integer>();
        Map<Id,String> studentIdToCollegeNameAndStudentName  = new Map<Id,String>();
        for(Marks__c marks : [SELECT Id, Score__c, Student__c, Student__r.Name, Student__r.College__c, Student__r.College__r.Name
                              FROM Marks__c
                              WHERE Student__r.College__c != NULL
                              AND Score__c > 0]){
                                  if(!collegeAndStudentIdToTotalMarksMap.containsKey(marks.Student__r.College__c + '*' + marks.Student__c)){
                                      collegeAndStudentIdToTotalMarksMap.put(marks.Student__r.College__c + '*' + marks.Student__c,0);
                                  }
                                  Integer currentMarks = collegeAndStudentIdToTotalMarksMap.get(marks.Student__r.College__c + '*' + marks.Student__c);
                                  currentMarks += (Integer)marks.Score__c;
                                  collegeAndStudentIdToTotalMarksMap.put(marks.Student__r.College__c + '*' + marks.Student__c,currentMarks);
                                  
                                  if(!studentIdToCollegeNameAndStudentName.containsKey(marks.Student__c)){
                                      studentIdToCollegeNameAndStudentName.put(marks.Student__c, marks.Student__r.Name + '*' + marks.Student__r.College__r.Name);
                                  }
                              }
        
        Map<Id,String> collegeIdToMaxMarks = new Map<Id,String>();
        for(String key : collegeAndStudentIdToTotalMarksMap.keySet()){
            Id collegeId = key.split('\\*').get(0);
            Id studentId = key.split('\\*').get(1);
            Integer totalMarks = collegeAndStudentIdToTotalMarksMap.get(key);
            if(!collegeIdToMaxMarks.containsKey(collegeId)){
                collegeIdToMaxMarks.put(collegeId,studentId + '*' + 0);
            }
            Integer currentScore = Integer.valueOf(collegeIdToMaxMarks.get(collegeId).split('\\*').get(1));
            if(currentScore < totalMarks){
                collegeIdToMaxMarks.put(collegeId, studentId + '*' + totalMarks);
            }
        }
        
        
        for(Id collegeId : collegeIdToMaxMarks.keySet()){
            Id studentId = collegeIdToMaxMarks.get(collegeId).split('\\*').get(0);
            Integer totalMarks = Integer.valueOf(collegeIdToMaxMarks.get(collegeId).split('\\*').get(1));
            
            System.debug(collegeId + '---------' + studentIdToCollegeNameAndStudentName.get(studentId) + '-------' + totalMarks);
        }
        
    }
}