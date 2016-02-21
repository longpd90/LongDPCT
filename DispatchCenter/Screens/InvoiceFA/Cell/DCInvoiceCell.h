//
//  DCInvoiceCell.h
//  DispatchCenter
//
//  Created by VietHQ on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCInvoiceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStatutLabel;
@property (weak, nonatomic) IBOutlet UIView *mLineBottomView;

@end
