//
//  InfoViewController.m
//  Zeus
//
//  Created by Oskar Groth on 2012-01-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import <IOKit/IOKitLib.h>
#import <IOKit/IOBSD.h>

#define NVIDA_VENDOR @"10DE"
#define AMD_VENDOR @"1002"

@implementation InfoViewController
@synthesize brandImageView;
@synthesize cardImageView;
@synthesize deviceButton;
@synthesize modelTextField;
@synthesize deviceTextField;
@synthesize vendorTextField;
@synthesize vramTextField;
@synthesize driverTextField;
@synthesize slotTextField;
@synthesize qeciTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}


-(void)awakeFromNib{
    [self update];
}


-(void)update{
    [self interrogateHardware];
    [brandImageView setImageScaling:NSScaleToFit];
    [cardImageView setImageScaling:NSScaleToFit];

    if([[vendorTextField stringValue] rangeOfString:NVIDA_VENDOR].location != NSNotFound){
        [brandImageView setImage:[NSImage imageNamed:@"nvidia.png"]];
    }else if([[vendorTextField stringValue] rangeOfString:AMD_VENDOR].location != NSNotFound){
        [brandImageView setImage:[NSImage imageNamed:@"amd.png"]];
    }else{
        // SÄtt till unknown
    }
    [cardImageView setImage:[NSImage imageNamed:@"amd_radeon_6950.png"]];


}

// Populate the popup list of displays by iterating over all of the displays
-(void)interrogateHardware
{
	CGError				err = CGDisplayNoErr;
    int                 i;
	CGDisplayCount		dspCount = 0;
    
	// Remove the default items from the device selection popup
    [deviceButton removeAllItems];
	
    // How many active displays do we have?
    err = CGGetActiveDisplayList(0, NULL, &dspCount);
    
	// If we are getting an error here then their won't be much to display.
    if(err != CGDisplayNoErr)
        return;
	
	// Maybe this isn't the first time though this function.
	if(displays != nil)
		free(displays);
    
	// Allocate enough memory to hold all the display IDs we have
    displays = calloc((size_t)dspCount, sizeof(CGDirectDisplayID));
    
	// Get the list of active displays
    err = CGGetActiveDisplayList(dspCount,
                                 displays,
                                 &dspCount);
	
	// More error-checking here
    if(err != CGDisplayNoErr)
    {
        NSLog(@"Could not get active display list (%d)\n", err);
        return;
    }
    
    // Now we iterate through them
    for(i = 0; i < dspCount; i++)
    {		
		[deviceButton addItemWithTitle:[[NSNumber numberWithUnsignedInt:CGDisplayUnitNumber (displays[i])] stringValue]];
    }
    
	// Select whatever device is first in the list
	[self selectDevice:nil];
    
	return;
}


// When a device is selected, update the UI with the new vender,device, model then update the OpenGL info.
// This IBAction is wired up to the device selection popup.
-(IBAction)selectDevice:(id)sender
{
	unsigned long currentService = 0;
    
	// Find out which display is selected
    currentService = [sender indexOfSelectedItem];
    
	// Make sure the display doesn't preserve values from
	// a previously selected display.
	[self resetWindowValues];
    
	//Update the IOKit Information for the display
	[self interrogateIOKitFor:displays[currentService]];

	//Update the Quartz Information for the display
	[self interrogateQuartzFor:displays[currentService]];
}

// Query Quartz to see if the display is using OpenGL
// acceleration.  If so, then the display is Quartz
// Extreme capable.
-(void)interrogateQuartzFor: (CGDirectDisplayID) displayID
{
	// Is the display hardware accelerated?
	if(CGDisplayUsesOpenGLAcceleration(displayID))
		[qeciTextField setStringValue:@"Enabled"];
}

