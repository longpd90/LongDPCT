//
//  DCInvoiceDetailHeaderCell.m
//  DispatchCenter
//
//  Created by VietHQ on 11/7/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCInvoiceDetailHeaderCell.h"
#import "DCInvoiceDetailFAInfo.h"

static CGFloat const kPercentWidthTextWithScreen = 135.0f/320.0f;

@implementation DCInvoiceDetailHeaderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.mInvoiceDateLabel.font = [UIFont normalFont];
    self.mInvoiceNoLabel.font = [UIFont normalFont];
    
    self.mInvoiceNoLabel.numberOfLines = 0;
    self.mInvoiceDateLabel.numberOfLines = 0;
    
    self.mInvoiceDateLabel.text = @"";
    self.mInvoiceNoLabel.text = @"";
}

- (void)updateConstraints
{
    __weak typeof (self) thiz = self;
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.top.right.left.equalTo(thiz);
            make.bottom.equalTo(strongSelf.mInvoiceDateLabel.mas_bottom).offset(4.0f).priorityMedium();
        }
    }];
        
    [self.mInvoiceDateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.left.equalTo( strongSelf.contentView.mas_left).offset(16.0f).priorityHigh();
            make.top.equalTo( strongSelf.contentView.mas_top).offset(4.0f).priorityHigh();
            make.width.mas_greaterThanOrEqualTo(135.0f);
        }
    }];
    
    [self.mInvoiceNoLabel mas_updateConstraints:^(MASConstraintMaker *make){
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.left.equalTo( strongSelf.mInvoiceDateLabel.mas_right).offset(20.0f).priorityHigh();
            make.top.equalTo( strongSelf.contentView.mas_top).offset(4.0f).priorityHigh();
            make.width.mas_greaterThanOrEqualTo(135.0f);
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

@end


@implementation DCInvoiceDetailHeaderCell(CellForInvoice)

-(void)bindingDataForEntity:(NSObject*)obj
{
    DCTwoColumnCellHelper *pItem = (DCTwoColumnCellHelper*)obj;
    self.mInvoiceDateLabel.text = pItem.mTitle;
    self.mInvoiceNoLabel.text = pItem.mContent;
    
    self.mInvoiceDateLabel.preferredMaxLayoutWidth = kPercentWidthTextWithScreen*MAIN_SCREEN.size.width;
    self.mInvoiceNoLabel.preferredMaxLayoutWidth = kPercentWidthTextWithScreen*MAIN_SCREEN.size.width;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end