global class ContactBatch implements Database.Batchable<sObject>, Database.stateful{
    
    global Integer total_size = 0;
    global Integer fail_size = 0;
    global Integer success_size = 0;
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, Fax, MobilePhone, Description Account.Name,Account.Rating,Account.Phone,Account.Fax Account.Industry FROM Contact';
        /* getJobId
         * getChildJobId
         * AsyncApexJob
         * 
         */
        AsyncApexJob[] apexJobs = [SELECT Id,
                                  ApexClassId, ApexClass.Name,
                                  NumberOfErrors, JobItemsProcessed,
                                  TotalJobItems,Status,JobType
                                  FROM AsyncApexJob
                                  WHERE Id =: bc.getJobId()];
        System.debug('Batch Status start method : ' + apexJobs);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Contact> conList){
        Integer size = conList.size();
        total_size += size;
        for(Contact con : conList){
            if(con.Fax == null || con.Fax == ''){
                con.Fax = con.Account.Fax;
            }
            if(con.MobilePhone == null || con.MobilePhone == ''){
                con.MobilePhone = con.Account.Phone;
            }
            con.Email = 'vickykr26941@gmail.com';
            con.Description = con.Account.Name + ' ' + con.Account.Rating + ' ' + con.Account.Industry + ' ' + con.Email;
        }
        // update conList;
        Database.SaveResult[] result =  Database.update(conList,false);
        for(Database.SaveResult sr : result){
            if(sr.isSuccess()){
                success_size += 1;
            }else{
                fail_size += 1;
            }
        }
    }
    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('Status Of Batch Class : ContactBatch');
        email.setSenderDisplayName('vicky kumar');
        email.setHtmlBody('Dear User Batch processed' + 
                          '<br/> Total Records : ' + total_size + 
                           '<br/> Success Count : ' + success_size + 
                           '<br/> Fail Count : ' + fail_size);
        
        List<String> emailTo = new List<String>();
        emailTo.add('vickykr26941@gmail.com');
        email.setToAddresses(emailTo);
        Messaging.SingleEmailMessage[] emailList = new List<Messaging.SingleEmailMessage>();
        emailList.add(email);
        Messaging.sendEmail(emailList,false);
        
     
        
    }
    
    // Database.executeBatch(new )

}