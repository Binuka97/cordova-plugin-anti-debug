#import "AntiDebug.h"
#import <sys/sysctl.h>
#import <sys/types.h>
#import <sys/ptrace.h>
#import <dlfcn.h>
#import <unistd.h>

@implementation AntiDebug

- (void)pluginInitialize {
    [self preventDebuggerAttach];
}

// Cordova Method: Check if Debugger is Attached
- (void)isDebugged:(CDVInvokedUrlCommand *)command {
    BOOL debugged = [self isDebuggerAttached];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:debugged];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

// Cordova Method: Check if Developer Options are Enabled
- (void)isDevOptionsEnabled:(CDVInvokedUrlCommand *)command {
    BOOL devEnabled = [self isDeveloperModeEnabled];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:devEnabled];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

// 🔍 Detect if Debugger is Attached
- (BOOL)isDebuggerAttached {
    int mib[4];
    struct kinfo_proc info;
    size_t size = sizeof(info);

    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();

    info.kp_proc.p_flag = 0;

    if (sysctl(mib, 4, &info, &size, NULL, 0) == -1) {
        return NO;
    }

    return (info.kp_proc.p_flag & P_TRACED) != 0;
}

// 🔒 Prevent Debugger from Attaching
- (void)preventDebuggerAttach {
    ptrace(PT_DENY_ATTACH, 0, 0, 0);
}

// 🚨 Detect Developer Mode (More Reliable)
- (BOOL)isDeveloperModeEnabled {
    int32_t result = 0;
    size_t size = sizeof(result);
    int mib[2] = {CTL_KERN, KERN_PROC};

    if (sysctl(mib, 2, &result, &size, NULL, 0) != -1) {
        return result != 0;
    }

    return NO;
}

@end
