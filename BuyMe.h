//
//  BuyMe.h
//  Angler
//
//  Created by smrt on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BuyMe : NSView {
@private
    NSAttributedString * attributedTitle;
#ifdef FREE_VERSION
    NSTimer * blink;
    bool blinkState;
#endif
}

- (void)doBlink:(NSTimer *)theTimer;

@end
