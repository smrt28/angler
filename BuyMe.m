//
//  BuyMe.m
//  Angler
//
//  Created by smrt on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuyMe.h"


@implementation BuyMe

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        blinkState = true;
        blink = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(doBlink:) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)dealloc
{
    [blink release];
    [super dealloc];
}

- (void)doBlink:(NSTimer *)theTimer {
    blinkState = blinkState ? false : true;
    [self setNeedsDisplay:YES];
}


- (NSAttributedString *)attributedTitle {
    
	// set default attributes & alignment
	if (!attributedTitle) {
        
		NSFont *smallFont = [NSFont controlContentFontOfSize:
                             [NSFont systemFontSizeForControlSize: NSSmallControlSize]];
        
		NSMutableDictionary *attributes = [[NSDictionary dictionaryWithObjectsAndKeys:
                                            smallFont, NSFontAttributeName,
                                            [NSColor blackColor] , NSForegroundColorAttributeName,
                                            nil] mutableCopy];
        
		NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		
		[pStyle setAlignment: NSCenterTextAlignment];
		[attributes setValue: pStyle forKey: NSParagraphStyleAttributeName];
        [attributes setObject:[NSColor yellowColor] forKey:NSForegroundColorAttributeName];
		[pStyle release];
		[attributes autorelease];
		
		return [[[NSAttributedString alloc] initWithString: @"Buy to stop the blinking!" attributes: attributes] autorelease];
	}
	
	return attributedTitle;
}

/*
- (NSRect)titleRectForBounds:(NSRect)theRect {
    NSRect titleFrame = [super titleRectForBounds:theRect];
    NSSize titleSize = [[self attributedStringValue] size];
    theRect.origin.y += (theRect.size.height - titleSize.height)/2.0 - 0.5;
    return theRect;
}
 */

- (void)drawRect:(NSRect)dirtyRect
{
    if (blinkState) {

    NSSize titleSize = [[self attributedTitle] size];
    NSRect theRect = [super bounds];
    theRect.origin.y -= (theRect.size.height - titleSize.height)/2.0 - 0.5;
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:3 yRadius:3];
    [[NSColor colorWithCalibratedRed:1 green:0 blue:0 alpha:0.7] set];
    [path fill];
    
        [[self attributedTitle] drawInRect: theRect];
    }

}



@end
