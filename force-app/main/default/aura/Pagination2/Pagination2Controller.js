({
    doInit : function(cmp, event, helper) {
        cmp.set('v.page_size', 5);
        cmp.set('v.offset', 5);
        cmp.set('v.start', 0);
        cmp.set('v.end', 5);

        var total_size = 0;

        // get total number of students
        var temp_action = cmp.get('c.countOfStudents');
        temp_action.setCallback(this,function(response){
            var state =  response.getState();
            if (state === "SUCCESS"){
                total_size = response.getReturnValue();
                cmp.set('v.totalSize', total_size);
        
            }else if(state === 'INCOMPLETE'){
                console.log('find total students :-> incomplete');
            }else if(state === 'ERROR'){
                console.log('find total students :-> error');
            }
        });

        $A.enqueueAction(temp_action);
        // get first 5 students
        var action = cmp.get("c.getStudent");
        action.setParams({start_row : 0, end_row:5});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var returened_value = response.getReturnValue();
                var paginationList = [];
                for (var i = 0; i < returened_value.length; i++) {
                    paginationList.push(returened_value[i]);
                }
                cmp.set('v.paginationList', paginationList);
                // console.log(paginationList);
            }else if(state === 'INCOMPLETE'){
                console.log('get students :-> incomplete');
            }else if(state === 'ERROR'){
                console.log('get students :-> error');
            }
        });
        $A.enqueueAction(action);
    },

    onSelectChange : function(cmp, event, helper) {

        var selected_value = cmp.find('record').get('v.value');
        var action = cmp.get('c.getStudent');
        action.setParams({start_row:0, end_row : selected_value});
        action.setCallback(this, function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                var paginationList = responce.getReturnValue();
                // console.log(paginationList);

                cmp.set('v.page_size',selected_value);
                cmp.set('v.start', 0);
                cmp.set('v.end', selected_value);
                cmp.set('v.paginationList', paginationList);

            }else if(state === 'INCOMPLETE'){
                console.log('get students :-> incomplete');
            }else if(state === 'ERROR'){
                console.log('get students :-> error');
            }
        });

        $A.enqueueAction(action);
    },

    next : function(cmp, event, helper) {
        
        // cmp.set('v.paginationList', []);
        var start = cmp.get('v.start');
        var end = parseInt(cmp.get('v.end'));
        var page_size = parseInt(cmp.get('v.page_size'));

        var action = cmp.get('c.getStudent');
        action.setParams({start_row: end, end_row : page_size});
        action.setCallback(this, function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                var paginationList = responce.getReturnValue();
                // console.log(paginationList);

                cmp.set('v.paginationList', paginationList);
                cmp.set('v.start', end);
                cmp.set('v.end', end + page_size);

            }else if(state === 'INCOMPLETE'){
                console.log('get students :-> incomplete');
            }else if(state === 'ERROR'){
                console.log('get students :-> error');
            }
        });
        $A.enqueueAction(action);

    },

    first: function(cmp, event, helper) {

        var page_size = cmp.get('v.page_size');
        var action = cmp.get('c.getStudent');
        action.setParams({start_row: 0, end_row : page_size});
        action.setCallback(this, function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                var paginationList = responce.getReturnValue();
                // console.log(paginationList);

                cmp.set('v.paginationList', paginationList);
                cmp.set('v.start', 0);
                cmp.set('v.end', page_size);

            }else if(state === 'INCOMPLETE'){
                console.log('get students :-> incomplete');
            }else if(state === 'ERROR'){
                console.log('get students :-> error');
            }
        });
        $A.enqueueAction(action);

    },
    previous: function(cmp, event, helper) {

        // start - end : page-size: 5
        // 20 - 25 // 15 - 20
        // start =  start - page_size;
        // end = start;

        var start = cmp.get('v.start');
        var end = cmp.get('v.end');
    
        var page_size = cmp.get('v.page_size');
        var action = cmp.get('c.getStudent');
        start = start - page_size;
        end = start;
    

        action.setParams({start_row: start, end_row : page_size});
        action.setCallback(this, function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                var paginationList = responce.getReturnValue();
                // console.log(paginationList);

                cmp.set('v.paginationList', paginationList);
                cmp.set('v.start', start);
                cmp.set('v.end', end);

            }else if(state === 'INCOMPLETE'){
                console.log('get students :-> incomplete');
            }else if(state === 'ERROR'){
                console.log('get students :-> error');
            }
        });
        $A.enqueueAction(action);

    },

    last: function(cmp, event, helper) {

        // total records in last page : x =  total_size % page_size
        // start = end - x

        var total_size = cmp.get('v.totalSize');
        var page_size = cmp.get('v.page_size');
        var last_records = total_size % page_size;
        var start = total_size - last_records;

        var action = cmp.get('c.getStudent');
        action.setParams({start_row: start, end_row : page_size});
        action.setCallback(this, function(responce){
            var state = responce.getState();
            if(state === 'SUCCESS'){
                var paginationList = responce.getReturnValue();
                // console.log(paginationList);

                cmp.set('v.paginationList', paginationList);
                cmp.set('v.start', start);
                cmp.set('v.end', total_size);

            }else if(state === 'INCOMPLETE'){
                console.log('get students :-> incomplete');
            }else if(state === 'ERROR'){
                console.log('get students :-> error');
            }
        });
        $A.enqueueAction(action);

        
    },



})