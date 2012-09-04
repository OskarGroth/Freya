//
//  InfoViewController.h
//  Zeus
//
//  Created by Oskar Groth on 2012-01-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface InfoViewController : NSViewController{
    NSArray *infoNames;
    NSArray *infoValues;
	CGDirectDisplayID *displays;

}
-(IBAction)selectDevice:(id)sender;
-(void)interrogateIOKitFor: (CGDirectDisplayID) displayID;
-(void) resetWindowValues;
-(void)interrogateQuartzFor: (CGDirectDisplayID) displayID;
-(void)interrogateHardware;
-(void)update;
@property (strong) IBOutlet NSImageView *brandImageView;
@property (strong) IBOutlet NSImageView *cardImageView;

@property (strong) IBOutlet NSPopUpButton *deviceButton;
@property (strong) IBOutlet NSTextField *modelTextField;
@property (strong) IBOutlet NSTextField *deviceTextField;
@property (strong) IBOutlet NSTextField *vendorTextField;
@property (strong) IBOutlet NSTextField *vramTextField;
@property (strong) IBOutlet NSTextField *driverTextField;
@property (strong) IBOutlet NSTextField *slotTextField;
@property (strong) IBOutlet NSTextField *qeciTextField;


@end
