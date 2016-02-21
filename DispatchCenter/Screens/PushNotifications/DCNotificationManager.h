//
//  DCNotificationManager.h
//  DispatchCenter
//
//  Created by Phung Long on 11/23/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCNotificationManager : NSObject

+ (DCNotificationManager *)shareInstance;
- (UIViewController *)processPushNotification:(NSDictionary*)userInfo;
@end
