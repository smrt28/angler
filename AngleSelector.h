//
//  AngleSelector.h
//  Angler
//
//  Created by smrt on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EdgesHolder.h"
#import "AppCtrl.h"
@interface AngleSelector : NSControl {
	IBOutlet id<AngleSelectorHandler> handler;
	int edges;
    NSColor *color;
    NSColor *colorSel;
    id appCtrl;
    SEL sel;
    BOOL isSelected;
}

-(void)dealloc;
-(void)setSelected:(BOOL)b;

@property int edges;

@end
