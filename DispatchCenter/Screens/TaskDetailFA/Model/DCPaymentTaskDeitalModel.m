//
//  DCPaymentTaskDeitalModel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCPaymentTaskDeitalModel.h"

@implementation DCPaymentTaskDeitalModel

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        self.mId = [dict integerForKey:@"id"];
        self.mNeedPay = [dict boolForKey:@"need_pay"];
        self.mPayDate = [dict stringForKey:@"payment_date"];
        self.mPayDate = self.mPayDate ? [self.mPayDate dateMMDDYY] : @"";
        self.mPaidAmount = [dict stringForKey:@"paid_amount"];
        self.mPaidAmount = [NSString stringWithFormat:@"฿%@",self.mPaidAmount];
        
        
        NSDictionary *pPaymentMethod = [dict dictionaryForKey:@"payment_method"];
        self.mMethodName = [pPaymentMethod stringForKey:@"name"];
        self.mMethodType = [pPaymentMethod stringForKey:@"type"];
        
        NSDictionary *pDictDetail = [dict dictionaryForKey:@"detail"];
        self.mCardHolderName = [pDictDetail stringForKey:@"card_holder_name"];
        self.mCardNumber = [pDictDetail stringForKey:@"card_number"];
        self.mExpiryMonth = [pDictDetail integerForKey:@"expiry_month"];
        self.mExpiryYear = [pDictDetail integerForKey:@"expiry_year"];
        
        
        
        NSDictionary *pStatusDict = [dict dictionaryForKey:@"status"];
        self.mStatus = [pStatusDict stringForKey:@"name"];
        if ([self.mStatus isEqualToString:@"Posted"]) {
            self.mStatus = [NSString stringWithFormat:@"Paid"];
        } else if ([self.mStatus isEqualToString:@"Draft"]) {
            self.mStatus = [NSString stringWithFormat:@"Waiting for payment"];
        }
    }
    
    return self;
}

@end
