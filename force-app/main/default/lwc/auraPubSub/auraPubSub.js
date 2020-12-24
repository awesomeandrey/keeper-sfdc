import {api, LightningElement, wire} from "lwc";
import {CurrentPageReference} from "lightning/navigation";
import {APPLICATION_EVENTS, fireEvent, registerListener, unregisterAllListeners, unregisterListener} from "c/pubSub";

export default class AuraPubSub extends LightningElement {
    @api registerEvent;

    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        if (!this.pageRef) return;
        this.registerListener(this.registerEvent, this.handleEvent.bind(this));
    }

    handleEvent(data) {
        this.dispatchEvent(new CustomEvent("callback", {detail: {payload: data}}));
    }

    @api
    registerListener(eventName, callback) {
        registerListener(eventName, callback, this);
    }

    disconnectedCallback() {
        this.unregisterAllListeners();
    }

    @api
    unregisterListener(eventName, callback) {
        unregisterListener(eventName, callback, this);
    }

    @api
    unregisterAllListeners() {
        unregisterAllListeners(this);
    }

    @api
    fireEvent(eventName, data) {
        fireEvent(this.pageRef, eventName, data);
    }

    @api
    applicationEvents() {
        return APPLICATION_EVENTS;
    }
}
