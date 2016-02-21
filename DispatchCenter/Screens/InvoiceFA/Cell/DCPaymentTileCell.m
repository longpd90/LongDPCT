//
//  DCPaymentTileCell.m
//  DispatchCenter
//
//  Created by Phung Long on 12/4/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCPaymentTileCell.h"

@implementation DCPaymentTileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)checkButtonClicked:(id)sender {
    if (self.clickPaymentMethod)
    {
        self.clickPaymentMethod(self.mIdxPath);
    }
}

@end
