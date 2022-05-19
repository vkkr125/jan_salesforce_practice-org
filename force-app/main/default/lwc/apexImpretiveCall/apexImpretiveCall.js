import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/DemoGetData.getAccounts';
import getContactsParam from '@salesforce/apex/DemoGetData.getContactsParam';

export default class ApexImpretiveCall extends LightningElement {


    selectedAccountId;
    accounts;
    error;
    contacts;
    @wire(getAccounts)
    wiredGetAccounts({data,error}){
        if(data){
            this.accounts = data;
        }else{
            this.error = error;
        }
    }
    handleChange(event){
        this.selectedAccountId = event.target.value;
        getContactsParam({accountId : this.selectedAccountId})
        .then((result)=>{
            this.contacts = result;
            console.log(this.contacts);
        }).catch((error)=>{
            this.error = error;
            console.log('error while fetching contact data');
        });
        console.log('selected account id is  : ' + this.selectedAccountId);
    }



}