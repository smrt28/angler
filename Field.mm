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
	_x = _y = 0;
	_w = _h = _height = _width = 0;
	_maxWidth = _maxHeight = 0;
	_marginX = _marginY = 5;
	_dragState = 0;
	_lines = [[NSMutableArray alloc] init];
	return self;
}

-(void)setX:(CGFloat)x y:(CGFloat)y {
	_x = x;
	_y = y;
}

-(void)setWidth:(CGFloat)w {
	_width = w;
}

-(void)setHeight:(CGFloat)h {
	_height = h;
}

-(Field *)initWithW:(int)w h:(int)h max_w:(CGFloat)mw max_h:(CGFloat)mh {
	[self init];
	_w = w; _h = h;
	_width = _maxWidth = mw; _height = _maxHeight = mh;
	
	return self;
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
	CGFloat gridx = [self gridX];
	CGFloat gridy = [self gridY];
	
	rv.x = (gridx * p.x) + _x + _marginX;
	rv.y = (gridy * p.y) + _y + _marginY;
	return rv;
}

-(bool)makeFPoint:(NSPoint)p fpoint:(FPoint *)f {
	CGFloat gridx = [self gridX];
	CGFloat gridy = [self gridY];
	f->x = ((p.x - _marginX - _x) + (0.5 * gridx)) / gridx;
	f->y = ((p.y - _marginY - _y) + (0.5 * gridy)) / gridy;
	if (f->x >= 0 && f->x < _w && f->y >= 0 && f->y < _h)
		return true;
	return false;
}

-(CGFloat)gridX {
	return (_width - 2*_marginX) / _w;
}

-(CGFloat)gridY {
	return (_height - 2*_marginY) / _h;
}


-(CGFloat)zoomX:(CGFloat)x {
	CGFloat rv = (_width / _maxWidth) * x;
	return rv;
}

-(CGFloat)zoomY:(CGFloat)y {
	CGFloat rv = (_height / _maxHeight) * y;
	return rv;
}




-(void) drawNSLineFrom:(NSPoint)p1 to:(NSPoint)p2 {
	NSBezierPath* path2 = [NSBezierPath bezierPath];
	[path2 moveToPoint:NSMakePoint(p1.x, p1.y)];
	[path2 lineToPoint:NSMakePoint(p2.x, p2.y)];
	[path2 setLineCapStyle:NSSquareLineCapStyle];
	[path2 setLineWidth: 1.8];
	[[NSColor blackColor] set];
	[path2 stroke];	
}


-(void) drawLine:(FLine)l {
	NSPoint pp1 = [self makeNSPoint:l.p1];
	NSPoint pp2 = [self makeNSPoint:l.p2];
    [self drawNSLineFrom:pp1 to:pp2];
}



-(void) drawLineFrom:(FPoint)fp1 to:(NSPoint)pp2 {
	NSPoint pp1 = [self makeNSPoint:fp1];
    [self drawNSLineFrom:pp1 to:pp2];
}


-(void) drawDot:(NSPoint)point size:(float)size {
	NSBezierPath *path1;
	float dm = size * size;
	float rd = dm * 0.50;
	NSPoint origin  = { point.x - rd, point.y - rd };
	NSRect mainOval = { origin.x, origin.y, dm, dm };
	path1 = [NSBezierPath bezierPathWithOvalInRect:mainOval];
	[path1 setLineWidth:1.2];
	[[NSColor blackColor] set];[path1 fill];	
	[[NSColor blackColor] set];[path1 stroke];	
}


-(bool)startAt:(NSPoint)p {
	
	if ([self makeFPoint:p fpoint:&_startPoint]) {
		_dragState = 1;
		return true;
	}
	_dragState = 0;
	return false;
}

-(bool)dragTo:(NSPoint)p {
	if (_dragState == 1)
		_endPoint = p;
		
	return false;
}

-(bool)stopAt:(NSPoint)p {
	_dragState = 0;
	return false;
}


-(void) draw {
	
	NSRect r;
	r.origin.y = r.origin.x = 0;
	r.size.width = _width;
	r.size.height = _height;

	[[NSColor blueColor] set];
	
	[[NSColor colorWithDeviceRed: 0.6 green: 0.6 blue: 0.8 alpha: 1] set];
	[NSBezierPath fillRect: r];
	
	if (_dragState == 1)
		[self drawLineFrom:_startPoint to:_endPoint];
	

	int i, j;
	
	for(i=0;i<_w;i++)
	{
		for(j=0;j<_h;j++)
		{
			NSPoint p = [self makeNSPoint: FPoint(i, j)];
			[self drawDot:p size:1.5];
		}
	}
	

}

@end









