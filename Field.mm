//
//  Field.mm
//  Angler
//
//  Created by smrt on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Field.h"

#define DEFAULT_GRID 30

@implementation Field

-(id)init {
	_w = _h = _height = _width = 0;
	_maxWidth = _maxHeight = 0;
	_grid = DEFAULT_GRID;
	_lines = [[NSMutableArray alloc] init];
	return self;
}

-(void)setWidth:(CGFloat)w {
	_width = w;
}

-(void)setHeight:(CGFloat)h {
	_height = h;
}

-(void)initWithW:(int)w h:(int)h max_w:(CGFloat)mw max_h:(CGFloat)mh {
	[self init];
	_w = w; _h = h;
	_maxWidth = mw; _maxHeight = mh;
}

-(void)dealloc {
	[_lines release];	
	[super dealloc];
}


-(bool)checkFPoint:(FPoint)p {
	if (p.x < 0 || p.y < 0) return false;
	if (p.x >= _w || p.y >= _h) return false;
	return true;
}

-(void)pushLine:(FLine)l {
	if (![self checkFPoint:l.p1] || ![self checkFPoint:l.p2])
		return;
	
	NSValue *nv = [NSValue valueWithBytes:&l objCType:@encode(FLine)];
	[_lines addObject: nv];
}


-(void)popLine {
	[_lines removeLastObject];
}


-(NSPoint)makeNSPoint:(FPoint)p {
	NSPoint rv;	
	rv.x = (_width / _w) * p.x;
	rv.y = (_height / _h) * p.y;
	return rv;
}

-(CGFloat)zoomX:(CGFloat)x {
	CGFloat rv = (_width / _maxWidth) * x;
	return rv;
}

-(CGFloat)zoomY:(CGFloat)y {
	CGFloat rv = (_height / _maxHeight) * y;
	return rv;
}


@end
