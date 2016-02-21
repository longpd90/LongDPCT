//
//  DCTaskTwoButtonCell.h
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTaskTwoButtonCell : UITableViewCell

@property (copy, nonatomic) void(^clickOkBtn)();
@property (copy, nonatomic) void(^clickCancelBtn)();

@property (weak, nonatomic) IBOutlet UIButton *mCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *mOkButton;

@end
