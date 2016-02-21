//
//  DCValidateEditProfileModel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/21/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCValidateEditProfileModel.h"

@interface DCValidateEditProfileModel()

@property(nonatomic, copy) NSString *mStrFirstName;
@property(nonatomic, copy) NSString *mStrLastName;
@property(nonatomic, copy) NSString *mStrPhone;
@property(nonatomic, copy) NSString *mStrCountry;

@end

@implementation DCValidateEditProfileModel

-(instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class"
                                 userInfo:nil];
    
    return nil;
}

-(instancetype)initWithFirstName:(NSString*)firstName
                        lastName:(NSString*)lastName
                    mobileNumber:(NSString*)numb
                         country:(NSString *)country
{
    self = [super init];
    
    if (self)
    {
        self.mStrFirstName = firstName;
        self.mStrLastName = lastName;
        self.mStrPhone = numb;
        self.mStrCountry = country;
        
        [self stringValidate];
    }
    
    return self;
}

-(NSString*)stringValidate
{
    NSMutableString *pStrAlert = [[NSMutableString alloc] initWithCapacity:200];
    
    /////////////// FILL ALL CELL ///////////////
    if ([self isFillAllRequestField])
    {
        
        if (self.mStrFirstName.length > 100 )
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_first_name_limit", nil)];
        }
        
        if (self.mStrLastName.length > 100)
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_last_name_limit", nil)];
        }
        
        if (![self.mStrPhone isPhoneNumber])
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_phone_not_valid", nil)];
        }
        
        return pStrAlert;
    }
    
    ////////////// NOT FILL ALL CELL ////////////
    if (![self isFillAllRequestField])
    {
        if ( ![self.mStrFirstName isNotNullString] || ![self.mStrFirstName isNotBlankString])
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_first_name_nil", nil)];
        }
        
        if ( ![self.mStrLastName isNotNullString] || ![self.mStrLastName isNotBlankString])
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_last_name_nil", nil)];
        }
        
        if ( ![self.mStrPhone isNotNullString] || ![self.mStrPhone isNotBlankString])
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_phone_nil", nil)];
        }
        
        if (![self.mStrCountry isNotNullString] || ![self.mStrCountry isNotBlankString])
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_country_nil", nil)];
        }
        
        return pStrAlert;
    }
    
    return pStrAlert;
}

-(BOOL)isFillAllRequestField
{
    return  [self.mStrFirstName isNotNullString] && [self.mStrFirstName isNotBlankString] &&
            [self.mStrLastName isNotNullString] && [self.mStrLastName isNotBlankString] &&
            [self.mStrPhone isNotNullString] && [self.mStrPhone isNotBlankString] &&
            [self.mStrCountry isNotNullString] && [self.mStrCountry isNotBlankString];
}

@end
