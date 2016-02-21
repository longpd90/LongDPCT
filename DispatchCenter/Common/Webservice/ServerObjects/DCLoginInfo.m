//
//  DCLoginInfo.m
//  DispatchCenter
//
//  Created by Hung Bui on 10/6/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCLoginInfo.h"

#define KEY_USER_STATUS             @"LoginEntity_user_status"
#define KEY_TOKEN                   @"LoginEntity_token"
#define KEY_QB_LOGIN                @"LoginEntity_qb_login"
#define KEY_QB_PASS                 @"LoginEntity_qb_pass"
#define KEY_QB_ROOMID               @"LoginEntity_qb_roomid"
#define KEY_QB_ROOMJID              @"LoginEntity_qb_roomjid"
#define kDCFacebookFisrtNameKey                     @"kDCFacebookFisrtNameKey"
#define kDCFacebookLastNameKey                      @"kDCFacebookLastNameKey"
#define kDCFacebookEmailKey                         @"kDCFacebookEmailKey"

#define kDCGoogleFisrtNameKey                     @"kDCFacebookFisrtNameKey"
#define kDCGoogleLastNameKey                      @"kDCFacebookLastNameKey"
#define kDCGoogleEmailKey                         @"kDCFacebookEmailKey"

#define kDCTwitterFisrtNameKey                     @"kDCFacebookFisrtNameKey"
#define kDCTwitterLastNameKey                      @"kDCFacebookLastNameKey"
#define kDCTwitterEmailKey                         @"kDCFacebookEmailKey"

@implementation DCLoginInfo

- (void)parseResponse:(NSDictionary *)response {
    id tmp = [response objectForKey:API_PR_NAME_TOKEN];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.token = tmp;
    }
    
    tmp = [response objectForKey:API_PR_NEED_USER];
    if ([tmp isKindOfClass:[NSDictionary class]]) {
        self.userInfo = [DCMyProfile new];
        [self.userInfo parseResponse:tmp];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.token = [decoder decodeObjectForKey:KEY_TOKEN];
        self.userStatus = (DCUserStatus)[[decoder decodeObjectForKey:KEY_USER_STATUS] intValue];
        self.userInfo = [DCMyProfile new];
        self.userInfo.qbUserInfo = [DCQBUserInfo new];
        self.userInfo.qbUserInfo.login = [decoder decodeObjectForKey:KEY_QB_LOGIN];
        self.userInfo.qbUserInfo.password = [decoder decodeObjectForKey:KEY_QB_PASS];
        self.userInfo.qbUserInfo.roomID = [decoder decodeObjectForKey:KEY_QB_ROOMID];
        self.userInfo.qbUserInfo.roomJID = [decoder decodeObjectForKey:KEY_QB_ROOMJID];

    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:@(self.userStatus) forKey:KEY_USER_STATUS];
    [encoder encodeObject:self.token forKey:KEY_TOKEN];
    [encoder encodeObject:self.userInfo.qbUserInfo.login forKey:KEY_QB_LOGIN];
    [encoder encodeObject:self.userInfo.qbUserInfo.password forKey:KEY_QB_PASS];
    [encoder encodeObject:self.userInfo.qbUserInfo.roomID forKey:KEY_QB_ROOMID];
    [encoder encodeObject:self.userInfo.qbUserInfo.roomJID forKey:KEY_QB_ROOMJID];

}

+ (DCLoginInfo*)readSaved {
    // Read object from user default
    NSUserDefaults *defaults = USER_DEFAULT_STANDARD;
    NSData *myEncodedObject = [defaults objectForKey:USER_KEY_LOGIN_INFO];
    if (myEncodedObject) {
        DCLoginInfo *obj = (DCLoginInfo *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        return obj;
    } else {
        return nil;
    }
}

+ (void)removeSaved {
    [USER_DEFAULT_STANDARD removeObjectForKey:USER_KEY_LOGIN_INFO];
    [USER_DEFAULT_STANDARD synchronize];
}

- (void)storeToFile {
    // Store object o NSUSerDefault
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = USER_DEFAULT_STANDARD;
    [defaults setObject:myEncodedObject forKey:USER_KEY_LOGIN_INFO];
    [defaults synchronize];
}

@end
