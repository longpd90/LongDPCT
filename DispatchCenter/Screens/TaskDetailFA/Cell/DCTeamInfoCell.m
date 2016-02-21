//
//  DCTeamInfoCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTeamInfoCell.h"

@implementation DCTeamInfoCell

- (void)awakeFromNib
{
    self.mAvaImageView.layer.cornerRadius = CGRectGetWidth(self.mAvaImageView.frame)*0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
