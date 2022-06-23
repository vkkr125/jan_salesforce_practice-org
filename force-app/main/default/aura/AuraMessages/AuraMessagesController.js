({
    handleRecivedData : function(component, event, helper) {
        var data = event.getParam('arguments');
        if(data){
            var message = data.message;
            var contactList = data.contactList;
            component.set('v.message', message);
            component.set('v.contact_list', contactList);


            console.log(message);
            component.set('v.message', message);
        }
    }
})