//
//  DCQBUserInfo.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "ServerObjectBase.h"

@interface DCQBUserInfo : ServerObjectBase

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *roomID;
@property (nonatomic, strong) NSString *roomJID;

@end
