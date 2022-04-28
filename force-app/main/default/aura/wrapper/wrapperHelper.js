({
    handleEditContact : function(component,event) {
        component.set('v.editcontact', true);

        // take all contacts those have been selected
        var contactList = component.get('v.check_list'); 
        var check_box_list = component.find('checkbox');
        var selected_box_count = 0;
        for(let i = 0; i<check_box_list.length; i++){
            if(check_box_list[i].get('v.value')){
                selected_box_count ++;
            }
        }
        if(!selected_box_count){
            alert('please select the contact rows to edit');
            component.set('v.editcontact', false);
            return;
        }
        component.set('v.view.wrapper_contactList', contactList);
    }
})