//
//  DCTaskListWFTypePendingAndCompletedCell.h
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTaskCountWF.h"

@class DCTaskWF;
@class DCTaskWFDetail;
@interface DCTaskListWFTypePendingAndCompletedCell : UITableViewCell
@property (strong, nonatomic) DCtaskGroupWF *taskGroup;
- (void) fillDataToCell:(DCTaskWFDetail *)obj;

@end
