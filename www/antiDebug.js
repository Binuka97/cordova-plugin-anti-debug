var exec = require('cordova/exec');

var AntiDebug = {
    isDebugged: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "AntiDebug", "isDebugged", []);
    },
    isDevOptionsEnabled: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "AntiDebug", "isDevOptionsEnabled", []);
    }
};

module.exports = AntiDebug;
