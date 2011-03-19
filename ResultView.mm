//
//  ResultView.m
//  Angler
//
//  Created by smrt on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultView.h"
#import "Field.h"

@implementation ResultView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        field = [[Field alloc] initWithW:18 h:18 max_w:500 max_h:500];
        field.bgcolor = [NSColor colorWithDeviceRed: 0.6 green: 0.6 blue: 0.8 alpha: 1];
    }
    return self;
}


-(void)dealloc {
    [field release];
    [super dealloc];
}

- (void)mouseDown:(NSEvent *)theEvent {

//	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:self];
//	[ctrl showDesignerAtX:p.x y:p.y];
}

- (void)mouseDragged:(NSEvent *)theEvent {
	NSLog(@"result - mouse dragged!");
}

- (void)drawRect:(NSRect)dirtyRect {
	
	static const CGFloat S = 120; 
	static const CGFloat one = 0.9;
	static const CGFloat two = 0.8;
	
	int nx, ny;
	
	int x, y;
	
	NSRect bounds = [self bounds];
	
	nx = 1 + (bounds.size.width / S);
	ny = 1 + (bounds.size.height / S);
	
	
	
	NSColor *c1 = [NSColor colorWithDeviceRed:one green:one blue:one alpha: 1];
	NSColor *c2 = [NSColor colorWithDeviceRed:two green:two blue:two alpha: 1];

	NSRect r;
	r.size.width = r.size.height = S;

	NSColor *c;
	
	for (x = 0; x < nx; x++) {
		for (y = 0; y < ny; y++) {
			r.origin.x = x * S;
			r.origin.y = y * S;
			c = ((x + y) % 2) ? c1 : c2;
			[c set];
			[NSBezierPath fillRect: r];
			
		}
	}
    
//    [self animator];
	
//	[[NSColor yellowColor] set];
//	[NSBezierPath fillRect: bounds];

}

- (BOOL)isFlipped { return YES; }

-(void)setContent:(ALEdges *) edges {

}

@end
