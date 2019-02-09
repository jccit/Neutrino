//
//  JSProcess.m
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import "JSProcess.h"

@interface JSProcess ()

@end

@implementation JSProcess

@synthesize platform;
@synthesize versions;

- (id)init
{
    self = [super init];
    
    NSOperatingSystemVersion os = [[NSProcessInfo processInfo] operatingSystemVersion];
    
    self.platform = @"darwin";
    
    self.versions = @{
                      @"electron": @"0.0.1-neutrino",
                      @"neutrino": @"0.0.1",
                        @"chrome": @"0.0.1",
                          @"node": @"0.0.1"
                      };
    
    return self;
}
@end
