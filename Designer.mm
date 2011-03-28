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


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		resOffset = 0;
		_field = [[Field alloc] initWithW:18 h:18 max_w:500 max_h:500];
		_field.bgcolor = [NSColor colorWithDeviceRed: 0.6 green: 0.6 blue: 0.8 alpha: 1];
		edges = [[ALEdges alloc] init];
		[_field setEdgesHolder:self];
        [_field setDots:YES];
	}
    return self;
}

- (void)timerFired:(NSTimer*)theTimer {
	NSLog(@"time!");
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[edges release];
	[_field setEdgesHolder:nil];
	[super dealloc];
}

-(void)awakeFromNib
{		
	[[self window] makeFirstResponder:self];
	[[self window] setAcceptsMouseMovedEvents:YES]; 
}

- (BOOL)acceptsMouseMovedEvent {
	return YES;
}
 
-(BOOL)acceptsFirstResponder { return YES; }

-(BOOL)becomeFirstResponder { return YES; } 

- (void)mouseMoved:(NSEvent *)theEvent {
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSRect bounds = [self bounds];
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


-(void)mouseExited:(NSEvent *)theEven {
	NSLog(@"Mouse exited!");
}

-(void)recalculate {
    
    if ([edges valid])
		resOffset ++;
    else {    
        [edges runA34];
        [resultView setContent: edges];
        resOffset = 0;
    }
    
    al::A34Result *res_ptr = [edges result];
    if (!res_ptr) return;
    
    al::A34Result &res = *res_ptr;
    
    if (resOffset >= res.size())
        resOffset = 0;

    NSString *s = 0;
    
    int totalCnt, idx;
    totalCnt = 0; idx = 0;
    
    if (res.errorMessage) {
        s = [NSString stringWithFormat:@"%s", res.errorMessage];
        
    } else if (res.size() > 0) {
        
        NSString *biggest = @"";
        NSString *smallest = @"";
        
        al::Float biggestArea = res.getBiggestArea();
        al::Float smallestArea = res.getSmallestArea();
        
        al::Float area = res[resOffset].area();
        
        if (area == biggestArea) {
            biggest = @"biggest";
        }
        if (area == smallestArea) {
            smallest = @"smallest";
        }
        
        totalCnt = res.size();
        idx = resOffset + 1;
    }
    
    if (!s) {
        NSString *aname = [NSString stringWithFormat:@"%d", [edges edges]];
        s = [NSString stringWithFormat:@"%@: %d/%d", aname, idx, totalCnt];    
    }
    
    [textResultCnt setStringValue: s];

    
	[self setNeedsDisplay:YES];    
}

- (void) keyDown:(NSEvent *)event {
    [self recalculate];
	[self setNeedsDisplay:YES];
}


void DrawRoundedRect(NSRect rect, CGFloat x, CGFloat y)
{
    NSBezierPath* path = [NSBezierPath bezierPath];
	[path setLineWidth: 5];
	[path setLineCapStyle:NSSquareLineCapStyle];
    [path appendBezierPathWithRoundedRect:rect xRadius:x yRadius:y];
    [path fill];
}

- (void)drawRectPrinter:(NSRect)dirtyRect {

}

- (void)drawRect:(NSRect)dirtyRect {
    

    
    
	NSRect bounds = [self bounds];

	CGFloat C = 15;
	NSRect border;
	border.size = bounds.size;
	border.origin = bounds.origin;
	//[_field.bgcolor set];
    
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRect: bounds];
    [[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.5] set];
    [path fill];
    
    
	
	[_field setX:bounds.origin.x + C y:bounds.origin.y + C];
	[_field setWidth: bounds.size.width - 2*C];	
	[_field setHeight: bounds.size.height - 2*C];
	[_field setMarginX:0];
	[_field setMarginY:0];

    NSColor *col;

    if ([edges result]) {
    switch([edges result]->clasifySize(resOffset)) {
        case 0: col = [NSColor colorWithCalibratedRed:0.5 green:0.5 blue:1 alpha:0.5]; break;
        case 1: col = [NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:0.5]; break;
        case 2: col = [NSColor colorWithCalibratedRed:1 green:0.5 blue:0.5 alpha:0.5]; break;
    }
    }
    
   	[_field draw:edges offset:resOffset resultColor:col];
}

- (void)scrollWheel:(NSEvent *)theEvent {
	
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

-(void)showDesignerAtX:(CGFloat)x y:(CGFloat)y {
	[self setHidden:NO];
	[[self window] makeFirstResponder:self];
	[[self window] setAcceptsMouseMovedEvents:YES];
	[[self window] setMinSize:NSMakeSize(450.0, 450.0)];
	//[self setEnabled:NO];
	NSRect frame = [self frame];
	frame.origin.x = x - [_field width] / 2;
	frame.origin.y = y - [_field height] / 2;
	[self setFrame: frame];
}

-(void)lineDrawn:(al::Line)line {
    if (line.p1.cmp(&line.p2))
        return;
	[edges push:line];
    [self recalculate];
}

-(void)edgesCountChanged:(int)ed {
	[edges setEdges: ed];
    [self recalculate];
}

-(IBAction)undo: sender {
    [edges pop];
    [self recalculate];
}

@end
