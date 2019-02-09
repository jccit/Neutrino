function nativeCall(props) {
    const params = "neutrinoBridge:" + JSON.stringify(props);
    return prompt(params);
}

var process = {
    versions: {
        get node() {
            return nativeCall({ request: 'process', array: 'versions', item: 'node' });
        },
        get chrome() {
            return nativeCall({ request: 'process', array: 'versions', item: 'chrome' });
        },
        get electron() {
            return nativeCall({ request: 'process', array: 'versions', item: 'electron' });
        },
    }
}

window.onload = () => {
    nativeCall({ request: 'BrowserWindow', call: 'ready-to-show' });
};
