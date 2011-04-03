//
//  AppCtrl.h
//  Angler
//
//  Created by smrt on 2/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALEdges.h"

@class AngleSelector;
@class Designer;
@class ResultView;
@class AppCtrl;

@interface AAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    IBOutlet NSWindow * window;
    IBOutlet AppCtrl * appCtrl;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;    
- (void)applicationWillHide:(NSNotification *)aNotification;
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;
@end



//- (void)setDelegate:(id < NSWindowDelegate >)delegate


@interface AppCtrl : NSObject {
	IBOutlet Designer * designer;
	IBOutlet NSTextField * textResultCnt;
    IBOutlet NSWindow * resultViewWindow;
    IBOutlet NSPanel *panel;
    IBOutlet AngleSelector * activeASelector;
    IBOutlet ResultView *resultView;
    IBOutlet NSPopUpButton *widthSelectMenu;

    IBOutlet NSButton *printButton;
    IBOutlet NSButton *clearButton;
    IBOutlet NSButton *undoButton;
}

-(void)show;
-(id)init;

-(IBAction)showDrawer: sender;
-(IBAction)print: sender;

-(void)showDesignerAtX:(CGFloat)x y:(CGFloat)y;

- (IBAction) showAllResults:sender;
- (IBAction) selectNAngler:sender;
- (IBAction) widthChange:(NSPopUpButton *)sender;

- (void) notifyChanges:(ALEdges *)edges;

@end
