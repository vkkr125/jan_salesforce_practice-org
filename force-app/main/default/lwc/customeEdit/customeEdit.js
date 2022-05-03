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
    selected_contacts = [];
    selected_opportunities = [];


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
        this.contacts_editable = false;

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
            for(let i = 0; i<this.contacts.length; i++){
                var new_obj = Object.assign({}, this.contacts[i]);
                this.selected_contacts.push(new_obj);
            }
            
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
        for(let i = 0; i<this.selected_contacts.length; i++){
            if(this.selected_contacts[i].Id === event.target.value){
                if(event.target.checked){
                    this.selected_contacts[i].iseditable = true;
                }else{
                    this.selected_contacts[i].iseditable = false;
                }
            }
        }
    }
    handleSaveContact(event){
        alert('Record got saved successfully');
        this.contacts_editable = false;
        let checkboxes = this.template.querySelectorAll('[data-id="checkbox"]');
        for(let i = 0; i< checkboxes.length; i++){
            if(checkboxes[i].checked){
                checkboxes[i].checked = false;
            }
        }
        for(let i = 0; i<this.contacts.length; i++){
            if(this.contacts[i].iseditable){
                this.contacts[i].iseditable = false;
            }
        }

        // process the contact data and make apex call to save the all contacts
    }
    handleEditContact(event){
        this.contacts_editable = true;
        this.contacts = [];
        for(let i = 0; i<this.selected_contacts.length; i++){
            this.contacts.push(this.selected_contacts[i]);
        }
       
    }
    handleSingleContactSave(event){
        alert('contat has been save successfully ' + event.target.value);
        let elements = this.template.querySelectorAll('[data-id="checkbox"]');
        for(let i = 0; i < elements.length; i++){
            if(event.target.value === elements[i].value){
                elements[i].checked = false;
                break;
            }
        }
        
        var json_data = '';
        let contactId = event.target.value;
        for(let i = 0; i<this.selected_contacts.length; i++){
            if(this.selected_contacts[i].Id === contactId){
                this.selected_contacts[i].iseditable = false;
                json_data = this.contacts[i];
                break;
            }
        }
        this.contacts = [];
        for(let i = 0; i<this.selected_contacts.length; i++){
            this.contacts.push(this.selected_contacts[i]);
        }
        // process the json_data // remove editable and then update using apex
        
    }

}


//