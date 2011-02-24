//
//  Field.h
//  Angler
//
//  Created by smrt on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

struct FPoint {
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
	CGFloat _grid;
	int _w;
	int _h;
	CGFloat _width;
	CGFloat _height;	
	CGFloat _maxWidth;
	CGFloat _maxHeight;
	NSMutableArray *_lines;
}

-(void)initWithW:(int)w h:(int)h max_w:(CGFloat)mw max_h:(CGFloat)mh;
-(void)setWidth:(CGFloat)w;
-(void)setHeight:(CGFloat)h;
-(void)pushLine:(FLine)l;
-(void)popLine;
-(bool)checkFPoint:(FPoint)p;
-(CGFloat)zoomX:(CGFloat)x;
-(CGFloat)zoomY:(CGFloat)y;



-(NSPoint)makeNSPoint:(FPoint)p;



@end
