//
//  DCTeamTaskModel.h
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCMemberModel;

@interface DCTeamTaskModel : NSObject

@property(nonatomic, strong) DCMemberModel *mLeader;
@property(nonatomic, strong) NSArray *mArrMember;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end

@interface DCMemberModel : NSObject

@property(nonatomic, copy) NSString *mStrName;
@property(nonatomic, copy) NSString *mStrImageURL;
@property(nonatomic, copy) NSString *mStrPhoneNumb;
@property(nonatomic, assign) BOOL mIsLeader;
@property(nonatomic, assign) NSUInteger mUserId;
@property(nonatomic, assign) BOOL mShareLocation;

@end

