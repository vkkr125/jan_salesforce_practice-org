({
    fireAlert: function (message, type) {
        const evt = $A.get("e.c:AlertEvent");
        evt.setParams({
            message: message,
            alertType: type
        });
        evt.fire();
    }
})