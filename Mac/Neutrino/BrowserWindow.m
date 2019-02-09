//
//  BrowserWindow.m
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import "BrowserWindow.h"

@interface BrowserWindow ()

@property (strong) IBOutlet WKWebView *webView;
@property (strong) NSWindow *window;

@end

@implementation BrowserWindow

- (instancetype)initAsResizable:(BOOL)resizable hasFrame:(BOOL)hasFrame
{
    NSWindowStyleMask styleMask = 0;
    if (resizable) {
        styleMask |= NSWindowStyleMaskResizable;
    }
    if (hasFrame) {
        styleMask |= NSWindowStyleMaskClosable;
        styleMask |= NSWindowStyleMaskTitled;
        styleMask |= NSWindowStyleMaskMiniaturizable;
    }
    
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(100, 100, 640, 480)
                                                   styleMask:styleMask
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    
    self.window.opaque = NO;
    self.window.hasShadow = YES;
    self.window.ignoresMouseEvents = NO;
    self.window.allowsConcurrentViewDrawing = YES;
    self.window.releasedWhenClosed = NO;
    self.window.title = @"Neutrino";
    
    [self.window setDelegate:self];
    
    WKWebViewConfiguration *wkConfig = [[WKWebViewConfiguration alloc] init];
    
#ifdef DEBUG
    [wkConfig.preferences setValue:@YES forKey:@"developerExtrasEnabled"];
#endif
    
    // Inject runtime script
    NSString *runtimePath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"runtime.js"];
    NSString *runtimeSrc = [NSString stringWithContentsOfFile:runtimePath encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *runtime = [[WKUserScript alloc] initWithSource:runtimeSrc injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
    [contentController addUserScript:runtime];
    
    wkConfig.userContentController = contentController;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.window.contentView.frame configuration:wkConfig];
    
    [webView setNavigationDelegate:self];
    [webView setUIDelegate:self];
    
    self.window.contentView = webView;
    self.webView = webView;
    
    return [self initWithWindow:self.window];
}

- (void) loadURL:(NSURL *)url {
    if (url.isFileURL) {
        NSString *dir = [url.path stringByDeletingLastPathComponent];
        NSURL *baseURL = [NSURL fileURLWithPath:dir isDirectory:YES];
        
        [self.webView loadFileURL:url allowingReadAccessToURL:baseURL];
    }
}

- (void) loadFile:(NSString *)path {
    if (![path hasPrefix:@"http"]) {
        NSString *appDir =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"app"];
        NSString *fullPath = [appDir stringByAppendingPathComponent:path];
        NSURL *url = [NSURL fileURLWithPath:fullPath];
        
        [self loadURL:url];
    }
}

- (void)setDelegate:(id<BrowserWindowDelegate>)theDelegate
{
    delegate = theDelegate;
}

- (BOOL)windowShouldClose:(NSWindow *)sender
{
    [delegate onClose];
    return YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.window setTitle:[self.webView title]];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    NSString *prefix = @"neutrinoBridge:";
    if ([prompt hasPrefix:prefix]) {
        NSString *jsonStr = [prompt substringFromIndex:[prefix length]];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        if (!error) {
            NSDictionary *results = object;
            NSLog(@"Request: %@", [results objectForKey:@"request"]);
            
            completionHandler([delegate handleNativeCall:results]);
        } else {
            completionHandler(defaultText);
        }
    } else {
        completionHandler(defaultText);
    }
}

@end
