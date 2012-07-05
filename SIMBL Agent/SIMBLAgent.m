/**
 * Copyright 2003-2009, Mike Solomon <mas63@cornell.edu>
 * SIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */
/**
 * Copyright 2012, Norio Nomura
 * EasySIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */

#import <ScriptingBridge/ScriptingBridge.h>
#import <Carbon/Carbon.h>
#import "SIMBL.h"
#import "SIMBLAgent.h"

@implementation SIMBLAgent

@synthesize waitingInjectionNumber=_waitingInjectionNumber;
@synthesize scriptingAdditionsPath=_scriptingAdditionsPath;
@synthesize osaxPath=_osaxPath;
@synthesize linkedOsaxPath=_linkedOsaxPath;
@synthesize applicationSupportPath=_pluginsPath;

#pragma NSApplicationDelegate Protocol

- (void) applicationDidFinishLaunching:(NSNotification*)notificaion
{
    SIMBLLogInfo(@"agent started");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES);
    NSString *libraryPath = (NSString*)[paths objectAtIndex:0];
    self.scriptingAdditionsPath = [libraryPath stringByAppendingPathComponent:SIMBLScriptingAdditionsPath];
    self.osaxPath = [[NSBundle mainBundle]pathForResource:SIMBLBundleBaseName ofType:SIMBLBundleExtension];
    self.linkedOsaxPath = [self.scriptingAdditionsPath stringByAppendingPathComponent:SIMBLBundleName];
    self.waitingInjectionNumber = 0;
    self.applicationSupportPath = [libraryPath stringByAppendingPathComponent:SIMBLApplicationSupportPath];
    
    [[NSDistributedNotificationCenter defaultCenter]addObserver:self
                                                       selector:@selector(receiveSIMBLHasBeenLoadedNotification:)
                                                           name:SIMBLHasBeenLoadedNotification
                                                         object:nil];
    
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    [[workspace notificationCenter] addObserver:self
                                       selector:@selector(applicationLaunched:)
                                           name:NSWorkspaceDidLaunchApplicationNotification object:nil];
    
    // inject into resumed applications
    for (NSRunningApplication *appInfo in [workspace runningApplications]) {
        [self injectSIMBL:appInfo];
    }
}

#pragma mark SBApplicationDelegate Protocol

- (id) eventDidFail:(const AppleEvent *)event withError:(NSError *)error;
{
    return nil;
}

#pragma mark NSWorkspaceDidLaunchApplicationNotification

- (void) applicationLaunched:(NSNotification*)notification
{
	[self injectSIMBL:[[notification userInfo]objectForKey:NSWorkspaceApplicationKey]];
}

#pragma mark SIMBLHasBeenLoadedNotification

- (void) receiveSIMBLHasBeenLoadedNotification:(NSNotification*)notification
{
    SIMBLLogDebug(@"receiveSIMBLHasBeenLoadedNotification from %@", notification.object);
	self.waitingInjectionNumber--;
    if (!self.waitingInjectionNumber) {
        NSError *error = nil;
        [[NSFileManager defaultManager]removeItemAtPath:self.linkedOsaxPath error:&error];
        if (error) {
            SIMBLLogNotice(@"removeItemAtPath error:%@",error);
        }
    }
    [self injectSandboxedBundleidentifier:notification.object enabled:NO];
    [[NSProcessInfo processInfo]enableSuddenTermination];
}

#pragma mark -

