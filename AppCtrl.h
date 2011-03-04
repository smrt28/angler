//
//  AppCtrl.h
//  Angler
//
//  Created by smrt on 2/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Designer;
@class ResultView;


@interface AppCtrl : NSObject {
	IBOutlet Designer * designer;
	IBOutlet ResultView * results;
}

-(void)showDesignerAtX:(CGFloat)x y:(CGFloat)y;

-(void)doSomething;

@end
