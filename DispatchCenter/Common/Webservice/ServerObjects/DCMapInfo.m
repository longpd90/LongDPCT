//
//  DCMapInfo.m
//  DispatchCenter
//
//  Created by VietHQ on 11/2/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCMapInfo.h"

@implementation DCMapInfo

-(void)parseResponse:(NSDictionary *)response
{
    id tmp = response;
    
    if ([tmp isKindOfClass:[NSDictionary class]])
    {
        self.mState = [self objectByDict:tmp andKey:@"province"];
        //DLogInfo(@"id state %li", (long)self.mState.mId);
        self.mDistrict = [self objectByDict:tmp andKey:@"district"];
        self.mSubDistrict = [self objectByDict:tmp andKey:@"subdistrict"];
    }
}

-(DCItemNameId*)objectByDict:(NSDictionary*)dict andKey:(NSString*)key
{
    NSDictionary *pState = [dict dictionaryForKey:key];
    
    DCItemNameId *pItem = [[DCItemNameId alloc] init];
    pItem.mId = [pState integerForKey:@"id"];
    pItem.mName = [pState stringForKey:@"name"];
    
    return pItem;

}

@end
