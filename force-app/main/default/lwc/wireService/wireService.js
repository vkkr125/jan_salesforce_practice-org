import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/DemoGetData.getContacts';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import updateContacts from '@salesforce/apex/DemoGetData.updateContacts';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';

import ID_FIELD from '@salesforce/schema/Contact.Id';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class WireService extends LightningElement {

    draftValues = [];
    columns = [
        {label : 'FirstName', fieldName : 'FirstName', editable:true},
        {label : 'LastName', fieldName : 'LastName', editable:true},
        {label : 'Title', fieldName : 'Title',editable : true},
        {label : 'Contact Phone', fieldName : 'Phone', editable : true},
        {label : 'Contact Email', fieldName : 'Email', editable : true},
    ];

    @wire(getContacts)
    contact_data;


     /// update single row using updateRecord lwc method
    // handleSave(event) {

    //     const fields = {}; 
    //     fields[ID_FIELD.fieldApiName] = event.detail.draftValues[0].Id;
    //     fields[FIRSTNAME_FIELD.fieldApiName] = event.detail.draftValues[0].FirstName;
    //     fields[LASTNAME_FIELD.fieldApiName] = event.detail.draftValues[0].LastName;
    //     fields[PHONE_FIELD.fieldApiName] = event.detail.draftValues[0].Phone;
    //     fields[TITLE_FIELD.fieldApiName] = event.detail.draftValues[0].Title;
    //     fields[EMAIL_FIELD.fieldApiName] = event.detail.draftValues[0].Email;
        
    //     const recordInput = {fields};
    //     // console.log(recordInput);

    //     // will update single row // will update first row 
    //     updateRecord(recordInput)
    //     .then(() => {
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Success',
    //                 message: 'Contact updated',
    //                 variant: 'success'
    //             })
    //         );
    //         // Display fresh data in the datatable
    //         return refreshApex(this.contact_data).then(() => {
    //             // Clear all draft values in the datatable
    //             this.draftValues = [];
    //         });
    //     }).catch(error => {
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Error updating or reloading record',
    //                 message: 'error while update the data',
    //                 variant: 'error'
    //             })
    //         );
    //     });
    // }


    /// update multiple rows using updateRecord lwc method
    // handleSave(event){
    //     const recordInputs = event.detail.draftValues.slice().map(draft =>{
    //         const fields = Object.assign({}, draft);
    //         return {fields};
    //     });
    //     // console.log(recordInputs);
        
    //     const promises = recordInputs.map(recordInput => updateRecord(recordInput));
    //     // console.log(promises);
    //     Promise.all(promises).then(contact =>{
    //         const toastEvent = new ShowToastEvent({
    //             title : 'Success',
    //             message : 'Contacts Updated Successfully !!!',
    //             variant : 'success'
    //         });
    //         this.dispatchEvent(toastEvent);

    //         this.draftValues = [];
    //         return refreshApex(this.contact_data);

    //     }).catch( error =>{
    //         const toastEvent = ShowToastEvent({
    //             title : 'faild',
    //             message : 'Contacts Faild to update successfully !!!',
    //             variant : 'error',
    //         });
    //         this.dispatchEvent(toastEvent);
    //         return this.refreshApex(this.contact);
    //     });
    // }

    // update the , updated values using apex method 
    async handleSave(event) {
        const updatedFields = event.detail.draftValues;
        
        // Prepare the record IDs for getRecordNotifyChange()
        const notifyChangeIds = updatedFields.map(row => { return { "recordId": row.Id } });

        try {
            // Pass edited fields to the updateContacts Apex controller
            const result = await updateContacts({data: updatedFields});
            console.log(JSON.stringify("Apex update result: "+ result));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contact updated',
                    variant: 'success'
                })
            );
            // Refresh LDS cache and wires
            getRecordNotifyChange(notifyChangeIds);
            // Display fresh data in the datatable
            refreshApex(this.contact_data).then(() => {
                // Clear all draft values in the datatable
                this.draftValues = [];
            });
       } catch(error) {
               this.dispatchEvent(
                   new ShowToastEvent({
                       title: 'Error updating or refreshing records',
                       message: error.body.message,
                       variant: 'error'
                   })
             );
        };
    }

}


// 1 more example of wire service with parameter 
// wire service with parameter and function
// apex imperetive call by click and select
// data passing by event from child to parent and handling the event
// data table with inline editing
// message channel example 
// pagination and custome enline editing 
// read the documentation also
// revise all the apex codes // apex // perform demo's
// trigger's apex and validation with triggers and all