//
//  DCQBUserInfo.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCQBUserInfo.h"

@implementation DCQBUserInfo
- (void)parseResponse:(NSDictionary *)response {
    id tmp = [response objectForKey:API_PR_USER_QB_LOGIN];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.login = tmp;
    }
    
    tmp = [response objectForKey:API_PR_NAME_PASSWORD];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.password = tmp;
    }
    
    tmp = [response objectForKey:API_PR_USER_QB_ROOM_ID];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.roomID = tmp;
    }
    
    tmp = [response objectForKey:API_PR_USER_QB_ROOM_JID];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.roomJID = tmp;
    }
}

@end
