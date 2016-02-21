//
//  DCInvoiceWFCell.m
//  DispatchCenter
//
//  Created by VietHQ on 11/4/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceWFCell.h"

static CGFloat kPercentWidthSumaryWithScreen = 260.0f/320.0f;
static CGFloat kPercentWidthTitleWithScreen = 232.0f/320.0f;

@implementation DCInvoiceWFCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.mSumaryLabel.numberOfLines = 0;
    self.mSumaryLabel.text = @"";
    
    self.mTitleLabel.font = [UIFont normalBoldFont];
    self.mTitleLabel.numberOfLines = 0;
    self.mTitleLabel.text = @"";
    
    self.mDateLabel.textColor = [UIColor colorTextContent];
    self.mDateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"str_invoice_date", nil), @""];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    __weak typeof (self) thiz = self;
    
    [self.mTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.top.equalTo(strongSelf.contentView.mas_top).offset(6.0f).priorityHigh();
            make.left.equalTo(strongSelf.contentView.mas_left).offset(36.0f).priorityHigh();
            make.height.mas_greaterThanOrEqualTo(20.0f);
        }
    }];
    
    [self.mSumaryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.top.equalTo(strongSelf.mTitleLabel.mas_bottom).priorityHigh();
            make.left.equalTo(strongSelf.contentView).offset(8.0f).priorityHigh();
            make.width.mas_greaterThanOrEqualTo(kPercentWidthSumaryWithScreen);
            make.height.mas_greaterThanOrEqualTo(20.0f);
        }
    }];
    
    [self.mDateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.top.equalTo(strongSelf.mSumaryLabel.mas_bottom).offset(2.0f).priorityHigh();
            make.left.equalTo(strongSelf.contentView).offset(8.0f).priorityHigh();
            make.bottom.equalTo(strongSelf.contentView.mas_bottom).offset(-9.0f).priorityHigh();
        }
    }];
    
    [self.mArrowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.centerY.equalTo(strongSelf.contentView.mas_centerY).priorityHigh();
            make.right.equalTo( strongSelf.contentView.mas_right).offset(-14.0f).priorityHigh();
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    [self.contentView setNeedsLayout];
    
    self.mTitleLabel.preferredMaxLayoutWidth = kPercentWidthSumaryWithScreen*MAIN_SCREEN.size.width;
    self.mSumaryLabel.preferredMaxLayoutWidth = kPercentWidthTitleWithScreen*MAIN_SCREEN.size.width;
    
    [super layoutSubviews];
}

@end
