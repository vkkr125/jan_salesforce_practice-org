import getContacts from '@salesforce/apex/DemoGetData.getContacts';
import { api, LightningElement, wire } from 'lwc';
export default class EventParentComponent extends LightningElement {

    parentProperty = "Hello";
    message;
    contacts;
    contact_column = [
        { label: 'First Name', fieldName: 'FirstName', type: 'String'},
        { label: 'Last Name', fieldName: 'LastName', type: 'String'},
        { label: 'Phone', fieldName: 'Phone', type: 'String'},
        { label: 'Email', fieldName: 'Email', type: 'String'},
    ];
    is_contact_available(){
        return this.contacts.length > 0;
    }
    @api
    printContacts(){
        // print all the contacts Name : 
        var all_contacts = '';
        for(let i = 0; i < this.contacts.length; i++){
            all_contacts += this.contacts[i].FirstName;
        }
        return all_contacts;
    }
    handleChildEvent(event){
        this.message = event.detail.message;
        this.contacts = event.detail.contacts;
        console.log(this.message);
        console.log(this.contacts);
    }

}