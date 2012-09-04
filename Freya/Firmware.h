//
//  Firmware.h
//  Freya
//
//  Created by Oskar Groth on 2012-07-19.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FirmwareComment;

@interface Firmware : NSManagedObject
+(void)setMapping;

@property (nonatomic) NSString * author;
@property (nonatomic) NSDate * createdAt;
@property (nonatomic) id data;
@property (nonatomic) NSNumber * firmwareID;
@property (nonatomic) NSString * info;
@property (nonatomic) NSString * md5;
@property (nonatomic) NSString * model;
@property (nonatomic) NSNumber * modified;
@property (nonatomic) NSNumber * rating;
@property (nonatomic) NSString * title;
@property (nonatomic) NSSet *comments;
@end

@interface Firmware (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(FirmwareComment *)value;
- (void)removeCommentsObject:(FirmwareComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;
@end
