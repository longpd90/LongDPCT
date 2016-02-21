//
//  DCInvoiceForListInfo.m
//  DispatchCenter
//
//  Created by VietHQ on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceForListInfo.h"

@implementation DCInvoiceForListInfo

-(void)parseResponse:(NSDictionary *)response
{
    id tmp = response;
    
    if ( [tmp isKindOfClass:[NSArray class]])
    {
        // create container array
        NSMutableArray *pArr = [[NSMutableArray alloc] initWithCapacity:((NSArray*)tmp).count];
        
        // add new object
        for (NSDictionary *pDict in tmp)
        {
            DCInvoiceForListModel *pModel = [[DCInvoiceForListModel alloc] initWithDict:pDict];
            [pArr addObject:pModel];
        }
        
        self.mInvoiceList = nil; // refresh
        self.mInvoiceList = [pArr copy];
    }
}

@end

@implementation DCInvoiceForListModel

-(instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class"
                                 userInfo:nil];
    return nil;
}

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        //
        self.mId = [dict integerForKey:@"id"];
        
        //
        NSDictionary *pTask = [dict dictionaryForKey:@"task"];
        self.mStrTaskName = [pTask stringForKey:@"task"];
        self.mStrSumary = [pTask stringForKey:@"summary"];
        
        //
        self.mInvoiceNo = [dict stringForKey:@"invoice_no"];
        self.mInvoiceDate = [dict stringForKey:@"invoice_date"];
        
        //
        NSDictionary *pStatus = [dict dictionaryForKey:@"status"];
        self.mStatusCode = [pStatus stringForKey:@"code"];
        self.mStatusName = [pStatus stringForKey:@"name"];
        
        //
        self.mAmountUnTaxed = [dict integerForKey:@"amount_untaxed"];
        self.mAmountTax = [dict integerForKey:@"amount_tax"];
        self.mAmountTotal = [dict integerForKey:@"amount_total"];
        
        //
        self.mShortAddress = [dict stringForKey:@"short_address"];
    }
    
    return self;
}

@end
