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

#pragma mark User defaults

+ (void)initialize {
    NSMutableDictionary *initialValues = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:2],@"SIMBLLogLevel", nil];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:initialValues];
}

#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSError *error = nil;
    NSString *loginItemsPath = [[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Library/LoginItems"];
    NSArray *loginItems = [[[NSFileManager defaultManager]contentsOfDirectoryAtPath:loginItemsPath error:&error]
                           pathsMatchingExtensions:[NSArray arrayWithObject:@"app"]];
    NSString *loginItemBundleVersion = nil;
    if (error) {
        NSLog(@"contentsOfDirectoryAtPath error:%@", error);
    } else if (![loginItems count]) {
        NSLog(@"no loginItems found at %@", loginItemsPath);
    } else {
        NSString *loginItemPath = [loginItemsPath stringByAppendingPathComponent:[loginItems objectAtIndex:0]];
        NSBundle *loginItemBundle = [NSBundle bundleWithPath:loginItemPath];
        self.loginItemBundleIdentifier = [loginItemBundle bundleIdentifier];
        loginItemBundleVersion = [loginItemBundle objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    }
    if (self.loginItemBundleIdentifier && loginItemBundleVersion) {
        NSArray *runningApplications = [NSRunningApplication runningApplicationsWithBundleIdentifier:self.loginItemBundleIdentifier];
        
        NSInteger state = NSOffState;
        if ([runningApplications count]) {
            state = NSOnState;
            for (NSRunningApplication *app in runningApplications) {
                NSString *runningBundleVersion = [[NSBundle bundleWithURL:[app bundleURL]]objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
                
                // if running agent's bundle version is different from my bundle, need restart agent from my bundle.
                if (![loginItemBundleVersion isEqualToString:runningBundleVersion]) {
                    CFStringRef bundleIdentifeierRef = (__bridge CFStringRef)self.loginItemBundleIdentifier;
                    [self.useSIMBL setEnabled:NO];
                    state = NSOffState;
                    [app addObserver:self forKeyPath:@"isTerminated" options:NSKeyValueObservingOptionNew context:(__bridge_retained void*)app];
                    if (!SMLoginItemSetEnabled(bundleIdentifeierRef, NO)) {
                        NSLog(@"SMLoginItemSetEnabled(YES) failed!");
                    }
                }
            }
        }
        self.useSIMBL.state = state;
    } else {
        [self.useSIMBL setEnabled:NO];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

#pragma mark NSKeyValueObserving Protocol

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isTerminated"]) {
        [object removeObserver:self forKeyPath:keyPath];
        [self.useSIMBL setEnabled:YES];
        CFRelease((CFTypeRef)context);
    }
}

#pragma mark IBAction

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
