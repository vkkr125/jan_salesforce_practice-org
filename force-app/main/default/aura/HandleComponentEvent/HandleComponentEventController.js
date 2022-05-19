({
    handleComponentEvent : function(component, event, helper) {
        var message = event.getParam("message");
        var contactList = event.getParam("contactList");
        var good = event.getParam('good');
        console.log(contactList);

        component.set('v.message', message);
        component.set('v.contactList', contactList);
        component.set('v.good', good);
        var count = parseInt(component.get('v.count'));
        count = count + 1;
        component.set('v.count', count);


    }
})
