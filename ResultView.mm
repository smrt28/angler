//
//  ResultView.m
//  Angler
//
//  Created by smrt on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultView.h"
#import "Field.h"

//#define S 200

@implementation ResultView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        edges = 0;
        field = [[Field alloc] initWithW:18 h:18 max_w:400 max_h:400];
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
	
	static CGFloat S; 
	static const CGFloat one = 0.1;
	static const CGFloat two = 0.2;
	
	int nx, ny;
	
	int x, y, W;

	

    NSRect bnd = [self bounds];

    W = 6;
    S = bnd.size.width / W;
    
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
    
    
    if (edges) {
        NSColor *colors[3];
        colors[0] = [NSColor colorWithCalibratedRed:0.5 green:0.5 blue:1 alpha:0.5];
        colors[1] = [NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:0.5];
        colors[2] = [NSColor colorWithCalibratedRed:1 green:0.5 blue:0.5 alpha:0.5];
        
        CGFloat xx, yy;
        
        bool last = false;
        int k = 0;
        int n = [edges getResultCount];
        [field setWidth:S];
        [field setHeight:S];
        

        for(y = 0; !last && k < n;y ++) {
            for(x = 0; !last && k < n && x < W; x ++, k++) {
                xx = x*S; yy = y*S;
                if (xx > bnd.origin.x + bnd.size.width ||
                    yy > bnd.origin.y + bnd.size.height) {
                    last = true;
                    break;
                }
                
                NSColor *col;
                col = colors[[edges result]->clasifySize(k)];
                [field setX:x*S y:y*S];
                [field draw:edges offset:k resultColor:col];
            }
        }
    }
        
//    [self animator];
//	[[NSColor yellowColor] set];
//	[NSBezierPath fillRect: bounds];

}

- (BOOL)isFlipped { return YES; }

-(void)setContent:(ALEdges *)ed{
    [edges release];
    edges = ed;
    [edges retain];
    [self setNeedsDisplay:YES];
}

@end
