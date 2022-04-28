public class Stack {
    public List<Integer> stk;
    public void push(Integer val){
        this.stk.add(val);
    }
    public Integer pop(){
        Integer val = this.stk[this.stk.size() - 1];
        this.stk.remove(this.stk.size() - 1);
        return val;
    }
}