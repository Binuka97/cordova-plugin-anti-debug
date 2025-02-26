#import <Cordova/CDV.h>

@interface AntiDebug : CDVPlugin

- (void)isDebugged:(CDVInvokedUrlCommand *)command;
- (void)isDevOptionsEnabled:(CDVInvokedUrlCommand *)command;
- (BOOL)isDebuggerAttached;
- (BOOL)isDeveloperOptionsEnabled;
- (void)preventDebuggerAttach;

@end
