public class MixedDMLFuture {
    public static void useFutureMethod(){
        Account acc = new Account(Name = 'Acme');
        insert acc;
        Util.insertUserWithRole('vkkr125@gmail.com.user_from_apex',
                                '125vk','vkkr125@gmail.com',
                                'tiwariji future');
    }
    public static void useNoFutureMethod(){
        Account acc = new Account(Name = 'Acme');
        insert acc;
        Util.insertUserWithoutRole('vkkr125@gmail.com.user_from_apex',
                                   '125vk',
                                   'vkkr125@gmail.com',
                                   'tiwariji no future');
    }
}

// way to pass the sObject to the Future method
// pass the data by serializing the data to the future method as string and then deserialize the data after getting 
// like pssing -> JSON.serialize(con) // after reciving Contact con = (Contact)JSON.deserialize(con_str);