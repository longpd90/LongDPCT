//
//  DCLoginInfo.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/6/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "ServerObjectBase.h"
#import "DCMyProfile.h"

typedef enum {
    DCUserStatusNone,
    DCUserStatusFirstReg,
    DCUserStatusVerifiedPhone,
    DCUserStatusVerifed
}DCUserStatus;

@interface DCLoginInfo : ServerObjectBase
@property (nonatomic, assign) DCUserStatus userStatus;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) DCMyProfile *userInfo;

+ (DCLoginInfo*)readSaved;
+ (void)removeSaved;
- (void)storeToFile;
@end
