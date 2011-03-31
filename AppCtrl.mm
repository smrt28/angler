//
//  AppCtrl.m
//  Angler
//
//  Created by smrt on 2/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppCtrl.h"
#import "Designer.h"
#import "ResultView.h"
#import "AngleSelector.h"

@implementation AppCtrl

-(id)init {
    [super init];
    
    return self;
}


-(void)showDesignerAtX:(CGFloat)x y:(CGFloat)y {
	[designer showDesignerAtX:x y:y];
}

- (IBAction) showAllResults: sender {
    [resultViewWindow makeKeyAndOrderFront:nil];
}

-(IBAction)showDrawer: sender {
   // [panel orderFront: self]; 
    [panel setIsVisible:YES];
    
}

- (IBAction) selectNAngler: sender {
    int i = [sender edges];
    [designer edgesCountChanged:i];
    
    [activeASelector setSelected: NO];
    activeASelector = sender;
    [activeASelector setSelected: YES];
}

- (void)awakeFromNib {
   // DrawPanleDelegate *dpd = [[DrawPanleDelegate alloc] init];
   // [panel setDelegate: dpd];
    [designer edgesCountChanged:3];
    [activeASelector setSelected: YES];
    [widthSelectMenu selectItemAtIndex: 1];
}


-(void)show {
    [resultViewWindow orderFront:self];
    [panel setIsVisible:YES];
}

- (void)windowWillClose:(NSNotification *)notification {
    if ([notification object] == panel) {
        [resultViewWindow setIsVisible: NO];
    } else if ([notification object] == resultViewWindow) {
        [panel setIsVisible: NO];
    }        
}

-(IBAction)print: sender {
    [resultView print: sender];
}

- (IBAction) widthChange:(NSPopUpButton *)sender {
    int i = [sender indexOfSelectedItem] + 5;
    [resultView setFieldsInRow: i];
}

@end


@implementation AAppDelegate

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    return NSTerminateNow;
}

- (void)applicationWillHide:(NSNotification *)aNotification {
    
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    if (flag)
        return NO;
    [appCtrl show];
    //[window orderFront:self];
    return YES;
}


@end