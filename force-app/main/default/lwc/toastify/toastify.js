import {ShowToastEvent} from "lightning/platformShowToastEvent";

const Mode = {
    DISMISSABLE: "dismissable",
    PESTER: "pester",
    STICKY: "sticky"
};

const Variant = {
    INFO: "info",
    SUCCESS: "success",
    WARNING: "warning",
    ERROR: "error"
};

function success({message, mode, title}) {
    showToast(!title ? "Success" : title, message, Variant.SUCCESS, mode);
}

function info({message, mode, title}) {
    showToast(!title ? "Info" : title, message, Variant.INFO, mode);
}

function warning({message, mode, title}) {
    showToast(!title ? "Warning" : title, message, Variant.WARNING, mode);
}

function error({message, mode, title}) {
    showToast(!title ? "Error" : title, message, Variant.ERROR, mode);
}

function showToast(title, message, variant, mode) {
    if (!mode) {
        mode = Mode.DISMISSABLE;
    }

    const event = new ShowToastEvent({
        title,
        message,
        variant,
        mode
    });
    dispatchEvent(event);
}

export default {success, info, warning, error};