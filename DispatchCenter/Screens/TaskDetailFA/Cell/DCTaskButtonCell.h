//
//  DCTaskButtonCell.h
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTaskButtonCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *mIdxPath;
@property (weak, nonatomic) IBOutlet UIButton *mButton;
@property (nonatomic, copy) void(^clickButtonCallback)(NSIndexPath *idxPath);

@end
