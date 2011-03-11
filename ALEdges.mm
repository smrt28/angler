//
//  Edges.m
//  Angler
//
//  Created by smrt on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ALEdges.h"


@implementation ALEdges

@synthesize result;

-(void)push:(al::Line)line {
	resultValid = false;
	lines.push_back(line);
}
-(std::vector<al::Line> &) getLines {
	return lines;
}
-(ALEdges *)init {
	result = 0;
	edges = 4;
	resultValid = false;
	return self;
}

-(bool)runA34 {
	if (resultValid) 
		return true;
	delete result;
	result = 0;
	al::A34 a34(lines, edges);
	result = a34.run();
	resultValid = true;
	return false;
}

-(void)dealloc {
	delete result;
	[super dealloc];
}

-(bool)valid {
	return resultValid;
}


-(void)setEdges:(int)ed {
	if (ed == edges) return;
	edges = ed;
	resultValid = false;
}

@end

/*
@implementation ALEdges


@end*/