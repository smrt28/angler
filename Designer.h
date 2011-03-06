//
//  Designer.h
//  Angler
//
//  Created by smrt on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Field.h"
#import "AppCtrl.h"
//#import "Board.h"
//#import "DesignerProtocol.h"

typedef struct {
	int x, y;
} DPoint;

typedef struct {
	DPoint p1;
	DPoint p2;
} DLine;



@interface Designer : NSControl {
 	
	SEL action;
	
	float _zoom;
	
	Field *_field;
	
	NSTimer * _timer;
	IBOutlet NSTextField * textResultCnt;
	
	//NSAnimation *_shading;
	
	IBOutlet AppCtrl * appCtrl;
}


-(void)showDesignerAtX:(CGFloat)x y:(CGFloat)y;


@end
