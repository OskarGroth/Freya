//
//  UploadDropView.h
//  Freya
//
//  Created by Oskar Groth on 2012-07-12.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class UploadViewController;
@interface UploadDropView : NSView
{
    NSColor *startingColor;
    NSColor *endingColor;
    int angle;
}

// Define the variables as properties
@property(nonatomic) NSColor *startingColor;
@property(nonatomic) NSColor *endingColor;
@property(nonatomic) IBOutlet NSTextField *label;
@property(assign) int angle;
@property (strong) IBOutlet UploadViewController *controller;

@end