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
    NSTimer * blink;
    bool blinkState;
    int paused;
    BOOL hidden;
    int msgId;
    BOOL blinking;
}

-(void)setMsgId:(int)mid;
-(void)hide:(BOOL)b;
- (void)doBlink:(NSTimer *)theTimer;

@end
