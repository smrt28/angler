//
//  Field.h
//  Angler
//
//  Created by smrt on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

struct FPoint {
	FPoint() : x(0), y(0) { }
	FPoint(int x, int y) : x(x), y(y) {}
	
	int x; 
	int y;
};

struct FLine {
	FPoint p1;
	FPoint p2;	
};

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
	NSMutableArray *_lines;
	
	CGFloat _marginX;
	CGFloat _marginY;
	
	
	//dragging line
	int _dragState;
	FPoint _startPoint;
	NSPoint _endPoint;
	
}

-(CGFloat)width;
-(CGFloat)height;


-(Field *)initWithW:(int)w h:(int)h max_w:(CGFloat)mw max_h:(CGFloat)mh;
-(void)setWidth:(CGFloat)w;
-(void)setHeight:(CGFloat)h;
-(void)pushLine:(FLine)l;
-(void)popLine;
-(bool)checkFPoint:(FPoint)p;
-(CGFloat)zoomX:(CGFloat)x;
-(CGFloat)zoomY:(CGFloat)y;

-(void)draw;

-(NSPoint)makeNSPoint:(FPoint)p;
-(bool)makeFPoint:(NSPoint)p fpoint:(FPoint *)f;

-(bool)startAt:(NSPoint)p;
-(bool)dragTo:(NSPoint)p;
-(bool)stopAt:(NSPoint)p;

-(void)setX:(CGFloat)x y:(CGFloat)y;

-(CGFloat)gridX;
-(CGFloat)gridY;

-(void) drawLine:(FLine)l;
-(void) drawLineFrom:(FPoint)fp1 to:(NSPoint)np2;

@end
