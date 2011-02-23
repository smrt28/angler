//
//  Designer.m
//  Angler
//
//  Created by smrt on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Designer.h"
#import "primitives.h"

@implementation Designer


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		p1_valid = false;
		p2_valid = false;
		board = [Board alloc];
		grid = 25;
		margin.x = 10;
		margin.y = 10;
		width = 16;
		height = 16;		
		lines = [[NSMutableArray alloc] init];
#if 0	
		NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(20, 20, 50, 20)];
		[button setButtonType:NSMomentaryPushInButton];
		[button setAction:@selector(click:)];
		[button setTarget:self];
		[self addSubview:button];
		[button setNeedsDisplay:YES];
#endif
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
	rv.x = ((CGFloat)p.x) * grid + margin.x;
	rv.y = ((CGFloat)p.y) * grid + margin.y;
	return rv;
}

-(DPoint) p2dp:(NSPoint)p {
	DPoint rv;
	rv.x = (p.x -= margin.y) / grid + 0.5;
	rv.y = (p.y -= margin.x) / grid + 0.5;	
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
	/*
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSLog(@"mouseMove %f %f", p.x, p.y);
	[self setNeedsDisplay:YES];
*/
	NSLog(@"mouseMove");
}

- (void)mouseDragged:(NSEvent *)theEvent {
	
	drag = [self convertPoint:[theEvent locationInWindow] fromView:nil];	
	NSLog(@"mouseDragged");
	[self setNeedsDisplay:YES];
	drag_valid = true;
	
}

- (void)mouseDown:(NSEvent *)theEvent {
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	int x = (p.x -= margin.y) / grid + 0.5;
	int y = (p.y -= margin.x) / grid + 0.5;
	p1.x = x;
	p1.y = y;
	p1_valid = true;
	p2_valid = false;
/*	
	id<NSString> ss = @"something";
	NSString *s;
	s = id;
*/	
//	location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//	DLine *line = [DLine alloc];	
	NSLog(@"mouseDragged %d %d", x, y);
	[self setNeedsDisplay:YES];
}


- (void)mouseUp:(NSEvent *)theEvent {
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	int x = (p.x -= margin.y) / grid + 0.5;
	int y = (p.y -= margin.x) / grid + 0.5;
	p2.x = x;
	p2.y = y;
	p2_valid = true;
	drag_valid = false;
	[self pushLine];
	NSLog(@"mouseDragged %d %d", x, y);
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

-(void) pushLine {
	if (!p1_valid || !p2_valid) return;
	if (![self isValidPoint:p1] || ![self isValidPoint:p2])
		return;
	DLine l;
	l.p1 = p1;
	l.p2 = p2;
	NSValue *nv = [NSValue valueWithBytes:&l objCType:@encode(DLine)];
	[lines addObject: nv];
}

-(void) drawLine:(DLine)l {
	NSPoint pp1 = [self dp2p:l.p1];
	NSPoint pp2 = [self dp2p:l.p2];
	NSBezierPath* path2 = [NSBezierPath bezierPath];
	[path2 moveToPoint:NSMakePoint(pp1.x, pp1.y)];
	[path2 lineToPoint:NSMakePoint(pp2.x, pp2.y)];
	[path2 setLineCapStyle:NSSquareLineCapStyle];
	[path2 setLineWidth:1.8];
	[path2 stroke];
}

- (void) keyDown:(NSEvent *)event {
	unsigned short code = [event keyCode];
	if (code == 51) {
		[lines removeLastObject];
		[self setNeedsDisplay:YES];
	}
}

- (void)drawRect:(NSRect)dirtyRect {
	NSRect r = [self frame];
	r.origin.y = r.origin.x = 0;
	[[NSColor blueColor] set];
	NSGraphicsContext* aContext = [NSGraphicsContext currentContext];
	
	aContext = 0;
	
	[[NSColor colorWithDeviceRed: 0.7 green: 1 blue: 0.7 alpha: 1] set];
	[NSBezierPath fillRect: r];
	
	int i, j;
	for (i = 0; i<width;i++) {
		for (j = 0; j<height;j++) {
			if ((p1.x == i && p1.y == j && p1_valid) ||
				(p2.x == i && p2.y == j && p2_valid)) {
				[self drawDot:NSMakePoint(margin.x + i*grid, 
										  margin.y + j*grid) size:2.5];
				
			} else {
				[self drawDot:NSMakePoint(margin.x + i*grid, 
										  margin.y + j*grid) size:1.5];
			}	
		}
	}
	
	
	for(NSValue *v in lines) {
		DLine l;
		[v getValue: &l];
		[self drawLine: l];		
	}
	
	
	if (p1_valid && drag_valid) {
		NSPoint a, b;
		a = [self dp2p:p1];
		b = drag;
		
		
		NSBezierPath* path2 = [NSBezierPath bezierPath];
		[path2 moveToPoint:NSMakePoint(a.x, a.y)];
		[path2 lineToPoint:NSMakePoint(b.x, b.y)];
		[path2 setLineCapStyle:NSSquareLineCapStyle];
		[path2 setLineWidth:1.8];
		[path2 stroke];
		
	}
	 
}

- (void)scrollWheel:(NSEvent *)theEvent {
	NSLog(@"scroll y:%f", [theEvent deltaY]);
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
