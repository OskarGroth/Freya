//
//  UploadDropView.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-12.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "UploadDropView.h"
#import "UploadViewController.h"
@implementation UploadDropView

// Automatically create accessor methods
@synthesize startingColor;
@synthesize endingColor;
@synthesize angle;
@synthesize label;
@synthesize controller;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeString, 
                                       NSFilenamesPboardType, nil]];
    }
    return self;
}

-(void)drawRect:(NSRect)myRect{

    startingColor = [NSColor colorWithDeviceWhite:0.9 alpha:1.0];
    endingColor = [NSColor colorWithDeviceWhite:1.0 alpha:1.0];
    //Create the gradient
    NSGradient *gradient = [[NSGradient alloc]initWithStartingColor:startingColor endingColor:endingColor];
    //Draw the gradient in the view at a 90 degree angle
    NSRect k = NSRectFromCGRect(CGRectMake(self.bounds.origin.x, self.bounds.origin.y+23, self.bounds.size.width, self.bounds.size.height-23));
    [gradient drawInRect:k angle:90];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) 
		== NSDragOperationGeneric) {
		
        return NSDragOperationGeneric;
		
    } // end if
	
    // not a drag we can use
	return NSDragOperationNone;	
	
} // end draggingEntered

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    return YES;
} // end prepareForDragOperation


- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    
    NSArray *zImageTypesAry = [NSArray arrayWithObjects:NSFilenamesPboardType, NSPasteboardTypeString, nil];
    NSString *zDesiredType = [zPasteboard availableTypeFromArray:zImageTypesAry];
    
    if ([zDesiredType isEqualToString:NSFilenamesPboardType]) {
		// the pasteboard contains a list of file names
		//Take the first one
		NSArray *zFileNamesAry = [zPasteboard propertyListForType:@"NSFilenamesPboardType"];
        
        [controller filesWereDropped:zFileNamesAry];
        
		return YES;
        
    }// end if
	
	//this can't happen ???
	NSLog(@"Error MyNSView performDragOperation");
	return NO;
	
} // end performDragOperation


@end