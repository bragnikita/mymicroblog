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
    const uri = new URI(relative);
    if (uri.is("absolute")) {
        return uri.toString();
    }
    return uri.path(relative).toString();
}

export function isAbsolute(url) {
    return new URI(url).is("absolute");
}

export function redirectTo(urlOfPath) {
    let target = new URI(urlOfPath);
    if (target.is('relative')) {
        target = new URI().resource(target.resource());
    }
    if (isDomEnv()) {
        window.location.href = target.toString();
    }
}