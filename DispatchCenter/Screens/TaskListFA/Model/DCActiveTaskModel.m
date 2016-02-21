//
//  DCActiveTaskModel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/13/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCActiveTaskModel.h"

@implementation DCActiveTaskModel

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.mActive = NO;
        self.mAmountTotal = 0;
        self.mAmountTax = 0;
        self.mUnTaxed = 0;
        self.mId = 0;
        self.mSummary = 0;
        self.mStrCode = nil;
        self.mStrName = nil;
        self.mTask = nil;
        self.mTaskNo = nil;
    }
    
    return self;
}

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        self.mId = [dict integerForKey:@"id"];
        
        self.mActive = [dict boolForKey:@"active"];
        self.mAmountTax = [dict integerForKey:@"amount_tax"];
        self.mUnTaxed = [dict integerForKey:@"amount_untaxed"];
        
        NSString *pStrDate = [dict stringForKey:@"due_date"];
        self.mDueDate = [pStrDate dateMMDDYY];
        //DLogInfo(@" ~ date %@", self.mDueDate);
        
        NSDictionary *pStatusDict = [dict dictionaryForKey:@"status"];
        self.mStrCode = [pStatusDict stringForKey:@"code"];
        self.mStrName = [pStatusDict stringForKey:@"name"];
        //DLogInfo(@" ~ Code %@", self.mStrCode);
        
        self.mSummary = [dict integerForKey:@"summary"];
        self.mTask = [dict stringForKey:@"task"];
        self.mTaskNo = [dict stringForKey:@"task_no"];
    }
    
    return self;
}

@end