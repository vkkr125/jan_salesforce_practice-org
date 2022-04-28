({
    findToppers : function(component, event, helper) {

        component.set('v.showSpinner', true);
        var action = component.get("c.getToppers");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var keys = Object.keys(data);
               
                var stud_data_list = [];
                for(let i = 0; i<keys.length; i++){
                    var stud_data = { };

                    stud_data.Id = keys[i];
                    stud_data.College_Name = data[keys[i]][0];
                    stud_data.Student_Name = data[keys[i]][1];
                    stud_data.Total_Marks =  data[keys[i]][2];
                    stud_data_list.push(stud_data);
                }
                component.set('v.student_data',stud_data_list);
                console.log(stud_data_list);


            } else if (state === "INCOMPLETE") {
                console.log('Getting Topper Data Incomplete');
            }
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);


    }
})