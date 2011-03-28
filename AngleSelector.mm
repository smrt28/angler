//
//  AngleSelector.m
//  Angler
//
//  Created by smrt on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AngleSelector.h"
#include <stdio.h>

@implementation AngleSelector

@synthesize edges;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        isSelected = NO;
        edges = 4;
        CGFloat x = 0.3;
        CGFloat a = 0.8;
        color = [[NSColor colorWithCalibratedRed:x green:x blue:x alpha:a] retain];
      
        x = 1;
        colorSel = [[NSColor colorWithCalibratedRed:x green:x blue:x alpha:a] retain];

        
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {

	int i;
	NSRect bounds = [self bounds];
    
   // [NSBezierPath fillRect: bounds];
    
	CGFloat w2 = bounds.size.width / 2;
	CGFloat h2 = bounds.size.height / 2;

	NSBezierPath* path = [NSBezierPath bezierPath];
	[path setLineCapStyle:NSSquareLineCapStyle];
	[path setLineWidth: 2];
    
    if (isSelected)
        [colorSel set];
    else
        [color set];

	
	for (i = 0;i < edges + 1; i++) {
		CGFloat alpha = i * ((2*M_PI) / edges);
		CGFloat x = sin(alpha) * w2;
		CGFloat y = cos(alpha) * h2;
		
		if (i == 0)
			[path moveToPoint:NSMakePoint(x + w2, y + h2)];
		else
			[path lineToPoint:NSMakePoint(x + w2, y + h2)];
	}
	[path fill];
	
	NSDictionary * dict =
    [NSDictionary dictionaryWithObjects:
	 [NSArray arrayWithObjects:
	  [NSFont fontWithName:@"Arial Black" size:55],
	  [NSColor blackColor],
	  nil]
						forKeys:
	 [NSArray arrayWithObjects:
	  NSFontAttributeName,
	  NSForegroundColorAttributeName,
	  nil]];
	

	
	NSString *s = [NSString stringWithFormat:@"%d", edges ];
	NSSize sz = [s sizeWithAttributes: dict];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [appCtrl performSelector:sel withObject:self];
}

- (BOOL)isFlipped { return YES; }

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath {
    if ([keyPath  compare:@"edges"] == NSOrderedSame) {
        NSNumber *ne = value;
        edges = [ne intValue];
    }
}

- (void)setAction:(SEL)aSelector {
    sel = aSelector;
}

- (void)setTarget:(id)anObject {
    appCtrl = anObject;
}

-(void)setSelected:(BOOL)b {
    if (b!=isSelected)
        [self setNeedsDisplay:YES];
    isSelected = b;
}

@end
