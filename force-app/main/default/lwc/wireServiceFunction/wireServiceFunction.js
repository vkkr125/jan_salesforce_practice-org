import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/DemoGetData.getAccounts';
import getContactsParam from '@salesforce/apex/DemoGetData.getContactsParam';
import getOpportunityParam from '@salesforce/apex/DemoGetData.getOpportunityParam';


export default class WireServiceFunction extends LightningElement {
    opportunity_head = ['Opportunity Name','StageName','Close Date', 'Amount','Owner Contact'];
    contact_head = ['Contact Id','First Name','Last Name','Title', 'Phone', 'Email'];

    @track accounts = [];
    @track contacts = [];
    @track opportunities = [];


    // account_available = false;
    @wire(getAccounts)
    wiredGetAccounts({data,error}){
        if(data){
            this.accounts = [];
            data.forEach((account)=>{
                this.accounts.push({
                    Id : account.Id,
                    Name : account.Name
                })
            });
        }
    }
    get account_available(){
        return this.accounts.length > 0;
    }
    get contact_available(){
        return this.contacts.length > 0;
    }
    get opportunity_available(){
        return this.opportunities.length > 0;
    }
    handleChange(event){
        // call apex imperatively to fetch the data 
        this.contacts = [];
        let accountId = event.target.value;
        console.log('selected account id ' + accountId);
        getContactsParam({accountId : accountId})
        .then((result) =>{
            console.log(result);
            this.contacts = result;
        })
        .catch(error =>{
            console.log('error while loading the contact data');
        });

        getOpportunityParam({accountId : accountId})
        .then(result=>{
            this.opportunities = [];
            this.opportunities = result;
        })
        .catch(error =>{
            console.log('error while loading the opportunity data');
        });
    }


}