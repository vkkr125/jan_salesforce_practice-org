import { api, LightningElement } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FIELD_FIRST_NAME from '@salesforce/schema/Contact.FirstName';
import FIELD_LAST_NAME from '@salesforce/schema/Contact.LastName';
import FIELD_PHONE from '@salesforce/schema/Contact.Phone';
import FIELD_TITLE from '@salesforce/schema/Contact.Title';
import FIELD_EMAIL from '@salesforce/schema/Contact.Email';

export default class RecordViewFormPractice extends LightningElement {
    @api objectApiName;
    @api recordId;

    // passing the field with field reference
    fields = [FIELD_FIRST_NAME, FIELD_LAST_NAME, FIELD_TITLE, FIELD_PHONE, FIELD_EMAIL];

    // without field reference 
    // fields = ['FirstName', 'LastName','Title','Email'];
    handleSuccess(event){
        const toastEvent = new ShowToastEvent({
            title: 'Create Contact',
            message: 'Contact Has Been Updated Successfully with Id ' + event.detail.id,
            varient : 'success'
        });
        this.dispatchEvent(toastEvent);
    }
}


//  view record 
//  edit record
//  create new record

