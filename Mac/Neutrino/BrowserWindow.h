//
//  BrowserWindow.h
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BrowserWindowDelegate <NSObject>

- (void)onClose;
- (NSString *) handleNativeCall:(NSDictionary *)params;

@end

@interface BrowserWindow : NSWindowController<NSWindowDelegate, WKNavigationDelegate, WKUIDelegate> {
    id<BrowserWindowDelegate> delegate;
}

- (void)setDelegate:(id<BrowserWindowDelegate>)delegate;

- (instancetype)initAsResizable:(BOOL)resizable hasFrame:(BOOL)hasFrame;

- (void)loadURL:(NSURL *)url;
- (void)loadFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
