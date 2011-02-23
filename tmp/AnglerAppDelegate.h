//
//  AnglerAppDelegate.h
//  Angler
//
//  Created by smrt on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AnglerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *aWindow;
}

-(NSWindow *)window;
-(void)setWindow:(NSWindow *)w;

@property (assign) IBOutlet NSWindow *window;

@end
