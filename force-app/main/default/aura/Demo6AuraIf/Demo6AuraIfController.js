({
    handleClick : function(component, event, helper) {
        var show_data = component.get('v.truthy');
        component.set('v.truthy', !show_data);
        if(show_data == true){
            component.set('v.buttonlable', 'Show True');
        }else{
            component.set('v.buttonlable', 'Show False');
        }
    }
})