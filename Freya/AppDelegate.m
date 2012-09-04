//
//  AppDelegate.m
//  Freya
//
//  Created by Oskar Groth on 2012-06-19.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "EDStarRating.h"
#import <HexFiend/HexFiend.h>
#import "HexFiend/HexFiend.h"
#import "FirmwareComment.h"
#import "Firmware.h"
#import "InfoViewController.h"
@implementation AppDelegate
@synthesize icons;
@synthesize sortingMode;
@synthesize databaseController;
@synthesize modifyController = _modifyController;
@synthesize window = _window;
@synthesize starRating;
@synthesize collectionView;
@synthesize infoView;
@synthesize files;
@synthesize arrayController;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    starRating.starImage = [NSImage imageNamed:@"star.png"];
    starRating.starHighlightedImage = [NSImage imageNamed:@"starhighlighted.png"];
    starRating.maxRating = 5.0;
    starRating.delegate = self;
    starRating.horizontalMargin = 12;
    starRating.editable=YES;
    starRating.displayMode=EDStarRatingDisplayFull;
    starRating.rating= 2.5;
    NSViewController *myView =[[InfoViewController alloc] initWithNibName:@"InfoView" bundle:nil];
    [infoView addSubview:myView.view];
   // RKLogConfigureByName("RestKit/Network", RKLogLevelTrace); // Aktiverar debug output
    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    [_modifyController setUpBoundDataHexView];    
    [_modifyController didChangeValueForKey:@"examples"];
    [self setupRestkit];
    [Firmware setMapping];
    [FirmwareComment setMapping];
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[Firmware class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    [mapping mapKeyPath:@"comments" toRelationship:@"comments" withMapping:[RKManagedObjectMapping mappingForClass:[FirmwareComment class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore]];
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSString *folder = [self applicationSupportFolder];
    NSString *firmwares = [NSString stringWithFormat:@"%@/Firmwares", folder];
    NSString *scripts = [NSString stringWithFormat:@"%@/Scripts", folder];
    NSError *error;
    if(![manager fileExistsAtPath:firmwares]){
        [manager createDirectoryAtPath:firmwares withIntermediateDirectories:NO attributes:nil error:&error];
    }
    if(![manager fileExistsAtPath:scripts]){
        [manager createDirectoryAtPath:scripts withIntermediateDirectories:NO attributes:nil error:&error];
    }
    [self loadFiles];
    
}

-(void)setupRestkit{
    [RKClient clientWithBaseURL:[NSURL URLWithString:@"http://freyaserver.herokuapp.com/"]];
    [[RKClient sharedClient] setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[RKClient sharedClient] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    RKObjectManager* manager = [RKObjectManager managerWithBaseURLString:@"http://freyaserver.herokuapp.com/"];
    manager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"Freya.sqlite"];
    [RKObjectManager setSharedManager:manager];
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
}

-(void)loadFiles{
    NSMutableArray	*tempArray = [[NSMutableArray alloc] init];
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSString *folder = [self applicationSupportFolder];
    NSString *firmwares = [NSString stringWithFormat:@"%@/Firmwares", folder];
    
    NSArray *dirContents = [manager contentsOfDirectoryAtPath:firmwares error:nil];
    dirContents = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.rom'"]];

    // read the list of icons from disk in 'icons.plist'
    for (int i = 0; i < dirContents.count; i++) {
        [tempArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
         [NSImage imageNamed:@"rom.png"], @"icon",
         [dirContents objectAtIndex:i], @"name",
         nil]];
    }

    [self setIcons:tempArray];
    [collectionView scrollPoint:NSMakePoint(0, 0)];
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
}

- (NSString *)applicationSupportFolder {
    
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                        NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:
                                                0] : NSTemporaryDirectory();
    return [basePath
            stringByAppendingPathComponent:@"Freya"];
}



- (BOOL)collectionView:(NSCollectionView *)cv writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard
{
    NSMutableArray *urls = [NSMutableArray array];
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         NSDictionary *dictionary = [[cv content] objectAtIndex:idx];
         NSImage *image = [dictionary objectForKey:@"name"];
         NSString *name = [dictionary objectForKey:@"icon"];
         if (image && name)
         {
             NSURL *url = [temporaryDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.tiff", name]];
             [urls addObject:url];
             [[image TIFFRepresentation] writeToURL:url atomically:YES];
         }
     }];
    if ([urls count] > 0)
    {
        [pasteboard clearContents];
        return [pasteboard writeObjects:urls];
    }
    return NO;
}

- (void)setSortingMode:(NSUInteger)newMode
{
    sortingMode = newMode;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                               initWithKey:@"name"
                               ascending:(sortingMode == 0)
                               selector:@selector(caseInsensitiveCompare:)];
    [arrayController setSortDescriptors:[NSArray arrayWithObject:sort]];
}


-(void)awakeFromNib
{
    [arrayController addObserver:self forKeyPath:@"selectedObjects"
                         options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if(arrayController.selectedObjects.count == 0){
        return;
    }
    NSString *file = [[[arrayController selectedObjects] objectAtIndex:0] valueForKey:@"name"];
    NSString *path = [NSString stringWithFormat:@"%@/Firmwares/%@", [self applicationSupportFolder], file];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [_modifyController.boundDataHexView setData:data];
}

-(IBAction)editableChanged:(id)sender
{
    starRating.editable=[sender state];
    [starRating setNeedsDisplay];
}
-(IBAction)displayModeChanged:(id)sender
{
    NSInteger selectedMode = [sender selectedRow];
    starRating.displayMode=selectedMode;
    [starRating setNeedsDisplay];
}
-(IBAction)ratingChanged:(id)sender
{
    NSSlider *slider = (NSSlider*)sender;
    starRating.rating = [slider floatValue];
}
@end
