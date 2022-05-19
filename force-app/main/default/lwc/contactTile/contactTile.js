import { api, LightningElement } from 'lwc';

export default class ContactTile extends LightningElement {
    @api contact;
    handleClick(event){

        alert('contact id in tile component : ' + this.contact.Id);
        let customEvent = new CustomEvent('childevent',{
            detail:{
                contactId : this.contact.Id,
                message : 'contact id is : ' + this.contact.Id
            },
            bubbles : true,
            composed : true
        });
        this.dispatchEvent(customEvent);
    }
}