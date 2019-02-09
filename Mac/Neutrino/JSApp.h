//
//  JSApp.h
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSEngine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JSAppExports <JSExport>

JSExportAs(on, - (void)on:(NSString *)event withCallback:(JSValue *)cb);
- (void)quit;

@end

@interface JSApp : NSObject <JSAppExports>

- (BOOL)emitReady:(NSError **)outError;
- (void)emitEvent:(NSString *)event;

@property (nonatomic, weak) JSEngine *jsEngine;

@end

NS_ASSUME_NONNULL_END
