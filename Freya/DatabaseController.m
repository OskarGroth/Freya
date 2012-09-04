//
//  DatabaseController.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-10.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "DatabaseController.h"
#import <HexFiend/HexFiend.h>
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "CellInfo.h"
#import "CardCell.h"
#import "AppDelegate.h"
#import "SourceListItem.h"
#import "PXSourceList.h"
#import "Firmware.h"
#import "DMTabBar.h"
#import "DMTabBarItem.h"
#import "RatingCell.h"
#import "STOverlayController.h"
#import "FirmwareComment.h"
#import <Quartz/Quartz.h>
#import "NSTimer+Blocks.h"
@implementation DatabaseController
@synthesize commentAuthorField;
@synthesize commentField;
@synthesize panel;
@synthesize commentView;
@synthesize tabBar;
@synthesize tableView;
@synthesize firmwareView;
@synthesize firmwareTitleField;
@synthesize firmwareModelField;
@synthesize firmwareAuthorField;
@synthesize firmwareIDField;
@synthesize firmwareDateField;
@synthesize firmwareRating;
@synthesize firmwareInfoField;
@synthesize firmwareCardView;
@synthesize firmwareContainerView;
@synthesize scrollView;
@synthesize allFirmwares;
@synthesize firmwares;
@synthesize firmwareTableView;
@synthesize cardTableView;
@synthesize cardImageView;
@synthesize overlayController;
@synthesize currentFirmware;
@synthesize cardModels;
@synthesize previousTab;
-(void)awakeFromNib{
    [super awakeFromNib];	
	sourceListItems = [[NSMutableArray alloc] init];
    overlayController = [[STOverlayController alloc] init];
    [cardImageView setImageScaling:NSImageScaleProportionallyUpOrDown];
    [sourceList setRowHeight:30];
    NSMutableArray *tabItems = [[NSMutableArray alloc] init];
    DMTabBarItem *refresh = [[DMTabBarItem alloc] initWithIcon:[NSImage imageNamed:@"refresh.png"] tag:99];
    [refresh.tabBarItemButton setTitle:@" "];
    [[refresh tabBarItemButton] setButtonType:NSMomentaryPushInButton];
    [refresh.tabBarItemButton setAlternateImage:[NSImage imageNamed:@"refresh.png"]];
    [refresh setButtonType:NSMomentaryPushInButton];
    [tabItems addObject:refresh];
    [tabItems addObject:[[DMTabBarItem alloc] initWithIcon:[NSImage imageNamed:@"tabeye.png"] tag:0]];
    previousTab = [tabItems objectAtIndex:1];
    [tabItems addObject:[[DMTabBarItem alloc] initWithIcon:[NSImage imageNamed:@"tabfile.png"] tag:1]];
    DMTabBarItem *search = [[DMTabBarItem alloc] initWithIcon:[NSImage imageNamed:@"magnify.png"] tag:98];
    [search.tabBarItemButton setButtonType:NSMomentaryPushInButton];
    [search.tabBarItemButton setTitle:@" "];
    [tabItems addObject:search];
    cardModels = [[NSMutableArray alloc] init];
    [cardModels addObject:@"AMD Radeon X1900 512MB"];
    [cardModels addObject:@"AMD Radeon 4870 512MB"];
    [cardModels addObject:@"AMD Radeon 4870 1GB"];
    [cardModels addObject:@"AMD Radeon 4890 1GB"];
    [cardModels addObject:@"AMD Radeon 5770 1GB"];
    [cardModels addObject:@"AMD Radeon 5850 1GB"];
    [cardModels addObject:@"AMD Radeon 5870 1GB"];
    [cardModels addObject:@"AMD Radeon 6870 1GB"];
    [cardModels addObject:@"AMD Radeon 6950 1GB"];
    [cardModels addObject:@"AMD Radeon 6970 1GB"];
    [cardModels addObject:@"AMD Radeon 7970 1GB"];
    [cardModels addObject:@"Nvidia 7300GT 256MB"];
    [cardModels addObject:@"Nvidia 7800GT 256MB"];
    [cardModels addObject:@"Nvidia 8800GTS 512MB"];
    [cardModels addObject:@"Nvidia 8800GTS 896MB"];
    [cardModels addObject:@"Nvidia 8800GTS 1GB"];
    [cardModels addObject:@"Nvidia 8800GT 512MB"];
    [cardModels addObject:@"Nvidia 8800GT 896MB"];
    [cardModels addObject:@"Nvidia 8800GT 1GB"];
    [cardModels addObject:@"Nvidia 8800GTX 896MB"];
    [cardModels addObject:@"Nvidia 8800GTX 1GB"];
    [cardModels addObject:@"Nvidia 8800GTX 1280MB"];
    [cardModels addObject:@"Nvidia GTX 275 896MB"];
    [cardModels addObject:@"Nvidia GTX 275 1GB"];
    [cardModels addObject:@"Nvidia GTX 285 1GB"];
    [cardModels addObject:@"Nvidia GTX 480 1GB"];
    [cardModels addObject:@"Nvidia GTX 480 1.5GB"];
    [cardModels addObject:@"Nvidia GTX 570 1GB"];
    [cardModels addObject:@"Nvidia GTX 580 1GB"];
    [cardModels addObject:@"Nvidia GTX 580 1280MB"];
    
    firmwareRating.starImage = [NSImage imageNamed:@"star.png"];
    firmwareRating.starHighlightedImage = [NSImage imageNamed:@"starhighlighted.png"];
    firmwareRating.maxRating = 5.0;
    firmwareRating.delegate = self;
    firmwareRating.horizontalMargin = 12;
    firmwareRating.editable=YES;
    firmwareRating.displayMode=EDStarRatingDisplayFull;
    
    [tabBar setTabBarItems:tabItems];
    //[tabBar handleTabBarItemSelection:^(DMTabBarItemSelectionType selectionType, DMTabBarItem *targetTabBarItem, NSUInteger targetTabBarItemIndex) {

   // }];
    
}

