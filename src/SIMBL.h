/**
 * Copyright 2004-2009, Mike Solomon <mas63@cornell.edu>
 * SIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */

#import <Foundation/Foundation.h>
#import "SIMBLPlugin.h"

#define SIMBLPluginPath @"Application Support/SIMBL/Plugins"
#define SIMBLStringTable @"SIMBLStringTable"
#define SIMBLApplicationIdentifier @"SIMBLApplicationIdentifier"
#define SIMBLTargetApplications @"SIMBLTargetApplications"
#define SIMBLBundleIdentifier @"BundleIdentifier"
#define SIMBLMinBundleVersion @"MinBundleVersion"
#define SIMBLMaxBundleVersion @"MaxBundleVersion"
#define SIMBLTargetApplicationPath @"TargetApplicationPath"
#define SIMBLRequiredFrameworks @"RequiredFrameworks"

@protocol SIMBLPlugin
+ (void) install;
@end

@interface SIMBL : NSObject
{
}

+ (void) installPlugins:(NSNotification*)_notification;
+ (BOOL) loadBundleAtPath:(NSString*)_bundlePath;
+ (BOOL) loadBundle:(SIMBLPlugin*)_bundle forApplicationIdentifiers:(NSArray*)_applicationIdentifiers;
+ (BOOL) loadBundle:(SIMBLPlugin*)_bundle forTargetApplications:(NSArray*)_targetApplications;
+ (BOOL) loadBundle:(SIMBLPlugin*)_bundle;

@end
