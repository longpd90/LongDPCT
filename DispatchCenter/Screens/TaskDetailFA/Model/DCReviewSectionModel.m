//
//  DCReviewSectionModel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/27/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCReviewSectionModel.h"

@implementation DCReviewSectionModel

-(void)parseResponse:(NSDictionary *)response
{
    id tmp = response;
    if ([tmp isKindOfClass:[NSDictionary class]])
    {
        self.mReviewUpdateDict = response;
    }
    
}

-(instancetype)initWithDrawDictFromServer:(NSDictionary*)tmp
{
    self = [super init];
    
    if (self)
    {
        NSDictionary *pReviewData = [tmp dictionaryForKey:@"review"];
        
        if (!pReviewData)
        {
            pReviewData = tmp;
        }
        
        self.mId = [pReviewData integerForKey:@"id"];
        self.mTemplateId = [pReviewData integerForKey:@"template_id"];
        self.mAvgStar = [pReviewData floatForKey:@"avg_score"];
        self.mStrComment = [pReviewData stringForKey:@"comment"];
        
        NSArray *pArrDetail = [pReviewData arrayForKey:@"details"];
        NSMutableArray *pArrStarModel = [[NSMutableArray alloc] initWithCapacity:pArrDetail.count];
        for (NSDictionary *pDict in pArrDetail)
        {
            DCStarModel *pStarModel = [[DCStarModel alloc] init];
            pStarModel.mId = [pDict integerForKey:@"id"];
            pStarModel.mName = [pDict stringForKey:@"name"];
            pStarModel.mStarValue = [pDict floatForKey:@"score"];
            
            [pArrStarModel addObject:pStarModel];
        }
        
        self.mArrStarModel = [pArrStarModel copy];
        DLogInfo(@"%li", (long)self.mArrStarModel.count);
    }
    
    return self;
}

-(NSDictionary*)jsonDataSendToServer
{
    NSMutableDictionary *pDict = [[NSMutableDictionary alloc] initWithCapacity:50];
    
    pDict[@"id"] = @(self.mId);
    pDict[@"template_id"] = @(self.mTemplateId);
    pDict[@"comment"] = self.mStrComment ? : @"";
    
    NSMutableArray *pDetails = [[NSMutableArray alloc] initWithCapacity:10];
    for (DCStarModel *pStar in self.mArrStarModel)
    {
        [pDetails addObject:[pStar jsonData]];
    }
    
    pDict[@"details"] = pDetails;
    
    DLogInfo(@"review send to server %@", pDict);
    
    return pDict;
}

@end


// -------------------------------------- //
@implementation DCStarModel

-(NSDictionary*)jsonData
{
    return @{ @"id" : self.mId ? @(self.mId) : @0,
              @"name" : self.mName ? : @"",
              @"score" : self.mStarValue ? @(self.mStarValue) : @0};
}

@end


// -------------------------------------- //
@implementation DCStarStatus

-(NSDictionary*)jsonData
{
    return @{ @"name" : self.mStrName ? : @"",
              @"code" : self.mStrCode ? : @""};
}

@end
