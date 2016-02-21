//
//  DCMyProfile.m
//  DispatchCenter
//
//  Created by VietHQ on 10/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCMyProfile.h"

static NSString *const kFirstName = @"DCMyProfileFirstName";
static NSString *const kLastName = @"DCMyProfileLastName";
static NSString *const kEmail = @"DCMyProfileEmail";
static NSString *const kPassword = @"DCMyProfilePassword";

static NSString *const kCountry = @"DCMyProfileCountry";
static NSString *const kIdCountry = @"DCMyProfileIdCountry";

static NSString *const kPhoneNumber = @"DCMyProfilePhoneNumber";
static NSString *const kAddress1 = @"DCMyProfileAddress1";
static NSString *const kAddress2 = @"DCMyProfileAddress2";

static NSString *const kSubDistrict = @"CMyProfileSubDistrict";
static NSString *const kIdSubDistrict = @"CMyProfileIdSubDistrict";

static NSString *const kDistrict = @"CMyProfileDistrict";
static NSString *const kIdDistrict = @"CMyProfileIdDistrict";

static NSString *const kZipCode = @"CMyProfileZipCode";
static NSString *const kMobileNumber = @"CMyProfileMobileNumber";

static NSString *const kState = @"CMyProfileState";
static NSString *const kIdState = @"CMyProfileIdState";

static NSString *const kStatus = @"CMyProfileStatus";

@interface DCMyProfile()



@end


@implementation DCMyProfile

#pragma mark - init
-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.mStatus =  DCMyProfileStatusNone;
    }
    
    return self;
}

