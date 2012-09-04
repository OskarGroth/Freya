//
//  FirmwareComment.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-19.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "FirmwareComment.h"
#import "Firmware.h"
#import "RestKit/RestKit.h"


@implementation FirmwareComment

@dynamic text;
@dynamic commentID;
@dynamic createdAt;
@dynamic author;
@dynamic firmware;
@dynamic firmwareID;
+(void)setMapping{
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[FirmwareComment class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    mapping.primaryKeyAttribute = @"commentID";
    [mapping mapKeyPathsToAttributes:
     @"text", @"text",
     @"created_at", @"createdAt",
     @"author", @"author",
     @"firmware_id", @"firmwareID",
     @"id", @"commentID",
     nil];
    [[RKObjectManager sharedManager].mappingProvider setMapping:mapping forKeyPath:@"comments"];
    [mapping hasOne:@"firmware" withMapping:[RKManagedObjectMapping mappingForClass:[Firmware class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore]];
    [mapping connectRelationship:@"firmware" withObjectForPrimaryKeyAttribute:@"firmwareID"];
}

- (NSComparisonResult)compare:(FirmwareComment *)otherObject {
    return [self.createdAt compare:otherObject.createdAt];
}
@end
