//
//  EdgesHolder.h
//  Angler
//
//  Created by smrt on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "EdgesHolder.h"
#include "AAtoms.h"

@protocol EdgesHolder

-(void)lineDrawn:(al::Line)line;

@end
