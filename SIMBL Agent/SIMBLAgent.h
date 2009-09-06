/**
 * Copyright 2003-2009, Mike Solomon <mas63@cornell.edu>
 * SIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */

#import <Cocoa/Cocoa.h>

@interface NSApplication (SystemVersion)

- (void)getSystemVersionMajor:(unsigned *)major
                        minor:(unsigned *)minor
                       bugFix:(unsigned *)bugFix;

@end


@interface SIMBLAgent : NSObject {
}

- (void) applicationDidFinishLaunching:(NSNotification*)notification;
- (void) loadInLaunchd;
- (void) injectSIMBL:(NSNotification*)notification;

@end
