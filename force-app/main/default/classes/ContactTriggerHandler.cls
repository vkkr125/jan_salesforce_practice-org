public class ContactTriggerHandler {
    public static void preventDuplicateContactBasedOnEmailAndContactPhone(List<Contact> newList){
        Set<String> emailSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        for(Contact con : newList){
            emailSet.add(con.Email);
            phoneSet.add(con.Phone);
        }
        if(emailSet.size() == 0) return;
        Set<String> uniqueContactSet = new Set<String>();
        for(Contact con : [SELECT Id,Email, Phone
                           FROM Contact
                           WHERE Email IN: emailSet
                           AND phone IN: phoneSet]){
                               String key = con.Email + '*' + con.Phone;
                               uniqueContactSet.add(key.toUpperCase());
                           }
        for(Contact con : newList){
            
            String key = con.Email + '*' + con.Phone;
            if(uniqueContactSet.contains(key.toUpperCase())){
                con.addError('Duplicate Contact Values');
            }else{
                uniqueContactSet.add(key);
            }
        }
    }
    
    public static void preventDuplicateContact(List<Contact> newList,Map<Id,Contact> oldMap){
        // requirements : prevent duplicate records getting inserted based on (FirstName + LastName + Email + BirthDate)
        // get all the contacts which are getting inserted and chek if any records already exist in the database
        // also make sure, all the records are getting inserted in unique
        
        Set<String> firstNameSet = new Set<String>();
        Set<String> lastNameSet= new Set<String>();
        Set<String> emailSet = new Set<String>();
        Set<Date> birthDateSet= new Set<Date>();
        for(Contact con : newList){
            if(oldMap == NULL
               || con.FirstName != oldMap.get(con.id).FirstName 
               || con.LastName  != oldMap.get(con.Id).LastName
               || con.Email != oldMap.get(con.Id).Email
               || con.Birthdate != oldMap.get(con.Id).BirthDate){
                   firstNameSet.add(con.FirstName);
                   lastNameSet.add(con.LastName);
                   emailSet.add(con.Email);
                   BirthDateSet.add(con.Birthdate);
               }
            
        }
        
        if(firstNameSet.size() == 0) return;        
        Set<String> uniqueContactSet = new Set<String>();
        for(Contact con : [SELECT Id,FirstName, LastName,Email, BirthDate
                           FROM Contact
                           WHERE FirstName IN : firstNameSet
                           AND LastName IN : lastNameSet
                           AND Email IN : emailSet
                           AND BirthDate IN : birthDateSet]){
                               uniqueContactSet.add((con.FirstName + '*' + con.LastName + '*' + con.Email + '*' + con.Birthdate).toUpperCase());
                           }
        
        for(Contact con : newList){
            String key = con.FirstName + '*' + con.LastName + '*' + con.Email + '*' + String.valueOf(con.Birthdate);
            if(uniqueContactSet.contains(key.toUpperCase())){
                con.addError(System.Label.Contact_Duplicate_Error_Label);
            }
            uniqueContactSet.add(key.toUpperCase());
        }
    }
}