//In case of a value isn't avalible make sure the main window will reflect what we know
//by resetting all values that may not be updated.
-(void) resetWindowValues
{
	// vendorIDOut, deviceIDOut, modelOut and vramOut are obtained using IOKit
	[vendorTextField setStringValue:@"Unknown"];
	[deviceTextField setStringValue:@"Unknown"];
	[modelTextField setStringValue:@"Unknown"];
	[vramTextField setStringValue:[NSString stringWithFormat:@"%dMB / %dKB", 0, 0]];
    [qeciTextField setStringValue:@"Disabled"];
}

-(void)interrogateIOKitFor: (CGDirectDisplayID) displayID
{
    CFTypeRef           typeCode;
    CFDataRef vendorID, deviceID, model;
    CFStringRef driver;
	long vram, deviceNumber;
	io_registry_entry_t dspPort;
    
	// Get the I/O Kit service port for the display
	dspPort = CGDisplayIOServicePort(displayID);
    
	// Get the information for the device we've selected from the list
	// The vendor ID, device ID, and model are all available as properties of the hardware's I/O Kit service port
	vendorID = IORegistryEntrySearchCFProperty(dspPort,kIOServicePlane,CFSTR("vendor-id"),kCFAllocatorDefault,kIORegistryIterateRecursively | kIORegistryIterateParents);
	deviceID = IORegistryEntrySearchCFProperty(dspPort,kIOServicePlane,CFSTR("device-id"),kCFAllocatorDefault,kIORegistryIterateRecursively | kIORegistryIterateParents);
	model = IORegistryEntrySearchCFProperty(dspPort,kIOServicePlane,CFSTR("model"),
                                            kCFAllocatorDefault,kIORegistryIterateRecursively | kIORegistryIterateParents);
    driver = IORegistryEntrySearchCFProperty(dspPort,kIOServicePlane,CFSTR("IOOCDBundleName"),
                                            kCFAllocatorDefault,kIORegistryIterateRecursively | kIORegistryIterateParents);
	
	// Send the appropriate data to the outputs checking to validate the data
    if(vendorID)
		[vendorTextField setStringValue:[NSString stringWithFormat:@"0x%08X",*((UInt32*)CFDataGetBytePtr(vendorID))]];
    
    if(deviceID)
		[deviceTextField setStringValue:[NSString stringWithFormat:@"0x%08X",*((UInt32*)CFDataGetBytePtr(deviceID))]];
    
	if(model)
		[modelTextField setStringValue:[[NSString alloc] initWithBytes:CFDataGetBytePtr(model) length:CFDataGetLength(model) encoding:NSUTF8StringEncoding]];
	if(driver)
		[driverTextField setStringValue:[[NSString alloc] initWithString:(__bridge NSString*)driver]];

    
	// Ask IOKit for the property for the display VRAM size
    typeCode = IORegistryEntrySearchCFProperty(dspPort,kIOServicePlane,CFSTR("VRAM,totalsize"),
                                           kCFAllocatorDefault,kIORegistryIterateRecursively | kIORegistryIterateParents);
    
	// Ensure we have valid data from IOKit
	if(typeCode && CFGetTypeID(typeCode) == CFNumberGetTypeID())
	{
		// If so, convert the CFNumber into a plain unsigned long
		CFNumberGetValue(typeCode, kCFNumberSInt32Type, &vram);
	}
    
	// Output the information for the device's vram - note the formatting on the VRAM information
	[vramTextField setStringValue:[NSString stringWithFormat:@"%d MB", (vram / 1024)]];
    
    //------------------------------------------------------------------------------------------------------------------------
    // Ask IOKit for the property for the display Device Slot
    typeCode = IORegistryEntrySearchCFProperty(dspPort,kIOServicePlane,CFSTR("pci-device-number"),
                                               kCFAllocatorDefault,kIORegistryIterateRecursively | kIORegistryIterateParents);
    // Ensure we have valid data from IOKit
	if(typeCode && CFGetTypeID(typeCode) == CFNumberGetTypeID())
	{
		// If so, convert the CFNumber into a plain unsigned long
		CFNumberGetValue(typeCode, kCFNumberSInt32Type, &deviceNumber);
	}
    
    [slotTextField setStringValue:[NSString stringWithFormat:@"%d", deviceNumber]];

}


@end
