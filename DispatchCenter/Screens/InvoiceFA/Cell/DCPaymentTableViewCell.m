//
//  DCPaymentTableViewCell.m
//  DispatchCenter
//
//  Created by Phung Long on 12/2/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCPaymentTableViewCell.h"

@implementation DCPaymentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    for (id subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField*)subView;
            tf.placeholder = NSLocalizedString(tf.placeholder, nil);
            NSLog(@"place holder === %@ \n",tf.placeholder);
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)continueButtonClicked:(id)sender {
    if (self.clickContinueMethod)
    {
        self.clickContinueMethod(self.mIdxPath);
    }
}

@end
