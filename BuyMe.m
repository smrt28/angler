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
#ifdef FREE_VERSION
        paused = 0;
        blinkState = true;
        blink = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(doBlink:) userInfo:nil repeats:YES];
#endif
    }
    
    return self;
}

- (void)dealloc
{
#ifdef FREE_VERSION
    [blink release];
#endif
    [super dealloc];
}

- (void)doBlink:(NSTimer *)theTimer {
#ifdef FREE_VERSION
    if (paused > 0) 
        paused--;
    else
        [self setHidden:NO];
        
    blinkState = blinkState ? false : true;
    [self setNeedsDisplay:YES];
#endif
}

#ifdef FREE_VERSION
- (NSAttributedString *)attributedTitle {
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
        [attributes setObject:[NSColor colorWithCalibratedRed:1 green:1 blue:0 alpha:1] forKey:NSForegroundColorAttributeName];
		[pStyle release];
		[attributes autorelease];
		
		return [[[NSAttributedString alloc] initWithString: @"Buy to stop the blinking!" attributes: attributes] autorelease];
	}

	return attributedTitle;
}
#endif


- (void)drawRect:(NSRect)dirtyRect
{
#ifdef FREE_VERSION
    if (blinkState) {

    NSSize titleSize = [[self attributedTitle] size];
    NSRect theRect = [super bounds];
    theRect.origin.y -= (theRect.size.height - titleSize.height)/2.0 - 0.5;
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:3 yRadius:3];
    [[NSColor colorWithCalibratedRed:1 green:0 blue:0 alpha:0.4] set];
    [path fill];
    
        [[self attributedTitle] drawInRect: theRect];
    }
#endif
}

#ifdef FREE_VERSION
- (void)mouseDown:(NSEvent *)theEvent {
    paused = 50;
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.hroby.com/ag"]];
    [self setHidden:YES];
}
#endif
@end
