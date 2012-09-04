//
//  RatingCell.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-19.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "RatingCell.h"
#import "EDStarRating.h"
@implementation RatingCell
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    [super drawWithFrame:cellFrame inView:controlView];
    // my custom NSButtonCell
    NSButtonCell *warningCell = [[NSButtonCell alloc] init];  
    EDStarRating *k = [[EDStarRating alloc] init];
    [warningCell setTitle:@"aaa"];
    [self.controlView addSubview:k];
}

@end
