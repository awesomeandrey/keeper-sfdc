import {LightningElement, api} from "lwc";
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from "lightning/flowSupport";

// Constants
const FLOW_ATTRIBUTE_NAME = "DoEnterSecretKeyManually";

export default class SksInitiation extends LightningElement {
    @api doEnterSecretKeyManually = false;

    handleManualEntryClick(event) {
        event.preventDefault();
        this.doEnterSecretKeyManually = true;
        this.next();
    }

    handleGenerateBySystemClick(event) {
        event.preventDefault();
        this.doEnterSecretKeyManually = false;
        this.next();
    }

    next() {
        this.dispatchEvent(new FlowAttributeChangeEvent(FLOW_ATTRIBUTE_NAME, this.doEnterSecretKeyManually));
        this.dispatchEvent(new FlowNavigationNextEvent());
    }
}
