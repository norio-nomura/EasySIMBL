/**
 * Copyright 2012, hetima
 * EasySIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */


#import "ESPluginListTableView.h"
#import "ESPluginListManager.h"

@implementation ESPluginListTableView

- (void)awakeFromNib
{
    [self setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType,nil]];
}

- (NSArray*)filesFromPasteboard:(NSPasteboard*)pasteboard
{
    NSArray *files = [[pasteboard propertyListForType:NSFilenamesPboardType]pathsMatchingExtensions:[NSArray arrayWithObject:@"bundle"]];
    return files;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    if ([[self filesFromPasteboard:[sender draggingPasteboard]]count]) {
    return NSDragOperationCopy;
    } else {
        return NSDragOperationNone;
    }
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if ([[self filesFromPasteboard:[sender draggingPasteboard]]count]) {
    [self setBackgroundColor:[NSColor selectedControlColor]];
    return NSDragOperationCopy;
    } else {
        return NSDragOperationNone;
    }
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    [self setBackgroundColor:[NSColor controlBackgroundColor]];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    if ([[self filesFromPasteboard:[sender draggingPasteboard]]count]) {
    [self setBackgroundColor:[NSColor controlBackgroundColor]];
    return YES;
    } else {
        return NO;
    }
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    BOOL handled=NO;
    
    NSArray *files = [self filesFromPasteboard:[sender draggingPasteboard]];
    for (NSString* path in files) {
        if ([path hasSuffix:@".bundle"]) {
            handled=YES;
            ESPluginListManager* manager=(ESPluginListManager*)self.delegate;
            [manager installPlugin:path];
        }
    }
    
    return handled;
}

- (NSMenu*)menuForEvent:(NSEvent *)event
{
    NSMenu* menu=nil;
    
	NSInteger row = [self rowAtPoint:[self convertPoint:[event locationInWindow] fromView:nil]];
	if(row >= 0){
        ESPluginListManager* manager=(ESPluginListManager*)self.delegate;
        menu=[manager menuForTableView:self row:row];
	}
    return menu;
}

@end
