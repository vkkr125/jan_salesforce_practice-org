import getContacts from '@salesforce/apex/DemoGetData.getContacts';
import { api, LightningElement, wire } from 'lwc';

export default class EventChildComponent extends LightningElement {

    // task
    // take the contacts data and pass over to the parent and grand parent component
    // call child component methods from parent component 
    
    message = 'Default Message From Child Component';
    @api childProperty;
    @wire(getContacts)
    contacts
    handleMessage(event){
        this.message = event.target.value;
    }

    printMessage(){
        console.log(this.message);
        console.log(this.contacts);
    }
    handleClick(event){
        var customEvent = new CustomEvent('childevent', {
            detail : {
                message : this.message,
                contacts : this.contacts.data
            },
            bubbles : true,
            composed : true 
        });
        this.dispatchEvent(customEvent);
        console.log(this.contacts.data);
        console.log(this.message);
    }

}