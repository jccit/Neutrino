//
//  JSApp.m
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import "JSApp.h"

@interface JSApp ()

@property (nonatomic, strong) NSMutableDictionary *eventCallbacks;

@end

@implementation JSApp

- (id)init
{
    self = [super init];
    
    self.eventCallbacks = [NSMutableDictionary dictionary];
    
    return self;
}

- (void)on:(NSString *)event withCallback:(JSValue *)cb {
    if (event.length > 0 && cb) {
        NSMutableArray *cbArr = self.eventCallbacks[event] ?: [NSMutableArray array];
        [cbArr addObject:cb];
        
        self.eventCallbacks[event] = cbArr;
    }
}

- (BOOL)emitReady:(NSError **)outError
{
    self.jsEngine.lastException = nil;
    
    for (JSValue *cb in self.eventCallbacks[@"ready"]) {
        //NSLog(@"%s, %@", __func__, cb);
        
        [cb callWithArguments:@[]];
        
        if (self.jsEngine.lastException) {
            if (outError) {
                *outError = [NSError errorWithDomain:@"JSAppError"
                                                code:102
                                            userInfo:@{
                                                       NSLocalizedDescriptionKey: self.jsEngine.lastException,
                                                       @"SourceLineNumber": @(self.jsEngine.lastExceptionLine),
                                                       }];
            }
            return NO;
        }
    }
    return YES;
}

- (void)emitEvent:(NSString *)event
{
    for (JSValue *cb in self.eventCallbacks[event]) {
        [cb callWithArguments:@[]];
    }
}

- (void)quit
{
    [self emitEvent:@"window-all-closed"];
    [[NSApplication sharedApplication] terminate:nil];
}

@end
