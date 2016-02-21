//
//  DCInvoiceTwoColumnCell.m
//  DispatchCenter
//
//  Created by VietHQ on 11/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//


#import "DCInvoiceTwoColumnCell.h"
#import "DCInvoiceDetailFAInfo.h"

static CGFloat const kPercentWithContentWithScreen = 154.0f/320.0f;

@implementation DCInvoiceTwoColumnCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mContentLabel.numberOfLines = 0;
    
    self.mContentLabel.text = @"";
    self.mTitleLabel.text = @"";
}

- (void)updateConstraints
{
    __weak typeof (self) thiz = self;
    
    [self.mTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.left.equalTo(thiz.contentView.mas_left).offset(18.0f).priorityHigh();
            make.top.equalTo(thiz.contentView.mas_top).offset(4.0f).priorityHigh();
            make.width.mas_greaterThanOrEqualTo(124.0f).priorityHigh();
        }
    }];
    
    [self.mContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.top.equalTo(strongSelf.contentView.mas_top).offset(4.0f).priority(750);
            make.left.equalTo(strongSelf.mTitleLabel.mas_right).offset(8.0f).priority(750);
            make.bottom.equalTo(strongSelf.contentView.mas_bottom).offset(-5.0f).priorityHigh();
        }
    }];
    
    [self.mLineBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.left.equalTo(strongSelf.contentView.mas_left).offset(16).priority(750);
            make.right.equalTo(strongSelf.contentView.mas_right).offset(-16).priority(750);
            make.width.mas_offset(MAIN_SCREEN.size.width - 32.0f);
            make.height.mas_greaterThanOrEqualTo(1);
            make.bottom.equalTo(strongSelf.mas_bottom).offset(-1.0f).priority(750);
        }
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];

    self.mContentLabel.preferredMaxLayoutWidth =  kPercentWithContentWithScreen*MAIN_SCREEN.size.width;
    
    [super layoutSubviews];
}

@end


@implementation DCInvoiceTwoColumnCell(CellForInvoice)

-(void)bindingDataForEntity:(NSObject *)obj
{
    DCTwoColumnCellHelper *pItem = (DCTwoColumnCellHelper*)obj;
    self.mTitleLabel.text = pItem.mTitle;
    if ([[pItem.mContent lowercaseString] isEqualToString:@"unpaid"]) {
        pItem.mContent = NSLocalizedString(@"Waiting for payment",nil);
    }
    self.mContentLabel.text = pItem.mContent;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
