//
//  DCProvincesModel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/23/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCCheckIdModel.h"
#import "DCListCountryInfo.h"

@interface DCCheckIdModel()

@property(strong, nonatomic) NSArray *mArrList;

@end

@implementation DCCheckIdModel

-(instancetype)initWithNameAndIdList:(NSArray*)arr
{
    self = [super init];
    
    if (self)
    {
        if (arr.count && [[arr firstObject] isKindOfClass: [DCItemNameId class]])
        {
            self.mArrList = [arr copy];
        }
    }
    
    return self;
}

-(NSInteger)idForName:(NSString*)name
{
    for (DCItemNameId *pItem in self.mArrList)
    {
        if ([[pItem.mName lowercaseString] isEqualToString:[name lowercaseString]])
        {
            return pItem.mId;
        }
    }
    
    return 0;
}

@end