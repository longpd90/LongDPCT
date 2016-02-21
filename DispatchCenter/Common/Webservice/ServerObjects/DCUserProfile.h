//
//  DCUserProfile.h
//  DispatchCenter
//
//  Created by Hung Bui on 10/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "ServerObjectBase.h"

@interface DCUserProfile : ServerObjectBase
@property (nonatomic, strong) NSString *qbLogin;
@property (nonatomic, strong) NSString *qbPassword;
@property (nonatomic, strong) NSString *qbRoomID;
@property (nonatomic, strong) NSString *qbRoomJID;
@end
