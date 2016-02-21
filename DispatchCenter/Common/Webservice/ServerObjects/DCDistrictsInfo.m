//
//  DCDistrictsInfo.m
//  DispatchCenter
//
//  Created by VietHQ on 10/23/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCDistrictsInfo.h"
#import "DCListCountryInfo.h"

@implementation DCSubDistrictsInfo

-(void)parseResponse:(NSDictionary *)response
{
    id tmp = response;
    
    if ([tmp isKindOfClass:[NSArray class]])
    {
        NSMutableArray *pArrData = [[NSMutableArray alloc] initWithCapacity:((NSArray*)tmp).count];
        
        for (NSDictionary *pDict in (NSArray*)tmp)
        {
            DCItemNameId *pItem = [[DCItemNameId alloc] init];
            pItem.mId = [pDict integerForKey:@"id"];
            pItem.mName = [pDict stringForKey:@"name"];
            
            [pArrData addObject:pItem];
        }
        
        if (pArrData.count)
        {
            self.mSubDistricstList = [pArrData copy];
        }

    }
}

@end

@implementation DCDistrictsInfo

-(void)parseResponse:(NSDictionary *)response
{
    id tmp = response;
    
    if ([tmp isKindOfClass:[NSArray class]])
    {
        NSMutableArray *pArrData = [[NSMutableArray alloc] initWithCapacity:((NSArray*)tmp).count];
        
        for (NSDictionary *pDict in (NSArray*)tmp)
        {
            DCItemNameId *pItem = [[DCItemNameId alloc] init];
            pItem.mId = [pDict integerForKey:@"id"];
            pItem.mName = [pDict stringForKey:@"name"];
            
            [pArrData addObject:pItem];
        }
        
        self.mDistrictsList = [pArrData copy];
    }

}

@end
