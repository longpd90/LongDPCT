//
//  DCSetting.m
//  DispatchCenter
//
//  Created by Phung Long on 11/5/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCSetting.h"

static NSString *const kNotificationStatus = @"kNotificationStatus";
static NSString *const kPrivacyStatus = @"kPrivacyStatus";
static NSString *const kOnlineStatus = @"kOnlineStatus";

static NSString *const kPhoneNumber = @"kPhoneNumber";
static NSString *const kMerchantID = @"kMerchantID";
static NSString *const kCurrencyCode = @"kCurrencyCode";
static NSString *const kSecurityKey = @"kSecurityKey";
static NSString *const kSecrectKey = @"kSecrectKey";


@implementation DCSetting

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        self.notification = [[decoder decodeObjectForKey:kNotificationStatus] boolValue];
        self.privacy = [[decoder decodeObjectForKey:kPrivacyStatus] boolValue];
        self.online = [[decoder decodeObjectForKey:kOnlineStatus] boolValue];
        
        self.phoneNumber = [decoder decodeObjectForKey:kPhoneNumber];
        self.merchant_id = [decoder decodeObjectForKey:kMerchantID];
        
        self.currency_code = [decoder decodeObjectForKey:kCurrencyCode];
        self.securityKey = [decoder decodeObjectForKey:kSecurityKey];
        
        self.secrectKey = [decoder decodeObjectForKey:kSecrectKey];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:@(self.notification) forKey:kNotificationStatus];
    [encoder encodeObject:@(self.privacy) forKey:kPrivacyStatus];
    [encoder encodeObject:@(self.online) forKey:kOnlineStatus];
    
    [encoder encodeObject:self.phoneNumber forKey:kPhoneNumber];
    [encoder encodeObject:self.merchant_id forKey:kMerchantID];
    
    [encoder encodeObject:self.currency_code forKey:kCurrencyCode];
    [encoder encodeObject:self.securityKey forKey:kSecurityKey];
    
    [encoder encodeObject:self.secrectKey forKey:kSecrectKey];
}


#pragma mark - save obj
+ (DCSetting*)readSaved
{
    // Read object from user default
    NSUserDefaults *defaults = USER_DEFAULT_STANDARD;
    NSData *myEncodedObject = [defaults objectForKey:USER_KEY_MY_SETTINGS_INFO];
    if (myEncodedObject)
    {
        DCSetting *obj = (DCSetting *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        return obj;
    }
    
    return nil;
}

- (void)storeToFile
{
    // Store object o NSUSerDefault
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = USER_DEFAULT_STANDARD;
    [defaults safeSetObject:myEncodedObject forKey:USER_KEY_MY_SETTINGS_INFO];
}

+ (void)removeSave
{
    NSUserDefaults *defaults = USER_DEFAULT_STANDARD;
    [defaults removeObjectForKey:USER_KEY_MY_SETTINGS_INFO];
    [defaults synchronize];
}

#pragma mark - parse obj

-(void)parseResponse:(NSDictionary *)response
{
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        self.notification = [[response stringForKey:@"notification"] isEqualToString:@"enable"] ? YES : NO;
        id privateSetting = [response objectForKey:@"privacy"];
        if (privateSetting && [privateSetting isKindOfClass:[NSDictionary class]]) {
            id shareLocation = [privateSetting objectForKey:@"share_location"];
            if (shareLocation && [shareLocation isKindOfClass:[NSString class]]) {
                self.privacy = [shareLocation isEqualToString:@"enable"] ? YES : NO;
            }
        }
        self.online = [[response stringForKey:@"online"] isEqualToString:@"enable"] ? YES : NO;
        
        id contact_us = [response objectForKey:@"contact_us"];
        if (contact_us && [contact_us isKindOfClass:[NSDictionary class]]) {
            self.phoneNumber = [contact_us objectForKey:@"phone"];
        }
        // 2c2p payment
        NSDictionary *paymentDictionnary = [response dictionaryForKey:@"2c2p"];
        self.currency_code = [paymentDictionnary stringForKey:@"currency_code"];
        self.merchant_id = [paymentDictionnary stringForKey:@"merchant_id"];
        self.securityKey = [[paymentDictionnary dictionaryForKey:@"key"] stringForKey:@"ios"];
        self.secrectKey = [paymentDictionnary stringForKey:@"secret_key"];
    }
}


@end
