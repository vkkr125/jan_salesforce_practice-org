public class Q_ClassDemo_2 implements Queueable{
    
    public Id parentId;
    public Q_ClassDemo_2(Id accountId){
        this.parentId = accountId;
    }
    public void execute(QueueableContext qc){
        Contact con = new Contact(LastName = 'Contact12', FirstName = 'Queueable1', AccountId = this.parentId);
        insert con;
    }
}