({
    afterRender: function (component, helper) {
        this.superAfterRender();
        $A.enqueueAction(component.get("c.subscribe"));
    }
});