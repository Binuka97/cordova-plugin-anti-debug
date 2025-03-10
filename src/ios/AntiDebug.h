#import <Cordova/CDV.h>

@interface AntiDebug : CDVPlugin

- (void)pluginInitialize;  // Added for proper initialization
- (void)isDebugged:(CDVInvokedUrlCommand *)command;
- (void)isDevOptionsEnabled:(CDVInvokedUrlCommand *)command;
- (BOOL)isDebuggerAttached;
- (BOOL)isDeveloperModeEnabled;  // Fixed incorrect method name
- (void)preventDebuggerAttach;

@end
