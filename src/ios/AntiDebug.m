#import "AntiDebug.h"
#import <sys/sysctl.h>
#import <dlfcn.h>
#import <stdio.h>

@implementation AntiDebug

- (void)pluginInitialize {
    [self preventDebuggerAttach];
}

// Cordova Method to Check if Debugger is Attached
- (void)isDebugged:(CDVInvokedUrlCommand *)command {
    BOOL debugged = [self isDebuggerAttached];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:debugged];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

// Cordova Method to Check if Developer Options are Enabled
- (void)isDevOptionsEnabled:(CDVInvokedUrlCommand *)command {
    BOOL devEnabled = [self isDeveloperOptionsEnabled];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:devEnabled];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

// Check if debugger is attached
- (BOOL)isDebuggerAttached {
    int mib[4];
    struct kinfo_proc info;
    size_t size = sizeof(info);

    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();

    if (sysctl(mib, 4, &info, &size, NULL, 0) == -1) {
        return NO;
    }

    return (info.kp_proc.p_flag & P_TRACED) != 0;
}

// Prevent debugger from attaching
- (void)preventDebuggerAttach {
    void *handle = dlopen(0, RTLD_NOW);
    if (handle) {
        int (*ptrace_ptr)(int, int, void*, int) = dlsym(handle, "ptrace");
        if (ptrace_ptr) {
            ptrace_ptr(31, 0, 0, 0);  // PT_DENY_ATTACH
        }
        dlclose(handle);
    }
}

// Check if Developer Options are enabled (iOS equivalent)
- (BOOL)isDeveloperOptionsEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"NSUserDefaults.standardUserDefaults"];
}

@end
