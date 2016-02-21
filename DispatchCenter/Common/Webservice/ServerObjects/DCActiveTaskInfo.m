//
//  DCActiveTaskInfo.m
//  DispatchCenter
//
//  Created by VietHQ on 10/13/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCActiveTaskInfo.h"
#import "DCActiveTaskModel.h"
#import "DCCalFrameActiveTask.h"

@implementation DCActiveTaskInfo

-(void)parseResponse:(NSDictionary *)response
{
    NSArray *tmp = (NSArray*)response;
    if (tmp.count)
    {
        NSMutableArray *pArrActive = [[NSMutableArray alloc] initWithCapacity:tmp.count];
        NSMutableArray *pArrNotActive = [[NSMutableArray alloc] initWithCapacity:tmp.count];
        
        NSMutableArray *pArrFrameActive = [[NSMutableArray alloc] initWithCapacity:tmp.count];
        NSMutableArray *pArrFrameNotActive = [[NSMutableArray alloc] initWithCapacity:tmp.count];
        
        for ( NSDictionary *pDictData in tmp)
        {
            DCActiveTaskModel *pTaskModel = [[DCActiveTaskModel alloc] initWithDict:pDictData];
            pTaskModel.mActive ? [pArrActive addObject:pTaskModel] : [pArrNotActive addObject:pTaskModel];
            
            DCCalFrameActiveTask *pCalFrameModel = [[DCCalFrameActiveTask alloc] initWithTaskNameWithtext:pTaskModel.mStrName andFont:[UIFont normalBoldFont]];
            pTaskModel.mActive ? [pArrFrameActive addObject:pCalFrameModel] : [pArrFrameNotActive addObject:pCalFrameModel];
        }
        
        self.mArrNotActiveTask = [pArrNotActive copy];
        self.mArrActiveTask = [pArrActive copy];
        self.mArrFrameForActive = [pArrFrameActive copy];
        self.mArrFrameForNotActive = [pArrFrameNotActive copy];
        
        //DLogInfo(@"~ active %@", self.mArrActiveTask);
        //DLogInfo(@"~ not active %@", self.mArrNotActiveTask);
    }
}

@end
