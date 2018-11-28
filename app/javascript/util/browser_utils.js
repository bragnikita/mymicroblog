import URI from 'urijs';

export function isDomEnv() {
    return !!(window && document);
}

export function copyToClipboard(str) {
    if (!isDomEnv()) {
        return Promise.resolve();
    }
    return new Promise(function(resolve, reject) {
        let success = false;
        function listener(e) {
            e.clipboardData.setData("text/plain", str);
            e.preventDefault();
            success = true;
        }
        document.addEventListener("copy", listener);
        document.execCommand("copy");
        document.removeEventListener("copy", listener);
        success ? resolve(): reject();
    });
}

export function urlAbsolutize(relative) {
    return new URI().path(relative).toString();
}