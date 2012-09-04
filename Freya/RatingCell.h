//
//  RatingCell.h
//  Freya
//
//  Created by Oskar Groth on 2012-07-19.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDStarRating.h"
@interface RatingCell : NSTextFieldCell {
@private

}
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end
