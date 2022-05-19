({
    doInIt : function(component, event, helper) {
        var action = component.get('c.getContacts');
        action.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                component.set('v.contactList', responce.getReturnValue());
            }else{
                console.log('error while loading the data');
            }
        });
        $A.enqueueAction(action);
    },
    handleClick : function(component,event,helper){
        // pass the data to the child component 
        component.find('auramessage').sampleMethod('message from parent to child : vicky', component.get('v.contactList'));
    }
})
