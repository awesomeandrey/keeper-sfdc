import {LightningElement, track, wire} from "lwc";
import {getFieldValue, getRecord, getRecordNotifyChange} from "lightning/uiRecordApi";
import {CurrentPageReference} from "lightning/navigation";
import {APPLICATION_EVENTS, fireEvent} from "c/pubSub";
import toastify from "c/toastify";

import CurrentUserId from "@salesforce/user/Id";

import KEEPER_SECRET_KEY from "@salesforce/schema/User.KeeperSecretKey__c";
import HAS_SECRET_KEY_CONFIGURED from "@salesforce/schema/User.HasSecretKeyConfigured__c";

export default class ActionsPanel extends LightningElement {
    @track userId = CurrentUserId;
    @track hasSecretKeyConfigured = false;

    @wire(CurrentPageReference) pageRef;

    get secretKeyStatusVariant() {
        return this.hasSecretKeyConfigured ? "success" : "warning";
    }

    @wire(getRecord, {recordId: "$userId", fields: [KEEPER_SECRET_KEY, HAS_SECRET_KEY_CONFIGURED]})
    wireUserInfo({data, error}) {
        if (data) {
            // TODO - wire service is not reactive to data modifications initiated at backend;
            this.hasSecretKeyConfigured = getFieldValue(data, HAS_SECRET_KEY_CONFIGURED);
        }
    }

    handleSetupSecretKey(event) {
        event.preventDefault();
        if (this.hasSecretKeyConfigured) {
            toastify.info({message: "Secret key has already been created."});
        } else {
            const flowApiName = "SecretKeySetup"; // Hardcoded Flow API name;
            fireEvent(this.pageRef, APPLICATION_EVENTS.RunFlow, {
                name: flowApiName, onfinish: outputVariables => {
                    getRecordNotifyChange([{recordId: this.userId}]);
                }
            });
        }
    }

    handleCreateCredential(event) {
        event.preventDefault();
        if (this.hasSecretKeyConfigured) {
            // TODO - launch another flow;
            toastify.error({message: "UNDER CONSTRUCTION"});
        } else {
            toastify.warning({message: "First, you have to generate Secret Key to encrypt data with."});
        }
    }
}