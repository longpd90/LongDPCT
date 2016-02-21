//
//  DCInvoiceDetailTextCell.m
//  DispatchCenter
//
//  Created by VietHQ on 11/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceDetailTextCell.h"
#import "DCInvoiceDetailFAInfo.h"

static CGFloat kPercentWithContentWithScreen = 288.0f/320.0f;

@implementation DCInvoiceDetailTextCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.mTitleLabel.numberOfLines = 0;
    self.mTitleLabel.font = [UIFont normalBoldFont];
}

- (void)updateConstraints
{
    __weak typeof (self) thiz = self;
    
    [self.mTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.left.equalTo(strongSelf.contentView.mas_left).offset(16.0f).priorityHigh();
            make.top.equalTo(strongSelf.contentView.mas_top).offset(4.0f).priorityHigh();
            make.width.mas_greaterThanOrEqualTo(288.0f);
            make.bottom.equalTo(strongSelf.contentView.mas_bottom).offset(-4.0f).priority(750);
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
    
    self.mTitleLabel.preferredMaxLayoutWidth =  kPercentWithContentWithScreen*MAIN_SCREEN.size.width;
    
    [super layoutSubviews];

}

@end

@implementation DCInvoiceDetailTextCell(CellForInvoice)

-(void)bindingDataForEntity:(NSObject *)obj
{
    DCTwoColumnCellHelper *pItem = (DCTwoColumnCellHelper*)obj;
    self.mTitleLabel.text = pItem.mTitle;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
