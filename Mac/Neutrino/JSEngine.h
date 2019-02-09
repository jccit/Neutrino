//
//  JSEngine.h
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSEngine : NSObject

@property (nonatomic, strong) JSContext *jsContext;

@property (nonatomic, strong) NSString *lastException;
@property (nonatomic, assign) NSInteger lastExceptionLine;

- (void)ready:(NSError **)error;
- (void)emitEvent:(NSString *)event;

- (BOOL)loadJS:(NSString *)js error:(NSError **)outError;

- (NSString *)handleNativeCall:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
