//
//  DCListCountryInfo.m
//  DispatchCenter
//
//  Created by VietHQ on 10/8/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCListCountryInfo.h"

@implementation DCItemNameId

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

@end


@implementation DCListCountryInfo

- (void)parseResponse:(NSDictionary *)response {
    NSArray *tmp = (NSArray*)response;
    //DLogInfo(@"%@", tmp);
    
   
    if (tmp.count)
    {
        NSMutableArray *pArrData = [[NSMutableArray alloc] initWithCapacity:tmp.count];
        NSMutableArray *pArrDataNameId = [[NSMutableArray alloc] initWithCapacity:tmp.count];
        for ( NSDictionary *pItemCountry in tmp)
        {
            // create arr data with country name only
            [pArrData addObject:[pItemCountry stringForKey:API_PR_COUNTRY_NAME]];
            
            // create arr data with name and id
            DCItemNameId *pItem = [[DCItemNameId alloc] init];
            pItem.mId = [pItemCountry integerForKey:@"id"];
            pItem.mName = [pItemCountry stringForKey:API_PR_COUNTRY_NAME];
            pItem.mISOName = [pItemCountry stringForKey:@"code"];
            
            [pArrDataNameId addObject:pItem];
        }
        
        self.mListCountry = [pArrData copy];
        self.mListCountryWithId = [pArrDataNameId copy];
        self.mListCountryCode = [pArrDataNameId copy];
    }
}

@end
