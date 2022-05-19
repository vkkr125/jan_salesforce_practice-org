({
    doInit : function(cmp, event, helper) {
        // get total students
        // start = 0, page_size = 5, end = 5, paginationList = 5 students
        // studentList = total students 

        var action = cmp.get("c.getTotalStudents");
        action.setCallback(this,function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                var studentList = responce.getReturnValue();
                var paginationList = [];
                for(let i = 0; i<Math.min(5, studentList.length); i++){
                    paginationList.push(studentList[i]);
                }
                cmp.set('v.paginationList', paginationList);
                cmp.set('v.studentList', studentList);
                cmp.set('v.page_size', 5);
                cmp.set('v.start', 0);
                cmp.set('v.end', 5);
                cmp.set('v.total_size', studentList.length);
            }else{
                console.log('smothing wen wrong in get total students');
            }
        });
        $A.enqueueAction(action);
    },
    onselect: function(cmp, event, helper) {
        var selected_page_size = cmp.find('records').get('v.value');
        
        var studentList = cmp.get('v.studentList');
        var paginationList = [];
        for(let i = 0; i<Math.min(selected_page_size, studentList.length); i++){
            paginationList.push(studentList[i]);
        }
        cmp.set('v.start', 0);
        cmp.set('v.end', selected_page_size);
        cmp.set('v.page_size', selected_page_size);
        cmp.set('v.paginationList', paginationList);

    },
    next :function(cmp, event, helper) {
        // start = end, end = end + page_size

        var start = parseInt(cmp.get('v.start'));
        var end = parseInt(cmp.get('v.end'));
        var page_size = parseInt(cmp.get('v.page_size'));
        console.log(start);
        console.log(end);


        start = end;
        end = end + page_size;
        var paginationList = [];
        var studentList = cmp.get('v.studentList');
        for(let i = start; i < Math.min(end, studentList.length); i++){
            paginationList.push(studentList[i]);
        }
        cmp.set('v.start', start);
        cmp.set('v.end', end);
        cmp.set('v.paginationList', paginationList);

    },
    previous : function(cmp, event, helper) {
        // start = start - page_size
        // end = start
        var start = parseInt(cmp.get('v.start'));
        var end = parseInt(cmp.get('v.end'));
        var page_size = parseInt(cmp.get('v.page_size'));

        end = start;
        start = start - page_size;
        var studentList = cmp.get('v.studentList');
        var paginationList = [];
        if(start >= 0){
            for(let i = start; i < Math.min(end, studentList.length); i++){
                paginationList.push(studentList[i]);
            }
        }
        cmp.set('v.start', start);
        cmp.set('v.end', end);
        cmp.set('v.paginationList', paginationList);
    },
    first : function(cmp, event, helper) {

        // start = 0, end = page_size
        var page_size = parseInt(cmp.get('v.page_size')); 
        var studentList = cmp.get('v.studentList');
        var paginationList = [];
        for(let i = 0; i < Math.min(page_size, studentList.length); i++){
            paginationList.push(studentList[i]);
        }
        cmp.set('v.paginationList', paginationList);
        cmp.set('v.start', 0);
        cmp.set('v.end', page_size);

    },
    last : function(cmp, event, helper) {
        // records in last page   x = total_size % page_size
        // start = total_size - x
        // end = total_size

        var studentList = cmp.get('v.studentList');
        var paginationList = [];
        var total_size = cmp.get('v.total_size');
        var page_size = cmp.get('v.page_size');
        var lst_rec = total_size % page_size;

        for(let i = total_size - lst_rec; i < total_size; i++){
            paginationList.push(studentList[i]);
        }
        cmp.set('v.paginationList', paginationList);
        cmp.set('v.start', total_size - lst_rec);
        cmp.set('v.end', total_size);

        
    },
    // implementing searching functionality
    findData : function(cmp,evnt,helper){
        var search_message = cmp.get('v.searchinput').toUpperCase();
        // searching as substring 
        if(search_message.length > 0){
            var studentList = cmp.get('v.studentList');
            var filtered_data = [];
            if(studentList.length > 0 && studentList != undefined){
                for(let i = 0; i<studentList.length; i++){
                    var student_name = studentList[i].Name.toUpperCase();
                    if(search_message.length > student_name.length) continue;
                    // substring searchign algorithm
                    var ok = false;
                    let n = student_name.length, m = search_message.length;
                    for(let j = 0; j<=(n - m); j++){
                        let k = 0;
                        for(k = 0; k<m; k++){
                            if(student_name[j + k] != search_message[k]){
                                ok = false;
                                break;
                            }
                        }
                        if(k === m){
                            filtered_data.push(studentList[i]);
                        }
                    }
                }
            }
            
            console.log(filtered_data);
            if(filtered_data.length >= 0 && filtered_data != undefined){
                cmp.set('v.searchList', filtered_data);
                var input_buttons = cmp.find('input1');
                input_buttons.forEach(function(ele, idx){
                    $A.util.addClass(input_buttons[idx],'show');
                });
            }
        }else{
            // remove css class
            cmp.set('v.searchList', []);
            var input_buttons = cmp.find('input1');
            input_buttons.forEach(function(ele,idx){
                $A.util.removeClass(input_buttons[idx], 'show');
            });
        }
        console.log(search_message);
    }


})



// facet , 