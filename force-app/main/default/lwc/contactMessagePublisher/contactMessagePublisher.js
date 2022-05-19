import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/DemoGetData.getContacts';
import CONTACT_MESSAGE_CHANNEL from '@salesforce/messageChannel/ContactSelected__c';
import { publish, MessageContext} from 'lightning/messageService';

export default class ContactMessagePublisher extends LightningElement {
    @wire(getContacts)
    contacts;

    @wire(MessageContext)
    context;

    handleChildEvent(event){
        alert('contact id in publisher component : ' + event.detail.contactId);
        const message = { 
            recordId : event.detail.contactId,
            message : 'Hello Form Publisher Component'
        };
        publish(this.context, CONTACT_MESSAGE_CHANNEL, message);
    }
}