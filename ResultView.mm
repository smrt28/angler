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

    int fieldsPerRow = 6;
    CGFloat singleFieldSize = paperSize.width / fieldsPerRow;
    int n = [edges getResultCount];
    int rows = ((n - 1)/fieldsPerRow) + 1;
    int rowsPerPage = paperSize.height / singleFieldSize;
    int fieldsPerPage = rowsPerPage * fieldsPerRow;
    int pages = (n - 1)/fieldsPerPage + 1;
    
    range->location = 1;
    range->length = pages + 1;
    page = 0;
    return YES;
}


- (float)calculatePrintHeight {
    NSPrintInfo *pi = [[NSPrintOperation currentOperation] printInfo];
    NSSize paperSize = [pi paperSize];
    float pageHeight = paperSize.height - [pi topMargin] - [pi bottomMargin];
    float scale = [[[pi dictionary] objectForKey:NSPrintScalingFactor]
                   floatValue];
    return pageHeight / scale;
}

- (NSRect)rectForPage:(NSInteger)pageNumber {
    NSRect rv;
    
    NSPrintInfo *pi = [[NSPrintOperation currentOperation] printInfo];
    NSSize paperSize = [pi paperSize];
    rv.origin.x = 0;
    rv.origin.y = 0;
    rv.size.width = paperSize.width;
    rv.size.height = paperSize.height;
    return rv;
}

- (void)drawRect:(NSRect)dirtyRect {
	
    if (! [NSGraphicsContext currentContextDrawingToScreen] ) { 
        NSPrintInfo *pi = [[NSPrintOperation currentOperation] printInfo];
        NSSize paperSize = [pi paperSize];
        
        CGFloat marginX = 30;
        CGFloat marginY = 30;
        int fieldsPerRow = 6;
        
        paperSize.width -= 2*marginX;
        paperSize.height -= 2*marginY;
        
        CGFloat singleFieldSize = paperSize.width / fieldsPerRow;
        int n = [edges getResultCount];
        int rows = ((n - 1)/fieldsPerRow) + 1;
        int rowsPerPage = paperSize.height / singleFieldSize;
        int fieldsPerPage = rowsPerPage * fieldsPerRow;
        int pages = (n - 1)/fieldsPerPage + 1;
        
        if (page == 0) {
            page++;
            Field *f = [[[Field alloc] initWithW:18 h:18 max_w:paperSize.width max_h:paperSize.width] autorelease];
            f.bgcolor = [NSColor colorWithDeviceRed: 0 green: 0 blue: 0 alpha: 1];
            f.lineColor = [NSColor blackColor];
            f.maxLineWidth = f.minLineWidth = 2;
            [f setX:marginX y:marginX + paperSize.height/2 - paperSize.width/2];
            [f draw:edges offset:-1 resultColor:0];
            
            return;
        }
        
        
        int from = (page - 1) * fieldsPerPage;
        int to = from + fieldsPerPage;
        if (to > n) to = n;
        
        Field *f = [[[Field alloc] initWithW:18 h:18 max_w:singleFieldSize max_h:singleFieldSize] autorelease];
        f.bgcolor = [NSColor colorWithDeviceRed: 0 green: 0 blue: 0 alpha: 1];
        f.lineColor = [NSColor blackColor];
        f.maxLineWidth = f.minLineWidth = 0.4;

        NSColor *colors[3];
        colors[0] = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.15];
        colors[1] = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.15];
        colors[2] = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.15];    

        int x, y, k;
        k = from;

        for (y = 0; k < to && y < rowsPerPage; y++) {
            for (x = 0; k < to && x < fieldsPerRow; x++) {
                
                
                NSColor *col;
                col = colors[[edges result]->clasifySize(k)];
                
                [f setX:x*singleFieldSize+marginX y:y*singleFieldSize+marginY];
                [f draw:edges offset:k resultColor:col];      

                k ++;
                
            }
        }
        
        page++;
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
