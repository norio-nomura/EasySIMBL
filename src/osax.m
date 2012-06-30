/**
 * Copyright 2012, Norio Nomura
 * EasySIMBL is released under the GNU General Public License v2.
 * http://www.opensource.org/licenses/gpl-2.0.php
 */

#import "SIMBL.h"

__attribute__((constructor))
static void EasySIMBLInitializer()
{
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [SIMBL installPlugins];
        });
    }
}

