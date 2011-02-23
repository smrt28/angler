//
//  AppCtrl.h
//  Angler
//
//  Created by smrt on 2/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Designer.h"

@interface AppCtrl : NSObject {
	IBOutlet NSButton * buttonCount;
	IBOutlet Designer * designer;
}

-(IBAction)clicka:(id)sender;
-(IBAction)clicka2:(id)sender;

@end
