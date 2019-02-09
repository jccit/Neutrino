//
//  JSEngine.m
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import "JSEngine.h"
#import "JSApp.h"
#import "JSConsole.h"
#import "JSProcess.h"
#import "JSBrowserWindow.h"

NSString * const kJSErrorDomain = @"JSErrorDomain";

@interface JSEngine ()

@property (nonatomic, strong) JSVirtualMachine *jsVM;
@property (nonatomic, strong) NSDictionary *jsModules;
@property (nonatomic, strong) JSApp *jsAppObject;

@property (nonatomic, assign) BOOL inException;

@end

@implementation JSEngine

- (id)init
{
    self = [super init];
    
    self.jsVM = [[JSVirtualMachine alloc] init];
    self.jsContext = [[JSContext alloc] initWithVirtualMachine:self.jsVM];
    
    self.jsAppObject = [[JSApp alloc] init];
    self.jsAppObject.jsEngine = self;
    
    // Setup native js modules
    NSMutableDictionary *modules = [NSMutableDictionary dictionary];
    modules[@"electron"] = @{
                             @"app": self.jsAppObject,
                             @"BrowserWindow": [JSBrowserWindow class]
                             };
    
    self.jsModules = modules;
    
    __block __weak JSEngine *weakSelf = self;
    
    // Global overrides
    self.jsContext[@"require"] = ^(NSString *arg) {
        id module = weakSelf.jsModules[arg];
        return module;
    };
    self.jsContext[@"process"] = [[JSProcess alloc] init];
    self.jsContext[@"console"] = [[JSConsole alloc] init];
    
    return self;
}

- (void)_jsException:(JSValue *)exception {
    NSLog(@"%s, %@", __func__, exception);
    
    if (self.inException) {
        return;
    }
    
    self.inException = YES;
    
    self.lastException = exception.toString;
    self.lastExceptionLine = [exception valueForProperty:@"line"].toInt32;
    
    self.inException = NO;
}

- (BOOL)loadJS:(NSString *)js error:(NSError **)outError {
    [self.jsContext evaluateScript:js];
    
    if (self.lastException) {
        if (outError) {
            *outError = [NSError errorWithDomain:kJSErrorDomain
                                            code:101
                                        userInfo:@{
                                                   NSLocalizedDescriptionKey: self.lastException,
                                                   @"SourceLineNumber": @(self.lastExceptionLine)
                                                   }];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)ready:(NSError **)error
{
    [self.jsAppObject emitReady:error];
}

- (void)emitEvent:(NSString *)event
{
    [self.jsAppObject emitEvent:event];
}

- (NSString *)handleNativeCall:(NSDictionary *)params
{
    JSProcess *proc = self.jsContext[@"process"];
    return proc.versions[@"electron"];
}

@end
