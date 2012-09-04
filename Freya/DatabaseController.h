//
//  DatabaseController.h
//  Freya
//
//  Created by Oskar Groth on 2012-07-10.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "EDStarRating.h"
#import "PXSourceListDataSource.h"
#import "PXSourceListDelegate.h"
#import "STOverlayController.h"
#import "JUEmptyView.h"
#import "Firmware.h"
#import "DMTabBar.h"
@interface DatabaseController : NSObject <RKRequestDelegate, RKObjectLoaderDelegate, NSTableViewDataSource, NSTableViewDelegate, PXSourceListDataSource, PXSourceListDelegate, EDStarRatingProtocol>{
    IBOutlet PXSourceList *sourceList;	
	NSMutableArray *sourceListItems;
}
@property (strong) IBOutlet NSTextField *commentAuthorField;
@property (strong) IBOutlet NSTextField *commentField;
@property (strong) IBOutlet NSView *panel;
@property (strong) IBOutlet NSView *commentView;
@property (strong) IBOutlet DMTabBar *tabBar;
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSView *firmwareView;
@property (strong) IBOutlet NSTextField *firmwareTitleField;
@property (strong) IBOutlet NSTextField *firmwareModelField;
@property (strong) IBOutlet NSTextField *firmwareAuthorField;
@property (strong) IBOutlet NSTextField *firmwareIDField;
@property (strong, nonatomic) NSMutableArray *cardModels;
@property (strong) IBOutlet NSTextField *firmwareDateField;
@property (strong) IBOutlet EDStarRating *firmwareRating;
@property (strong) IBOutlet NSTextField *firmwareInfoField;
@property (strong) IBOutlet NSImageView *firmwareCardView;
@property (strong) IBOutlet JUEmptyView *firmwareContainerView;
@property (strong, nonatomic) Firmware *currentFirmware;
@property (strong, nonatomic) DMTabBarItem *previousTab;
@property (strong, nonatomic) NSMutableArray *allFirmwares;
@property (unsafe_unretained) IBOutlet NSScrollView *scrollView;
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(void)reloadFirmwares;
-(void)willLoadView;
-(void)tabBarSelection:(DMTabBarItemSelectionType)selectionType target:(DMTabBarItem*)targetTabBarItem index:(NSUInteger)targetIndex;
@property (nonatomic) NSMutableDictionary *firmwares;
@property (strong) IBOutlet NSTableView *firmwareTableView;
@property (strong) IBOutlet NSTableView *cardTableView;
@property (strong) IBOutlet NSImageView *cardImageView;
@property (strong, nonatomic) STOverlayController *overlayController;
@end
