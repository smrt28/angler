//
//  Board.h
//  Angler
//
//  Created by smrt on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Board : NSObject {

	int width;
	int height;
	CGFloat grid;
}


-(void)draw:(CGFloat)p;


@end
