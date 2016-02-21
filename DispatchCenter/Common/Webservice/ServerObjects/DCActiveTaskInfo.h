//
//  DCActiveTaskInfo.h
//  DispatchCenter
//
//  Created by VietHQ on 10/13/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObjectBase.h"

@interface DCActiveTaskInfo : ServerObjectBase

@property(nonatomic, strong) NSArray *mArrActiveTask;
@property(nonatomic, strong) NSArray *mArrNotActiveTask;

@property(nonatomic, strong) NSArray *mArrFrameForActive;
@property(nonatomic, strong) NSArray *mArrFrameForNotActive;

@end
