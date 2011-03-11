//
//  Edges.h
//  Angler
//
//  Created by smrt on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "A34.h"

@interface ALEdges : NSObject {
	std::vector<al::Line> lines;
	al::A34Result *result;
	bool resultValid;
}

@property al::A34Result* result;

-(ALEdges *)init;
-(void)dealloc;
-(void)push:(al::Line)line;
-(bool)runA34;
-(std::vector<al::Line> &) getLines;

@end
