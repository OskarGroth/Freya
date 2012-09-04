//
//  DropViewController.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-12.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "UploadViewController.h"
#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "RestKit/JSONKit.h"
#import <CommonCrypto/CommonDigest.h>
#import "RestKit/RKObjectManager.h"
#import "RestKit/RKObjectRouter.h"
@interface UploadViewController ()

@end

@implementation UploadViewController
@synthesize firmwarePanel;
@synthesize scriptPanel;
@synthesize cardBox;
@synthesize doneImageView;
@synthesize loadingPanel;
@synthesize returnButton;
@synthesize loadingNameLabel;
@synthesize loadingLabel;
@synthesize loadingSpinner;
@synthesize loadingImageView;
@synthesize scriptImageView;
@synthesize firmwareImageView;
@synthesize firmwareInfoField;
@synthesize firmwareTitleField;
@synthesize firmwareAuthorField;
@synthesize scriptInfoField;
@synthesize scriptAuthorField;
@synthesize scriptTitleField;
@synthesize scriptLabel;
@synthesize firmwareLabel;
@synthesize dropPanel;
@synthesize currentPanel;
@synthesize loadedFile;
@synthesize originalCheckBox;
@synthesize firmwareData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [firmwareImageView setImageScaling:NSImageScaleAxesIndependently];
    }
    
    return self;
}
-(void)filesWereDropped:(NSArray *)files{
    loadedFile = [files objectAtIndex:0];
    NSString *ext = [loadedFile pathExtension];
    if ([ext isEqualToString:@"py"] || [ext isEqualToString:@"rb"] || [ext isEqualToString:@"applescript"]) {
        [self loadScriptPanel];
    }else if ([ext isEqualToString:@"rom"]){
        [self loadFirmwarePanel];
    }
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    [loadingSpinner incrementBy:2.0];
    NSDictionary *resp = [[JSONDecoder decoder] parseJSONData:response.body];
    NSDictionary *errors = [resp valueForKey:@"errors"];
    if (errors) {
        NSString *key = [[errors allKeys] objectAtIndex:0];
        NSString *message = [NSString stringWithFormat:@"%@ %@", [key capitalizedString], [[errors valueForKey:key] objectAtIndex:0]];
        if ([key isEqualToString:@"md5"]) {
            message = @"This firmware already exists in Freya database!";
        }
        [loadingLabel setStringValue:message];
        [returnButton setTitle:@"Return"];
        [returnButton setHidden:NO];
        [loadingSpinner stopAnimation:nil];
        [loadingSpinner setHidden:YES];
    }
    if ([resp valueForKey:@"id"]) {
        // If we recieved firmware object, upload the firmware data to it
        RKParams *file = [RKParams params];
        [[file setData:firmwareData MIMEType:@"application/octet-stream" forParam:@"firmware[firmware_data]"] setFileName:@"firmware.rom"];
        [RKObjectManager sharedManager].serializationMIMEType = @"application/octet-stream";
        [[RKClient sharedClient] put:[NSString stringWithFormat:@"firmwares/%@", [resp valueForKey:@"id"]] params:file delegate:self];
        [loadingLabel setStringValue:@"Uploading firmware data..."];
        [loadingSpinner incrementBy:3.0];
    }else if(!errors) {
        // Firmware data upload completed
        [loadingLabel setStringValue:@"Upload successful!"];
        [returnButton setTitle:@"Done"];
        [doneImageView setImage:[NSImage imageNamed:@"doneicon"] ];
        [loadingSpinner stopAnimation:nil];
        [loadingSpinner setHidden:YES];
        [returnButton setHidden:NO];
    }

}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(error.description);
}

-(NSString*) getMD5FromFile:(NSString *)pathToFile {
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    
    NSData *inputData = [[NSData alloc] initWithContentsOfFile:pathToFile];
    CC_MD5([inputData bytes], [inputData length], outputData);
    
    NSMutableString *hash = [[NSMutableString alloc] init];
    
    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", outputData[i]];
    }
    
    return hash;
}

- (IBAction)returnPress:(id)sender {
    [self cancelPress:nil];
    if ([((NSButton*)sender).title isEqualToString:@"Return"]) {
        if ([loadingImageView.image isEqualTo:firmwareImageView.image]) {
            currentPanel = firmwarePanel;
        }else {
            currentPanel = scriptPanel;
        }
        [self deployPanel];
    }
}

