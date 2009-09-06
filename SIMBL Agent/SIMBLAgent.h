//
//  SIMBLAgent.h
//  SIMBL Agent
//
//  Created by Mike Solomon on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
