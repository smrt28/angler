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
        edges = 4;
        color = [[NSColor whiteColor] retain];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {

	int i;
	NSRect bounds = [self bounds];
	CGFloat w2 = bounds.size.width / 2;
	CGFloat h2 = bounds.size.height / 2;

	NSBezierPath* path = [NSBezierPath bezierPath];
	[path setLineCapStyle:NSSquareLineCapStyle];
	[path setLineWidth: 2];
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
	
	
	
	//[s drawAtPoint: NSMakePoint(w2 - sz.width/2, sz.height/4) withAttributes:dict]; 
	
}

- (void)mouseUp:(NSEvent *)theEvent {
	edges ++;
	if (edges > 15)
		edges = 3;
	[handler edgesCountChanged: edges];
	[self setNeedsDisplay:YES];
}

- (BOOL)isFlipped { return YES; }

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath {
    
    if ([keyPath  compare:@"color"] == NSOrderedSame) {
        float r, g, b, a;
        
        NSString *s = value;
        int l = [s length] + 1;
        char buf[l];
        if ([s getCString:buf maxLength:l encoding:NSUTF8StringEncoding]) {
            sscanf(buf, "%f, %f, %f, %f", &r, &g, &b, &a);
            [color release];
            color = [[NSColor colorWithCalibratedRed:r green:g blue:b alpha:a] retain];
        }
    }
    
}


@end
