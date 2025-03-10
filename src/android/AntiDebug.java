package com.example.antidebug;

import android.content.Context;
import android.provider.Settings;
import android.os.Debug;
import android.util.Log;
import android.system.Os;
import android.system.OsConstants;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CordovaInterface;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class AntiDebug extends CordovaPlugin {

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        preventDebuggerAttach();
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("isDebugged")) {
            callbackContext.success(isDebuggerAttached() ? 1 : 0);
            return true;
        } else if (action.equals("isDevOptionsEnabled")) {
            callbackContext.success(isDevOptionsEnabled() ? 1 : 0);
            return true;
        }
        return false;
    }

    private boolean isDebuggerAttached() {
        return Debug.isDebuggerConnected() || Debug.waitingForDebugger() || detectTracerPid();
    }

    private void preventDebuggerAttach() {
        try {
            Os.ptrace(OsConstants.PT_DENY_ATTACH, 0, 0, 0);
        } catch (Exception e) {
            Log.e("AntiDebug", "Failed to prevent debugger attach", e);
        }
    }

    private boolean detectTracerPid() {
        try (BufferedReader reader = new BufferedReader(new FileReader("/proc/self/status"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("TracerPid:")) {
                    int tracerPid = Integer.parseInt(line.split("\\s+")[1]);
                    return tracerPid > 0;
                }
            }
        } catch (IOException e) {
            Log.e("AntiDebug", "Error reading TracerPid", e);
        }

        return detectTamperedMemory();
    }

    private boolean detectTamperedMemory() {
        try (BufferedReader reader = new BufferedReader(new FileReader("/proc/self/maps"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains("frida") || line.contains("gdb") || line.contains("ptrace")) {
                    Log.w("AntiDebug", "Memory tampering detected!");
                    return true;
                }
            }
        } catch (IOException e) {
            Log.e("AntiDebug", "Error reading memory maps", e);
        }
        return false;
    }

    private boolean isDevOptionsEnabled() {
        Context context = cordova.getActivity().getApplicationContext();
        int devOptionsEnabled = 0;
        int adbEnabled = 0;

        try {
            devOptionsEnabled = Settings.Secure.getInt(
                context.getContentResolver(),
                Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0
            );
        } catch (Exception e) {
            Log.e("AntiDebug", "Error checking Developer Options", e);
        }

        try {
            adbEnabled = Settings.Global.getInt(
                context.getContentResolver(),
                Settings.Global.ADB_ENABLED, 0
            );
        } catch (Exception e) {
            Log.e("AntiDebug", "Error checking ADB status", e);
        }

        return devOptionsEnabled != 0 || adbEnabled != 0;
    }
}
