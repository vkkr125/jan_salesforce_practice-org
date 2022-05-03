({
    doInit : function(component, event, helper) {
        var action = component.get("c.getStudents");
        var action2 = component.get('c.getCourses');
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
               component.set('v.studentList', response.getReturnValue());  
            }
            else if(state === 'ERROR'){
                alert('student data error');
            }
        });
        $A.enqueueAction(action);
        action2.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                component.set('v.courseList', responce.getReturnValue());
            }
            else if(state === 'ERROR'){
                alert('course data error');
            }
        });
        $A.enqueueAction(action2);
    }
})