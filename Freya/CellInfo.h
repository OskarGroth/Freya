//
//  CellInfo.h
//  Freya
//
//  Created by Oskar Groth on 2012-07-10.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellInfo : NSObject <NSCopying> {
@private
    NSString *__unsafe_unretained title;
    NSString *__unsafe_unretained subtitle;
    NSImage *__unsafe_unretained image;
}

@property (unsafe_unretained) NSString *title;
@property (unsafe_unretained) NSString *subtitle;
@property (unsafe_unretained) NSImage *image;

- (id)initWithTitle:(NSString *)_title subtitle:(NSString *)_subtitle image:(NSImage *)_image;

@end