-(void)tabBarSelection:(DMTabBarItemSelectionType)selectionType target:(DMTabBarItem*)targetTabBarItem index:(NSUInteger)targetIndex{
    if (selectionType == DMTabBarItemSelectionType_WillSelect) {
        //NSLog(@"Will select %lu/%@",targetTabBarItemIndex,targetTabBarItem);
        if (targetTabBarItem.tag == 99) {
            [self reloadFirmwares];
        }
        [tabBar selectTabBarItem:[tabBar.tabBarItems objectAtIndex:targetIndex]];
        
    } else if (selectionType == DMTabBarItemSelectionType_DidSelect) {     
        if (targetTabBarItem.tag == 1) {
            [self switchToSubview:commentView fromView:firmwareView direction:NO];
        }else if (targetTabBarItem.tag == 0) {
            [self switchToSubview:firmwareView fromView:commentView direction:NO];
        }
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    NSString *comment = [(FirmwareComment*)[currentFirmware.comments.allObjects objectAtIndex:row] text];
    CGFloat f = [[NSFont systemFontOfSize:8] maximumAdvancement].width;
    return [self heightForStringDrawing:comment withFont:[NSFont systemFontOfSize:12] forWidth:295] + 20;
}
-(float)heightForStringDrawing:(NSString*)theTextField withFont:(NSFont*)myFont forWidth:(float)myWidth{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:theTextField];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize: NSMakeSize(myWidth, FLT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:myFont range:NSMakeRange(0,[textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    [layoutManager glyphRangeForTextContainer:textContainer];
    return [layoutManager usedRectForTextContainer:textContainer].size.height;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if(currentFirmware){
        return currentFirmware.comments.allObjects.count;
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView 
objectValueForTableColumn:(NSTableColumn *)tableColumn 
            row:(NSInteger)row
{
    FirmwareComment *comment = (FirmwareComment*)[currentFirmware.comments.allObjects objectAtIndex:row];
    NSString *text = [NSString stringWithFormat:@"%@, %@:\n%@",comment.createdAt, comment.author, comment.text];
    return text;
}


-(NSCell*)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTextFieldCell *cell = [[NSTextFieldCell alloc] init];
    [cell setWraps:YES];
    return cell;
}

- (IBAction)downloadPress:(id)sender {
    [overlayController endOverlay];
    [[RKClient sharedClient] setBaseURL:[RKURL URLWithString:[currentFirmware.data valueForKey:@"url"]]];
    [[RKClient sharedClient] get:@"" delegate:self];
    [overlayController beginOverlayToView:firmwareView withLabel:@"Downloading..." radius:10.0 size:CGSizeMake(200, 80)];
}


-(void)switchToSubview:(NSView*)view fromView:(NSView*)oldView direction:(BOOL)left{
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    if(left){
        [transition setSubtype:kCATransitionFromRight];
    }else{
        [transition setSubtype:kCATransitionFromLeft];
    }
    [firmwareContainerView setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"subviews"]];
    [[firmwareContainerView animator] replaceSubview:oldView with:view];
}

-(void)reloadFirmwares{
    NSFetchRequest *req = [Firmware fetchRequest];
    NSArray *fetchedFirmwares = [[NSArray alloc] initWithArray: [Firmware objectsWithFetchRequest:req]];
    req = [FirmwareComment fetchRequest];
    NSArray *fetchedComments = [FirmwareComment objectsWithFetchRequest:req];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    for (Firmware *f in fetchedFirmwares) {
        [context deleteObject:f];
    }
    for (FirmwareComment *c in fetchedComments) {
        [context deleteObject:c];
    }
    [context save:nil];
    [sourceList reloadData];
    [overlayController endOverlay];
    [overlayController beginOverlayToView:scrollView
                                withLabel:@"Loading firmwares..."
                                   radius:10.0 size:CGSizeMake(200, 80)];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"firmwares" delegate:self];
}

-(void)willLoadView{
    AppDelegate *d = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [d.window setMaxSize:NSMakeSize(656, 418+22)];
    [d.window setMinSize:NSMakeSize(656, 418+22)];
    [self reloadFirmwares];
}

- (IBAction)commentPostPress:(id)sender {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:commentAuthorField.stringValue forKey:@"author"];
    [data setValue:commentField.stringValue forKey:@"text"];
    [data setValue:currentFirmware.firmwareID forKey:@"firmware_id"];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:data, @"comment", nil];

    [[RKClient sharedClient] post:@"comments" params:params delegate:self];
}

