//
//  JSBrowserWindow.h
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "BrowserWindow.h"
#import "JSEngine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JSBrowserWindowExports <JSExport>

- (instancetype)initWithOptions:(NSDictionary *)opts;

- (void)loadURL:(NSString *)url;
- (void)loadFile:(NSString *)path;

- (BOOL)isVisible;
- (void)show;
- (void)hide;
- (void)focus;

- (void)sendEvent:(NSString *)name;

JSExportAs(on,
           - (void)on:(NSString *)event withCallback:(JSValue *)cb
           );

JSExportAs(once,
           - (void)once:(NSString *)event withCallback:(JSValue *)cb
           );

@end

@interface JSBrowserWindow : NSObject<JSBrowserWindowExports, BrowserWindowDelegate>

@property (nonatomic, strong) BrowserWindow *windowController;

@end

NS_ASSUME_NONNULL_END
