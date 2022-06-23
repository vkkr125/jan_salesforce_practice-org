public with sharing class MarksTriggerHandler {
    public static void checkDuplicateSubject(List<Marks__c> newList,Map<Id,Marks__c> oldMap){
        Set<Id> studentIdSet = new Set<Id>();
        for(Marks__c marks : newList){
            if(oldMap == NULL || oldMap.get(marks.Id).Subject__c != marks.Subject__c){
                studentIdSet.add(marks.Student__c);
            }
        }
        Map<Id,String> studentIdToSubjectsMap = new Map<Id,String>();
        for(Marks__c marks : [SELECT Id, Subject__c, Student__c
                              FROM Marks__c
                              WHERE Student__c IN :studentIdSet]){
                                  if(!studentIdToSubjectsMap.containsKey(marks.Student__c)){
                                      studentIdToSubjectsMap.put(marks.Student__c, '');
                                  }
                                  String currentSubjects = studentIdToSubjectsMap.get(marks.Student__c);
                                  currentSubjects += marks.Subject__c + ';';
                                  studentIdToSubjectsMap.put(marks.Student__c, currentSubjects);
                              }
        
        for(Marks__c marks : newList){
            String totalCurrentSubjects = studentIdToSubjectsMap.get(marks.Student__c);
            if(totalCurrentSubjects!= NULL && totalCurrentSubjects.contains(marks.Subject__c)){
                marks.AddError('Duplicate Subject For this Student');
            }
        }
    }
}