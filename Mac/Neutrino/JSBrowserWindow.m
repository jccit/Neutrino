//
//  JSBrowserWindow.m
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import "JSBrowserWindow.h"
#import "JSProcess.h"

@interface JSBrowserWindow ()

@property (nonatomic, strong) NSMutableDictionary *eventCallbacks;
@property (nonatomic, strong) NSMutableDictionary *singleEventCallbacks;

@end

@implementation JSBrowserWindow

- (instancetype)initWithOptions:(NSDictionary *)opts
{
    self = [super init];
    
    self.eventCallbacks = [NSMutableDictionary dictionary];
    self.singleEventCallbacks = [NSMutableDictionary dictionary];
    
    id val;
    BOOL resizable = YES;
    BOOL hasFrame = YES;
    BOOL show = YES;
    
    self.windowController = [[BrowserWindow alloc] initAsResizable:resizable hasFrame:hasFrame];
    
    [self.windowController setDelegate:self];
    
    NSWindow *win = self.windowController.window;
    NSRect frame = win.frame;
    bool frameChanged = NO;
    bool frameMoved = NO;
    if ((val = opts[@"width"]) && [val integerValue] > 0) {
        frame.size.width = [val doubleValue];
        frameChanged = YES;
    }
    if ((val = opts[@"height"]) && [val integerValue] > 0) {
        frame.size.height = [val doubleValue];
        frameChanged = YES;
    }
    if ((val = opts[@"x"]) && [val integerValue] > 0) {
        frame.origin.x = [val doubleValue];
        frameMoved = YES;
    }
    if ((val = opts[@"y"]) && [val integerValue] > 0) {
        frame.origin.y = [val doubleValue];
        frameMoved = YES;
    }
    if ((val = opts[@"show"])) {
        show = [val boolValue];
    }
    
    [win setFrame:frame display:YES];
    
    if (frameChanged && !frameMoved) {
        [win center];
    }
    
    if (show) {
        [self show];
    }
    
    return self;
}

- (void)on:(NSString *)event withCallback:(JSValue *)cb {
    if (event.length > 0 && cb) {
        NSMutableArray *cbArr = self.eventCallbacks[event] ?: [NSMutableArray array];
        [cbArr addObject:cb];
        
        self.eventCallbacks[event] = cbArr;
    }
}

- (void)once:(NSString *)event withCallback:(JSValue *)cb {
    if (event.length > 0 && cb) {
        NSMutableArray *cbArr = self.singleEventCallbacks[event] ?: [NSMutableArray array];
        [cbArr addObject:cb];
        
        self.singleEventCallbacks[event] = cbArr;
    }
}

- (void)show
{
    [self.windowController showWindow:nil];
}

- (void)hide
{
    [self.windowController.window orderOut:nil];
}

- (void)focus
{
    [self.windowController.window makeKeyWindow];
}

- (void)loadURL:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [self.windowController loadURL:url];
}

- (void)loadFile:(NSString *)path
{
    [self.windowController loadFile:path];
}

- (BOOL)isVisible {
    return self.windowController.window.visible;
}

- (void)sendEvent:(NSString *)name
{
    for (JSValue *cb in self.eventCallbacks[name]) {
        [cb callWithArguments:@[]];
    }
    
    for (JSValue *cb in self.singleEventCallbacks[name]) {
        [cb callWithArguments:@[]];
        [self.singleEventCallbacks[name] removeObject:cb];
    }
}

- (void)onClose
{
    [self sendEvent:@"closed"];
}

- (NSString *)handleNativeCall:(NSDictionary *)params
{
    if ([[params objectForKey:@"request"] isEqual:@"process"]) {
        JSProcess *process = [[JSProcess alloc] init];
        
        if ([[params objectForKey:@"array"] isEqual:@"versions"]) {
            return [[process versions] objectForKey:[params objectForKey:@"item"]];
        }
    } else if ([[params objectForKey:@"request"] isEqual:@"BrowserWindow"]) {
        NSString *eventName = [params objectForKey:@"call"];
        if (eventName) {
            [self sendEvent:eventName];
        }
    }
        
    return @"";
}

@end
