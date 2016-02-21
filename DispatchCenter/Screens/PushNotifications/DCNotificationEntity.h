//
//  DCNotificationEntity.h
//  DispatchCenter
//
//  Created by Phung Long on 11/23/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCNotificationEntity : NSObject
@property (nonatomic, assign) NSInteger filter;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *diaglogID;
@property (nonatomic, strong) NSString *userID;

+ (DCNotificationEntity *)parseNotificationFromDict:(NSDictionary*)notificationDict;
@end
