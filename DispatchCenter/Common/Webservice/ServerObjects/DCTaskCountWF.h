//
//  DCTaskCountWF.h
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "ServerObjectBase.h"

@class DCtaskGroupWF;
@interface DCTaskCountWF : ServerObjectBase

@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSArray *total_by_group;
@property (nonatomic, strong) NSMutableArray *result;

@end

@interface DCtaskGroupWF : ServerObjectBase

@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;

@end
