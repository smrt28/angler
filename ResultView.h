//
//  ResultView.h
//  Angler
//
//  Created by smrt on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppCtrl.h"
#import "ALEdges.h"
#import "Field.h"

@interface ResultView : NSView {
	IBOutlet AppCtrl *ctrl;
    IBOutlet NSScrollView *scrollView;
    Field * field;
    ALEdges * edges;
    int page;
    int fieldsInRow;
}

-(void)setFieldsInRow:(int)flds;

-(void)setContent:(ALEdges *) edges;
-(void)checkResize;

@end
