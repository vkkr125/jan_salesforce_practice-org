public class Util {
    public static void insertUserWithRole(String userName,String als,String email,String LastName){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        UserRole role = [SELECT Id FROM UserRole WHERE Name = 'COO'];
        
        User usr = new User(alias = als,
                            Email = email,
                            LastName = LastName,
                            emailencodingkey = 'UTF-8',
                            LocaleSidKey = 'en_US',
                            LanguageLocaleKey = 'en_US',
                            TimeZoneSidKey = 'America/Los_Angeles',
                            profileId = p.Id, userRoleId = role.Id,
                            username = userName);
        
        insert usr;
    }
    public static void insertUserWithoutRole(String username, String alias,String email,String LastName){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        
        User usr = new User(alias = alias,
                            Email = email,
                            LastName = LastName,
                            emailencodingkey = 'UTF-8',
                            LocaleSidKey = 'en_US',
                            LanguageLocaleKey = 'en_US',
                            TimeZoneSidKey = 'America/Los_Angeles',
                            profileId = p.Id,
                            username = userName);
        
        insert usr;
    }
}