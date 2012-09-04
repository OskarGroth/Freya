//
//  FirmwareComment.h
//  Freya
//
//  Created by Oskar Groth on 2012-07-19.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Firmware;

@interface FirmwareComment : NSManagedObject
+(void)setMapping;
@property (nonatomic) NSString * text;
@property (nonatomic) NSNumber * commentID;
@property (nonatomic) NSNumber * firmwareID;
@property (nonatomic) NSDate * createdAt;
@property (nonatomic) NSString * author;
@property (nonatomic) Firmware *firmware;

@end
