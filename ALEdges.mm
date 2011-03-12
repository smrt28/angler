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
	lines.push_back(line);
    resultFor = -1;
}

-(std::vector<al::Line> &) getLines {
	return lines;
}

-(ALEdges *)init {
	result = 0;
	edges = 4;
    resultFor = -1;
	return self;
}

-(bool)runA34 {
    if (resultFor == edges)
        return true;

	delete result;
	result = 0;
	al::A34 a34(lines, edges);
	result = a34.run();
    resultFor = edges;
	return false;
}

-(void)dealloc {
	delete result;
	[super dealloc];
}

-(bool)valid {
	return edges == resultFor;
}


@synthesize edges;

@end

/*
@implementation ALEdges


@end*/