/**
 * Copyright 2003-2009, Mike Solomon <mas63@cornell.edu>
 * SIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */

#import "SIMBLPlugin.h"

@implementation SIMBLPlugin

+ (SIMBLPlugin*) bundleWithPath:(NSString*)_path
{
	return [[[SIMBLPlugin alloc] initWithPath:_path] autorelease];
}

- (NSString*) path
{
	return path;
}

- (void) setPath:(NSString*)_path
{
	if (path && (!_path || ![path isEqualToString:_path]))
		[path autorelease];
	
	if (_path)
		path = [_path copy];
	else
		path = _path;
}

- (NSDictionary*) info
{
	return info;
}

- (void) setInfo:(NSDictionary*)_info
{
	if (info == _info)
		return;
	
	if (_info)
		[_info retain];
	
	if (info)
		[info release];
	
	info = _info;
}

- (SIMBLPlugin*) initWithPath:(NSString*)_path
{
	if (!(self = [super init]))
		return nil;
	[self setPath:_path];
	[self setInfo:[NSDictionary dictionaryWithContentsOfFile:[NSString pathWithComponents:[NSArray arrayWithObjects:_path, @"Contents", @"Info.plist", nil]]]];
	return self;
}

- (NSString*) bundleIdentifier
{
	return [info objectForKey:@"CFBundleIdentifier"];
}

- (id) objectForInfoDictionaryKey:(NSString*)key
{
	return [info objectForKey:key];
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
		return [[self path] lastPathComponent];
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
