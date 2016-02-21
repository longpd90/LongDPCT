//
//  DCTaskButtonCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskButtonCell.h"

@implementation DCTaskButtonCell

- (void)awakeFromNib {
    // Initialization code
    self.mButton.backgroundColor = [UIColor yellowButton];
    self.mButton.layer.cornerRadius = 2.0f;
    self.mButton.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickBtnCallback:(id)sender
{
    if (self.clickButtonCallback)
    {
        self.clickButtonCallback(self.mIdxPath);
    }
}

-(void)layoutSubviews
{
    CGRect frameContent = self.contentView.frame;
    self.mButton.center = CGPointMake( CGRectGetWidth(frameContent)*0.5f, self.mButton.center.y);
}

@end
