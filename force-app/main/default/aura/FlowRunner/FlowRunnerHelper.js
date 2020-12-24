({
    // Constants;
    FlowAuraId: "dynamicFlowRuntimeId",
    // Utility functions;
    destroyFlow: function (component) {
        const flowComponent = component.find(this.FlowAuraId);
        if (flowComponent && flowComponent.isValid()) {
            flowComponent.destroy();
        }
    },
    /**
     * Core API
     *
     * @param component - host component reference
     * @param parameters - {name:[FLOW API NAME], inputVariables: [FLOW INPUT VARIABLES]}
     * @return {Promise}
     */
    launchFlow: function (component, parameters) {
        return new Promise((resolve, reject) => {
            const {name: flowName, inputVariables} = parameters;
            if (!flowName) {
                // `flowName` is required parameter;
                reject({message: "Flow API name is not provided!"});
            }
            // Dynamically instantiate Flow component;
            $A.createComponent(
                "lightning:flow",
                // Define Flow component properties;
                {
                    "aura:id": this.FlowAuraId,
                    "onstatuschange": event => {
                        const currentStatus = event.getParam("status");
                        if (currentStatus === "FINISHED") {
                            // Collect altered output variables;
                            const outputVariables = (event.getParam("outputVariables") || [])
                                .reduce((_, variable) => Object.assign(_, {[variable.name]: variable.value}), {});
                            // Destroy dynamically created Flow component;
                            this.destroyFlow(component);
                            // Resolve Promise;
                            resolve(outputVariables);
                        } else if (currentStatus === "ERROR") {
                            const error = event.getParam("error");
                            console.error("FlowRunner.cmp", error);
                            // Reject Promise;
                            reject(error);
                        }
                    },
                },
                (flowComponent, status, error) => {
                    if (status === "SUCCESS") {
                        component.find("overlayLib")
                            .showCustomModal({
                                body: flowComponent,
                                showCloseButton: true,
                                closeCallback: () => {
                                    const flowComponent = component.find(this.FlowAuraId);
                                    if (flowComponent && flowComponent.isValid()) {
                                        // Destroy dynamically created Flow component;
                                        flowComponent.destroy();
                                        // Resolve promise with empty output variables;
                                        resolve({});
                                    }
                                }
                            })
                            .then(panel => {
                                // Persist reference to modal object;
                                component.set("v.overlayPanel", panel);
                            })
                            .then(() => {
                                // Launch Flow;
                                flowComponent.startFlow(flowName, inputVariables);
                            });
                    } else {
                        console.error("FlowRunner.cmp", error);
                        reject(error);
                    }
                }
            );
        }).then(outputVariables => {
            // Close modal;
            component.get("v.overlayPanel").close();
            // Return Flow output variables;
            return outputVariables;
        });
    }
});