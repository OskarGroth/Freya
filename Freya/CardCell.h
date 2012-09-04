//
//  CustomCell.h
//  Freya
//
//  Created by Oskar Groth on 2012-07-10.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CardCell : NSTextFieldCell {
@private
    NSImage *__unsafe_unretained image;
    NSString *__unsafe_unretained subtitle;
}

@property (unsafe_unretained) NSImage *image;
@property (unsafe_unretained) NSString *subtitle;
@end