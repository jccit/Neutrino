//
//  JSConsole.h
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JSConsoleExports <JSExport>

@property (nonatomic, copy) void (^log)(NSString *str);

@end

@interface JSConsole : NSObject <JSConsoleExports>

@end

NS_ASSUME_NONNULL_END
