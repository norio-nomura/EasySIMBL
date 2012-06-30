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

@interface SIMBLPlugin : NSObject

+ (SIMBLPlugin*) bundleWithPath:(NSString*)path;
- (SIMBLPlugin*) initWithPath:(NSString*)path;

@property (strong, nonatomic) NSString* path;
@property (strong, nonatomic) NSDictionary* info;

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
