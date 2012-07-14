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

@interface NSBundle (SIMBLCocoaExtensions)

- (NSString*) _dt_info;
- (NSString*) _dt_version;
- (NSString*) _dt_bundleVersion;
- (NSString*) _dt_name;

@end

#define EasySIMBLApplicationSupportPathComponent @"Application Support/SIMBL"
#define EasySIMBLPluginsPathComponent @"Plugins"
#define EasySIMBLScriptingAdditionsPathComponent @"ScriptingAdditions"
#define EasySIMBLBundleBaseName @"EasySIMBL"
#define EasySIMBLBundleExtension @"osax"
#define EasySIMBLBundleName @"EasySIMBL.osax"
#define EasySIMBLPreferencesPathComponent @"Preferences"
#define EasySIMBLSuiteBundleIdentifier @"com.github.norio-nomura.EasySIMBL"
#define EasySIMBLPreferencesExtension @"plist"
#define EasySIMBLHasBeenLoadedNotification @"EasySIMBLHasBeenLoadedNotification"
#define EasySIMBLOriginalSIMBLAgentBundleIdentifier @"net.culater.SIMBL_Agent"

#define SIMBLStringTable @"SIMBLStringTable"
#define SIMBLApplicationIdentifier @"SIMBLApplicationIdentifier"
#define SIMBLTargetApplications @"SIMBLTargetApplications"
#define SIMBLBundleIdentifier @"BundleIdentifier"
#define SIMBLMinBundleVersion @"MinBundleVersion"
#define SIMBLMaxBundleVersion @"MaxBundleVersion"
#define SIMBLTargetApplicationPath @"TargetApplicationPath"
#define SIMBLRequiredFrameworks @"RequiredFrameworks"

#define SIMBLPrefKeyLogLevel @"SIMBLLogLevel"
#define SIMBLLogLevelDefault 2
#define SIMBLLogLevelNotice 2
#define SIMBLLogLevelInfo 1
#define SIMBLLogLevelDebug 0

@protocol SIMBLPlugin
+ (void) install;
@end

#define SIMBLLogDebug(format, ...) [SIMBL logMessage:[NSString stringWithFormat:format, ##__VA_ARGS__] atLevel:SIMBLLogLevelDebug]
#define SIMBLLogInfo(format, ...) [SIMBL logMessage:[NSString stringWithFormat:format, ##__VA_ARGS__] atLevel:SIMBLLogLevelInfo]
#define SIMBLLogNotice(format, ...) [SIMBL logMessage:[NSString stringWithFormat:format, ##__VA_ARGS__] atLevel:SIMBLLogLevelNotice]


@interface SIMBL : NSObject

+ (void) logMessage:(NSString*)message atLevel:(int)level;
+ (void) installPlugins;
+ (BOOL) shouldInstallPluginsIntoApplication:(NSBundle*)_appBundle;

+ (NSString*)applicationSupportPath;

@end
