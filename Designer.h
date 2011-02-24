//
//  Designer.h
//  Angler
//
//  Created by smrt on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

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
	//NSPoint location;
	
	bool p1_valid;
	bool p2_valid;
	DPoint p1;
	DPoint p2;
	
	int width;
	int height;

	bool drag_valid;
	NSPoint drag;
	
	NSPoint margin;
	CGFloat _grid;
	
	//Board *board;
	NSMutableArray *lines;
	
	SEL action;
	
	float _zoom;
}

-(NSPoint) dp2p:(DPoint)point;
-(DPoint) p2dp:(NSPoint)dpoint;

-(void) drawDot:(NSPoint)point size:(float)size;

-(bool) isValidPoint:(DPoint)p; 
-(bool) isValidLine:(DLine)l;

-(void) drawLine:(DLine)l;

-(void) pushLine;

-(float) grid;

-(float) minZoom;

-(float) zoom:(float)z;


@end
