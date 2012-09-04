//
//  PrototypeView.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-23.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "PrototypeView.h"

@implementation PrototypeView
@synthesize selected;
- (void)drawRect:(NSRect)dirtyRect 
{
    if (selected) {
        NSString *inColorString = @"6eb2f1";
        NSColor *result = nil;
        unsigned int colorCode = 0;
        unsigned char redByte, greenByte, blueByte;
        
        if (nil != inColorString)
        {
            NSScanner *scanner = [NSScanner scannerWithString:inColorString];
            (void) [scanner scanHexInt:&colorCode];	// ignore error
        }
        redByte		= (unsigned char) (colorCode >> 16);
        greenByte	= (unsigned char) (colorCode >> 8);
        blueByte	= (unsigned char) (colorCode);	// masks off high bits
        result = [NSColor
                  colorWithCalibratedRed:		(float)redByte	/ 0xff
                  green:	(float)greenByte/ 0xff
                  blue:	(float)blueByte	/ 0xff
                  alpha:0.8];        NSShadow *shadow = [[NSShadow alloc] init];
        [result set];
        [shadow setShadowColor:[NSColor blackColor]];
        [shadow setShadowBlurRadius:3.0f];
        [shadow setShadowOffset:CGSizeMake(0.0f, -5.0f)];
        //[shadow set];
        
        CGRect rect = [self bounds];
        rect.size.width -= 30;
        rect.size.height -= 0;
        rect.origin.y += 4;
        rect.origin.x += 15;
        [NSBezierPath fillRect: rect];
    }
}


@end
