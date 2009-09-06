/**
 * Copyright 2003-2009, Mike Solomon <mas63@cornell.edu>
 * SIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */

#import <Foundation/Foundation.h>

@interface SIMBLPlugin : NSObject
{
	NSString* path;
	NSDictionary* info;
}

+ (SIMBLPlugin*) bundleWithPath:(NSString*)_path;
- (SIMBLPlugin*) initWithPath:(NSString*)_path;

- (NSString*) path;
- (void) setPath:(NSString*)_path;
- (NSDictionary*) info;
- (void) setInfo:(NSDictionary*)_info;
- (NSString*) bundleIdentifier;
- (id) objectForInfoDictionaryKey:(NSString*)key;

- (NSString*) _dt_info;
- (NSString*) _dt_version;
- (NSString*) _dt_bundleVersion;
- (NSString*) _dt_name;

@end


@interface NSBundle (SIMBLCocoaExtensions)

- (NSString*) _dt_info;
- (NSString*) _dt_version;
- (NSString*) _dt_bundleVersion;
- (NSString*) _dt_name;

@end
