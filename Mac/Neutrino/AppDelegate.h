//
//  AppDelegate.h
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSEngine.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) JSEngine *js;

@end

