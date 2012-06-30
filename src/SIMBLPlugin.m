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

#import "SIMBLPlugin.h"

@implementation SIMBLPlugin

@synthesize path=_path, info=_info;

+ (SIMBLPlugin*) bundleWithPath:(NSString*)path
{
	return [[SIMBLPlugin alloc] initWithPath:path];
}

- (SIMBLPlugin*) initWithPath:(NSString*)path
{
	if (!(self = [super init]))
		return nil;
	self.path = path;

    NSArray* bundlePathParts = [NSArray arrayWithObjects:path, @"Contents", @"Info.plist", nil];
	if (nil == bundlePathParts)
		return nil;
	NSString* bundlePath = [NSString pathWithComponents:bundlePathParts];
	if (nil == bundlePath) {
		NSLog(@"Unable to create bundle path string from components: %@", bundlePathParts);
		return nil;
	}
	NSDictionary* bundleDict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
	if (nil == bundleDict) {
		NSLog(@"Unable to create dictionary from bundle at path '%@'", bundlePath);
		return nil;
	}
	if (0 == [bundleDict count]) {
		NSLog(@"Warning: Empty dictionary created from bundle at path '%@'", bundlePath);
		return nil;
	}

	self.info = bundleDict;
	return self;

}

- (NSString*) bundleIdentifier
{
	return [self.info objectForKey:@"CFBundleIdentifier"];
}

- (id) objectForInfoDictionaryKey:(NSString*)key
{
	return [self.info objectForKey:key];
}

- (NSString*) _dt_info
{
	return [self objectForInfoDictionaryKey: @"CFBundleGetInfoString"];
}

- (NSString*) _dt_version
{
	return [self objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- (NSString*) _dt_bundleVersion
{
	return [self objectForInfoDictionaryKey: @"CFBundleVersion"];
}

- (NSString*) _dt_name
{
	NSString* name = [self objectForInfoDictionaryKey:@"CFBundleName"];
	if (name != nil)
		return name;
	else
		return [self.path lastPathComponent];
}


@end

@implementation NSBundle (SIMBLCocoaExtensions)

- (NSString*) _dt_info
{
	return [self objectForInfoDictionaryKey: @"CFBundleGetInfoString"];
}

- (NSString*) _dt_version
{
	return [self objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- (NSString*) _dt_bundleVersion
{
	return [self objectForInfoDictionaryKey: @"CFBundleVersion"];
}

- (NSString*) _dt_name
{
	return [self objectForInfoDictionaryKey:@"CFBundleName"];
}

@end
