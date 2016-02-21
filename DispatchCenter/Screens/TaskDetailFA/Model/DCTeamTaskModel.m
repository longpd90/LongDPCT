//
//  DCTeamTaskModel.m
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTeamTaskModel.h"

@implementation DCMemberModel

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.mIsLeader = NO;
    }
    
    return self;
}

@end

@implementation DCTeamTaskModel

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        self.mLeader = [[DCMemberModel alloc] init];
        NSDictionary *pDictContainer = [dict dictionaryForKey:@"team"];
        
        NSDictionary *pDictTeam = [pDictContainer dictionaryForKey:@"contact"];
        self.mLeader.mStrName = [pDictTeam valueForKey:@"name"];
        self.mLeader.mStrPhoneNumb = [pDictTeam valueForKey:@"mobile"];
        self.mLeader.mStrImageURL = [pDictTeam valueForKey:@"image"];
        self.mLeader.mIsLeader = YES;
        
        NSDictionary *pUserQBDict = [pDictTeam dictionaryForKey:@"user_qb"];
        self.mLeader.mUserId = [pUserQBDict integerForKey:@"user_id"];
        //DLogInfo(@"user id %li", self.mLeader.mUserId);
        
        NSString *pIsOnLocation = [pDictTeam stringForKey:@"share_location"];
        self.mLeader.mShareLocation = [pIsOnLocation isEqualToString:@"enable"];
        
        NSArray *pMembers = [pDictContainer arrayForKey:@"members"];
        NSMutableArray *pArrDataMember = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSDictionary *pDictMember in pMembers)
        {
            DCMemberModel *pModel = [[DCMemberModel alloc] init];
            pModel.mStrName = [pDictMember stringForKey:@"name"];
            pModel.mStrImageURL = [pDictMember stringForKey:@"image"];
            pModel.mIsLeader = NO;
            
            [pArrDataMember addObject:pModel];
        }
        
        self.mArrMember = [pArrDataMember copy];
    }
    
    return self;
}

@end
