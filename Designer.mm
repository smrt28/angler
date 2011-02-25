//
//  Designer.m
//  Angler
//
//  Created by smrt on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Designer.h"

//#import "primitives.h"

@implementation Designer

#define ZOOM_SPEED 0.2

- (float)grid {
	return _grid + _zoom * ZOOM_SPEED;
}

-(float)minZoom {
	return (3 - _grid)/ZOOM_SPEED;
}

-(float) zoom:(float)z {
	float rv = z * ( (_grid + _zoom * ZOOM_SPEED) / _grid );
	if (rv < 0.5) rv = 0.5;
	return rv;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_field = [[Field alloc] initWithW:18 h:18 max_w:500 max_h:500];
		p1_valid = false;
		p2_valid = false;
		_grid = 30;
		margin.x = 5;
		margin.y = 5;
		width = 28;
		height = 28;
		_zoom = 0;
		lines = [[NSMutableArray alloc] init];
    }
    return self;
}


-(bool) isValidPoint:(DPoint)p {
	if (p.x < 0 || p.y < 0) return false;
	if (p.x >= width || p.y >= height) return false;
	return true;
}

-(bool) isValidLine:(DLine)l {
	return [self isValidPoint:l.p1] &&
		[self isValidPoint:l.p2];
}



- (void)dealloc {
	[lines release];
	[super dealloc];
}

-(NSPoint) dp2p:(DPoint)p {
	NSPoint rv;
	rv.x = ((CGFloat)p.x) * [self grid] + margin.x;
	rv.y = ((CGFloat)p.y) * [self grid] + margin.y;
	return rv;
}

-(DPoint) p2dp:(NSPoint)p {
	DPoint rv;
	rv.x = (p.x -= margin.y) / [self grid] + 0.5;
	rv.y = (p.y -= margin.x) / [self grid] + 0.5;	
	return rv;
}


-(void)awakeFromNib
{	
	[[self window] makeFirstResponder:self];
	[[self window] setAcceptsMouseMovedEvents:YES];
}

- (BOOL)acceptsMouseMovedEvent {
	return YES;
}

- (void)mouseMoved:(NSEvent *)theEvent {

}

- (void)mouseDragged:(NSEvent *)theEvent {
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	[_field dragTo:p];
	[self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	[_field startAt:p];
}


- (void)mouseUp:(NSEvent *)theEvent {
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	[_field stopAt:p];
	[self setNeedsDisplay:YES];
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


- (void) keyDown:(NSEvent *)event {
	unsigned short code = [event keyCode];
	if (code == 51) {
		[lines removeLastObject];
		[self setNeedsDisplay:YES];
	}

	
}

- (void)drawRect:(NSRect)dirtyRect {
	int i, j;
	for (j=0;j<6;j++) {
	for (i=0;i<6;i++) {
		[_field setX:30 + i*[_field width] 
				   y:30 + j*[_field height]];
		[_field draw];
	}
	}
	/*
	[_field setX:30+[_field width] y:30];
	[_field draw];
	*/
	
	[_field setX:30 y:30];
}

- (void)scrollWheel:(NSEvent *)theEvent {
	CGFloat x = [theEvent deltaX];
	CGFloat y = [theEvent deltaY];
	CGFloat a = (x + y) / 2;
	
	[_field setWidth:[_field width] - a];
	[_field setHeight:[_field height] - a];
	NSLog(@"zoom :%f", _zoom);
	[self setNeedsDisplay:YES];
	
}

- (SEL)action {
	return action; 
}

- (void)setTarget:(id)anObject {
	
}

- (void)setAction:(SEL)newAction {
    action = newAction;
}

- (BOOL)isFlipped { return YES; }

@end
