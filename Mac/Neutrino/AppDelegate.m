//
//  AppDelegate.m
//  Neutrino
//
//  Created by Joe on 28/01/2019.
//  Copyright © 2019 jccit. All rights reserved.
//

#import "AppDelegate.h"
#import "BrowserWindow.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
#ifdef DEBUG
    // Enable devtools
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WebKitDeveloperExtras"];
#endif
    
    // Insert code here to initialize your application
    [[BrowserWindow alloc] initWithWindowNibName:@"BrowserWindow"];
    
    self.js = [[JSEngine alloc] init];
    
    // Load main js
    NSString *appDir =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"app"];
    NSString *mainJSPath = [appDir stringByAppendingPathComponent:@"main.js"];
    NSString *mainJS = [NSString stringWithContentsOfFile:mainJSPath encoding:NSUTF8StringEncoding error:NULL];
    
    self.js.jsContext[@"__dirname"] = appDir;
    
    NSError *error = nil;
    if (![self.js loadJS:mainJS error:&error]) {
        NSLog(@"JS Execution failed: %@", error);
        
        [NSApp terminate:nil];
    }
    
    [self.js ready:&error];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [self.js emitEvent:@"window-all-closed"];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.js emitEvent:@"activate"];
    return YES;
}

@end
