//
//  DCLoginValidateModel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/12/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCLoginValidateModel.h"

@implementation DCLoginValidateModel

-(instancetype)initWithEmail:(NSString*)email andPassword:(NSString*)password;
{
    self = [super init];
    
    if (self)
    {
        self.mStrEmail = email;
        self.mStrPassword = password;
    }
    
    return self;
}



-(NSString*)stringValidate
{
    BOOL isFillAllCall = self.mStrEmail.length && self.mStrPassword.length;
    if (isFillAllCall)
    {
        if (![self.mStrEmail isValidEmail])
        {
            return NSLocalizedString(@"msg_email_not_valid", nil);
        }
        else
        {
            return nil;
        }
    }
    
    NSMutableString *pStrAlert = [[NSMutableString alloc] initWithCapacity:100];
    if (!isFillAllCall)
    {
        if ( ![self.mStrEmail isNotNullString])
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_email_nil", nil)];
        }
        
        if ( ![self.mStrPassword isNotNullString])
        {
            [pStrAlert appendString:NSLocalizedString(@"msg_password_nil", nil)];
        }
    }
    
    return pStrAlert;
}

@end
