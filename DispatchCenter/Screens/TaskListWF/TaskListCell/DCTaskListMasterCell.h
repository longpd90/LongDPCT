//
//  DCTaskListMasterCell.h
//  DispatchCenter
//
//  Created by Thuy Do Thanh on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCtaskGroupWF;
@interface DCTaskListMasterCell : UITableViewCell

- (void) fillDataToCell:(DCtaskGroupWF *)object;

@end
