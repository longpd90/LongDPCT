//
//  DCInvoiceWFCell.h
//  DispatchCenter
//
//  Created by VietHQ on 11/4/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCInvoiceWFCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mSumaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mArrowImageView;

@end
