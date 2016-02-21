//
//  DCBankBranchModel.m
//  DispatchCenter
//
//  Created by Phung Long on 12/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCBankBranchInfo.h"

@implementation DCBankBranchInfo

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
            DCBankBranchModel *pModel = [[DCBankBranchModel alloc] initWithDict:pDict];
            [pArr addObject:pModel];
        }
        
        self.mBankList = nil; // refresh
        self.mBankList = [pArr copy];
    }
}

@end

@implementation DCBankBranchModel

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        self.bankCode = [dict stringForKey:@"code"];
        self.bankName = [dict stringForKey:@"name"];
    }
    
    return self;
}

@end

