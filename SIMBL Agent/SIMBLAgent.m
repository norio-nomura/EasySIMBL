/**
 * Copyright 2003-2009, Mike Solomon <mas63@cornell.edu>
 * SIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */

#import "SIMBLAgent.h"
#import <ScriptingBridge/ScriptingBridge.h>
#import <Carbon/Carbon.h>

@implementation NSApplication (SystemVersion)

- (void)getSystemVersionMajor:(unsigned *)major
                        minor:(unsigned *)minor
                       bugFix:(unsigned *)bugFix;
{
    OSErr err;
    SInt32 systemVersion, versionMajor, versionMinor, versionBugFix;
    if ((err = Gestalt(gestaltSystemVersion, &systemVersion)) != noErr) goto fail;
    if (systemVersion < 0x1040)
    {
        if (major) *major = ((systemVersion & 0xF000) >> 12) * 10 +
            ((systemVersion & 0x0F00) >> 8);
        if (minor) *minor = (systemVersion & 0x00F0) >> 4;
        if (bugFix) *bugFix = (systemVersion & 0x000F);
    }
    else
    {
        if ((err = Gestalt(gestaltSystemVersionMajor, &versionMajor)) != noErr) goto fail;
        if ((err = Gestalt(gestaltSystemVersionMinor, &versionMinor)) != noErr) goto fail;
        if ((err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix)) != noErr) goto fail;
        if (major) *major = versionMajor;
        if (minor) *minor = versionMinor;
        if (bugFix) *bugFix = versionBugFix;
    }
    
    return;
    
fail:
    NSLog(@"Unable to obtain system version: %ld", (long)err);
    if (major) *major = 10;
    if (minor) *minor = 0;
    if (bugFix) *bugFix = 0;
}

@end


@implementation SIMBLAgent

- (void) applicationDidFinishLaunching:(NSNotification*)notificaion
{
	NSProcessInfo* procInfo = [NSProcessInfo processInfo];
	if ([(NSString*)[[procInfo arguments] lastObject] hasPrefix:@"-psn"]) {
		// if we were started interactively, load in launchd and terminate
		NSLog(@"installing into launchd");
		[self loadInLaunchd];
		[NSApp terminate:nil];
	}
	else {
		NSLog(@"initialized");
		[[[NSWorkspace sharedWorkspace] notificationCenter]
				addObserver:self selector:@selector(injectSIMBL:)
				name:NSWorkspaceDidLaunchApplicationNotification object:nil];
	}
}

- (void) loadInLaunchd
{
	NSTask* task = [NSTask launchedTaskWithLaunchPath:@"/bin/launchctl" arguments:[NSArray arrayWithObjects:@"load", @"-F", @"-S", @"Aqua", @"/Library/ScriptingAdditions/SIMBL.osax/Contents/Resources/SIMBL Agent.app/Contents/Resources/net.culater.SIMBL.Agent.plist", nil]];
	[task waitUntilExit];
	if ([task terminationStatus] != 0)
		NSLog(@"launchctl returned %d", [task terminationStatus]);
}

#define SCRIPT_SRC_LEOPARD @"tell application \"%@\"\ninject SIMBL into Leopard\nend tell"
#define SCRIPT_SRC_SNOW_LEOPARD @"tell application \"%@\"\ninject SIMBL into Snow Leopard\nend tell"

- (void) _injectSIMBL:(NSNotification*)notification
{
	/* injectSIMBL in a generic way that works, but it isn't specific to the
	inbound notification. the code below is attempting to be more specific by
	referencing the PSN, but it doesn't actually work.
	*/
	NSLog(@"received %@", [notification userInfo]);
	
	unsigned majorOSVersion = 0;
	unsigned minorOSVersion = 0;
	unsigned buxfixOSVersion = 0;
	[NSApp getSystemVersionMajor:&majorOSVersion minor:&minorOSVersion bugFix:&buxfixOSVersion];
	
	if (majorOSVersion != 10) {
		NSLog(@"something fishy - OS X version %u", majorOSVersion);
	}

	NSString* script_src = nil;
	if (minorOSVersion > 5) {
		script_src = [NSString stringWithFormat:SCRIPT_SRC_SNOW_LEOPARD, 
			[[notification userInfo] objectForKey:@"NSApplicationName"]];
	}
	else {
		script_src = [NSString stringWithFormat:SCRIPT_SRC_LEOPARD, 
			[[notification userInfo] objectForKey:@"NSApplicationName"]];
	}
  NSLog(@"sending %@", script_src);
	NSAppleScript* script = [[NSAppleScript alloc] initWithSource:script_src];
	NSDictionary* errorInfo = nil;
	NSAppleEventDescriptor* reply = [script executeAndReturnError:&errorInfo];
	if (reply == nil)
		NSLog(@"errors %@", errorInfo);
}

- (void) injectSIMBL:(NSNotification*)notification
{
	NSLog(@"received %@", [notification userInfo]);

	// Get the right event ID for this version of OS X
	unsigned majorOSVersion = 0;
	unsigned minorOSVersion = 0;
	unsigned buxfixOSVersion = 0;
	[NSApp getSystemVersionMajor:&majorOSVersion minor:&minorOSVersion bugFix:&buxfixOSVersion];
	
	if (majorOSVersion != 10) {
		NSLog(@"something fishy - OS X version %u", majorOSVersion);
		return;
	}
	AEEventID eventID = minorOSVersion > 5 ? 'load' : 'leop';

	
	// Find the process to target
	pid_t pid = [[[notification userInfo] objectForKey: @"NSApplicationProcessIdentifier"] intValue];
	SBApplication *app = [SBApplication applicationWithProcessIdentifier: pid];
	if (!app) {
		NSLog(@"Can't find app with pid %d", pid);
		return;
	}
	[app setSendMode: kAENoReply];
	
	
	// Force AppleScript to initialize in the app, by getting the dictionary
	[app sendEvent: kASAppleScriptSuite id: kGetAEUT parameters: 0];
	
	// Inject!
	[app sendEvent: 'SIMe' id: eventID parameters: 0];
}

@end