- (void) injectSIMBL:(NSRunningApplication *)appInfo
{
	// NOTE: if you change the log level externally, there is pretty much no way
	// to know when the changed. Just reading from the defaults doesn't validate
	// against the backing file very ofter, or so it seems.
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];

	NSString* appName = [appInfo localizedName];
	SIMBLLogInfo(@"%@ started", appName);
	SIMBLLogDebug(@"app start notification: %@", appInfo);
		
	// check to see if there are plugins to load
	if ([SIMBL shouldInstallPluginsIntoApplication:[NSBundle bundleWithURL:[appInfo bundleURL]]] == NO) {
		return;
	}
	
	// BUG: http://code.google.com/p/simbl/issues/detail?id=11
	// NOTE: believe it or not, some applications cause a crash deep in the
	// ScriptingBridge code. Due to the launchd behavior of restarting crashed
	// agents, this is mostly harmless. To reduce the crashing we leave a
	// blacklist to prevent injection.  By default, this is empty.
	NSString* appIdentifier = [appInfo bundleIdentifier];
	NSArray* blacklistedIdentifiers = [defaults stringArrayForKey:@"SIMBLApplicationIdentifierBlacklist"];
	if (blacklistedIdentifiers != nil && 
			[blacklistedIdentifiers containsObject:appIdentifier]) {
		SIMBLLogNotice(@"ignoring injection attempt for blacklisted application %@ (%@)", appName, appIdentifier);
		return;
	}

	SIMBLLogDebug(@"send inject event");
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL isDirectory = NO;
    if (![fileManager fileExistsAtPath:self.scriptingAdditionsPath isDirectory:&isDirectory]) {
        if (![fileManager createDirectoryAtPath:self.scriptingAdditionsPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error]) {
            
            if (error) {
                SIMBLLogNotice(@"createDirectoryAtPath error:%@",error);
                return;
            }
        }
    } else if (!isDirectory) {
        SIMBLLogNotice(@"%@ is file. Expect are directory", self.scriptingAdditionsPath);
        return;
    }
        
    if ([fileManager fileExistsAtPath:self.osaxPath isDirectory:&isDirectory] && isDirectory) {
        // Find the process to target
        pid_t pid = [appInfo processIdentifier];
        SBApplication* app = [SBApplication applicationWithProcessIdentifier:pid];
        [app setDelegate:self];
        if (!app) {
            SIMBLLogNotice(@"Can't find app with pid %d", pid);
            return;
        }
        
        // hardlink SIMBL.osax to ScriptingAdditions
        if (![fileManager fileExistsAtPath:self.linkedOsaxPath isDirectory:&isDirectory]) {
            [fileManager linkItemAtPath:self.osaxPath toPath:self.linkedOsaxPath error:&error];
            if (error) {
                SIMBLLogNotice(@"linkItemAtPath error:%@",error);
                return;
            }
        }
        self.waitingInjectionNumber++;
        
        // hardlink SIMBL/Plugins to Container
        [self injectSandboxedBundleidentifier:appIdentifier enabled:YES];
        
        
        // Force AppleScript to initialize in the app, by getting the dictionary
        // When initializing, you need to wait for the event reply, otherwise the
        // event might get dropped on the floor. This is only seems to happen in 10.5
        // but it shouldn't harm anything.
        [app setSendMode:kAEWaitReply | kAENeverInteract | kAEDontRecord];
        [app sendEvent:kASAppleScriptSuite id:kGetAEUT parameters:0];
        
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
        id injectReply = [app sendEvent:'ESIM' id:'load' parameters:0];
        if (injectReply != nil) {
            SIMBLLogNotice(@"unexpected injectReply: %@", injectReply);
        }
        [[NSProcessInfo processInfo]disableSuddenTermination];
    }
}

- (void)injectSandboxedBundleidentifier:(NSString*)bundleIdentifier enabled:(BOOL)bEnabled;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES);
    NSString *containerPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[paths objectAtIndex:0], @"Containers", bundleIdentifier, nil]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL isDirectory = NO;
    if ([fileManager fileExistsAtPath:containerPath isDirectory:&isDirectory] && isDirectory) {
        NSString *containerScriptingAddtionsPath = [containerPath stringByAppendingPathComponent:@"Data/Library/ScriptingAdditions"];
        NSString *containerApplicationSupportPath = [containerPath stringByAppendingPathComponent:@"Data/Library/Application Support/SIMBL"];
        if (bEnabled) {
            [fileManager linkItemAtPath:self.scriptingAdditionsPath toPath:containerScriptingAddtionsPath error:&error];
            if (error) {
                SIMBLLogNotice(@"linkItemAtPath error:%@",error);
            }
            [fileManager linkItemAtPath:self.applicationSupportPath toPath:containerApplicationSupportPath error:&error];
            if (error) {
                SIMBLLogNotice(@"linkItemAtPath error:%@",error);
            }
        } else {
            [fileManager removeItemAtPath:containerScriptingAddtionsPath error:&error];
            if (error) {
                SIMBLLogNotice(@"removeItemAtPath error:%@",error);
            }
            [fileManager removeItemAtPath:containerApplicationSupportPath error:&error];
            if (error) {
                SIMBLLogNotice(@"removeItemAtPath error:%@",error);
            }
        }
    }
}

@end
