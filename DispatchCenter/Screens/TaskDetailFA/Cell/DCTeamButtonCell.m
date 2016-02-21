//
//  DCTeamButtonCell.m
//  DispatchCenter
//
//  Created by VietHQ on 10/15/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCTeamButtonCell.h"

@implementation DCTeamButtonCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.mChatButton.backgroundColor = [UIColor colorFromHexString:@"#444444"];
//    self.mLocationButton.backgroundColor = [UIColor colorFromHexString:@"#444444"];
//    self.mCallButton.backgroundColor = [UIColor colorFromHexString:@"#444444"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickChatCallback:(id)sender
{
    if (self.clickChatButton)
    {
        self.clickChatButton(self.mIdxPath);
    }
}

- (IBAction)clickCallCallback:(id)sender
{
    if (self.clickCallButton)
    {
        self.clickCallButton(self.mIdxPath);
    }
}

- (IBAction)clickLocationCallback:(id)sender
{
    if (self.clickLocationButton)
    {
        self.clickLocationButton(self.mIdxPath);
    }
}


@end
