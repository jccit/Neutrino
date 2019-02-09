//
//  JSConsole.m
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import "JSConsole.h"

@implementation JSConsole

@synthesize log;

- (id)init
{
    self = [super init];
    
    self.log = ^(NSString *str){
        NSArray *args = [JSContext currentArguments];
        
        if (args.count > 1) {
            NSString *argsStr = [[args subarrayWithRange:NSMakeRange(1, args.count - 1)] componentsJoinedByString:@", "];
            str = [str stringByAppendingFormat:@" %@", argsStr];
        }
        
        NSLog(@"JS:  %@", str);
    };
    
    return self;
}

@end
