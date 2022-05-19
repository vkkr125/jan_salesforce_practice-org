({
    doInit : function(component, event, helper) {
        var action = component.get('c.getAccounts');
        action.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                component.set('v.accountList', responce.getReturnValue());
                console.log(responce.getReturnValue());
            }else{
                console.log('error while fetching the account data');
            }
        });
        $A.enqueueAction(action);
    },
    handleChange : function(cmp,event,helper){
        
        var accountId = cmp.get('v.selectedAccountId');
        console.log(cmp.get('v.selectedAccountId'));
        
        var action = cmp.get('c.getContactsParam');
        action.setParams({accountId : accountId});
        action.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                var contactList = responce.getReturnValue();
                cmp.set('v.contactList', contactList);
                console.log(cmp.get('v.contactList'));
            }else{
                console.log('error while fetching the contact records');
            }
        });
        $A.enqueueAction(action);

        var action2 = cmp.get('c.getOpportunityParam');
        action2.setParams({accountId : accountId});
        action2.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                var opportunityList = responce.getReturnValue();
                cmp.set('v.opportunityList', opportunityList);
            }else{
                console.log('error while fetching the contact records');
            }
        });
        $A.enqueueAction(action2);

    }
})
