import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FIELD_FIRST_NAME from '@salesforce/schema/Contact.FirstName';
import FIELD_LAST_NAME from '@salesforce/schema/Contact.LastName';
import FIELD_PHONE from '@salesforce/schema/Contact.Phone';
import FIELD_TITLE from '@salesforce/schema/Contact.Title';
import FIELD_EMAIL from '@salesforce/schema/Contact.Email';

export default class RecordFormPractice extends LightningElement {
    @api objectApiName;
    @api recordId;
    fields = [FIELD_FIRST_NAME, FIELD_LAST_NAME, FIELD_PHONE, FIELD_TITLE, FIELD_EMAIL];

    handleSubmit(event){
        event.preventDefault(); 
        const fields = event.detail.fields;
        // process the fields
        alert('Processing the data before submitting');
        this.template.querySelector('lightning-record-form').submit(fields);
    }
    handleSuccess(event){
        const fields = event.detail.fields;
        // process the data or display the success toast message
        const toastEvent = new ShowToastEvent({
            title : 'Create Contact',
            message : 'Contact Created Successfully ' + event.detail.id,
            variant : 'suceess'
        });
        this.dispatchEvent(toastEvent);
        
    }
}