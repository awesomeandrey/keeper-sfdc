({
    doInit: function (component, event, helper) {
        // TODO - placeholder for component init;
    },
    // Called once after component has been rendered (see custom `renderer`);
    subscribe: function (component, event, helper) {
        // Subscribe to specific event;
        const pubSub = component.find("pubSub");
        const APP_EVENTS = pubSub.applicationEvents();
        const handlerFunction = params => {
            helper.launchFlow(component, params)
                .then(outputVariables => {
                    if (typeof params.onfinish === "function") {
                        params.onfinish(outputVariables);
                    }
                })
                .catch(error => {
                    // TODO - toastify
                    console.error("FlowRunner.cmp", JSON.stringify(error));
                });
        };
        component.set("v.handlerFunction", handlerFunction);
        pubSub.registerListener(APP_EVENTS.RunFlow, handlerFunction);
    },
    // Imperatively launch Flow from Aura context;
    run: function (component, event, helper) {
        const params = event.getParams("arguments");
        return helper.launchFlow(component, params);
    }
});
