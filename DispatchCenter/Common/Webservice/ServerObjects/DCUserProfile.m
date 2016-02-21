//
//  DCUserProfile.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCUserProfile.h"

@implementation DCUserProfile
- (void)parseResponse:(NSDictionary *)response {
    // TODO: parse other info
    NSDictionary *userQB = [response objectForKey:API_PR_USER_QB];
    if ([userQB isKindOfClass:[NSDictionary class]]) {
        id tmp = [userQB objectForKey:API_PR_USER_QB_LOGIN];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.qbLogin = tmp;
        }
        
        tmp = [userQB objectForKey:API_PR_NAME_PASSWORD];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.qbPassword = tmp;
        }
        
        tmp = [userQB objectForKey:API_PR_USER_QB_ROOM_ID];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.qbRoomID = tmp;
        }
        
        tmp = [userQB objectForKey:API_PR_USER_QB_ROOM_JID];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.qbRoomJID = tmp;
        }
    }
}
@end
