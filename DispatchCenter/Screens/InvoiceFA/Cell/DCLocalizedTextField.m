//
//  DCLocalizedTextField.m
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 12/9/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCLocalizedTextField.h"

@implementation DCLocalizedTextField
- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.placeholder) {
        self.placeholder = NSLocalizedString(self.placeholder, nil);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    if (self.placeholder) {
        self.placeholder = NSLocalizedString(self.placeholder, nil);
    }
}


@end
