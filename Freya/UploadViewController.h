//
//  DropViewController.h
//  Freya
//
//  Created by Oskar Groth on 2012-07-12.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RestKit/RestKit.h"
@class UploadDropView;
@interface UploadViewController : NSViewController <RKRequestDelegate>
@property (strong) IBOutlet NSComboBox *cardBox;
@property (strong) IBOutlet NSImageView *doneImageView;
@property (strong) IBOutlet NSPanel *loadingPanel;
@property (strong) IBOutlet NSButton *returnButton;
@property (strong) IBOutlet NSTextField *loadingNameLabel;
@property (strong) IBOutlet NSTextField *loadingLabel;
@property (strong) IBOutlet NSProgressIndicator *loadingSpinner;
@property (strong) IBOutlet NSImageView *loadingImageView;
@property (strong) IBOutlet NSImageView *scriptImageView;
@property (strong) IBOutlet NSImageView *firmwareImageView;
@property (strong) IBOutlet NSTextField *firmwareInfoField;
@property (strong) IBOutlet NSTextField *firmwareTitleField;
@property (strong) IBOutlet NSTextField *firmwareAuthorField;
@property (strong) IBOutlet NSTextField *scriptInfoField;
@property (strong) IBOutlet NSTextField *scriptAuthorField;
@property (strong) IBOutlet NSTextField *scriptTitleField;
@property (strong) IBOutlet NSTextField *scriptLabel;
@property (strong) IBOutlet NSTextField *firmwareLabel;
@property (strong, nonatomic) NSData *firmwareData;
@property (strong) IBOutlet NSPanel *dropPanel;
@property (strong, nonatomic) NSPanel *currentPanel;
- (IBAction)uploadDonePress:(id)sender;
@property (strong) IBOutlet NSPanel *firmwarePanel;
@property (strong) IBOutlet NSPanel *scriptPanel;
@property (strong, nonatomic) NSString *loadedFile;
@property (strong) IBOutlet NSButton *originalCheckBox;
-(void)filesWereDropped:(NSArray*)files;
-(NSString*) getMD5FromFile:(NSString *)pathToFile;
-(void)deployPanel;
@end
