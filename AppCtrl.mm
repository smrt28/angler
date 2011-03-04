//
//  AppCtrl.m
//  Angler
//
//  Created by smrt on 2/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppCtrl.h"
#import "Designer.h"
#import "ResultView.h"

@implementation AppCtrl

-(void)doSomething {
	[designer setHidden:NO];
}


-(void)showDesignerAtX:(CGFloat)x y:(CGFloat)y {
	[designer showDesignerAtX:x y:y];
}

@end