-(void)loadFirmwarePanel{
    [self cancelPress:nil];
    currentPanel = firmwarePanel;
    [firmwareLabel setStringValue:[[loadedFile lastPathComponent] stringByDeletingPathExtension]];
    [firmwareImageView setImage:[NSImage imageNamed:@"rom.png"]];
    AppDelegate *d = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [cardBox removeAllItems];
    [cardBox addItemsWithObjectValues:d.databaseController.cardModels];
    [doneImageView setImage:nil];
    [self deployPanel];
    
}
- (IBAction)uploadDonePress:(id)sender {
    [loadingSpinner setDoubleValue:0.0];
    if (currentPanel == firmwarePanel) {
        firmwareData = [NSData dataWithContentsOfFile:loadedFile];
        NSString *error;
        if (firmwareData.length > 200000) {
            error = @"Firmware is too large!";
        }else if(firmwareTitleField.stringValue.length < 5){
            error = @"Title is too short! Minimum 5 characters";
        }else if(firmwareAuthorField.stringValue.length < 4){
            error = @"Author is too short! Minimum 4 characters";
        }else if(firmwareInfoField.stringValue.length < 15){
            error = @"Description is too short! Minimum 15 characters";
        }else if([[cardBox stringValue] isEqualToString:@"Select card"]){
            error = @"You must select compatible card model!";
        }
        if(error){
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"Ok"];
            [alert setMessageText:error];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert runModal];
            return;
        }
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setValue:firmwareAuthorField.stringValue forKey:@"author"];
        [data setValue:firmwareTitleField.stringValue forKey:@"title"];
        [data setValue:[self getMD5FromFile:loadedFile] forKey:@"md5"];
        [data setValue:cardBox.stringValue forKey:@"card_model"];
        [data setValue:firmwareInfoField.stringValue forKey:@"info"];
        [data setValue:[NSNumber numberWithInt:originalCheckBox.state] forKey:@"modified"];
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:data, @"firmware", nil];
        [[RKClient sharedClient] post:@"firmwares" params:params delegate:self];
        [self cancelPress:nil];
        currentPanel = loadingPanel;
        [loadingImageView setImage:firmwareImageView.image];
        [loadingNameLabel setStringValue:firmwareLabel.stringValue];
    }else {
        
    }
    [loadingLabel setStringValue:@"Uploading info..."];
    [loadingSpinner incrementBy:4.0];
    [loadingSpinner setHidden:NO];
    [loadingSpinner startAnimation:nil];
    [returnButton setHidden:YES];
    [self deployPanel];
    
}

-(void)loadScriptPanel{
    [NSApp stopModal];
    [NSApp endSheet:currentPanel];
    [currentPanel orderOut:self];
    currentPanel = scriptPanel;
    NSString *ext = [loadedFile pathExtension];
    if ([ext isEqualToString:@"applescript"]) {
        [scriptImageView setImage:[NSImage imageNamed:@"applescript.png"]];
    }else if ([ext isEqualToString:@"rb"]) {
        [scriptImageView setImage:[NSImage imageNamed:@"ruby.png"]];
    }else if ([ext isEqualToString:@"py"]) {
        [scriptImageView setImage:[NSImage imageNamed:@"python.png"]];
    }
    [scriptLabel setStringValue:[[loadedFile lastPathComponent] stringByDeletingPathExtension]];
    [self deployPanel];
}

-(void)deployPanel{
    AppDelegate *d = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [NSApp beginSheet:currentPanel modalForWindow:d.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    // [NSApp runModalForWindow:currentPanel];   //This call blocks the execution until [NSApp stopModal] is called
    // [NSApp endSheet:currentPanel];
    //  [currentPanel orderOut:self];
}

- (IBAction)uploadPress:(id)sender {
    if (!dropPanel) {
        [self loadView];
    }
    currentPanel = dropPanel;
    [self deployPanel];
}
- (IBAction)cancelPress:(id)sender {
    [((NSButton*)sender) setNextState];
    [((NSButton*)sender) setNeedsDisplay];
    [NSApp stopModal];
    [NSApp endSheet:currentPanel];
    [currentPanel orderOut:self];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [sheet orderOut:self];
}

@end
