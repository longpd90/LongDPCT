//
//  DCTaskTwoButtonCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/16/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTaskTwoButtonCell.h"

@implementation DCTaskTwoButtonCell

- (void)awakeFromNib
{
    self.mCancelButton.backgroundColor = [UIColor yellowButton];
    self.mOkButton.backgroundColor = [UIColor yellowButton];
    
    self.mCancelButton.layer.cornerRadius = 2.0f;
    self.mCancelButton.clipsToBounds = YES;
    
    self.mOkButton.layer.cornerRadius = 2.0f;
    self.mOkButton.clipsToBounds = YES;
    
    [self.mCancelButton setTitle:NSLocalizedString(@"str_cancel_review", nil) forState:UIControlStateNormal];
    [self.mOkButton setTitle:NSLocalizedString(@"str_confirm_review", nil) forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (IBAction)clickCancelCallback:(id)sender
{
    if (self.clickCancelBtn)
    {
        self.clickCancelBtn();
    }
}

- (IBAction)clickOkCallback:(id)sender
{
    if (self.clickOkBtn)
    {
        self.clickOkBtn();
    }
}

@end
