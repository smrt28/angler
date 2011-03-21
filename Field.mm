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

@synthesize fieldWidth;
@synthesize fieldHeight;
@synthesize width;
@synthesize height;

-(id)init {
	_x = _y = 0;
	_w = _h = height = width = 0;
	fieldWidth = fieldHeight = 0;
	_marginX = _marginY = 0;
	_dragState = 0;
    dots = NO;
	bgcolor = [[NSColor colorWithDeviceRed: 0.6 green: 0.6 blue: 0.8 alpha: 0.8] retain];
	return self;
}

-(void)setBgcolor:(NSColor *)color {
	[bgcolor autorelease];
	bgcolor = [bgcolor retain];
}

-(NSColor *)bgcolor {
	return bgcolor;
}

-(void)setX:(CGFloat)x y:(CGFloat)y {
	_x = x;
	_y = y;
}

-(Field *)initWithW:(int)w h:(int)h max_w:(CGFloat)mw max_h:(CGFloat)mh {
	[self init];
	_w = w; _h = h;
	width = fieldWidth = mw; height = fieldHeight = mh;
	
	return self;
}

-(void)dealloc {
	[bgcolor release];
	[super dealloc];
}



-(void) setMarginX:(CGFloat)x {
	_marginX = x;
}

-(void) setMarginY:(CGFloat)y {
	_marginY = y;
}


-(NSPoint)makeNSPoint:(al::Point)p {
	NSPoint rv;	
	CGFloat gridx = [self gridX];
	CGFloat gridy = [self gridY];
	
	rv.x = (gridx * p.x) + _x + _marginX;
	rv.y = (gridy * p.y) + _y + _marginY;
	return rv;
}

-(NSPoint)makeNSPointFromAl:(al::Point)p {
	NSPoint rv;	
	CGFloat gridx = [self gridX];
	CGFloat gridy = [self gridY];
	
	rv.x = (gridx * p.x) + _x + _marginX;
	rv.y = (gridy * p.y) + _y + _marginY;
	return rv;
}

-(bool)makeAlPoint:(NSPoint)p alPoint:(al::Point *)f {
	al::Point ff;
	if (!f) f = &ff;
	CGFloat gridx = [self gridX];
	CGFloat gridy = [self gridY];
	f->x = (int)(((p.x - _marginX - _x) + (0.5 * gridx)) / gridx);
	f->y = (int)(((p.y - _marginY - _y) + (0.5 * gridy)) / gridy);
	if (f->x >= 0 && f->x < _w && f->y >= 0 && f->y < _h)
		return true;
	return false;
}

-(CGFloat)gridX {
	return (width - 2*_marginX) / (_w - 1);
}

-(CGFloat)gridY {
	return (height - 2*_marginY) / (_h - 1);
}


-(CGFloat)zoomX:(CGFloat)x {
	CGFloat rv = (width / fieldWidth) * x;
	return rv;
}

-(CGFloat)zoomY:(CGFloat)y {
	CGFloat rv = (height / fieldHeight) * y;
	return rv;
}



-(void) drawNSLineFrom:(NSPoint)p1 to:(NSPoint)p2 color:(NSColor *)color{
	NSBezierPath* path2 = [NSBezierPath bezierPath];
	[path2 moveToPoint:NSMakePoint(p1.x, p1.y)];
	[path2 lineToPoint:NSMakePoint(p2.x, p2.y)];
	[path2 setLineCapStyle:NSSquareLineCapStyle];
	float ww = 2.3;
	float w = ([self zoomX:ww] + [self zoomY:ww])/2;
	[path2 setLineWidth: w];
	[color set];
	[path2 stroke];	
}





-(void) drawNSLineFrom:(NSPoint)p1 to:(NSPoint)p2 {
	[self drawNSLineFrom:p1 to:p2 color:[NSColor whiteColor]];
}




-(void) drawLineFrom:(al::Point)fp1 to:(NSPoint)pp2 {
	NSPoint pp1 = [self makeNSPoint:fp1];
    [self drawNSLineFrom:pp1 to:pp2];
}


