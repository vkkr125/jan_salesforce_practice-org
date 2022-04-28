({
    doInit : function(component, event, helper) {
        var data = {
            FirstName : 'vicky',
            LastName : 'kumar',
            Email : 'vickykr26941@gmail.com'
        }
        component.set('v.mystring', 'Vicky Kumar Tiwar');
        component.set('v.jsObject', data);
        component.set('v.myCustomeWrapper', {FirstName : 'vicky kumar', Email : 'vickykr125@gmail.com'});
        

        console.log(component.get('v.mystring'));
    }
})