//
//  DCSetting.h
//  DispatchCenter
//
//  Created by Phung Long on 11/5/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ALREADY_FIRST_TIME_LAUNCH @"First Time Launching"
@interface DCSetting : ServerObjectBase

@property( assign, nonatomic) BOOL notification;
@property( assign, nonatomic) BOOL privacy;
@property( assign, nonatomic) BOOL online;
@property( strong, nonatomic) NSString *phoneNumber;
@property( strong, nonatomic) NSString *merchant_id;
@property( strong, nonatomic) NSString *currency_code;
@property( strong, nonatomic) NSString *securityKey;
@property( strong, nonatomic) NSString *secrectKey;

+ (DCSetting*)readSaved;
+ (void)removeSave;
- (void)storeToFile;

-(void)parseResponse:(NSDictionary *)response;



@end
