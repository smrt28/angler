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

- (BOOL)knowsPageRange:(NSRangePointer)range {
    NSPrintInfo *pi = [[NSPrintOperation currentOperation] printInfo];
    NSSize paperSize = [pi paperSize];
    
    CGFloat singleFieldSize = paperSize.width / 6;
    int n = [edges getResultCount];
    int rows = n / 6;
    
    //singleFieldSize * 
 
    range->location = 20;
    range->length = 5;
    return YES;
}

- (NSRect)rectForPage:(NSInteger)pageNumber {
    NSRect rv;
    rv.origin.x = 0;
    rv.origin.y = 0;
    rv.size.width = 100;
    rv.size.height = 100;
    return rv;
}

- (void)drawRect:(NSRect)dirtyRect {
	
    if (! [NSGraphicsContext currentContextDrawingToScreen] ) { 
        // Draw printer-only elements here
        NSRect r = dirtyRect;
        NSPrintOperation *op = [NSPrintOperation currentOperation];
        NSPrintInfo *pInfo = [op printInfo];
        NSLog(@"PRINT 2");
        return;
    }
    
    
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
        
         NSRect  vr = [self visibleRect];

        for(y = 0; !last && k < n;y ++) {
            for(x = 0; !last && k < n && x < W; x ++, k++) {
                xx = x*S; yy = y*S;
                
                if (yy + S < vr.origin.y) {
                    
                    int a;
                    a = 0;
                    continue;
                }
                
                if (yy > vr.origin.y + vr.size.height) {
                    continue;
                }
                /*
                if (xx > bnd.origin.x + bnd.size.width ||
                    yy > bnd.origin.y + bnd.size.height) {
                    last = true;
                    break;
                }*/
                
                //NSIntersectsRect();
                
                NSColor *col;
                col = colors[[edges result]->clasifySize(k)];
                [field setX:x*S y:y*S];
                [field draw:edges offset:k resultColor:col];
            }
        }
    }
}

- (BOOL)isFlipped { return YES; }

-(void)checkResize {
    NSRect f = [self frame];

    NSView * suv = [self superview];
    NSRect  vr = [self visibleRect];
    NSRect w = [suv bounds];
    int n = [edges getResultCount];
    f.size.height = ((n+5)/6) * (f.size.width/6);
    if (f.size.height < w.size.height)
        f.size.height = w.size.height;
    [self setFrame:f]; 
    [self setNeedsDisplay:YES];
}

-(void)setContent:(ALEdges *)ed {
    [self checkResize];
    [edges release];
    edges = ed;
    [edges retain];
    
    NSScrollView *sv = [self enclosingScrollView];
    
    NSRect r = [sv documentVisibleRect];
    sv = 0;
}

- (void)viewDidMoveToWindow
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowResized:) name:NSWindowDidResizeNotification
                                               object:[self window]];
}

- (void)windowResized:(NSNotification *)notification;
{
    [self checkResize];
}


@end
