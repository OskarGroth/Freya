//
//  ModifyController.h
//  Freya
//
//  Created by Oskar Groth on 2012-07-10.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HexFiend/HexFiend.h>
@interface ModifyController : NSObject{
    NSMutableArray *examples;

    NSData *textViewBoundData;
}
- (void)setUpBoundDataHexView;
-(void)willLoadView;
@property (strong) IBOutlet HFTextView *boundDataHexView;

@end

@interface FiendlingExample : NSObject {
    NSString *label;
    NSString *explanation;
}

@property(readonly) NSString *label;
@property(readonly) NSString *explanation;
+ (id)exampleWithLabel:(NSString *)someLabel explanation:(NSString *)someExplanation;

@end

