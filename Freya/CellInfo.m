//
//  CellInfo.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-10.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "CellInfo.h"

@implementation CellInfo
@synthesize image;
@synthesize subtitle;
@synthesize title;

-(id)initWithTitle:(NSString *)_title subtitle:(NSString *)_subtitle image:(NSImage *)_image{
    self = [super init];
    if(self){
        title = _title;
        subtitle = _subtitle;
        image = _image;
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    CellInfo *cellInfo = [[CellInfo alloc] initWithTitle:[self title]
                                                subtitle:[self subtitle]
                                                   image:[self image]];
    return cellInfo;
}
@end
