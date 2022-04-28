import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/DemoGetData.getAccounts';
import getContactsParam from '@salesforce/apex/DemoGetData.getContactsParam';
import getOpportunityParam from '@salesforce/apex/DemoGetData.getOpportunityParam';

export default class CustomeEdit extends LightningElement {
    opportunity_head = ['Name','Account Name','Close Date','Stage','Amount','Owner Contact'];

    contacts_editable = false;

    @track accounts = [];
    @track contacts = [];
    @track opportunities = [];
    @track error = [];
    @track selected_contacts = [];
    @track selected_opportunities = [];
    _temp_contacts = [];


    @wire(getAccounts)
    wiredGetAccounts({data,error}){
        this.accounts = [];
        if(data){
            data.forEach(account => {
                this.accounts.push({
                    Id : account.Id,
                    Name : account.Name
                })
            });
        }
    }
    get is_accounts_available(){
        return this.accounts.length > 0;
    }
    get is_contacts_available(){
        return this.contacts.length > 0;
    }
    get is_opportunities_available(){
        return this.opportunities.length > 0;
    }
    handleChange(event){
        let accountId = event.target.value;
        this.contacts = [];
        this.opportunities = [];

        getContactsParam({accountId : accountId})
        .then((result)=>{
            for(let i = 0; i < result.length; i++){
                this.contacts.push({
                    iseditable : false,
                    Id : result[i].Id,
                    FirstName : result[i].FirstName,
                    LastName : result[i].LastName,
                    Title : result[i].Title,
                    Phone : result[i].Phone,
                    Email : result[i].Email
                });
            }
           // console.log(JSON.stringify(this.contacts));
        })
        .catch((error)=>{
            console.log('error ' + JSON.stringify(error));
            this.error = error;
        });

        getOpportunityParam({accountId : accountId})
        .then(result =>{
            this.opportunities = result;
            console.log(JSON.stringify(this.opportunities));

        })
        .catch(error=>{
            this.error = error;
        });
    }
    handleCheckedContact(event){
        this._temp_contacts = [];
        var _new_temp_var;
        for(let i = 0; i < this.contacts.length; i++){
            _new_temp_var = this.contacts[i];
            if(event.target.value === this.contacts[i].Id){
                if(event.target.checked){
                    _new_temp_var.iseditable = true;
                }else{
                    _new_temp_var.iseditable = false;
                }
            }
            this._temp_contacts.push(_new_temp_var);
        }
    }
    handleSaveContact(event){
        alert('Record got saved successfully');
    }
    handleEditContact(event){
        this.contacts_editable = true;
        this.contacts = this._temp_contacts;
    }


}


//