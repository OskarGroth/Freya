//
//  SourceListItem.m
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2010 Alex Rozanski http://perspx.com
//
//  GC-enabled code revised by Stefan Vogt http://byteproject.net
//

#import "SourceListItem.h"


@implementation SourceListItem

@synthesize title;
@synthesize identifier;
@synthesize icon;
@synthesize badgeValue;
@synthesize children;
@synthesize rating;
@synthesize firmware;
#pragma mark -
#pragma mark Init/Dealloc/Finalize

- (id)init
{
	if(self=[super init])
	{
		badgeValue = -1;	//We don't want a badge value by default
	}
	
	return self;
}


+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier
{	

	SourceListItem *item = [SourceListItem itemWithTitle:aTitle identifier:anIdentifier icon:nil];

    
	return item;
}

+ (id)itemWithModelForFirmware:(Firmware*)_firmware{
    NSMutableArray *withoutRam = [[NSMutableArray alloc] initWithArray:[_firmware.model componentsSeparatedByString:@" "]];
    [withoutRam removeLastObject];
    NSString *name = [[[withoutRam valueForKey:@"description"] componentsJoinedByString:@"_"]lowercaseString];
    NSString *imageName = [NSString stringWithFormat:@"%@.png", name];
    SourceListItem *item = [SourceListItem itemWithTitle:_firmware.model identifier:_firmware.model icon:[NSImage imageNamed:imageName]];
    return item;
}


+ (id)itemWithFirmware:(Firmware*)_firmware{
    NSImage *icon;
    if (_firmware.modified.boolValue) {
        icon = [NSImage imageNamed:@"maciconz.png"];
    }else {
        icon = [NSImage imageNamed:@"pcicon.png"];
    }
    SourceListItem *item = [SourceListItem itemWithTitle:_firmware.title identifier:_firmware.title icon:icon];
   // item.rating = [[EDStarRating alloc] init];
    //[item.rating setRating:_firmware.rating.floatValue];
    [item setFirmware:_firmware];
	return item;
}

+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon
{
	SourceListItem *item = [[SourceListItem alloc] init];
	
	[item setTitle:aTitle];
	[item setIdentifier:anIdentifier];
	[item setIcon:anIcon];
	
	return item;
}



#pragma mark -
#pragma mark Custom Accessors

- (BOOL)hasBadge
{
	return badgeValue!=-1;
}

- (BOOL)hasChildren
{
	return [children count]>0;
}

- (BOOL)hasIcon
{
	return icon!=nil;
}

#pragma mark -
#pragma mark Custom Accessors

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p | identifier = %@ | title = %@ >", [self class], self, self.identifier, self.title];
}
@end
