//
//  DCValidateRegisterModel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/8/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCValidateRegisterModel.h"

static NSInteger const kLimitChar = 100;

@implementation DCValidateRegisterModel

-(NSString*)alertString
{
    NSMutableString *pMessenge = [[NSMutableString alloc] initWithCapacity:100];
    
    //////////////////// IF FILL ALL FIELDS ///////////////////////
    if ([self isFillAllField])
    {
        /* if all field ok */
        if ( [self.mStrEmail isValidEmail] &&
             self.mStrFirstName.length < 100 &&
             self.mStrLastName.length < 100 &&
            [self.mStrPhone isPhoneNumber])
        {
            return nil;
        }
        
        /* if has invalidate info */
        if (self.mStrFirstName.length > kLimitChar)
        {
            [pMessenge appendString:NSLocalizedString(@"msg_first_name_limit", nil)];
        }
        
        if (self.mStrLastName.length > kLimitChar)
        {
            [pMessenge appendString:NSLocalizedString(@"msg_last_name_limit", nil)];
        }
        
        if (![self.mStrEmail isValidEmail])
        {
            [pMessenge appendString:NSLocalizedString(@"msg_email_not_valid", nil)];
        }
        
        if (![self.mStrPhone isPhoneNumber])
        {
            [pMessenge appendString:NSLocalizedString(@"msg_phone_not_valid", nil)];
        }
        
        return pMessenge;
    }
    
    ////////////////////// MISS SOME FIELDS //////////////////////
    if ( ![self.mStrFirstName isNotNullString])
    {
        [pMessenge appendString:NSLocalizedString(@"msg_first_name_nil", nil)];
    }
    
    if ( ![self.mStrLastName isNotNullString])
    {
        [pMessenge appendString:NSLocalizedString(@"msg_last_name_nil", nil)];
    }
    
    if ( ![self.mStrEmail isNotNullString])
    {
        [pMessenge appendString:NSLocalizedString(@"msg_email_nil", nil)];
    }
    
    if ( ![self.mStrPhone isNotNullString])
    {
        [pMessenge appendString:NSLocalizedString(@"msg_phone_nil", nil)];
    }
    
    if ( ![self.mStrCountry isNotNullString])
    {
        [pMessenge appendString:NSLocalizedString(@"msg_country_nil", nil)];
    }
    
    return pMessenge;
}

-(void)setFirstName: (NSString*)firstName
           lastName: (NSString*)lastName
              email: (NSString*)email
              phone: (NSString*)phone
         andCountry: (NSString*)country
{
    self.mStrFirstName = firstName;
    self.mStrLastName = lastName;
    self.mStrEmail = email;
    self.mStrPhone = phone;
    self.mStrCountry = country;
    
    DLogInfo(@"info %@", self.mStrFirstName);
}

-(BOOL)isFillAllField
{
    return ( [self.mStrFirstName isNotNullString] &&
             [self.mStrLastName isNotNullString] &&
             [self.mStrEmail isNotNullString] &&
             [self.mStrCountry isNotNullString] &&
             [self.mStrPhone isNotNullString] );
}

@end
