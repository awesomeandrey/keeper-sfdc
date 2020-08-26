import { LightningElement, api, track } from "lwc";
import {
  FlowAttributeChangeEvent,
  FlowNavigationNextEvent
} from "lightning/flowSupport";

export default class SksManualInput extends LightningElement {
  @api secretKey;

  @track visible = false;
  @track loading = false;
  @track isSecretKeyValid = false;

  get controlIconName() {
    return this.visible ? "utility:hide" : "utility:preview";
  }

  get inputType() {
    return this.visible ? "text" : "password";
  }

  handleGenerateBtnClick(event) {
    this.loading = true;
    setTimeout(() => (this.loading = false), 1500);
  }

  handleToggleViewBtnClick(event) {
    this.visible = !this.visible;
  }

  handleNextBtnClick(event) {
    debugger;
  }
}
