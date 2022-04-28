public class ListDemo {
    public ListDemo(){
        
        // to initialize a list 
        // best practices :
        // always create meaningfull name, always append List at the end like collegeList etc
        List<String> colorList = new List<String>();
        List<Account> accountList = new List<Account>();
        List<Integer> integerList = new List<Integer>();
        
        // to add values to the list use add method
        colorList.add('Black');
        colorList.add('Green');
        colorList.add('Yellow');
        colorList.add('Black');
        
        // display the size of list
        system.debug('The lsit of size is ' + colorList.size());
        String color = colorList.get(3);
        System.debug('The color at index 3 is ' + color);
        
        // to add the values at particular index
        colorList.add(2,'Orange');
        System.debug('The list is ' + colorList);
        // to find first occurance of any element , we use indexOf method
        System.debug('The index of orange is ' + colorList.indexOf('Orange'));
        
        // to add one list into another we will use addAll method
        List<String> tempList = new List<String>();
        tempList.add('Pink');
        tempList.add('Red');
        colorList.addAll(tempList);
        
        colorList.remove(colorList.indexof('Orange')); // remove first occurance of Orange
        System.debug('the list after removing Orange is ' + colorList);
        
        // to iterate on list using for loop
        for(Integer i = 0; i<colorList.size(); i++){
            System.debug('Value at Index ' + ' is ' + colorList.get(i));
        }
        
        // iteration using foreach loop
        Integer count = 0;
        for(String colorName : colorList){
            System.debug('Value at Index ' + count + ' is ' + colorName);
            count ++;
        }
        colorList.clear();
        System.debug('size after clear method is ' + colorList.size());
        
    }
    public void StringIteration(){
        String myName = 'vicky kumar';
        for(String ch : myName.split('')){
            System.debug(ch);
        }
        
        // another way to iterate as characters
        for(Integer i = 0; i<myName.length(); i++){
            System.debug(myName.substring(i, i + 1));
        }
    }
}