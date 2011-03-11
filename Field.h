//
//  Field.h
//  Angler
//
//  Created by smrt on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "EdgesHolder.h"
#import "ALEdges.h"

#include "A34.h"



struct NLine {
	NSPoint p1;
	NSPoint p2;
};



@interface Field : NSObject {

@private
	

	
	//number of points
	int _w;
	int _h;
	
	//position where to draw
	CGFloat _x;
	CGFloat _y;
	
	CGFloat _width;
	CGFloat _height;	
	CGFloat _maxWidth;
	CGFloat _maxHeight;
	
	CGFloat _marginX;
	CGFloat _marginY;
	
	int _dragState;
	al::Point _startPoint;
	NSPoint _endPoint;
	
	NSColor *bgcolor;
	
	id<EdgesHolder>  edgesHolder;
}

-(id<EdgesHolder>)setEdgesHolder:(id<EdgesHolder>)eh;


-(bool)isBiggest;
-(bool)isSmallest;


-(void)setBgcolor:(NSColor *)color;
-(NSColor *)bgcolor;

-(CGFloat)width;
-(CGFloat)height;


-(Field *)initWithW:(int)w h:(int)h max_w:(CGFloat)mw max_h:(CGFloat)mh;
-(void)setWidth:(CGFloat)w;
-(void)setHeight:(CGFloat)h;
-(void)popLine;

-(CGFloat)zoomX:(CGFloat)x;
-(CGFloat)zoomY:(CGFloat)y;


-(void)draw:(ALEdges *)edges offset:(int)ofs;

-(bool)startAt:(NSPoint)p;
-(bool)dragTo:(NSPoint)p;
-(bool)stopAt:(NSPoint)p;

-(void)setX:(CGFloat)x y:(CGFloat)y;

-(CGFloat)gridX;
-(CGFloat)gridY;

-(void) setMarginX:(CGFloat)x;
-(void) setMarginY:(CGFloat)y;


@end
