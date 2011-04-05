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
		_field = [[Field alloc] initWithW:17 h:17 max_w:500 max_h:500];
		_field.bgcolor = [NSColor colorWithDeviceRed: 0.6 green: 0.6 blue: 0.8 alpha: 1];
//        backShow = [NSTimer scheduledTimerWithTimeInterval:0.3 invocation:@selector(updClk:) repeats:YES];
     //   [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updClk:) userinfo:nil repeats:YES];
       
    //    backShow = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updClk:) userInfo:nil repeats:YES];
		edges = [[ALEdges alloc] init];
		[_field setEdgesHolder:self];
        [_field setDots:YES];
	}
    return self;
}

- (void)updClk:(NSTimer *)theTimer {
    al::A34Result *res = [edges result];
    if (!res) return;

    if (res->size() <= 1) {
        resOffset = -1;
        return;
    }
    
    int tmp = resOffset;
    resOffset = rand() % res->size();

    if (resOffset == tmp) {
        resOffset++;
        resOffset %= res->size();
    }
    
    /*
    resOffset++;
    
    if (resOffset >= res->size())
        resOffset = 0;
    
    if (resOffset < 0) 
        resOffset = 0;
    */
    [self setNeedsDisplay:YES]; 
    
}

- (void)timerFired:(NSTimer*)theTimer {
	NSLog(@"time!");
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [backShow release];
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
        s = [NSString stringWithFormat:@"%@-angles found: %d", aname, totalCnt];    
    }
    
    [appCtrl notifyChanges: edges];
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
        case 0: col = [NSColor colorWithCalibratedRed:0.5 green:0.5 blue:1 alpha:0.05]; break;
        case 1: col = [NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:0.05]; break;
        case 2: col = [NSColor colorWithCalibratedRed:1 green:0.5 blue:0.5 alpha:0.05]; break;
    }
    }
    
    
    
//   	[_field draw:edges offset:resOffset resultColor:col];
   	[_field draw:edges offset:-1 resultColor:col];
    
 //   + (NSBezierPath *)bezierPathWithRect:(NSRect)aRec
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

-(IBAction)clear: sender {
    while([edges getLines].size() > 0) {
        [edges pop];
    }
    [self recalculate];
}

@end