-(void) drawAlLine:(al::Line)l {
	NSPoint p1 = [self makeNSPoint:l.p1];	
	NSPoint p2 = [self makeNSPoint:l.p2];
	[self drawNSLineFrom:p1 to:p2];
}

-(void) drawAlLine:(al::Line)l color:(NSColor *)color {
	NSPoint p1 = [self makeNSPoint:l.p1];	
	NSPoint p2 = [self makeNSPoint:l.p2];
	[self drawNSLineFrom:p1 to:p2 color:color];
}

-(void) drawDot:(NSPoint)point size:(float)size { //return;
	NSBezierPath *path1;
	
	float dmx = [self zoomX: size];
	float dmy = [self zoomY: size];
	
	float rdx = dmx * 0.50;
	float rdy = dmy * 0.50;
	
	NSPoint origin  = { point.x - rdx, point.y - rdy };
	NSRect mainOval = { origin.x, origin.y, dmx, dmy };
	
	
	path1 = [NSBezierPath bezierPathWithOvalInRect:mainOval];
	[path1 setLineWidth:1.2];
	[[NSColor grayColor] set];
	[path1 fill];	
	[path1 stroke];	
}


-(bool)startAt:(NSPoint)p {
	
	if ([self makeAlPoint:p alPoint:&_startPoint]) {
		_dragState = 1;
		return true;
	}
	_dragState = 0;
	return false;
}

-(bool)dragTo:(NSPoint)p {
	if (_dragState == 1) {
		p.x -= _x;
		p.y -= _y;
		_endPoint = p;
	}
		
	return false;
}

-(bool)stopAt:(NSPoint)p {
	if (_dragState != 1)
		return false;
	al::Point fp;
	if (![self makeAlPoint:p alPoint:&fp])
		return false;
	
	al::Line fl;
	fl.p1 = _startPoint;
	fl.p2 = fp;
	
	[edgesHolder lineDrawn:fl];

	_dragState = 0;
	return true;
}

-(void) drawALines:(al::Line *)al count:(int)count {
	int i;
	for (i=0;i<count;i++) {
		NSPoint p1 = [self makeNSPointFromAl: al[i].p1];
		NSPoint p2 = [self makeNSPointFromAl: al[i].p2];
		[self drawNSLineFrom:p1 to:p2];
	}
}

-(void) draw:(ALEdges *)edges offset:(int)ofs resultColor:(NSColor *)rcolor{
	
	NSRect r;
	r.origin.y = _y;
	r.origin.x = _x;
	r.size.width = width;
	r.size.height = height;
   
    
	[[NSColor blueColor] set];
	
	if (_dragState == 1) {
		NSPoint p;
		p.x = _endPoint.x + _x;
		p.y = _endPoint.y + _y;
		
		if ([self makeAlPoint:p alPoint:0 ])
		
		[self drawLineFrom:_startPoint to:p];
	}

	int i, j;
	if (dots) {
        for(i=0;i<_w;i++)
        {
            for(j=0;j<_h;j++)
            {
                NSPoint p = [self makeNSPoint: al::Point(i, j)];
                [self drawDot:p size:1.2];
            }
        }
    }
    
	std::vector<al::Line> &lines = [edges getLines];
	
	for (i = 0; i<lines.size(); i++) {
		[self drawAlLine:lines[i] color:[NSColor whiteColor]];
	}
	
	
	al::A34Result *result = [edges result];

	if ([edges valid] && ofs>=0 && result && result->size() > 0) {
		ofs %= result->size();
		NSBezierPath* path = [NSBezierPath bezierPath];
		al::Polygon res = (*result)[ofs];
		al::Point *points = res.getPoints();
		al::Point p1 = points[0];
		
		[path moveToPoint: [self makeNSPoint:p1]];
		
		for(i=1;i<res.getEdgesCount();i++) {
 			p1 = points[i];
			[path lineToPoint: [self makeNSPoint:p1]];
		}
		
        [rcolor set];
		[path fill];
		
	}

}

-(void)popLine {
	
}


-(id<EdgesHolder>)setEdgesHolder:(id<EdgesHolder>)eh {
	edgesHolder = eh;
	return eh;
}

@synthesize dots;

@end







