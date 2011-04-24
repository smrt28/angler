//
//  BuyMe.m
//  Angler
//
//  Created by smrt on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuyMe.h"


@implementation BuyMe

-(void)setMsgId:(int)mid {
    
    if (msgId != mid) {
        [attributedTitle release];
        attributedTitle = 0;
    }
    
    msgId = mid;
    
    blinking = NO;
    if (msgId == 0) {
#ifndef FREE_VERSION        
        [self hide:YES];
#endif        
        blinking = YES;
        return;
    }
    if (msgId == 1) {
        [self hide:NO];
        blinking = NO;
    }
}

-(void)hide:(BOOL)b {
    hidden = b;
    [self setHidden:b];
}

- (void)setHidden:(BOOL)flag {
    if (hidden) flag = YES;
    [super setHidden:flag];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMsgId:0];
        paused = 0;
        blinkState = true;
        blink = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(doBlink:) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)dealloc
{
    [attributedTitle release];
    [blink release];
    [super dealloc];
}

- (void)doBlink:(NSTimer *)theTimer {
    if (hidden) {
        [self setHidden:YES];
        return;
    }
    
    if (msgId == 0) {
        if (paused > 0) 
            paused--;
        else
            [self setHidden:NO];
    }
    
    blinkState = blinkState ? false : true;
    if (!blinking) blinkState = true;
    [self setNeedsDisplay:YES];
}

- (NSAttributedString *)attributedTitle {
	if (!attributedTitle) {
        
		NSFont *smallFont = [NSFont controlContentFontOfSize:
                             [NSFont systemFontSizeForControlSize: NSRegularControlSize /*NSSmallControlSize*/]];
        
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
		
        switch(msgId) {
#ifdef FREE_VERSION
            case 0:
                attributedTitle = [[[NSAttributedString alloc] initWithString: @"Buy to stop the blinking!" attributes: attributes] retain];
                break;
#endif
            case 1:
                attributedTitle = [[[NSAttributedString alloc] initWithString: @"The image is too complicated!" attributes: attributes] retain];
                break;
        }
        
	}

	return attributedTitle;
}


- (void)drawRect:(NSRect)dirtyRect
{
    if (blinkState) {

    NSSize titleSize = [[self attributedTitle] size];
    NSRect theRect = [super bounds];
    theRect.origin.y -= (theRect.size.height - titleSize.height)/2.0 - 0.5;
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:3 yRadius:3];
    [[NSColor colorWithCalibratedRed:1 green:0 blue:0 alpha:0.4] set];
    [path fill];
    
        [[self attributedTitle] drawInRect: theRect];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
#ifdef FREE_VERSION
    paused = 50;
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.hroby.com/ag"]];
    [self setHidden:YES];
#endif
}
@end
