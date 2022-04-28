({
    doInit : function(component, event, helper) {
        var action = component.get('c.getAccounts');
        action.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                // console.log(responce.getReturnValue());
                component.set('v.accountList', responce.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        var action2 = component.get('c.getPickListValuesIntoList');
        action2.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                // console.log(responce.getReturnValue());
                component.set('v.oppStageList', responce.getReturnValue());
            }
        });
       
        $A.enqueueAction(action2);
    }, 
    onAccountSelected : function(component, event, helper) {
        var action = component.get('c.getdata');
        action.setParams({accountId : component.get('v.selectedAccountId')});
        action.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){

                var responce_obj = JSON.parse(responce.getReturnValue());
                component.set('v.view', responce_obj);
                // console.log(responce_obj);
            }
        });
        $A.enqueueAction(action);

    },

    // call on checkbox value change
    onContactCheck : function(component, event, helper) {
        var selected_id = event.getSource().get('v.name');
        var contact_list = component.get('v.view.wrapper_contactList');
        var temp_contact_list = [];
        for(let i = 0; i < contact_list.length; i++){
            if(contact_list[i].contactObj.Id === selected_id){
                if(contact_list[i].isEditable){
                    contact_list[i].isEditable = false;
                }else{
                    contact_list[i].isEditable = true;
                }
            }
            temp_contact_list.push(contact_list[i]);
        }
        component.set('v.check_list', temp_contact_list);
    },
    hadleAllEditContact :  function(component, event,helper) {
        helper.handleEditContact(component,event);
    },
    handleAllSaveContact : function(component, event, helper) {
        var contactList = component.get('v.view.wrapper_contactList');
        var action = component.get('c.saveData');
        action.setParams({jsonString : JSON.stringify(component.get('v.view'))});

        action.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                console.log('hello save all');

                var temp_contactList = [];
                for(let i = 0; i<contactList.length; i++){
                    if(contactList[i].isEditable){
                       contactList[i].isEditable = false;
                    }
                    temp_contactList.push(contactList[i]);
                }
                var check_box_list = component.find('checkbox');
                for(let i = 0; i<check_box_list.length; i++){
                    if(check_box_list[i].get('v.value')){
                        check_box_list[i].set('v.value', false);
                    }
                }
                component.set('v.view.wrapper_contactList', temp_contactList);
                component.set('v.editcontact', false);
            }else{
                console.log('error in saving contact data');
            }
        });
        $A.enqueueAction(action);
    },
    handleSingleSave : function(component, event,helper){

        var json_data = '';
        var selected_id = event.getSource().get('v.name');
        var contactList = component.get('v.view.wrapper_contactList');
        for(let i = 0; i < contactList.length; i++){
            if(contactList[i].contactObj.Id === selected_id){
                json_data = JSON.stringify(contactList[i]);
                break;
            }
        }
        var action  = component.get('c.saveSingleContact');
        action.setParams({json_string : json_data});
        action.setCallback(this,function(responce){
            var state = responce.getState();

            var _temp_contact_list = [];
            if(state === 'SUCCESS'){
                // console.log('hello ');
                for(let i = 0; i<contactList.length; i++){
                    if(contactList[i].contactObj.Id === selected_id){
                        contactList[i].isEditable = false;
                        contactList[i].contactObj.Id = responce.getReturnValue();
                    }
                    _temp_contact_list.push(contactList[i]);
                }
                var check_box_list = component.find('checkbox');
                for(let i = 0; i<check_box_list.length; i++){
                    if(check_box_list[i].get('v.value') && check_box_list[i].get('v.name') === selected_id){
                        check_box_list[i].set('v.value', false);
                        break;
                    }
                }
                var checked_box = 0;
                component.set('v.view.wrapper_contactList', _temp_contact_list);
                for(let i = 0; i<check_box_list.length; i++){
                    if(check_box_list[i].get('v.value')){
                        checked_box ++;
                    }
                }
                if(!checked_box){
                    component.set('v.editcontact', false);
                }
            }else{
                console.log('error in saving the contact record');
            }
        });
        $A.enqueueAction(action);
    },
    addNewContact : function(component,event,helper){
        // console.log('Hello ' + JSON.stringify(component.get('v.view')));

        component.set('v.editcontact', true);
        var _new_contact = {
            "isEditable": true,
            "contactObj":{
                "attributes":{
                    "type":"Contact",
                },
                "FirstName":"",
                "LastName":"",
                "Phone":"",
                "Email":"",
                "AccountId": component.get('v.selectedAccountId')
            }
        };
        
        var _contact_list = component.get('v.view.wrapper_contactList');
        // console.log(_contact_list);
        // console.log(JSON.stringify(_contact_list));
        _contact_list.push(_new_contact);
        component.set('v.view.wrapper_contactList',_contact_list);
    },
    on_opportunity_check : function(cmp,event,helper){

        var selected_id = event.getSource().get('v.name');
        var opportunity_list = cmp.get('v.view.wrapper_opportunityList');


        var _temp_opportunity_list = [];
        for(let i = 0; i<opportunity_list.length; i++){
            if(opportunity_list[i].opportunityObj.Id === selected_id){
                if(opportunity_list[i].isEditable){
                    opportunity_list[i].isEditable = false;
                }else{
                    opportunity_list[i].isEditable = true;
                }
            }
            _temp_opportunity_list.push(opportunity_list[i]);
        }
        cmp.set('v.opp_check_list', _temp_opportunity_list);
    },
    hadleAllEditOpportunity : function(cmp,event,helper){
        var check_box_list = cmp.find('oppcheckbox');
        var checked_opportunity_list = cmp.get('v.opp_check_list');

        cmp.set('v.editopportunity', true);
        var selected_opp_count = 0;
        for(let i = 0; i < check_box_list.length; i++){
            if(check_box_list[i].get('v.value')){
                selected_opp_count ++;
            }
        }
        if(!selected_opp_count){
            alert('Please Select Opportunity To Edit');
            cmp.set('v.editopportunity', false);
            return;
        }
        cmp.set('v.view.wrapper_opportunityList', checked_opportunity_list);

    },
    handleAllSaveOpportunity : function(cmp,event,helper){
        var opportunityList = cmp.get('v.view.wrapper_opportunityList');
        var action = cmp.get('c.saveData');
        action.setParams({jsonString : JSON.stringify(cmp.get('v.view'))});
        action.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                // console.log('hello save all');

                var temp_opportunityList = [];
                for(let i = 0; i<opportunityList.length; i++){
                    if(opportunityList[i].isEditable){
                       opportunityList[i].isEditable = false;
                    }
                    temp_opportunityList.push(opportunityList[i]);
                }
                var check_box_list = cmp.find('oppcheckbox');
                for(let i = 0; i<check_box_list.length; i++){
                    if(check_box_list[i].get('v.value')){
                        check_box_list[i].set('v.value', false);
                    }
                }
                cmp.set('v.view.wrapper_opportunityList', temp_opportunityList);
                cmp.set('v.editopportunity', false);
            }else{
                console.log('error in saving contact data');
            }
        });
        $A.enqueueAction(action);
    },
    handleSingleOppSave : function(component, event,helper){

        var json_data = '';
        var selected_id = event.getSource().get('v.name');
        var opportunityList = component.get('v.view.wrapper_opportunityList');
        for(let i = 0; i < opportunityList.length; i++){
            if(opportunityList[i].opportunityObj.Id === selected_id){
                json_data = JSON.stringify(opportunityList[i]);
                break;
            }
        }
        var action  = component.get('c.saveSingleOpportunity');
        action.setParams({json_string : json_data});
        action.setCallback(this,function(responce){
            var state = responce.getState();

            var _temp_opportunity_list = [];
            if(state === 'SUCCESS'){
                // console.log('hello ');
                for(let i = 0; i<opportunityList.length; i++){
                    if(opportunityList[i].opportunityObj.Id === selected_id){
                        opportunityList[i].isEditable = false;
                        opportunityList[i].opportunityObj.Id = responce.getReturnValue();
                    }
                    _temp_opportunity_list.push(opportunityList[i]);
                }
                var check_box_list = component.find('oppcheckbox');
                for(let i = 0; i<check_box_list.length; i++){
                    if(check_box_list[i].get('v.value') && check_box_list[i].get('v.name') === selected_id){
                        check_box_list[i].set('v.value', false);
                        break;
                    }
                }
                var checked_box = 0;
                component.set('v.view.wrapper_opportunityList', _temp_opportunity_list);
                for(let i = 0; i<check_box_list.length; i++){
                    if(check_box_list[i].get('v.value')){
                        checked_box ++;
                    }
                }
                if(!checked_box){
                    component.set('v.editopportunity', false);
                }
            }else{
                console.log('error in saving the contact record');
            }
        });
        $A.enqueueAction(action);
    },
    addNewOpportunity : function(cmp,event,helper){
        console.log(JSON.stringify(cmp.get('v.view')));

        cmp.set('v.editopportunity', true);
        var _new_opportunity = {
            "opportunityObj":{
                "attributes":{
                    "type":"Opportunity",
                },
                "Name":"",
                "StageName":"",
                "Amount": "",
                "CloseDate":"",
                "AccountId": cmp.get('v.selectedAccountId'),
            },
            "isEditable": true
        };

        var _temp_opportunity_list = cmp.get('v.view.wrapper_opportunityList');
        _temp_opportunity_list.push(_new_opportunity);
        cmp.set('v.view.wrapper_opportunityList', _temp_opportunity_list);

    },

    searchopportunity: function(cmp,event,helper){
        console.log(cmp.get('v.opportunity_search_value'));
    },
    searchcontact : function(cmp,event,helper){
        console.log(cmp.get('v.contact_search_value'));
    }

})

