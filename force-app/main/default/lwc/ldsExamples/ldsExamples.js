import { api, LightningElement, wire } from 'lwc';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import PHONE from '@salesforce/schema/Contact.Phone';
import EMAIL from '@salesforce/schema/Contact.Email';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { deleteRecord } from 'lightning/uiRecordApi';

const fields = [FIRST_NAME_FIELD, LAST_NAME_FIELD, PHONE, EMAIL];
export default class LdsExamples extends LightningElement {
    @api objectApiName;
    @api recordId;
    
    @wire(getRecord, {recordId : '$recordId', fields : fields})
    contact;


    handleSuccess(event){
        const toastEvent = new ShowToastEvent({
            title: 'Edit Record',
            message: 'Contact Has been Updated Successfully !!',
            variant : 'success'
        });
        this.dispatchEvent(toastEvent);
    }




}