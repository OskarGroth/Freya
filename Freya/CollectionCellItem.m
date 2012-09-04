//
//  CollectionCell.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-23.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "CollectionCellItem.h"
#import "PrototypeView.h"
@interface CollectionCellItem ()

@end

@implementation CollectionCellItem

- (void)setSelected:(BOOL)flag
{
    [super setSelected:flag];
    [(PrototypeView*)[self view] setSelected:flag];
    [(PrototypeView*)[self view] setNeedsDisplay:YES];
}


@end
