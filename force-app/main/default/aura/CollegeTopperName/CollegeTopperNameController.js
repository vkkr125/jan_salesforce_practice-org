({
    doInit : function(component, event, helper) {

        var action = component.get('c.getColleges');
        action.setCallback(this,function(responce){
            var status = responce.getState();
            if(status === 'SUCCESS'){
                console.log(responce.getReturnValue());
                component.set('v.collegeList', responce.getReturnValue());
            }else if(status === 'ERROR'){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    },
    getTopper : function(component, event, helper) {
        var action = component.get('c.getTopperStudentName');
        action.setParams({ collegeId : component.get("v.selectedCollegeId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                // alert('seccess');
                console.log(response.getReturnValue());
                console.log(typeof(response.getReturnValue()));
                var data = response.getReturnValue();
                var data_ = data.split('*');
                console.log(data_);
                component.set('v.topperName', data_[0]);
                component.set('v.totalMarks', data_[1]);

            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    }

    
})