import { api, LightningElement, track, wire } from 'lwc';
import getdata from '@salesforce/apex/DemoWrapper.getdata';
import saveSingleContact from '@salesforce/apex/DemoWrapper.saveSingleContact';
import saveSingleOpportunity from '@salesforce/apex/DemoWrapper.saveSingleOpportunity';
import saveData from '@salesforce/apex/DemoWrapper.saveData';
import getPickListValuesIntoList from '@salesforce/apex/DemoWrapper.getPickListValuesIntoList';

import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';


export default class Lwcwrapper extends NavigationMixin(LightningElement){
    
    stageNameList;
    @api recordId;
    @api objectApiName;
    fields = ['Name', 'Phone', 'Rating', 'Website'];
    showContactSpinner;
    showOpportunitySpinner;
    @track view;
    @track error;
    selected_contactList ;
    selected_opportunityList;
    selected_contact_count ;
    selected_opportunity_count;

    // get picklist values of opportunity stage
    @wire(getPickListValuesIntoList)
    wieredStageNameList({data, error}){
        if(data){
            this.stageNameList = data;
        }else{
            this.error = error;
        }
    }

    // get the data in wrapper
    @wire(getdata, {accountId : '$recordId'})
    wieredGetData({data, error}){
        if(data){
            this.view = JSON.parse(data);

            // take the deep copy of the contact list and opportunity list
            var contact_list = JSON.parse(JSON.stringify(this.view.wrapper_contactList));
            var opportunity_list = JSON.parse(JSON.stringify(this.view.wrapper_opportunityList));
            this.selected_contactList = contact_list;
            this.selected_opportunityList = opportunity_list;

            console.log('Hello from the wired method');
            console.log(this.view);
        }else{
            this.error = error;
            console.log('error while loading the data');
            console.log(error);
        }
    }
    get contactSelectedCount(){
        return this.selected_contact_count;
    }
    get opportunitySelectedCount(){
        return this.selected_opportunity_count;
    }
    
    handleContactEnlineEdit(event){
        // make isEditable for selected contact

        var selectedContactId = event.target.value;
        console.log('selected contact id is ' + selectedContactId);
        for(let i = 0; i < this.view.wrapper_contactList.length; i++){
            if(this.view.wrapper_contactList[i].contactObj.Id === selectedContactId){
                this.view.wrapper_contactList[i].isEditable = true;
            }
        }
    }

