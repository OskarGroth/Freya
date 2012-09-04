//
//  AppDelegate.h
//  Freya
//
//  Created by Oskar Groth on 2012-06-19.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HexFiend/HexFiend.h>
#import "EDStarRating.h"
#import "ModifyController.h"
#import "DatabaseController.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,EDStarRatingProtocol>{
    IBOutlet NSCollectionView *collectionView;
    IBOutlet NSArrayController *arrayController;
}
@property (strong) IBOutlet NSArrayController *arrayController;
@property (strong) IBOutlet NSView *infoView;
@property (strong) IBOutlet NSArrayController *files;

@property (strong) IBOutlet DatabaseController *databaseController;
@property (strong) IBOutlet ModifyController *modifyController;
@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet EDStarRating *starRating;
@property  NSMutableArray *icons;
@property (strong) NSCollectionView *collectionView;

@property (nonatomic, assign) NSUInteger sortingMode;
-(IBAction)editableChanged:(id)sender;
-(IBAction)displayModeChanged:(id)sender;
- (NSString *)applicationSupportFolder;
-(void)loadFiles;
@end
