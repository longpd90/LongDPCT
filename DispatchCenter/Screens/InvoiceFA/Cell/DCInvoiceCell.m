//
//  DCInvoiceCell.m
//  DispatchCenter
//
//  Created by VietHQ on 11/3/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceCell.h"

@implementation DCInvoiceCell

- (void)awakeFromNib
{
    // Initialization code
    self.mStatutLabel.numberOfLines = 0;
    self.mStatutLabel.textColor = [UIColor greenStatusColor];
    self.mStatutLabel.font = [UIFont subTitleBoldFont];
    
    self.mTitleLabel.font = [UIFont normalBoldFont];
    self.mTimeLabel.font = [UIFont subTitleFont];
    self.mTimeLabel.textColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
