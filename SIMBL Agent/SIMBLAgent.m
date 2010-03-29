/**
 * Copyright 2003-2009, Mike Solomon <mas63@cornell.edu>
 * SIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */

#import "SIMBL.h"
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
    SIMBLLogNotice(@"Unable to obtain system version: %ld", (long)err);
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
		SIMBLLogNotice(@"installing into launchd");
		[self loadInLaunchd];
		[NSApp terminate:nil];
	}
	else {
		SIMBLLogInfo(@"agent started");
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
		SIMBLLogNotice(@"launchctl returned %d", [task terminationStatus]);
}

- (void) injectSIMBL:(NSNotification*)notification
{
	// NOTE: if you change the log level externally, there is pretty much no way
	// to know when the changed. Just reading from the defaults doesn't validate
	// against the backing file very ofter, or so it seems.
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];

	NSDictionary* appInfo = [notification userInfo];
	NSString* appName = [appInfo objectForKey:@"NSApplicationName"];
	SIMBLLogInfo(@"%@ started", appName);
	SIMBLLogDebug(@"app start notification: %@", appInfo);
		
	// check to see if there are plugins to load
	if ([SIMBL shouldInstallPluginsIntoApplication:[NSBundle bundleWithPath:[appInfo objectForKey:@"NSApplicationPath"]]] == NO) {
		return;
	}
	
	// BUG: http://code.google.com/p/simbl/issues/detail?id=11
	// NOTE: believe it or not, some applications cause a crash deep in the
	// ScriptingBridge code. Due to the launchd behavior of restarting crashed
	// agents, this is mostly harmless. To reduce the crashing we leave a
	// blacklist to prevent injection.  By default, this is empty.
	NSString* appIdentifier = [appInfo objectForKey:@"NSApplicationBundleIdentifier"];
	NSArray* blacklistedIdentifiers = [defaults stringArrayForKey:@"SIMBLApplicationIdentifierBlacklist"];
	if (blacklistedIdentifiers != nil && 
			[blacklistedIdentifiers containsObject:appIdentifier]) {
		SIMBLLogNotice(@"ignoring injection attempt for blacklisted application %@ (%@)", appName, appIdentifier);
		return;
	}

	SIMBLLogDebug(@"send inject event");
	
	// Get the right event ID for this version of OS X
	unsigned majorOSVersion = 0;
	unsigned minorOSVersion = 0;
	unsigned bugfixOSVersion = 0;
	[NSApp getSystemVersionMajor:&majorOSVersion minor:&minorOSVersion bugFix:&bugfixOSVersion];
	
	if (majorOSVersion != 10) {
		SIMBLLogNotice(@"something fishy - OS X version %u", majorOSVersion);
		return;
	}
	
	AEEventID eventID = minorOSVersion > 5 ? 'load' : 'leop';

	// Find the process to target
	pid_t pid = [[appInfo objectForKey:@"NSApplicationProcessIdentifier"] intValue];
	SBApplication* app = [SBApplication applicationWithProcessIdentifier:pid];
	[app setDelegate:self];
	if (!app) {
		SIMBLLogNotice(@"Can't find app with pid %d", pid);
		return;
	}
	
	// Force AppleScript to initialize in the app, by getting the dictionary
	// When initializing, you need to wait for the event reply, otherwise the
	// event might get dropped on the floor. This is only seems to happen in 10.5
	// but it shouldn't harm anything.
	[app setSendMode:kAEWaitReply | kAENeverInteract | kAEDontRecord];
	id initReply = [app sendEvent:kASAppleScriptSuite id:kGetAEUT parameters:0];

	// the reply here is of some unknown type - it is not an Objective-C object
	// as near as I can tell because trying to print it using "%@" or getting its
	// class both cause the application to segfault. The pointer value always seems
	// to be 0x10000 which is a bit fishy. It does not seem to be an AEDesc struct
	// either.
	// since we are waiting for a reply, it seems like this object might need to
	// be released - but i don't know what it is or how to release it.
	// NSLog(@"initReply: %p '%64.64s'", initReply, (char*)initReply);
	
	// Inject!
	[app setSendMode:kAENoReply | kAENeverInteract | kAEDontRecord];
	id injectReply = [app sendEvent:'SIMe' id:eventID parameters:0];
	if (injectReply != nil) {
		SIMBLLogNotice(@"unexpected injectReply: %@", injectReply);
	}
}

- (void) eventDidFail:(const AppleEvent*)event withError:(NSError*)error
{
	NSDictionary* userInfo = [error userInfo];
	NSNumber* errorNumber = [userInfo objectForKey:@"ErrorNumber"];
	
	// this error seems more common on Leopard
	if (errorNumber && [errorNumber intValue] == errAEEventNotHandled) {
		SIMBLLogDebug(@"eventDidFail:'%4.4s' error:%@ userInfo:%@", (char*)&(event->descriptorType), error, [error userInfo]);
	}
	else {
		SIMBLLogNotice(@"eventDidFail:'%4.4s' error:%@ userInfo:%@", (char*)&(event->descriptorType), error, [error userInfo]);
	}
}
@end


int main(int argc, char *argv[])
{
	return NSApplicationMain(argc, (const char **)argv);
}

