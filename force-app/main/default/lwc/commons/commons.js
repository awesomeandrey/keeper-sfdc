export const uniqueId = () => {
    let array = new Uint32Array(8);
    window.crypto.getRandomValues(array);
    let str = '';
    for (let i = 0; i < array.length; i++) {
        str += (i < 2 || i > 5 ? '' : '-') + array[i].toString(16).slice(-4);
    }
    return str;
}

export const wait = (callback) => {
    setTimeout(callback, 0);
}

export const pipe = (...functions) => (args) => functions.reduce((arg, fn) => fn(arg), args);

export const parseError = (error) => {
    if (typeof error === "string") {
        return {message: error};
    } else {
        const serializedDetails = error.body.message || "{}";
        const {context, stackTrace, message, type} = JSON.parse(serializedDetails);
        return {title: `${type} - ${context}`, message};
    }
}

export const debounce = (func, wait) => {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            timeout = null;
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
};