-(void)didLoadFirmwares{
    [sourceListItems removeAllObjects];
    NSFetchRequest *req = [Firmware fetchRequest];
    NSArray *tempArray = [[NSArray alloc] initWithArray:[Firmware objectsWithFetchRequest:req]];
    if(tempArray.count > 1){
        allFirmwares = [[NSMutableArray alloc] initWithArray:[tempArray sortedArrayUsingSelector:@selector(compare:)]];
    }
    firmwares = [[NSMutableDictionary alloc] init];
    for (Firmware *f in allFirmwares) {
        if (![firmwares objectForKey:f.model]) {
            [firmwares setObject:[[NSMutableArray alloc] init] forKey:f.model];
        }
        [[firmwares objectForKey:f.model] addObject:f];
    }
	
	//Set up the items
    NSArray *models = firmwares.allKeys;
    NSArray *firmwaresForModel;
    NSMutableArray *children = [[NSMutableArray alloc] init];
    SourceListItem *item;
    for (int i =0; i<models.count; i++) {
        [children removeAllObjects];
        firmwaresForModel = [firmwares objectForKey:[models objectAtIndex:i]];
        item = [SourceListItem itemWithModelForFirmware:[firmwaresForModel objectAtIndex:0]];
        [item setBadgeValue:[firmwaresForModel count]];
        for (Firmware *f in firmwaresForModel) {
            [children addObject:[SourceListItem itemWithFirmware:f]];
        }
        [item setChildren:children];
        [sourceListItems addObject:item];
    }
    
	[sourceList reloadData];
    [overlayController beginOverlayToView:scrollView
                                withLabel:@"Loading comments..."
                                   radius:10.0 size:CGSizeMake(200, 80)];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"comments" delegate:self];
}


