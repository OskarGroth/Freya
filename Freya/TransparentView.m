//
//  TransparentView.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-22.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "TransparentView.h"

@implementation TransparentView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor clearColor] set];
    [NSBezierPath fillRect: [self bounds]];
}

@end
