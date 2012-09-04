//
//  Firmware.m
//  Freya
//
//  Created by Oskar Groth on 2012-07-19.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "Firmware.h"
#import "FirmwareComment.h"
#import "RestKit/RestKit.h"


@implementation Firmware

@dynamic author;
@dynamic createdAt;
@dynamic data;
@dynamic firmwareID;
@dynamic info;
@dynamic md5;
@dynamic model;
@dynamic modified;
@dynamic rating;
@dynamic title;
@dynamic comments;

+(void)setMapping{
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[Firmware class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    mapping.primaryKeyAttribute = @"firmwareID";
    [mapping mapKeyPathsToAttributes:
     @"title", @"title",
     @"rating", @"rating",
     @"modified", @"modified",
     @"info", @"info",
     @"author", @"author",
     @"card_model", @"model",
     @"created_at", @"createdAt",
     @"md5", @"md5",
     @"id", @"firmwareID",
     @"firmware_data", @"data",
     nil];
    [[RKObjectManager sharedManager].mappingProvider setMapping:mapping forKeyPath:@"firmwares"];
    
}

- (NSComparisonResult)compareRating:(Firmware *)otherObject {
    if(!otherObject.rating){
        otherObject.rating = [NSNumber numberWithFloat:0.0];
    }
    return [self.rating compare:otherObject.rating];
}
- (NSComparisonResult)compare:(Firmware *)otherObject {
    return [self.model compare:otherObject.model];
}
@end
