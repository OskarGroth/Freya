//
//  ModifyController.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-10.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "ModifyController.h"
#import <HexFiend/HexFiend.h>
#import "AppDelegate.h"
@class HFTextView;
@implementation ModifyController
@synthesize boundDataHexView;
-(id)init{
    self = [super init];
    if(self){
        [self willChangeValueForKey:@"examples"];
    }
    return self;
}

-(void)willLoadView{
    AppDelegate *d = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [d.window setMaxSize:NSMakeSize(2000, 2000)];
}

- (IBAction)testPress:(id)sender {
}
- (IBAction)loadFirmwarePress:(id)sender {
    NSData *firmware = nil;
    // Check the PCI devices for video cards.
    CFMutableDictionaryRef match_dictionary = IOServiceMatching("IOPCIDevice");
    
    // Create a iterator to go through the found devices.
    io_iterator_t entry_iterator;
    if (IOServiceGetMatchingServices(kIOMasterPortDefault,
                                     match_dictionary,
                                     &entry_iterator) == kIOReturnSuccess)
    {
        // Actually iterate through the found devices.
        io_registry_entry_t serviceObject;
        while ((serviceObject = IOIteratorNext(entry_iterator))) {
            // Put this services object into a dictionary object.
            CFMutableDictionaryRef serviceDictionary;
            if (IORegistryEntryCreateCFProperties(serviceObject,
                                                  &serviceDictionary,
                                                  kCFAllocatorDefault,
                                                  kNilOptions) != kIOReturnSuccess)
            {
                // Failed to create a service dictionary, release and go on.
                IOObjectRelease(serviceObject);
                continue;
            }
            
            // If this is a GPU listing, it will have a "model" key
            // that points to a CFDataRef.
            const void *model = CFDictionaryGetValue(serviceDictionary, @"ATY,bin_image");
            if (model != nil) {
                if (CFGetTypeID(model) == CFDataGetTypeID()) {
                    // Get data for key
                    NSData *data = (__bridge NSData *)CFDictionaryGetValue(serviceDictionary, @"ATY,bin_image");
                    firmware = [[NSData alloc] initWithBytes:[data bytes] length:[data length]];
                    // Kolla om vi kommer hit igen, isf lagra flera GPU'er
                }
            }
            
            // Release the dictionary created by IORegistryEntryCreateCFProperties.
            CFRelease(serviceDictionary);
        }
    }
    
    if(firmware == nil){
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessageText:@"Failed to load firmware from driver!"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
        return;
    }else{
        [boundDataHexView setData:firmware];
    }
}


- (void)setUpBoundDataHexView {
    /* Bind our text view to our bound data */
    [boundDataHexView bind:@"data" toObject:self withKeyPath:@"textViewBoundData" options:nil];
}

- (void)setTextViewBoundData:(NSData *)data {
    textViewBoundData = data;
}

@end
@implementation FiendlingExample

@synthesize label = label, explanation = explanation;

+ (id)exampleWithLabel:(NSString *)someLabel explanation:(NSString *)someExplanation {
    FiendlingExample *example = [[self  alloc] init];
    example->label = [someLabel copy];
    example->explanation = [someExplanation copy];
    return example;
}



@end
