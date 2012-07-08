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

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    [self setBackgroundColor:[NSColor selectedControlColor]];
    return NSDragOperationCopy;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    [self setBackgroundColor:[NSColor controlBackgroundColor]];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    [self setBackgroundColor:[NSColor controlBackgroundColor]];
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    BOOL handled=NO;
    
    NSPasteboard *poPasteBd = [sender draggingPasteboard];
    NSArray *files = [poPasteBd propertyListForType:NSFilenamesPboardType];
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
