({
    run: function (component, event, helper) {
        return new Promise(((resolve, reject) => {
            const {name: flowName, params} = event.getParam("arguments");
            if (!flowName) reject({message: "Flow name is required in order to launch it."});
            $A.createComponent("lightning:flow", {
                onstatuschange: function (event) {
                    const currentStatus = event.getParam("status");
                    if (currentStatus === "FINISHED") {
                        resolve();
                    } else if (currentStatus === "ERROR") {
                        reject();
                    }
                }
            }, function (flowLauncherCmp, status, error) {
                if (status === "SUCCESS") {
                    component.find("overlayLib").showCustomModal({body: flowLauncherCmp, showCloseButton: true})
                        .then(panel => component.set("v.overlayPanel", panel))
                        .then(() => flowLauncherCmp.startFlow(flowName, params));
                } else {
                    console.error("FlowRunner.cmp", error);
                    reject(error);
                }
            });
        })).then(() => component.get("v.overlayPanel").close());
    }
});