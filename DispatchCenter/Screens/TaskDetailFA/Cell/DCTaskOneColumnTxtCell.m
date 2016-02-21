//
//  DCTaskOneColumnTxtCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskOneColumnTxtCell.h"

static CGFloat const kPercentWidthTitleWithScreen = 304.0f/320.0f;

@implementation DCTaskOneColumnTxtCell

#pragma mark - init
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.mTitleLabel.text = @"";
    }
    
    return self;
}

#pragma mark - create view
- (void)awakeFromNib
{
    UIView *pContainer = self.contentView;
    pContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.mTitleLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)updateConstraints
{
    __weak typeof (self) thiz = self;
    [self.mTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.top.equalTo(self.contentView.mas_top).offset(3.5f).priority(750);
            make.left.equalTo(self.contentView.mas_left).offset(8.0f).priority(750);
            make.centerY.offset(self.contentView.frame.size.height*0.5f).priority(750);
            make.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(0.0f, 0.0f, 4.0f, 0.0f)).priority(750);
        }
    }];
    
    [super updateConstraints];
}

#pragma mark - layout
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    [self.contentView setNeedsLayout];
    
    self.mTitleLabel.preferredMaxLayoutWidth = kPercentWidthTitleWithScreen*MAIN_SCREEN.size.width;
    
    [super layoutSubviews];
}

@end
