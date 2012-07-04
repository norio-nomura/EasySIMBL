/**
 * Copyright 2012, Norio Nomura
 * EasySIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */

#import <ServiceManagement/SMLoginItem.h>
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize loginItemBundleIdentifier=_loginItemBundleIdentifier;

@synthesize window = _window;
@synthesize useSIMBL = _useSIMBL;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSError *error = nil;
    NSString *loginItemsPath = [[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Library/LoginItems"];
    NSArray *loginItems = [[[NSFileManager defaultManager]contentsOfDirectoryAtPath:loginItemsPath error:&error]
                           pathsMatchingExtensions:[NSArray arrayWithObject:@"app"]];
    if (error) {
        NSLog(@"contentsOfDirectoryAtPath error:%@", error);
    } else if (![loginItems count]) {
        NSLog(@"no loginItems found at %@", loginItemsPath);
    } else {
        NSString *loginItemPath = [loginItemsPath stringByAppendingPathComponent:[loginItems objectAtIndex:0]];
        self.loginItemBundleIdentifier = [[NSBundle bundleWithPath:loginItemPath]bundleIdentifier];
    }
    if (self.loginItemBundleIdentifier) {
        NSArray *runningApplications = [NSRunningApplication runningApplicationsWithBundleIdentifier:self.loginItemBundleIdentifier];
        if (runningApplications ) {
            self.useSIMBL.state = [runningApplications count] ? NSOnState : NSOffState;
        }
    } else {
        [self.useSIMBL setEnabled:NO];
    }
}

- (IBAction)toggleUseSIMBL:(id)sender {
    NSInteger result = self.useSIMBL.state;

    CFStringRef bundleIdentifeierRef = (__bridge CFStringRef)self.loginItemBundleIdentifier;
    if (!SMLoginItemSetEnabled(bundleIdentifeierRef, self.useSIMBL.state == NSOnState)) {
        self.useSIMBL.state = self.useSIMBL.state == NSOnState ? NSOffState : NSOnState;
        NSLog(@"SMLoginItemSetEnabled() failed!");
    }
    self.useSIMBL.state = result;
}
@end
