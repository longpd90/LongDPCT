//
//  DCNotificationEntity.m
//  DispatchCenter
//
//  Created by Phung Long on 11/23/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCNotificationEntity.h"

@implementation DCNotificationEntity

+ (DCNotificationEntity *)parseNotificationFromDict:(NSDictionary*)notificationDict{
    if (notificationDict) {
        DCNotificationEntity *entity = [[DCNotificationEntity alloc] init];
        id aps = [notificationDict objectForKey:NOTI_APS];
        if (aps && [aps isKindOfClass:[NSDictionary class]]) {
            NSDictionary *apsDict = (NSDictionary *)aps;
            id alert = [apsDict objectForKey:NOTI_ALERT];
            if (alert) {
                entity.message = (NSString *)alert;


            } else {
                // Do nothing
            }
        }
        id filter = [notificationDict objectForKey:NOTI_FILTER];
        if (filter) {
            entity.filter = [((NSString *)filter) integerValue];
            
        } else {
            // Do nothing
        }
        id page = [notificationDict objectForKey:NOTI_PAGE];
        if (page) {
            entity.page = (NSString *)page;
            
        } else {
            // Do nothing
        }
        
        id dialogID = [notificationDict objectForKey:NOTI_DIALOGID];
        if (dialogID) {
            entity.diaglogID = (NSString *)dialogID ;
            
        } else {
            // Do nothing
        }

        id  userID = [notificationDict objectForKey:NOTI_USERID];
        if (userID) {
            entity.userID = (NSString *)userID;
            
        } else {
            // Do nothing
        }

        
        return entity;
        

    }
    return nil;
}
@end