    handleContactEnlineSave(event){
        // handle enline save of contact
        // fetch all the inputed values of partucular id and update into wrapper , call the apex imperative 

        var selectedContactId = event.target.value;
        var data_list = this.template.querySelectorAll(`[data-id="${selectedContactId}"]`);
        var json_string = ''; // store contact to save to the database
        for(let i = 0; i < this.view.wrapper_contactList.length; i++){
            if(this.view.wrapper_contactList[i].contactObj.Id === selectedContactId){
                this.view.wrapper_contactList[i].contactObj.FirstName = data_list[0].value;
                this.view.wrapper_contactList[i].contactObj.LastName = data_list[1].value;
                this.view.wrapper_contactList[i].contactObj.Phone = data_list[2].value;
                this.view.wrapper_contactList[i].contactObj.Email = data_list[3].value;
                json_string = this.view.wrapper_contactList[i];
                break;
            }
        }
        
        // console.log('contact information');
        // console.log(JSON.stringify(json_string));
    
        saveSingleContact({json_string : JSON.stringify(json_string)})
        .then((result)=>{
            // make selected contact non editable after saving the record
            for(let i = 0; i < this.view.wrapper_contactList.length; i++){
                if(this.view.wrapper_contactList[i].contactObj.Id === selectedContactId){
                    this.view.wrapper_contactList[i].isEditable = false;
                    break;
                }
            }
            // check if there is no selected contact after saving this
            // var ok = false;
            // for(let i = 0; i < this.wrapper_contactList.length; i++){
            //     if(this.view.wrapper_contactList[i].isEditable){
            //         ok = true;
            //         break;
            //     }
            // }
            // if(!ok){
            //     this.selected_contact_count = 0;
            //     let element = this.querySelectorAll('[data-id="contact-select"]');
            //     element.forEach((val, index, element) =>{
            //         element[index].checked = false;
            //     });
            // }
        })
        .catch((error)=>{
            alert('Error while saving the record with record id ' + selectedContactId);
            alert(error);
            this.error = error;
        });
    }
    handleSelectedContact(event){
        // var element = this.template.querySelector('[data-id="contact-select"]');
        var selectedContactId = event.target.name;
        var value = event.target.checked;
        console.log('selected contact id ' + selectedContactId);
        console.log('selected value is ' + value);

        for(let i = 0; i < this.view.wrapper_contactList.length; i++){
            if(this.view.wrapper_contactList[i].contactObj.Id === selectedContactId){
                if(value){
                    this.selected_contactList[i].isEditable = true;
                }else{
                    this.selected_contactList[i].isEditable = false;
                }
            }
        }
        console.log('all selected contacts are');
        console.log(JSON.stringify(this.selected_contactList));
    }
    editSelectedContacts(event){
        let cnt = 0;
        for(let i = 0; i < this.selected_contactList.length; i++){ 
            if(this.selected_contactList[i].isEditable){
                cnt ++;
            }
        }
        this.selected_contact_count = cnt;
        if(cnt == 0){
            alert('plase selecte the some check boxes to eidt contacts');
        }else{
            this.view.wrapper_contactList = [];
            this.view.wrapper_contactList = JSON.parse(JSON.stringify(this.selected_contactList));
        }
    }
    saveSelectedContacts(event){
        this.showContactSpinner = true;
        for(let i = 0; i < this.view.wrapper_contactList.length; i++){
            if(this.view.wrapper_contactList[i].isEditable){
                var selectedId = this.view.wrapper_contactList[i].contactObj.Id;
                var data_list = this.template.querySelectorAll(`[data-id="${selectedId}"]`);
                this.view.wrapper_contactList[i].contactObj.FirstName = data_list[0].value;
                this.view.wrapper_contactList[i].contactObj.LastName = data_list[1].value;
                this.view.wrapper_contactList[i].contactObj.Phone = data_list[2].value;
                this.view.wrapper_contactList[i].contactObj.Email = data_list[3].value;
            }
        }

        saveData({jsonString : JSON.stringify(this.view)})
        .then((result)=>{
            // make all the contacts non-editable and unmark all the selected contacts
            for(let i = 0; i < this.view.wrapper_contactList.length; i++){
                this.view.wrapper_contactList[i].isEditable = false;
                this.selected_contactList[i].isEditable = false;
            }
            var element = this.template.querySelectorAll('[data-id="contact-select"]');
            element.forEach((val, index, element) =>{
                element[index].checked = false;
            });
            this.showContactSpinner = false;
            alert('all contacts saved successfully !!!');
        })
        .catch((error)=>{
            this.error = error;
            alert('error while saving all Contacts data');
            this.showContactSpinner = false;
        })
        this.selected_contact_count = 0;

    }
    handleAddNewContact(event){

           // create contacts data with the wrapper format 
        // console.log(JSON.stringify(this.view.wrapper_contactList));
        // var _new_contact = {
        //     "isEditable":false,
        //     "contactObj":{
        //         "attributes":{
        //             "type":"Contact"
        //         },
        //         "FirstName":"Contact65",
        //         "LastName":"Demo901",
        //         "Phone":"91020269232",
        //         "Email":"vickykr26941@gmail.com",
        //         "AccountId": this.recordId
        //     }
        // };


         // create the contact using navigation mixin and stay at current page 
         // refresh the component to see the update data


        this.showContactSpinner = true;
        const defaultValues = encodeDefaultFieldValues({
            AccountId : this.recordId
        });
        console.log('defaults values are');
        console.log(defaultValues);
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new'
                //url : '/lightning/o/Contact/new?count=2&nooverride=1&useRecordTypeCheck=1&navigationLocation=RELATED_LIST'
            },
            state: {
                nooverride: 1,
                useRecordTypeCheck: 1,
                navigationLocation: 'RELATED_LIST',
                backgroundContext: '/lightning/r/Account/'+this.recordId+'/view',
                defaultFieldValues : defaultValues
            } 
        });
        eval("$A.get('e.force:refreshView').fire();");
        this.showContactSpinner = false;
    }

    handleOpportunityEnlineEdit(event){
        // make isEditable true for selected opportunity

        var selectedOpportunityId = event.target.value;
        console.log('selected opportunity id is ' + selectedOpportunityId);
        for(let i = 0; i < this.view.wrapper_opportunityList.length; i++){
            if(this.view.wrapper_opportunityList[i].opportunityObj.Id === selectedOpportunityId){
                this.view.wrapper_opportunityList[i].isEditable = true;
            }
        }
    }
    handleOpportunityEnlineSave(event){
         // find all the input values with the partucular id and call imperative method to update the 
         // opportunity + if there is not isEditalbe opportunity as true then unchek all the checkboxes


        var selectedOpportunityId = event.target.value;
        var data_list = this.template.querySelectorAll(`[data-id="${selectedOpportunityId}"]`);
        var json_string = ''; // store contact to save to the database
        for(let i = 0; i < this.view.wrapper_opportunityList.length; i++){
            if(this.view.wrapper_opportunityList[i].opportunityObj.Id === selectedOpportunityId){
                this.view.wrapper_opportunityList[i].opportunityObj.Name = data_list[0].value;
                this.view.wrapper_opportunityList[i].opportunityObj.StageName = data_list[1].value;
                this.view.wrapper_opportunityList[i].opportunityObj.CloseDate = data_list[2].value;
                this.view.wrapper_opportunityList[i].opportunityObj.Amount = data_list[3].value;
                json_string = this.view.wrapper_opportunityList[i];
                break;
            }
        }
        
        // console.log('contact information');
        // console.log(JSON.stringify(json_string));
    
        saveSingleOpportunity({json_string : JSON.stringify(json_string)})
        .then((result)=>{
            // make selected contact non editable after saving the record
            for(let i = 0; i < this.view.wrapper_opportunityList.length; i++){
                if(this.view.wrapper_opportunityList[i].opportunityObj.Id === selectedOpportunityId){
                    this.view.wrapper_opportunityList[i].isEditable = false;
                    break;
                }
            }
            // let ok = false;
            // for(let i = 0; i < this.view.wrapper_opportunityList.length; i++){
            //     if(this.view.wrapper_opportunityList[i].isEditable){
            //         ok = true;
            //         break;
            //     }
            // }
            // if(!ok){
            //     this.selected_opportunity_count = 0;
            //     let element = this.template.querySelectorAll('[data-id="opportunity-select"');
            //     element.forEach((val, index, element) =>{
            //         element[index].checked = false;
            //     });
            // }
        })
        .catch((error)=>{
            alert('Error while saving the record with record id ' + selectedContactId);
            alert(error);
            this.error = error;
        });
    }
    handleSelectedOpportunity(event){
        // var element = this.template.querySelector('[data-id="contact-select"]');
        var selectedOpportunityId = event.target.name;
        var value = event.target.checked;
        console.log('selected contact id ' + selectedOpportunityId);
        console.log('selected value is ' + value);

        for(let i = 0; i < this.view.wrapper_opportunityList.length; i++){
            if(this.view.wrapper_opportunityList[i].opportunityObj.Id === selectedOpportunityId){
                if(value){
                    this.selected_opportunityList[i].isEditable = true;
                }else{
                    this.selected_opportunityList[i].isEditable = false;
                }
            }
        }
        console.log('all selected contacts are');
        console.log(JSON.stringify(this.selected_opportunityList));
    }
    editSelectedOpportunity(event){
        let cnt = 0;
        for(let i = 0; i < this.selected_opportunityList.length; i++){ 
            if(this.selected_opportunityList[i].isEditable){
                cnt ++;
            }
        }
        this.selected_opportunity_count = cnt;
        if(cnt == 0){
            alert('plase selecte the some check boxes to eidt contacts');
        }else{
            this.view.wrapper_opportunityList = [];
            this.view.wrapper_opportunityList = JSON.parse(JSON.stringify(this.selected_opportunityList));
        }
    }

    saveSelectedOpportunity(event){
        // save all the opportunity by calling imperative call

        this.showOpportunitySpinner = true;
        for(let i = 0; i < this.view.wrapper_opportunityList.length; i++){
            if(this.view.wrapper_opportunityList[i].isEditable){
                var selectedId = this.view.wrapper_opportunityList[i].opportunityObj.Id;
                var data_list = this.template.querySelectorAll(`[data-id="${selectedId}"]`);
                this.view.wrapper_opportunityList[i].opportunityObj.Name = data_list[0].value;
                this.view.wrapper_opportunityList[i].opportunityObj.StageName = data_list[1].value;
                this.view.wrapper_opportunityList[i].opportunityObj.CloseDate = data_list[2].value;
                this.view.wrapper_opportunityList[i].opportunityObj.Amount = data_list[3].value;
            }
        }

        saveData({jsonString : JSON.stringify(this.view)})
        .then((result)=>{
            // make all the contacts non-editable and unmark all the selected contacts
            for(let i = 0; i < this.view.wrapper_opportunityList.length; i++){
                this.view.wrapper_opportunityList[i].isEditable = false;
                this.selected_opportunityList[i].isEditable = false;
            }
            var element = this.template.querySelectorAll('[data-id="opportunity-select"]');
            element.forEach((val, index, element) =>{
                element[index].checked = false;
            });
            this.showOpportunitySpinner = false;
            alert('all opportunity saved successfully !!!');
        })
        .catch((error)=>{
            this.error = error;
            alert('error while saving all Opportuntiy data');
            this.showOpportunitySpinner = false;
        })
        this.selected_opportunity_count = 0;
    }

    handleAddNewOpportunity(event){
        // idea : create contact and navigate to current page and refresh the 
        // component to load updated data

        this.showOpportunitySpinner = true;
        const defaultValues = encodeDefaultFieldValues({
            AccountId : this.recordId
        });
        console.log('defaults values are');
        console.log(defaultValues);
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'new'
            },
            state: {
                nooverride: 1,
                useRecordTypeCheck: 1,
                navigationLocation: 'RELATED_LIST',
                backgroundContext: '/lightning/r/Account/'+this.recordId+'/view',
                defaultFieldValues : defaultValues
            } 
        });
        eval("$A.get('e.force:refreshView').fire();");
        this.showOpportunitySpinner = false;
       
    }
}