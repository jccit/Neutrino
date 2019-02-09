//
//  JSProcess.h
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JSProcessExports <JSExport>

@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSDictionary *versions;

@end

@interface JSProcess : NSObject<JSProcessExports>

@end

NS_ASSUME_NONNULL_END
