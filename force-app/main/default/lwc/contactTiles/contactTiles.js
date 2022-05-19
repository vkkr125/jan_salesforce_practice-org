import { api, LightningElement } from 'lwc';

export default class ContactTiles extends LightningElement {
    @api contacts;
    handleChildEvent(event){
        alert('contact id in tiles component : ' + event.detail.contactId);
    }
}