-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSString *url = request.URL.absoluteString;
    if(url.length > 10 && [[url substringToIndex:10] isEqualToString:@"https://s3"]){
        NSData *download = response.body;
        NSString *firmwareID = [[url componentsSeparatedByString:@"/"] objectAtIndex:4];
        NSString *name;
        for (Firmware *f in allFirmwares){
            if ([f.firmwareID.stringValue isEqualToString:firmwareID]) {
                name = f.title;
                break;
            }
        }
        AppDelegate *appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        NSString *filePath = [NSString stringWithFormat:@"%@/Firmwares/%@.rom", [appDelegate applicationSupportFolder], name];
        NSFileManager *manager = [[NSFileManager alloc] init];
        for (int i = 1; i < 20; i++){
            if(![manager fileExistsAtPath:filePath]){
                break;
            }
            filePath = [NSString stringWithFormat:@"%@/Firmwares/%@(%i).rom", [(AppDelegate*)[[NSApplication sharedApplication] delegate] applicationSupportFolder], name, i];
        }
        [download writeToFile:filePath atomically:YES];
        [appDelegate loadFiles];
        [overlayController endOverlay];
        [overlayController beginOverlayToView:firmwareView
                                    withLabel:@"Download finished!"
                                       radius:10.0 size:CGSizeMake(200, 80)];
        [NSTimer scheduledTimerWithTimeInterval:3.0 block:^(void){
            [overlayController endOverlay];  
        }repeats:NO];

    }
    NSDictionary *resp = [[JSONDecoder decoder] parseJSONData:response.body];
    if ([resp valueForKey:@"firmware_id"]) {
        FirmwareComment *comment = [FirmwareComment object];
        [comment setText:[resp valueForKey:@"text"]];
        [comment setAuthor:[resp valueForKey:@"author"]];
        [comment setCommentID:[resp valueForKey:@"id"]];
        [comment setCreatedAt:[NSDate date]];
        [comment setFirmwareID:[resp valueForKey:@"firmware_id"]];
        [currentFirmware addCommentsObject:comment];
        [tableView reloadData];
    }
   // NSDictionary *s = [resp valueForKey:@"firmwares"];
}


-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    // NSLog(error.description);
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    //  NSLog(error.description);
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects{
    [overlayController endOverlay];
    if (objects.count > 0 && [[objects objectAtIndex:0] isKindOfClass:[Firmware class]]) {
        [self didLoadFirmwares];
    }

    
}


#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems count];
	}
	else {
		return [[item children] count];
	}
}



- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems objectAtIndex:index];
	}
	else {
		return [[item children] objectAtIndex:index];
	}
}
/*
 -(NSCell*)sourceList:(PXSourceList *)aSourceList dataCellForItem:(id)item{
 
 NSSliderCell *k = [[NSSliderCell alloc] init];
 [k setTitle:@"aaaaaaaaaaaa"];
 EDStarRating *m = [[EDStarRating alloc] init];
 
 [k setControlView:m];
 return k;
 }*/

- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];
}


- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{
	[item setTitle:object];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
	return [item hasBadge];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
	return [item badgeValue];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return [item hasIcon];
}


- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
}

- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu * m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return m;
	}
	return nil;
}


#pragma mark -
#pragma mark Source List Delegate Methods


- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
	if([[group identifier] isEqualToString:@"library"])
		return YES;
	
	return NO;
}


- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
	
	//Set the label text to represent the new selection
	if([selectedIndexes count]>1){
        
    }
	else if([selectedIndexes count]==1) {
		Firmware *f = [[sourceList itemAtRow:[selectedIndexes firstIndex]] firmware];
        [cardImageView setWantsLayer:YES];
        NSShadow *shadow = [[NSShadow alloc] init];
        [shadow setShadowColor:[NSColor blackColor]];
        [shadow setShadowBlurRadius:4.0f];
        [shadow setShadowOffset:CGSizeMake(4.0f, 4.0f)];
        
        [cardImageView setShadow:shadow];
        firmwareTitleField.stringValue = f.title;
        firmwareModelField.stringValue = f.model;
        firmwareInfoField.stringValue = f.info;
        firmwareAuthorField.stringValue = f.author;
        firmwareIDField.stringValue = f.firmwareID.stringValue;
        firmwareRating.rating = f.rating.floatValue;
        NSMutableArray *withoutRam = [[NSMutableArray alloc] initWithArray:[f.model componentsSeparatedByString:@" "]];
        [withoutRam removeLastObject];
        NSString *name = [[[withoutRam valueForKey:@"description"] componentsJoinedByString:@"_"]lowercaseString];
        NSString *imageName = [NSString stringWithFormat:@"%@.png", name];
        firmwareCardView.image = [NSImage imageNamed:imageName];
        [firmwareCardView setImageScaling:NSImageScaleProportionallyUpOrDown];
        // [firmwareView setFrame:NSMakeRect((firmwareContainerView.frame.size.width-456)/2, (firmwareContainerView.frame.size.height-367)/2, 456, 367)];
        if (firmwareContainerView.subviews.count == 0) {
            [firmwareContainerView addSubview:firmwareView];
        }
        currentFirmware = f;
        [tableView reloadData];
	}
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}


@end
