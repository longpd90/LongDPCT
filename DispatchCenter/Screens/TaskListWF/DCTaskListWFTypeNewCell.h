//
//  DCTaskListWFTypeNewCell.h
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTaskDetailWFInfo.h"
#import "DCTaskCountWF.h"
@class DCTaskWF;
@class DCTaskWFDetail;
@class DCTaskListWFTypeNewProtocol;

@protocol DCTaskListWFTypeNewProtocol <NSObject>

- (void) rejectTaskWF:(UITableViewCell *)cell;
- (void) acceptTaskWF:(UITableViewCell *)cell;

@end


@interface DCTaskListWFTypeNewCell : UITableViewCell

@property (nonatomic, assign) id <DCTaskListWFTypeNewProtocol> delegate;
@property (nonatomic, strong) DCTaskDetailWFInfo *info;
@property (nonatomic, strong) DCtaskGroupWF *taskGroup;
- (void) fillDataToCell:(DCTaskWFDetail *)obj;


@end
