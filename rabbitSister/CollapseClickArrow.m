//
//  CollapseClickIcon.m
//  CollapseClick
//
//  Created by Ben Gordon on 3/17/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClickArrow.h"

@implementation CollapseClickArrow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.arrowColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawWithColor:(UIColor *)color {
    self.arrowColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
}


@end
