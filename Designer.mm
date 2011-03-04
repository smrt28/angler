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



- (void)windowResized:(NSNotification *)notification;
{
	/*
	NSRect frame = [self frame];
	NSSize size = [[self window] frame].size;
	NSRect r;
	r.size = frame.size;
	r.origin.x = (size.width - frame.size.width) / 2;
	r.origin.y = (size.height - frame.size.height) / 2;
	[self setFrame: r];
	[self setNeedsDisplay:YES];
	
	NSLog(@"window width = %f, window height = %f", size.width, size.height);
	 
	 */
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_field = [[Field alloc] initWithW:18 h:18 max_w:500 max_h:500];
		_field.bgcolor = [NSColor colorWithDeviceRed: 0.6 green: 0.6 blue: 0.8 alpha: 1];
	
		/*
		// theAnim is an NSAnimation instance variable.
        _shading = [[NSAnimation alloc] initWithDuration:10.0
										 animationCurve:NSAnimationEaseIn];
        [_shading setFrameRate:20.0];
        [_shading setAnimationBlockingMode:NSAnimationNonblocking];
        [_shading setDelegate:self];
	*/
	/*	
		[[NSNotificationCenter defaultCenter] 
				addObserver:self selector:@selector(windowResized:) 
				name:NSWindowDidResizeNotification object:[self window]];
	 */
		
		/*
		_timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self 
									   selector:@selector(timerFired:) userInfo:(id)nil repeats:(BOOL)true];
*/
		
	}
    return self;
}

- (void)timerFired:(NSTimer*)theTimer {
	NSLog(@"time!");
}




- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

-(void)awakeFromNib
{	
[self setEnabled:NO];
}

- (BOOL)acceptsMouseMovedEvent {
	return YES;
}
 
-(BOOL)acceptsFirstResponder { return YES; }

-(BOOL)becomeFirstResponder { return YES; } 

- (void)mouseMoved:(NSEvent *)theEvent {
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSRect bounds = [self bounds];
	if (p.x > 0 && p.y > 0 && p.x < bounds.size.width && p.y < bounds.size.height)		
		NSLog(@"Mouse moved! %d %d", (int)p.x , (int)p.y);
	else {
		
		
	}
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

- (void) keyDown:(NSEvent *)event {
	unsigned short code = [event keyCode];
	if (code == 51) {
		[self setNeedsDisplay:YES];
	}
	/*
	NSRect r;
	r.origin.x = 0;
	r.origin.y = 0;
	r.size.width = 450;
	r.size.height = 450;
	[self setFrame: r];
*/
	[_field signal: code];
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

- (void)drawRect:(NSRect)dirtyRect {
	NSRect bounds = [self bounds];

	CGFloat C = 15;
	NSRect border;
	border.size = bounds.size;
	border.origin = bounds.origin;
	[_field.bgcolor set];
	DrawRoundedRect(border, 25, 25);
	
	[_field setX:bounds.origin.x + C y:bounds.origin.y + C];
	[_field setWidth: bounds.size.width - 2*C];	
	[_field setHeight: bounds.size.height - 2*C];
	[_field setMarginX:10];
	[_field setMarginY:10];	
	[_field draw];
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
//	[self setAlphaValue:0.5];
}

@end
