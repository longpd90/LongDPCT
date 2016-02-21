//
//  DCTaskTwoColumnTxtCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskTwoColumnTxtCell.h"
#import "DCInvoiceDetailFAInfo.h"

static CGFloat kPercentWithContentWithScreen = 158.0f/320.0f;

@implementation DCTaskTwoColumnTxtCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.mTitleLabel.text = @"";
        self.mContentLabel.text = @"";
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mContentLabel.numberOfLines = 0;    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.mContentLabel.preferredMaxLayoutWidth =  kPercentWithContentWithScreen*MAIN_SCREEN.size.width;
    
    [super layoutSubviews];
}

- (void)updateConstraints
{
    __weak typeof (self) thiz = self;
    
    [self.mBorderUpView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.top.mas_equalTo(strongSelf.contentView.mas_top).offset(1).priority(750);
            make.left.equalTo(strongSelf.contentView.mas_left).offset(16).priority(750);
            make.right.equalTo(strongSelf.contentView.mas_right).offset(-16).priority(750);
            make.width.mas_offset(MAIN_SCREEN.size.width - 32.0f);
            make.height.mas_greaterThanOrEqualTo(1);
        }
    }];

    [self.mTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.top.equalTo(strongSelf.contentView.mas_top).offset(4.0f).priority(750);
            make.left.equalTo(strongSelf.contentView.mas_left).insets(UIEdgeInsetsMake(0.0f, 16.0f, 0.0f, 0.0f)).priority(750);
            make.width.mas_greaterThanOrEqualTo(111.0f).priority(750);
        }
    }];
    
    [self.mContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong typeof (thiz) strongSelf = thiz;
        if (strongSelf)
        {
            make.top.equalTo(strongSelf.contentView.mas_top).offset(4.0f).priority(750);
            if (strongSelf.mTextContentMarginLeft)
            {
                make.left.equalTo(strongSelf.contentView.mas_left).offset(strongSelf.mTextContentMarginLeft).priorityHigh();
            }
            else
            {
                make.left.equalTo(strongSelf.mTitleLabel.mas_right).offset(8.0f).priority(750);
            }
            
            make.bottom.equalTo(strongSelf.contentView.mas_bottom).offset(-4.0f).priority(750);
            make.right.equalTo(strongSelf.contentView.mas_right).offset(-16.0f);
            make.width.mas_greaterThanOrEqualTo(158.0f);
        }
    }];
    
    
    //DLogInfo(@"line %@", NSStringFromCGRect(self.mContentLabel.frame));
    
    [super updateConstraints];
}

+(CGFloat)defaultHeight
{
    return 50.0f;
}

-(void)showBorderUp:(BOOL)value
{
    self.mBorderUpView.hidden = !value;
}

@end


// ------------------------------------------------- //
@implementation DCTaskTwoColumnTxtCell(BindingData)

-(void)bindingDataForEntity:(NSObject *)obj
{
    DCTwoColumnCellHelper *pItem = (DCTwoColumnCellHelper*)obj;
    self.mTitleLabel.text = pItem.mTitle;
    self.mContentLabel.text = NSLocalizedString(pItem.mContent,nil);
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];    
}

@end
