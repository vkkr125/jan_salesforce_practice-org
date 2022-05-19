({
    doInIt : function(cmp,event,helper){
        var action = cmp.get('c.getContacts');
        action.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
               cmp.set('v.contactList', responce.getReturnValue());
            //    console.log(cmp.get('v.contactList'));
            }else{
                console.log('error while loading contact data');
            }
        });
        $A.enqueueAction(action);
    },
    handleClick : function(component, event, helper) {
        
        var cmpEvent = component.getEvent('componentEvent');
        cmpEvent.setParams({
            message : "Message From Child Component",
            contactList : component.get('v.contactList'),
            good : false
        });
        cmpEvent.fire();
    }
})
