({
    doInit: function (component, event, helper) {
        component.set("v.isDesignMode", helper.isDesignMode());
    }
});