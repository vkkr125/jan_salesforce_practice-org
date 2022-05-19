import { LightningElement } from 'lwc';

export default class EventGrandParentComponent extends LightningElement {

    contacts;
    message;
    contacts_names;
    columns = [
        {label : 'First Name', fieldName : 'FirstName', type : 'String'},
        {label : 'Last Name', fieldName : 'LastName', type : 'String'},
        {label : 'Phone', fieldName : 'Phone', type : 'String'},
        {label : 'Email', fieldName : 'Email', type : 'String'}];
    
    is_contact_available(){
        return this.contacts.length > 0;
    }
    handleChildEvent(event){
        this.message = event.detail.message;
        this.contacts = event.detail.contacts;


        let childCmpRef = this.template.querySelector('c-event-parent-component');
        this.contacts_names = childCmpRef.printContacts();
    }
}