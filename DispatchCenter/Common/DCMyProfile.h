//
//  DCMyProfile.h
//  DispatchCenter
//
//  Created by VietHQ on 10/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCQBUserInfo.h"

typedef NS_ENUM(NSInteger, DCMyProfileStatus)
{
    DCMyProfileStatusNone,
    DCMyProfileStatusVerify
};


@interface DCMyProfile : ServerObjectBase

@property( nonatomic, strong) NSString *avatar;
@property( nonatomic, strong) NSString *mFirstName;
@property( nonatomic, strong) NSString *mLastName;
@property( nonatomic, strong) NSString *mPassword;

@property( nonatomic, assign) NSUInteger mIdCountry;
@property( nonatomic, strong) NSString *mCountry;
@property( nonatomic, strong) NSString *mCountryCode;

@property( nonatomic, strong) NSString *mEmail;
@property( nonatomic, strong) NSString *mPhoneNumber;
@property( nonatomic, strong) DCQBUserInfo *qbUserInfo;


@property( nonatomic, strong) NSString *mStreetAddress;
@property( nonatomic, strong) NSString *mAddress2;

@property( nonatomic, assign) NSUInteger mIdSubDistrict;
@property( nonatomic, strong) NSString *mSubDistrict;

@property( nonatomic, assign) NSUInteger mIdDistrict;
@property( nonatomic, strong) NSString *mDistrict;

@property( nonatomic, strong) NSString *mMobileNumber;

@property( nonatomic, assign) NSUInteger mIdState;
@property( nonatomic, strong) NSString *mState;

@property( nonatomic, strong) NSString *mZipCode;

@property( nonatomic, assign) DCMyProfileStatus mStatus;

@property( nonatomic, strong) NSString *mStrAva;

+ (DCMyProfile*)readSaved;
+ (void)removeSave;
- (void)storeToFile;
-(NSDictionary*)jsonEditProfile;
- (instancetype)initWithFacebookProfile:(NSDictionary *)dictionary ;
@end