import {api, LightningElement, track} from "lwc";
import {FlowAttributeChangeEvent, FlowNavigationBackEvent, FlowNavigationNextEvent} from "lightning/flowSupport";
import {debounce, parseError} from "c/commons";
import toastify from "c/toastify";

// Apex;
import validateSecretKeyApex from '@salesforce/apex/SKSController.validateSecretKey';

export default class SksManualInput extends LightningElement {
    @api secretKey;

    @track visible = false;
    @track loading = false;
    @track hasChanges = false;
    @track hasRendered = false;

    get labels() {
        return {
            title: "Create Secret Key",
            stepOneText: "Step #1",
            secretKeyDetailsText: "Secret key should be 19 bit size. You can also generate one by clicking button below.",
            secretKeyText: "Secret Key",
            typeHereText: "Type here...",
            clearBtn: "Clear",
            nextBtn: "Next",
            backBtn: "Back",
            secretKeyValidText: "Good",
            secretKeyInvalidText: "The input is not valid",
        };
    }

    get controlIconName() {
        return this.visible ? "utility:hide" : "utility:preview";
    }

    get inputType() {
        return this.visible ? "text" : "password";
    }

    get disableNextBtn() {
        return !this.isInputValid || this.loading;
    }

    get showStatus() {
        return !this.loading && this.hasChanges;
    }

    get inputElement() {
        return this.template.querySelector("lightning-input");
    }

    get isInputValid() {
        if (this.inputElement) {
            return this.inputElement.checkValidity();
        }
        return false;
    }

    debouncedValidateSecretKeyAndAssign = debounce(this.validateSecretKeyAndAssign.bind(this), 1000);

    // Component lifecycle hooks;

    renderedCallback() {
        if (!this.hasRendered) {
            this.hasRendered = true;
            this.inputElement.setCustomValidity("Secret Key should not be empty!");
        }
    }

    // Event handlers;

    handleClearBtnClick(event) {
        event.preventDefault();
        if (this.hasChanges === false) {
            this.hasChanges = true;
        }
        this.secretKey = "";
        this.inputElement.focus();
    }

    handleInputChange(event) {
        const value = event.target.value || "";
        if (!value.trim()) {
            this.inputElement.setCustomValidity("Secret Key should not be empty!");
        } else {
            this.debouncedValidateSecretKeyAndAssign(value);
        }
    }

    handleToggleViewBtnClick(event) {
        event.preventDefault();
        this.visible = !this.visible;
    }

    handleInputBlur(event) {
        event.preventDefault();
        if (this.hasChanges === false) {
            this.hasChanges = true;
        }
        this.inputElement.reportValidity();
    }

    handleNextBtnClick(event) {
        if (!this.isInputValid) {
            toastify.warning({message: "Provide valid Secret Key!"});
            return;
        }
        const attributeChangeEvent = new FlowAttributeChangeEvent('SecretKey', this.secretKey);
        this.dispatchEvent(attributeChangeEvent);
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    handleBackBtnClick(event) {
        event.preventDefault();
        const attributeChangeEvent = new FlowAttributeChangeEvent('SecretKey', "");
        this.dispatchEvent(attributeChangeEvent);
        const flowEvent = new FlowNavigationBackEvent();
        this.dispatchEvent(flowEvent);
    }

    // Core logic;

    async validateSecretKeyAndAssign(value) {
        this.loading = true;
        await this.validateSecretKey(value);
        this.loading = false;
        this.secretKey = value;
    }

    async validateSecretKey(value) {
        try {
            await validateSecretKeyApex({rawSecretKey: value});
            this.inputElement.setCustomValidity("");
        } catch (error) {
            const {message} = parseError(error);
            this.inputElement.setCustomValidity(message);
        } finally {
            this.inputElement.reportValidity();
        }
    }
}