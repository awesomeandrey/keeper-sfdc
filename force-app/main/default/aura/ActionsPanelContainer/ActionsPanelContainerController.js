({
    handleRunFlow: function (component, event, helper) {
        const flowApiName = event.getParam("name");
        component.find("flowRunner").run(flowApiName).then(() => {
            // Post processing logic here;
        });
    }
});