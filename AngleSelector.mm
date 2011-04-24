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
        
        x = 0.1;
        colorSel = [[NSColor colorWithCalibratedRed:x green:x blue:x alpha:a] retain];

        x = 0.5;
        colorTxt = [[NSColor colorWithCalibratedRed:x green:x blue:x alpha:a] retain]; 
        
        x = 1;
        colorTxtSel = [[NSColor colorWithCalibratedRed:x green:x blue:x alpha:a] retain];
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}


- (NSAttributedString *)attributedTitle: (NSString *)text {
    
    CGFloat addSize = -3;
    if (isSelected)
        addSize = 5;
    NSFont *smallFont = [NSFont controlContentFontOfSize:
                         [NSFont systemFontSizeForControlSize: NSRegularControlSize /*NSSmallControlSize*/] + addSize];
    
    NSMutableDictionary *attributes = [[NSDictionary dictionaryWithObjectsAndKeys:
                                        smallFont, NSFontAttributeName,
                                        [NSColor blackColor] , NSForegroundColorAttributeName,
                                        nil] mutableCopy];
    
    NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    
    [pStyle setAlignment: NSCenterTextAlignment];
    [attributes setValue: pStyle forKey: NSParagraphStyleAttributeName];
    [attributes setObject:(isSelected ? colorTxtSel : colorTxt) forKey:NSForegroundColorAttributeName];
    [pStyle release];
    [attributes autorelease];
    
    
    
    return [[[NSAttributedString alloc] initWithString:text attributes: attributes] autorelease];
    
}

    
- (void)drawText:(NSString *)text
{

    NSAttributedString *title = [self attributedTitle: text];
    
        NSSize titleSize = [title size];
        NSRect theRect = [super bounds];
        theRect.origin.y += (theRect.size.height - titleSize.height)/2.0 - 0.5;
        
        
    [title drawInRect: theRect];
}




- (void)drawRect:(NSRect)dirtyRect {

	int i;
	NSRect bounds = [self bounds];
    
    CGFloat dsz = 5;
    if (isSelected) dsz = 0;
    bounds.origin.x += dsz;
    bounds.origin.y += dsz;
    bounds.size.width -= dsz * 2;
    bounds.size.height -= dsz * 2;
    
   // [NSBezierPath fillRect: bounds];
    
	CGFloat w2 = bounds.size.width / 2;
	CGFloat h2 = bounds.size.height / 2;

	NSBezierPath* path = [NSBezierPath bezierPath];
	[path setLineCapStyle:NSSquareLineCapStyle];
    

    if (isSelected)
        [colorSel set];
    else
        [color set];

	
	for (i = 0;i < edges + 1; i++) {
		CGFloat alpha = i * ((2*M_PI) / edges);
		CGFloat x = sin(alpha) * w2;
		CGFloat y = cos(alpha) * h2;
		
		if (i == 0)
			[path moveToPoint:NSMakePoint(x + w2 + bounds.origin.x, y + h2 + bounds.origin.y)];
		else
			[path lineToPoint:NSMakePoint(x + w2 + bounds.origin.x, y + h2 + bounds.origin.y)];
	}
	[path setLineWidth: 0];    
	[path fill];
/*
    if (isSelected) {
        [path setLineWidth: 2];
        [[NSColor yellowColor] set];
        [path stroke];
    }
*/
	NSString *s = [NSString stringWithFormat:@"%d", edges ];
    
    [self drawText:s];
	/*
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
	

	
	NSSize sz = [s sizeWithAttributes: dict];
     */
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
