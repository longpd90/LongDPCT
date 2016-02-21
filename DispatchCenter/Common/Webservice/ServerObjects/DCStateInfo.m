//
//  DCStateInfo.m
//  DispatchCenter
//
//  Created by VietHQ on 10/21/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCStateInfo.h"

@implementation DCStateInfo

-(void)parseResponse:(NSDictionary *)response
{
    id tmp = response;
    if ([tmp isKindOfClass:[NSArray class]])
    {
        NSArray *pArr = (NSArray*)tmp;
        NSMutableArray *pArrData = [[NSMutableArray alloc] initWithCapacity:pArr.count];
        for (NSDictionary *pDict in pArr)
        {
            DCItemNameId *pItem = [[DCItemNameId alloc] init];
            pItem.mId = [pDict integerForKey:@"id"];
            pItem.mName = [pDict stringForKey:@"name"];
            
            [pArrData addObject:pItem];
        }
        
        if (pArrData.count)
        {
            self.mStateList = [pArrData copy];
        }
    }
}

@end
