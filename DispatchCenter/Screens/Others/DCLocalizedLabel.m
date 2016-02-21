//
//  DCLocalizedLabel.m
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 12/1/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCLocalizedLabel.h"

@implementation DCLocalizedLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    self.text = NSLocalizedString(self.text, nil);
}

@end
