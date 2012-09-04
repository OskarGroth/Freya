//
//  AppDelegate.h
//  HexFiend_2
//
//  Copyright 2008 ridiculous_fish. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSObject {
    IBOutlet NSMenuItem *extendForwardsItem, *extendBackwardsItem;
    IBOutlet NSMenuItem *fontMenuItem;
    IBOutlet NSMenuItem *processListMenuItem;
    IBOutlet NSMenu *bookmarksMenu;
    IBOutlet NSMenu *stringEncodingMenu;
}
@property (strong) IBOutlet NSView *infoView;

- (IBAction)diffFrontDocuments:(id)sender;

- (IBAction)setStringEncodingFromMenuItem:(NSMenuItem *)item;
- (void)setStringEncoding:(NSStringEncoding)encoding;

@end