- (instancetype)initWithFacebookProfile:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {

        self.mFirstName = [dictionary stringForKey:@"first_name"];
        self.mLastName = [dictionary stringForKey:@"last_name"];
        self.mEmail = [dictionary stringForKey:@"email"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        self.mFirstName = [decoder decodeObjectForKey:kFirstName];
        self.mLastName = [decoder decodeObjectForKey:kLastName];
        self.mPassword = [decoder decodeObjectForKey:kPassword];
        
        self.mCountry = [decoder decodeObjectForKey:kCountry];
        self.mIdCountry = [[decoder decodeObjectForKey:kIdCountry] integerValue];
        
        self.mEmail = [decoder decodeObjectForKey:kEmail];
        self.mPhoneNumber = [decoder decodeObjectForKey:kPhoneNumber];
        
        self.mStreetAddress = [decoder decodeObjectForKey:kAddress1];
        self.mAddress2 = [decoder decodeObjectForKey:kAddress2];
        
        self.mSubDistrict = [decoder decodeObjectForKey:kSubDistrict];
        self.mIdSubDistrict = [[decoder decodeObjectForKey:kIdSubDistrict] integerValue];
        
        self.mDistrict = [decoder decodeObjectForKey:kDistrict];
        self.mIdDistrict = [[decoder decodeObjectForKey:kIdDistrict] integerValue];
        //DLogInfo(@"district %li", (long)self.mIdDistrict);
        
        self.mMobileNumber = [decoder decodeObjectForKey:kMobileNumber];
        
        self.mState = [decoder decodeObjectForKey:kState];
        self.mIdState = [[decoder decodeObjectForKey:kIdState] integerValue];
        
        self.mZipCode = [decoder decodeObjectForKey:kZipCode];
        
        self.mStatus = (DCMyProfileStatus)[[decoder decodeObjectForKey:kStatus] integerValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.mFirstName forKey:kFirstName];
    [encoder encodeObject:self.mLastName forKey:kLastName];
    [encoder encodeObject:self.mPassword forKey:kPassword];
    
    [encoder encodeObject:self.mCountry forKey:kCountry];
    [encoder encodeObject:@(self.mIdCountry) forKey:kIdCountry];
    
    [encoder encodeObject:self.mEmail forKey:kEmail];
    [encoder encodeObject:self.mPhoneNumber forKey:kPhoneNumber];
    
    [encoder encodeObject:self.mStreetAddress forKey:kAddress1];
    [encoder encodeObject:self.mAddress2 forKey:kAddress2];
    
    [encoder encodeObject:self.mSubDistrict forKey:kSubDistrict];
    [encoder encodeObject:@(self.mIdSubDistrict) forKey:kIdSubDistrict];
    
    [encoder encodeObject:self.mDistrict forKey:kDistrict];
    [encoder encodeObject:@(self.mIdDistrict) forKey:kIdDistrict];
    
    [encoder encodeObject:self.mMobileNumber forKey:kMobileNumber];
    
    [encoder encodeObject:self.mState forKey:kState];
    [encoder encodeObject:@(self.mIdState) forKey:kIdState];
    
    [encoder encodeObject:self.mZipCode forKey:kZipCode];
    [encoder encodeObject:@(self.mStatus) forKey:kStatus];
}

#pragma mark - save obj
+ (DCMyProfile*)readSaved
{
    // Read object from user default
    NSUserDefaults *defaults = USER_DEFAULT_STANDARD;
    NSData *myEncodedObject = [defaults objectForKey:USER_KEY_MY_PROFILE_INFO];
    if (myEncodedObject)
    {
        DCMyProfile *obj = (DCMyProfile *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        return obj;
    }
    
    return nil;
}

- (void)storeToFile
{
    // Store object o NSUSerDefault
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = USER_DEFAULT_STANDARD;
    [defaults safeSetObject:myEncodedObject forKey:USER_KEY_MY_PROFILE_INFO];
}

+ (void)removeSave
{
    NSUserDefaults *defaults = USER_DEFAULT_STANDARD;
    [defaults removeObjectForKey:USER_KEY_MY_PROFILE_INFO];
    [defaults synchronize];
}

#pragma mark - parse obj
- (void)parseResponse:(NSDictionary *)response {

    id tmp = [response objectForKey:API_PR_URL_IMAGE];
    
    if ([tmp isKindOfClass:[NSString class]]) {
        self.avatar = tmp;
    }
    
    tmp = [response objectForKey:API_PR_USER_QB];
    if ([tmp isKindOfClass:[NSDictionary class]]) {
        self.qbUserInfo = [DCQBUserInfo new];
        [self.qbUserInfo parseResponse:tmp];
    }
    
    self.mFirstName = [response stringForKey:@"first_name"];
    self.mLastName = [response stringForKey:@"last_name"];

    
    NSDictionary *pAddressDict = [response dictionaryForKey:@"address"];
    self.mStreetAddress = [pAddressDict stringForKey:@"address1"];
    self.mAddress2 = [pAddressDict stringForKey:@"address2"];
    
    self.mState = [[pAddressDict dictionaryForKey:@"province"] stringForKey:@"name"];
    self.mIdState = [[pAddressDict dictionaryForKey:@"province"] integerForKey:@"id"];
    
    self.mCountry = [[pAddressDict dictionaryForKey:@"country"] stringForKey:@"name"];
    self.mIdCountry = [[pAddressDict dictionaryForKey:@"country"] integerForKey:@"id"];
    self.mCountryCode = [[pAddressDict dictionaryForKey:@"country"] stringForKey:@"code"];
    [USER_DEFAULT_STANDARD setObject:self.mCountryCode forKey:kDCPanCountryKey];
    
    self.mDistrict = [[pAddressDict dictionaryForKey:@"district"] stringForKey:@"name"];
    self.mIdDistrict = [[pAddressDict dictionaryForKey:@"district"] integerForKey:@"id"];
    
    self.mSubDistrict = [[pAddressDict dictionaryForKey:@"subdistrict"] stringForKey:@"name"];
    self.mIdSubDistrict = [[pAddressDict dictionaryForKey:@"subdistrict"] integerForKey:@"id"];
    
    
    NSInteger zip = [pAddressDict integerForKey:@"zip"];
    self.mZipCode = [NSString stringWithFormat:@"%li",(long)zip];
    
    self.mEmail = [response stringForKey:@"email"];
    
    self.mMobileNumber = [response stringForKey:@"mobile"];
    self.mPhoneNumber = [response stringForKey:@"phone"];
    
    self.mStatus = (DCMyProfileStatus)[response integerForKey:@"verify"];
}

#pragma mark - convert to dict
-(NSDictionary*)jsonEditProfile
{
    NSMutableDictionary *pDict = [[NSMutableDictionary alloc] initWithCapacity:50];
    
    pDict[@"first_name"] = self.mFirstName ? : @"";
    pDict[@"last_name"] = self.mLastName ? : @"";
    
    /////////////////// ADDRESS /////////////////
    NSDictionary *pProvince = @{
                                    @"id" : self.mIdState ? @(self.mIdState)  : @0,
                                    @"name" : self.mState ? : @""
                                };
    
    NSDictionary *pDistrict = @{
                                    @"id" : self.mIdDistrict ? @(self.mIdDistrict) : @0,
                                    @"name" : self.mDistrict ? : @""
                                };
    
    NSDictionary *pSubDistrict = @{
                                    @"id" : self.mIdSubDistrict ? @(self.mIdSubDistrict) : @0,
                                    @"name" : self.mSubDistrict ? : @""
                                   };
    
    NSDictionary *pCountry = @{
                                    @"id" : self.mIdCountry ? @(self.mIdCountry) : @0,
                                    @"name" : self.mCountry ? : @""
                               };

    
    NSDictionary *pAddress = @{
                                    @"address1" : self.mStreetAddress ? : @"",
                                    @"address2" : self.mAddress2 ? : @"",
                                    @"province" : pProvince,
                                    @"district" : pDistrict,
                                    @"subdistrict" : pSubDistrict,
                                    @"country" : pCountry,
                                    @"zip" : self.mZipCode ? : @""
                               };
    
    pDict[@"address"] = pAddress;
    
    ////////////////////////////////////////////
    pDict[@"mobile"] = self.mMobileNumber ? : @"";
    
    // if update phone, email, ava, password open those
    //pDict[@"phone"] = self.mPhoneNumber ? : (APP_DELEGATE.mMyProfile.mPhoneNumber ? : @"");
    //pDict[@"email"] = self.mEmail ? : (APP_DELEGATE.mMyProfile.mEmail ? : @"");
    //pDict[@"image"] = self.mStrAva ? : (APP_DELEGATE.mMyProfile.mStrAva ? : @"");
    //pDict[@"password"] = self.mPassword ? : (APP_DELEGATE.mMyProfile.mPassword ? : @"");
    
    DLogInfo("%@", pDict);
    return pDict;
}

@end
