//
//  DCLocalizedButton.m
//  DispatchCenter
//
//  Created by Hoang Truong Minh on 12/1/15.
//  Copyright © 2015 Helpser. All rights reserved.
//

#import "DCLocalizedButton.h"

@implementation DCLocalizedButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    NSString *normalTitle = [self titleForState:UIControlStateNormal];
    [self setTitle:NSLocalizedString([self titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    if (![normalTitle isEqualToString:[self titleForState:UIControlStateHighlighted]]) {
        [self setTitle:NSLocalizedString([self titleForState:UIControlStateHighlighted], nil) forState:UIControlStateHighlighted];
    }
    
    if (![normalTitle isEqualToString:[self titleForState:UIControlStateDisabled]]) {
        [self setTitle:NSLocalizedString([self titleForState:UIControlStateDisabled], nil) forState:UIControlStateDisabled];
    }
    
    if (![normalTitle isEqualToString:[self titleForState:UIControlStateSelected]]) {
        [self setTitle:NSLocalizedString([self titleForState:UIControlStateSelected], nil) forState:UIControlStateSelected];
    }
}

@end
