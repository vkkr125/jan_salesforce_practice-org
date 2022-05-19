import { LightningElement, wire } from 'lwc';
import CONTACT_MESSAGE_CHANNEL from '@salesforce/messageChannel/ContactSelected__c';
import { subscribe,MessageContext} from 'lightning/messageService';

export default class ContactMessageSubscriber extends LightningElement {
    subscription = null;
    selectedContactId;

    @wire(MessageContext)
    context;

    connectedCallback(){
        this.subscribeToMessageChannel();
    }
    subscribeToMessageChannel(){
        if (!this.subscription) {
            this.subscription = subscribe(
                this.context,
                CONTACT_MESSAGE_CHANNEL,
                (message) => this.handleMessage(message)
            );
        }
    }
    handleMessage(message){
        alert('published contact Id from Subscriber componennt : ' + message.recordId);
        alert('published message from Subscriber componennt : ' + message.message);
    }
}